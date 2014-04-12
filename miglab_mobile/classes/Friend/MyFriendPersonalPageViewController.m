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
#import "ChatViewController.h"

@interface MyFriendPersonalPageViewController ()

@end

@implementation MyFriendPersonalPageViewController

@synthesize userHeadView = _userHeadView;

@synthesize bodyTableView = _bodyTableView;
@synthesize tableTitles = _tableTitles;
@synthesize userinfo = _userinfo;

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
    
    //nav
    CGRect navViewFrame = self.navView.frame;
    float posy = navViewFrame.origin.y + navViewFrame.size.height;//ios6-45, ios7-65
    
    //nav bar
    self.navView.titleLabel.text = _userinfo.nickname;
    
    //user head
    NSArray *userHeadNib = [[NSBundle mainBundle] loadNibNamed:@"FriendMessageUserHead" owner:self options:nil];
    for (id oneObject in userHeadNib){
        if ([oneObject isKindOfClass:[FriendMessageUserHead class]]){
            _userHeadView = (FriendMessageUserHead *)oneObject;
            _userHeadView.isFriend = _isFriend;
            [_userHeadView updateFriendMessageUserHead:_userinfo];
            
            // 单独更新距离信息
            float fDistance = _userinfo.distance / 1000.0f;
            NSString* source = _userinfo.source;
            if (source) {
                
                _userHeadView.lblDistance.text = [NSString stringWithFormat:@"%.2fkm | %@", fDistance, source];
            }
            else {
                
                _userHeadView.lblDistance.text = [NSString stringWithFormat:@"%.2fkm", fDistance];
            }
        }//if
    }//for
    _userHeadView.frame = CGRectMake(ORIGIN_X, posy + 10, ORIGIN_WIDTH, 129);
    [self.view addSubview:_userHeadView];
    
    [_userHeadView.btnSendSong addTarget:self action:@selector(doRecommendMusic:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_isFriend) {
        
        [_userHeadView.btnSay addTarget:self action:@selector(doSendMessage:) forControlEvents:UIControlEventTouchUpInside];
        //_userHeadView.btnSay.imageView.image = [UIImage imageNamed:@""]
        
    } else {
        
        [_userHeadView.btnSay addTarget:self action:@selector(doSayHi:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //body menu
    _bodyTableView = [[UITableView alloc] init];
    _bodyTableView.frame = CGRectMake(ORIGIN_X, posy + 10 + 129 + 10, ORIGIN_WIDTH, kMainScreenHeight + self.topDistance - posy - BOTTOM_PLAYER_HEIGHT - 10 - 129 - 10 - 10 - 10);
    _bodyTableView.dataSource = self;
    _bodyTableView.delegate = self;
    _bodyTableView.backgroundColor = [UIColor clearColor];
    _bodyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _bodyTableView.scrollEnabled = NO;
    
    UIImageView *bodyBgImageView = [[UIImageView alloc] init];
    bodyBgImageView.frame = CGRectMake(ORIGIN_X, posy + 10 + 129 + 10, ORIGIN_WIDTH, kMainScreenHeight + self.topDistance - posy - BOTTOM_PLAYER_HEIGHT - 10 - 129 - 10 - 10 - 10);
    bodyBgImageView.image = [UIImage imageWithName:@"body_bg" type:@"png"];
    _bodyTableView.backgroundView = bodyBgImageView;
    [self.view addSubview:_bodyTableView];
    
    NSDictionary *dicMenu0 = [NSDictionary dictionaryWithObjectsAndKeys:@"friend_user_songlist_tip", @"MenuImageName", @"歌单", @"MenuText", nil];
    
//    NSDictionary *dicMenu1 = [NSDictionary dictionaryWithObjectsAndKeys:@"friend_user_photo_tip", @"MenuImageName", @"照片", @"MenuText", nil];
    _tableTitles = [NSArray arrayWithObjects:dicMenu0, nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//推荐ta歌曲
-(IBAction)doRecommendMusic:(id)sender{
    
    // 跳转到送歌页面
    FriendOfRecommendMusicViewController* sendsongViewController = [[FriendOfRecommendMusicViewController alloc] initWithNibName:@"FriendOfRecommendMusicViewController" bundle:nil];
    sendsongViewController.toUserInfo = _userinfo;
    [self.navigationController pushViewController:sendsongViewController animated:YES];
}

//发消息
-(IBAction)doSendMessage:(id)sender{
    
    PLog(@"doSendMessage...");
    
    int currentUserId = [[UserSessionManager GetInstance].userid intValue];
    ChatViewController *chatController = [[ChatViewController alloc] init:nil uid:currentUserId tid:[_userinfo.userid intValue]];
    [self.navigationController pushViewController:chatController animated:YES];
    
}

//打招呼
-(IBAction)doSayHi:(id)sender{
    
    PLog(@"doSayHi...");
    
    FriendOfSayHiViewController *sayHiViewController = [[FriendOfSayHiViewController alloc] initWithNibName:@"FriendOfSayHiViewController" bundle:nil];
    sayHiViewController.touserid = _userinfo.userid;
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
        musicListViewController.userinfo = _userinfo;
        [self.topViewcontroller.navigationController pushViewController:musicListViewController animated:YES];
    }
    
//    } else if (indexPath.row == 1) {
//        
//        FriendOfPhotoListViewController *photoListViewController = [[FriendOfPhotoListViewController alloc] initWithNibName:@"FriendOfPhotoListViewController" bundle:nil];
//        [self.topViewcontroller.navigationController pushViewController:photoListViewController animated:YES];
//        
//    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MusicSourceMenuCell";
	MusicSourceMenuCell *cell = (MusicSourceMenuCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"MusicSourceMenuCell" owner:self options:nil];
        cell = (MusicSourceMenuCell *)[nibContents objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
    
    NSDictionary *dicMenu = [_tableTitles objectAtIndex:indexPath.row];
    cell.menuImageView.image = [UIImage imageWithName:[dicMenu objectForKey:@"MenuImageName"]];
    cell.lblMenu.text = [dicMenu objectForKey:@"MenuText"];
    [cell.lblTipNum setHidden:YES];
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return CELL_HEIGHT;
}

@end
