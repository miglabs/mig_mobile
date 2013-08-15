//
//  MusicViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-13.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "MusicViewController.h"
#import "UIImage+PImageCategory.h"
#import "MusicPlayerNavigationView.h"
#import "MusicPlayerMenuView.h"
#import "MusicSourceMenuCell.h"

#import "LocalViewController.h"

@interface MusicViewController ()

@end

@implementation MusicViewController

@synthesize navView = _navView;

@synthesize bodyTableView = _bodyTableView;
@synthesize tableTitles = _tableTitles;

@synthesize playerMenuView = _playerMenuView;

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
    
    //bg
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    bgImageView.image = [UIImage imageWithName:@"view_bg" type:@"png"];
    [self.view addSubview:bgImageView];
    
    //top
    _navView = [[MusicPlayerNavigationView alloc] initMusicNavigationView:CGRectMake(0, 0, 320, 45)];
    [_navView.btnAvatar addTarget:self action:@selector(doNavigationAvatar:) forControlEvents:UIControlEventTouchUpInside];
    _navView.lblNickName.text = @"乐瑟啊乐瑟";
    [_navView.btnFirstMenu setTitle:@"歌单" forState:UIControlStateNormal];
    [_navView.btnFirstMenu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_navView.btnFirstMenu addTarget:self action:@selector(doNavigationFirst:) forControlEvents:UIControlEventTouchUpInside];
    [_navView.btnSecondMenu setTitle:@"歌友" forState:UIControlStateNormal];
    [_navView.btnSecondMenu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_navView.btnSecondMenu addTarget:self action:@selector(doNavigationSecond:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_navView];
    
    //body
    _bodyTableView = [[UITableView alloc] init];
    _bodyTableView.frame = CGRectMake(11.5, 45 + 10, 297, kMainScreenHeight - 45 - 10 - 10 - 73 - 10);
    _bodyTableView.dataSource = self;
    _bodyTableView.delegate = self;
    _bodyTableView.backgroundColor = [UIColor clearColor];
    _bodyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _bodyTableView.scrollEnabled = NO;
    
    UIImageView *bodyBgImageView = [[UIImageView alloc] init];
    bodyBgImageView.frame = _bodyTableView.frame;
    bodyBgImageView.image = [UIImage imageWithName:@"body_bg" type:@"png"];
    _bodyTableView.backgroundView = bodyBgImageView;
    [self.view addSubview:_bodyTableView];
    
    NSDictionary *dicMenu0 = [NSDictionary dictionaryWithObjectsAndKeys:@"music_source_menu_online", @"MenuImageName", @"在线推荐", @"MenuText", nil];
    NSDictionary *dicMenu1 = [NSDictionary dictionaryWithObjectsAndKeys:@"music_source_menu_like", @"MenuImageName", @"我喜欢的", @"MenuText", nil];
    NSDictionary *dicMenu2 = [NSDictionary dictionaryWithObjectsAndKeys:@"music_source_menu_nearby", @"MenuImageName", @"附近的好音乐", @"MenuText", nil];
    NSDictionary *dicMenu3 = [NSDictionary dictionaryWithObjectsAndKeys:@"music_source_menu_local", @"MenuImageName", @"本地音乐", @"MenuText", nil];
    //    _tableTitles = [NSArray arrayWithObjects:@"音乐基因", @"歌单", @"好友", @"设置", nil];
    _tableTitles = [NSArray arrayWithObjects:dicMenu0, dicMenu1, dicMenu2, dicMenu3, nil];
    
    //menu
    _playerMenuView = [[MusicPlayerMenuView alloc] initDefaultMenuView:CGRectMake(11.5, kMainScreenHeight - 73 - 10, 297, 73)];
    [_playerMenuView.btnAvatar addTarget:self action:@selector(doPlayerAvatar:) forControlEvents:UIControlEventTouchUpInside];
    _playerMenuView.lblSongInfo.text = @"迷宫仙曲－乐瑟";
    [_playerMenuView.btnDelete addTarget:self action:@selector(doDelete:) forControlEvents:UIControlEventTouchUpInside];
    [_playerMenuView.btnCollect addTarget:self action:@selector(doCollect:) forControlEvents:UIControlEventTouchUpInside];
    [_playerMenuView.btnPlayOrPause addTarget:self action:@selector(doPlayOrPause:) forControlEvents:UIControlEventTouchUpInside];
    [_playerMenuView.btnNext addTarget:self action:@selector(doNext:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playerMenuView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doNavigationAvatar:(id)sender{
    
}

-(IBAction)doNavigationFirst:(id)sender{
    
}

-(IBAction)doNavigationSecond:(id)sender{
    
}


-(IBAction)doPlayerAvatar:(id)sender{
    
}

-(IBAction)doDelete:(id)sender{
    
}

-(IBAction)doCollect:(id)sender{
    
}

-(IBAction)doPlayOrPause:(id)sender{
    
}

-(IBAction)doNext:(id)sender{
    
}

#pragma mark - UITableView delegate

// custom view for header. will be adjusted to default or specified header height
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIButton *btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    btnEdit.frame = CGRectMake(230, 8, 58, 28);
    UIImage *editNorImage = [UIImage imageWithName:@"music_source_edit" type:@"png"];
    [btnEdit setImage:editNorImage forState:UIControlStateNormal];
    
    UIImageView *separatorImageView = [[UIImageView alloc] init];
    separatorImageView.frame = CGRectMake(4, 45, 290, 1);
    separatorImageView.image = [UIImage imageWithName:@"music_source_separator" type:@"png"];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, 297, 45);
    [headerView addSubview:btnEdit];
    [headerView addSubview:separatorImageView];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // ...
    if (indexPath.row == 0) {
        
        LocalViewController *localViewController = [[LocalViewController alloc] initWithNibName:@"LocalViewController" bundle:nil];
        [self.navigationController pushViewController:localViewController animated:YES];
        
    }
    
}

#pragma mark - UITableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MusicSourceMenuCell";
	MusicSourceMenuCell *cell = (MusicSourceMenuCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"MusicSourceMenuCell" owner:self options:nil];
        cell = (MusicSourceMenuCell *)[nibContents objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
    
    NSDictionary *dicMenu = [_tableTitles objectAtIndex:indexPath.row];
    cell.menuImageView.image = [UIImage imageWithName:[dicMenu objectForKey:@"MenuImageName"]];
    cell.lblMenu.text = [dicMenu objectForKey:@"MenuText"];
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 57;
}

@end
