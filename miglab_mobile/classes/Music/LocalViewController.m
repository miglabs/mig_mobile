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

@synthesize navView = _navView;

@synthesize songTableView = _songTableView;
@synthesize songList = _songList;

@synthesize miglabAPI = _miglabAPI;

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
    
    //nav bar
    _navView = [[PCustomNavigationBarView alloc] initWithTitle:@"本地音乐" bgImageView:@"login_navigation_bg"];
    [self.view addSubview:_navView];
    
    UIImage *backImage = [UIImage imageWithName:@"login_back_arrow_nor" type:@"png"];
    [_navView.leftButton setBackgroundImage:backImage forState:UIControlStateNormal];
    _navView.leftButton.frame = CGRectMake(4, 0, 44, 44);
    [_navView.leftButton setHidden:NO];
    [_navView.leftButton addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //body
    //body bg
    UIImageView *bodyBgImageView = [[UIImageView alloc] init];
    bodyBgImageView.frame = CGRectMake(11.5, 45 + 10, 297, kMainScreenHeight - 45 - 10 - 10 - 73 - 10);
    bodyBgImageView.image = [UIImage imageWithName:@"body_bg" type:@"png"];
    [self.view addSubview:bodyBgImageView];
    
    //body head
    UILabel *lblDesc = [[UILabel alloc] init];
    lblDesc.frame = CGRectMake(16, 10, 140, 21);
    lblDesc.backgroundColor = [UIColor clearColor];
    lblDesc.font = [UIFont systemFontOfSize:15.0f];
    lblDesc.text = @"优先推荐以下歌曲";
    lblDesc.textAlignment = kTextAlignmentLeft;
    lblDesc.textColor = [UIColor whiteColor];
    
    UIButton *btnSort = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSort.frame = CGRectMake(162, 8, 58, 28);
    UIImage *sortNorImage = [UIImage imageWithName:@"music_source_sort" type:@"png"];
    [btnSort setImage:sortNorImage forState:UIControlStateNormal];
    
    UIButton *btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    btnEdit.frame = CGRectMake(230, 8, 58, 28);
    UIImage *editNorImage = [UIImage imageWithName:@"music_source_edit" type:@"png"];
    [btnEdit setImage:editNorImage forState:UIControlStateNormal];
    
    UIImageView *separatorImageView = [[UIImageView alloc] init];
    separatorImageView.frame = CGRectMake(4, 45, 290, 1);
    separatorImageView.image = [UIImage imageWithName:@"music_source_separator" type:@"png"];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(11.5, 45 + 10, 297, 45);
    [headerView addSubview:lblDesc];
    [headerView addSubview:btnSort];
    [headerView addSubview:btnEdit];
    [headerView addSubview:separatorImageView];
    [self.view addSubview:headerView];
    
    //song list
    _songTableView = [[UITableView alloc] init];
    _songTableView.frame = CGRectMake(11.5, 45 + 10 + 45, 297, kMainScreenHeight - 45 - 10 - 45 - 10 - 73 - 10);
    _songTableView.dataSource = self;
    _songTableView.delegate = self;
    _songTableView.backgroundColor = [UIColor clearColor];
    _songTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_songTableView];
    
    //data
    _songList = [[NSMutableArray alloc] init];
    
    PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
    NSMutableArray *tempSongInfoList = [databaseManager getSongInfoList:25];
    [_songList addObjectsFromArray:tempSongInfoList];
    
    //test
    [self getSongListFromIPod];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getSongListFromIPod{
    
    MPMediaQuery *videoQuery = [[MPMediaQuery alloc] init];
    NSArray *mediaItems = [videoQuery items];
    for (MPMediaItem *mediaItem in mediaItems){
        
        NSURL *URL = (NSURL*)[mediaItem valueForProperty:MPMediaItemPropertyAssetURL];
        
        if (URL) {
            NSString *name = (NSString *)[mediaItem valueForProperty:MPMediaItemPropertyTitle];
            NSString *artist = (NSString*)[mediaItem valueForProperty:MPMediaItemPropertyArtist];
            NSString *music = [URL absoluteString];
            
            NSLog(@"name(%@), artist(%@), musicUrl(%@)", name, artist, music);
            
        }
    }
    
    [self exportSongFromIPod:mediaItems currentIndex:0];
    
    /*
    NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pigDirectory = [[cachesDirectory stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:@"local"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:pigDirectory isDirectory:NULL])
    {
        NSError *error;
        if (![fm createDirectoryAtPath:pigDirectory withIntermediateDirectories:YES attributes:nil error:&error]) {
            [NSException raise:@"Exception" format:[error localizedDescription]];
        }
    }
    
    MPMediaQuery *videoQuery = [[MPMediaQuery alloc] init];
    NSArray *mediaItems = [videoQuery items];
    for (MPMediaItem *mediaItem in mediaItems){
        
        NSURL *URL = (NSURL*)[mediaItem valueForProperty:MPMediaItemPropertyAssetURL];
        
        if (URL) {
            NSString *name = (NSString *)[mediaItem valueForProperty:MPMediaItemPropertyTitle];
            NSString *artist = (NSString*)[mediaItem valueForProperty:MPMediaItemPropertyArtist];
            NSString *music = [URL absoluteString];
            
            NSLog(@"name(%@), artist(%@), musicUrl(%@)", name, artist, music);
            
            
            
            
        }
    }
    
    __block int currentMediaIndex = 0;
    if ([mediaItems count] > 0) {
        
        MPMediaItem *mediaItem = [mediaItems objectAtIndex:currentMediaIndex];
        NSURL *mediaItemUrl = [mediaItem valueForProperty:MPMediaItemPropertyAssetURL];
        NSString *name = (NSString *)[mediaItem valueForProperty:MPMediaItemPropertyTitle];
        
        NSString *file = [NSString stringWithFormat:@"%@/%@", pigDirectory, name];
        NSURL *dstUrl = [NSURL fileURLWithPath:file];
        
        TSLibraryImport *export = [[TSLibraryImport alloc] init];
        [export importAsset:mediaItemUrl toURL:dstUrl completionBlock:^(TSLibraryImport *import) {
            
            currentMediaIndex++;
            
            MPMediaItem *mediaItem = [mediaItems objectAtIndex:currentMediaIndex];
            NSURL *mediaItemUrl = [mediaItem valueForProperty:MPMediaItemPropertyAssetURL];
            NSString *name = (NSString *)[mediaItem valueForProperty:MPMediaItemPropertyTitle];
            
            NSString *file = [NSString stringWithFormat:@"%@/%@", pigDirectory, name];
            NSURL *dstUrl = [NSURL fileURLWithPath:file];
            
            TSLibraryImport *export = [[TSLibraryImport alloc] init];
            [export importAsset:mediaItemUrl toURL:dstUrl completionBlock:^(TSLibraryImport *import) {
                
                NSLog(@"complete...");
                
            }];
            
        }];
        
    }
    */
    
}

