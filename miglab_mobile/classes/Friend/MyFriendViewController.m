//
//  MyFriendViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-20.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "MyFriendViewController.h"
#import "FriendInfoCell.h"
#import "PUser.h"
#import "FriendOfAddViewController.h"
#import "MyFriendPersonalPageViewController.h"

@interface MyFriendViewController ()

@end

@implementation MyFriendViewController

@synthesize searchView = _searchView;

@synthesize friendTableView = _friendTableView;
@synthesize friendList = _friendList;

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
    self.navView.titleLabel.text = @"我的好友";
    
    UIImage *addFriendImage = [UIImage imageWithName:@"friend_button_add" type:@"png"];
    [self.navView.rightButton setBackgroundImage:addFriendImage forState:UIControlStateNormal];
    self.navView.rightButton.frame = CGRectMake(268, 7.5 + self.topDistance, 48, 29);
    [self.navView.rightButton setHidden:NO];
    [self.navView.rightButton addTarget:self action:@selector(doAddFriend:) forControlEvents:UIControlEventTouchUpInside];
    
    //search view
    NSArray *searchNib = [[NSBundle mainBundle] loadNibNamed:@"FriendSearchView" owner:self options:nil];
    for (id oneObject in searchNib){
        if ([oneObject isKindOfClass:[FriendSearchView class]]){
            _searchView = (FriendSearchView *)oneObject;
        }//if
    }//for
    _searchView.frame = CGRectMake(11.5, posy + 10, 297, 44);
    _searchView.searchTextField.delegate = self;
    [_searchView.btnSearch addTarget:self action:@selector(doSearch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_searchView];
    
    //search result view
    _friendTableView = [[UITableView alloc] init];
    _friendTableView.frame = CGRectMake(11.5, posy + 10 + 44 + 10, 297, kMainScreenHeight + self.topDistance - posy - 10 - 44 - 10 - 10 - 73 - 10);
    _friendTableView.dataSource = self;
    _friendTableView.delegate = self;
    _friendTableView.backgroundColor = [UIColor clearColor];
    _friendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView *bodyBgImageView = [[UIImageView alloc] init];
    bodyBgImageView.frame = CGRectMake(11.5, posy + 10 + 44 + 10, 297, kMainScreenHeight + self.topDistance - posy - 10 - 44 - 10 - 10 - 73 - 10);
    bodyBgImageView.image = [UIImage imageWithName:@"body_bg" type:@"png"];
    _friendTableView.backgroundView = bodyBgImageView;
    [self.view addSubview:_friendTableView];
    
    //
    _friendList = [[NSMutableArray alloc] init];
    
    //test data
    NearbyUser *testfriend = [[NearbyUser alloc] init];
    testfriend.nickname = @"猫王爱淘汰";
    testfriend.songname = @"机器猫";
    testfriend.sex = @"1";
    testfriend.distance = 423472;
    [_friendList addObject:testfriend];
    
    NearbyUser *testfriend1 = [[NearbyUser alloc] init];
    testfriend1.nickname = @"乐瑟乐瑟";
    testfriend1.distance = 90;
    testfriend1.sex = @"0";
    testfriend1.songname = @"真的想睡觉";
    [_friendList addObject:testfriend1];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doAddFriend:(id)sender{
    
    PLog(@"doAddFriend...");
    
    FriendOfAddViewController *addViewController = [[FriendOfAddViewController alloc] initWithNibName:@"FriendOfAddViewController" bundle:nil];
    [self.navigationController pushViewController:addViewController animated:YES];
    
}

-(IBAction)doSearch:(id)sender{
    
    PLog(@"doSearch...");
    
    [_searchView.btnSearch resignFirstResponder];
    
}

#pragma textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    PLog(@"textFieldDidBeginEditing...");
    
}

#pragma mark - UITableView delegate

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // ...
    NearbyUser* user = [_friendList objectAtIndex:indexPath.row];
    
    MyFriendPersonalPageViewController *personalPageViewController = [[MyFriendPersonalPageViewController alloc] initWithNibName:@"MyFriendPersonalPageViewController" bundle:nil];
    personalPageViewController.userinfo = user;
    [self.navigationController pushViewController:personalPageViewController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_friendList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"FriendInfoCell";
	FriendInfoCell *cell = (FriendInfoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"FriendInfoCell" owner:self options:nil];
        cell = (FriendInfoCell *)[nibContents objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
    
    NearbyUser *tempfriend = [_friendList objectAtIndex:indexPath.row];
    [cell updateFriendInfoCellData:tempfriend];
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 57;
}

@end
