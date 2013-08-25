//
//  MyFriendPersonalPageViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-23.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "MyFriendPersonalPageViewController.h"
#import "MusicSourceMenuCell.h"
#import "FriendOfRecommendMusicViewController.h"
#import "FriendOfChatViewController.h"
#import "FriendOfSayHiViewController.h"
#import "FriendOfMusicListViewController.h"
#import "FriendOfPhotoListViewController.h"

@interface MyFriendPersonalPageViewController ()

@end

@implementation MyFriendPersonalPageViewController

@synthesize navView = _navView;
@synthesize userHeadView = _userHeadView;

@synthesize bodyTableView = _bodyTableView;
@synthesize tableTitles = _tableTitles;

@synthesize isFriend = _isFriend;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isFriend = NO;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //nav bar
    _navView = [[PCustomNavigationBarView alloc] initWithTitle:@"猫王爱淘汰" bgImageView:@"login_navigation_bg"];
    [self.view addSubview:_navView];
    
    UIImage *backImage = [UIImage imageWithName:@"login_back_arrow_nor" type:@"png"];
    [_navView.leftButton setBackgroundImage:backImage forState:UIControlStateNormal];
    _navView.leftButton.frame = CGRectMake(4, 0, 44, 44);
    [_navView.leftButton setHidden:NO];
    [_navView.leftButton addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    
    //user head
    NSArray *userHeadNib = [[NSBundle mainBundle] loadNibNamed:@"FriendMessageUserHead" owner:self options:nil];
    for (id oneObject in userHeadNib){
        if ([oneObject isKindOfClass:[FriendMessageUserHead class]]){
            _userHeadView = (FriendMessageUserHead *)oneObject;
        }//if
    }//for
    _userHeadView.frame = CGRectMake(11.5, 44 + 10, 297, 129);
    [self.view addSubview:_userHeadView];
    
    if (_isFriend) {
        
        [_userHeadView.btnSayHi addTarget:self action:@selector(doRecommendMusic:) forControlEvents:UIControlEventTouchUpInside];
        [_userHeadView.btnAddBlack addTarget:self action:@selector(doSendMessage:) forControlEvents:UIControlEventTouchUpInside];
        
    } else {
        
        [_userHeadView.btnSayHi addTarget:self action:@selector(doSayHi:) forControlEvents:UIControlEventTouchUpInside];
        [_userHeadView.btnAddBlack addTarget:self action:@selector(doAddBlack:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    //body menu
    _bodyTableView = [[UITableView alloc] init];
    _bodyTableView.frame = CGRectMake(11.5, 44 + 10 + 129 + 10, 297, kMainScreenHeight - 44 - 10 - 129 - 10 - 10 - 73 - 10);
    _bodyTableView.dataSource = self;
    _bodyTableView.delegate = self;
    _bodyTableView.backgroundColor = [UIColor clearColor];
    _bodyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _bodyTableView.scrollEnabled = NO;
    
    UIImageView *bodyBgImageView = [[UIImageView alloc] init];
    bodyBgImageView.frame = CGRectMake(11.5, 44 + 10 + 129 + 10, 297, kMainScreenHeight - 44 - 10 - 129 - 10 - 10 - 73 - 10);
    bodyBgImageView.image = [UIImage imageWithName:@"body_bg" type:@"png"];
    _bodyTableView.backgroundView = bodyBgImageView;
    [self.view addSubview:_bodyTableView];
    
    NSDictionary *dicMenu0 = [NSDictionary dictionaryWithObjectsAndKeys:@"friend_user_songlist_tip", @"MenuImageName", @"歌单", @"MenuText", nil];
    NSDictionary *dicMenu1 = [NSDictionary dictionaryWithObjectsAndKeys:@"friend_user_photo_tip", @"MenuImageName", @"照片", @"MenuText", nil];
    _tableTitles = [NSArray arrayWithObjects:dicMenu0, dicMenu1, nil];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

//推荐ta歌曲
-(IBAction)doRecommendMusic:(id)sender{
    
    PLog(@"doRecommendMusic...");
    
}

//发消息
-(IBAction)doSendMessage:(id)sender{
    
    PLog(@"doSendMessage...");
    
}

//打招呼
-(IBAction)doSayHi:(id)sender{
    
    PLog(@"doSayHi...");
    
    FriendOfSayHiViewController *sayHiViewController = [[FriendOfSayHiViewController alloc] initWithNibName:@"FriendOfSayHiViewController" bundle:nil];
    [self.navigationController pushViewController:sayHiViewController animated:YES];
    
}

//拉进黑名单
-(IBAction)doAddBlack:(id)sender{
    
    PLog(@"doAddBlack...");
    
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // ...
    if (indexPath.row == 0) {
        
        FriendOfMusicListViewController *musicListViewController = [[FriendOfMusicListViewController alloc] initWithNibName:@"FriendOfMusicListViewController" bundle:nil];
        [self.topViewcontroller.navigationController pushViewController:musicListViewController animated:YES];
        
    } else if (indexPath.row == 1) {
        
        FriendOfPhotoListViewController *photoListViewController = [[FriendOfPhotoListViewController alloc] initWithNibName:@"FriendOfPhotoListViewController" bundle:nil];
        [self.topViewcontroller.navigationController pushViewController:photoListViewController animated:YES];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
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