-(void)exportSongFromIPod:(NSArray *)tmediaitems currentIndex:(int)tcurrentindex{
    
    if (tcurrentindex < [tmediaitems count]) {
        
        __block int tempindex = tcurrentindex;
        
        MPMediaItem *mediaItem = [tmediaitems objectAtIndex:tempindex];
        NSURL *mediaItemUrl = [mediaItem valueForProperty:MPMediaItemPropertyAssetURL];
        NSString *name = (NSString *)[mediaItem valueForProperty:MPMediaItemPropertyTitle];
        NSString *artist = (NSString*)[mediaItem valueForProperty:MPMediaItemPropertyArtist];
        
        NSString *localDir = [[SongDownloadManager GetInstance] getSongCacheDirectory];
        NSString *file = [NSString stringWithFormat:@"%@/%@.%@", localDir, name, [mediaItemUrl pathExtension]];
        
        NSDate *nowdate = [NSDate date];
        Song *tempsong = [[Song alloc] init];
        tempsong.songid = [nowdate timeIntervalSince1970];
        tempsong.songname = name;
        tempsong.artist = artist;
        tempsong.songtype = 1;
        tempsong.songurl = file;
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
                
                [[PDatabaseManager GetInstance] insertSongInfo:tempsong];
                
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
    return [_songList count];
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
    
    Song *tempsong = [_songList objectAtIndex:indexPath.row];
    cell.lblSongName.text = tempsong.songname;
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 57;
}

@end
