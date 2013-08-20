//
//  LikeViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "LikeViewController.h"
#import "MusicSongCell.h"
#import "Song.h"
#import "PDatabaseManager.h"

@interface LikeViewController ()

@end

@implementation LikeViewController

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
    _navView = [[PCustomNavigationBarView alloc] initWithTitle:@"我喜欢的" bgImageView:@"login_navigation_bg"];
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
    UIButton *btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    btnEdit.frame = CGRectMake(230, 8, 58, 28);
    UIImage *editNorImage = [UIImage imageWithName:@"music_source_edit" type:@"png"];
    [btnEdit setImage:editNorImage forState:UIControlStateNormal];
    
    UIImageView *separatorImageView = [[UIImageView alloc] init];
    separatorImageView.frame = CGRectMake(4, 45, 290, 1);
    separatorImageView.image = [UIImage imageWithName:@"music_source_separator" type:@"png"];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(11.5, 45 + 10, 297, 45);
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
    
//    [_songTableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
