//
//  LocalViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "LocalViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "TSLibraryImport.h"
#import "MusicSongCell.h"
#import "Song.h"
#import "PDatabaseManager.h"

@interface LocalViewController ()

@end

@implementation LocalViewController

@synthesize dataTableView = _dataTableView;
@synthesize dataList = _dataList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //nav
    CGRect navViewFrame = self.navView.frame;
    float posy = navViewFrame.origin.y + navViewFrame.size.height;//ios6-45, ios7-65
    
    //nav bar
    self.navView.titleLabel.text = @"本地音乐";
    
    //body
    //body bg
    UIImageView *bodyBgImageView = [[UIImageView alloc] init];
    bodyBgImageView.frame = CGRectMake(11.5, posy + 10, 297, kMainScreenHeight + self.topDistance - posy - 10 - 10 - 73 - 10);
    bodyBgImageView.image = [UIImage imageWithName:@"body_bg" type:@"png"];
    [self.view addSubview:bodyBgImageView];
    
    //body head ??
    
    //song list
    _dataTableView = [[UITableView alloc] init];
    _dataTableView.frame = CGRectMake(11.5, posy + 10, 297, kMainScreenHeight + self.topDistance - 45 - 10 - 45 - 10 - 73 - 10);
    _dataTableView.dataSource = self;
    _dataTableView.delegate = self;
    _dataTableView.backgroundColor = [UIColor clearColor];
    _dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_dataTableView];
    
    //data
    _dataList = [[NSMutableArray alloc] init];
    
    //export
    [self getSongListFromIPod];
    
    //test
//    PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
//    NSMutableArray *tempSongInfoList = [databaseManager getSongInfoList:25];
//    [_dataList addObjectsFromArray:tempSongInfoList];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doRecordLocalSongInfo:(NSMutableArray *)datalist{
    
    if ([UserSessionManager GetInstance].isLoggedIn && datalist && [datalist count] > 0) {
        
        NSString *userid = [UserSessionManager GetInstance].userid;
        NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
        NSString *username = [UserSessionManager GetInstance].currentUser.username;
        
        [self.miglabAPI doRecordLocalSongsArray:userid token:accesstoken source:@"2" urlcode:@"0" name:username songs:datalist];
        
    }
    
}

-(void)getSongListFromIPod{
    
    NSMutableArray *localDataList = [[NSMutableArray alloc] init];
    
    MPMediaQuery *videoQuery = [[MPMediaQuery alloc] init];
    NSArray *mediaItems = [videoQuery items];
    for (MPMediaItem *mediaItem in mediaItems){
        
        NSURL *URL = (NSURL*)[mediaItem valueForProperty:MPMediaItemPropertyAssetURL];
        
        if (URL) {
            NSString *name = (NSString *)[mediaItem valueForProperty:MPMediaItemPropertyTitle];
            NSString *artist = (NSString*)[mediaItem valueForProperty:MPMediaItemPropertyArtist];
            NSString *music = [URL absoluteString];
            
            NSLog(@"name(%@), artist(%@), musicUrl(%@)", name, artist, music);
            
            Song *tempsong = [[Song alloc] init];
            tempsong.songname = (name && name.length > 1) ? name : @"";
            tempsong.artist = (artist && artist.length > 1) ? artist : @"未知演唱者";
            [localDataList addObject:tempsong];
        }
    }
    
    [_dataList addObjectsFromArray:localDataList];
    
    //commit
    [self doRecordLocalSongInfo:localDataList];
    
    //export
    [self exportSongFromIPod:mediaItems currentIndex:0];
    
}

-(void)exportSongFromIPod:(NSArray *)tmediaitems currentIndex:(int)tcurrentindex{
    
    if (tcurrentindex < [tmediaitems count]) {
        
        __block int tempindex = tcurrentindex;
        
        MPMediaItem *mediaItem = [tmediaitems objectAtIndex:tempindex];
        NSURL *mediaItemUrl = [mediaItem valueForProperty:MPMediaItemPropertyAssetURL];
        NSString *name = (NSString *)[mediaItem valueForProperty:MPMediaItemPropertyTitle];
        NSString *artist = (NSString*)[mediaItem valueForProperty:MPMediaItemPropertyArtist];
        
        NSString *localDir = [[SongDownloadManager GetInstance] getIPodSongCacheDirectory];
        NSString *file = [NSString stringWithFormat:@"%@/%@.%@", localDir, name, [mediaItemUrl pathExtension]];
        
        NSDate *nowdate = [NSDate date];
        Song *tempsong = [[Song alloc] init];
        tempsong.songid = [nowdate timeIntervalSince1970];
        tempsong.songname = (name && name.length > 1) ? name : @"";
        tempsong.artist = (artist && artist.length > 1) ? artist : @"未知演唱者";;
        tempsong.songtype = 1;
        tempsong.songCachePath = file;
        
        //检查是否已经导入
        NSFileManager *fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:file]) {
            
            tempindex++;
            NSLog(@"complete...%d", tempindex);
            [self exportSongFromIPod:tmediaitems currentIndex:tempindex];
            
        } else {
            
            NSURL *dstUrl = [NSURL fileURLWithPath:file];
            TSLibraryImport *export = [[TSLibraryImport alloc] init];
            [export importAsset:mediaItemUrl toURL:dstUrl completionBlock:^(TSLibraryImport *import) {
                
                [[PDatabaseManager GetInstance] insertIPodSongInfo:tempsong];
                
                tempindex++;
                NSLog(@"complete...%d", tempindex);
                [self exportSongFromIPod:tmediaitems currentIndex:tempindex];
                
            }];
            
        }
        
        
    } else {
        
        NSLog(@"all complete...");
        
    }
    
}

#pragma mark - UITableView delegate

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // ...
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MusicSongCell";
	MusicSongCell *cell = (MusicSongCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"MusicSongCell" owner:self options:nil];
        cell = (MusicSongCell *)[nibContents objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
    
    Song *tempsong = [_dataList objectAtIndex:indexPath.row];
    cell.btnIcon.tag = tempsong.songid;
    cell.lblSongName.text = tempsong.songname;
    cell.lblSongName.font = [UIFont fontOfApp:15.0f];
    
    NSString *tempartist = tempsong.artist ? tempsong.artist : @"未知演唱者";
    cell.lblSongArtistAndDesc.text = [NSString stringWithFormat:@"%@ | %@", tempartist, @"来自IPod"];
    cell.lblSongArtistAndDesc.font = [UIFont fontOfApp:10.0f];
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 57;
}

@end
