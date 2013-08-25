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
#import "MyFriendPersonalPageViewController.h"

@interface MyFriendViewController ()

@end

@implementation MyFriendViewController

@synthesize navView = _navView;
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
    
    //nav bar
    _navView = [[PCustomNavigationBarView alloc] initWithTitle:@"我的好友" bgImageView:@"login_navigation_bg"];
    [self.view addSubview:_navView];
    
    UIImage *backImage = [UIImage imageWithName:@"login_back_arrow_nor" type:@"png"];
    [_navView.leftButton setBackgroundImage:backImage forState:UIControlStateNormal];
    _navView.leftButton.frame = CGRectMake(4, 0, 44, 44);
    [_navView.leftButton setHidden:NO];
    [_navView.leftButton addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    
    //search view
    NSArray *searchNib = [[NSBundle mainBundle] loadNibNamed:@"FriendSearchView" owner:self options:nil];
    for (id oneObject in searchNib){
        if ([oneObject isKindOfClass:[FriendSearchView class]]){
            _searchView = (FriendSearchView *)oneObject;
        }//if
    }//for
    _searchView.frame = CGRectMake(11.5, 44 + 10, 297, 44);
    _searchView.searchTextField.delegate = self;
    [_searchView.btnSearch addTarget:self action:@selector(doSearch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_searchView];
    
    //search result view
    _friendTableView = [[UITableView alloc] init];
    _friendTableView.frame = CGRectMake(11.5, 44 + 10 + 44 + 10, 297, kMainScreenHeight - 44 - 10 - 44 - 10 - 10 - 73 - 10);
    _friendTableView.dataSource = self;
    _friendTableView.delegate = self;
    _friendTableView.backgroundColor = [UIColor clearColor];
    _friendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView *bodyBgImageView = [[UIImageView alloc] init];
    bodyBgImageView.frame = CGRectMake(11.5, 44 + 10 + 44 + 10, 297, kMainScreenHeight - 44 - 10 - 44 - 10 - 10 - 73 - 10);
    bodyBgImageView.image = [UIImage imageWithName:@"body_bg" type:@"png"];
    _friendTableView.backgroundView = bodyBgImageView;
    [self.view addSubview:_friendTableView];
    
    //
    _friendList = [[NSMutableArray alloc] init];
    
    //test data
    PUser *testfriend = [[PUser alloc] init];
    testfriend.nickname = @"猫王爱淘汰";
    [_friendList addObject:testfriend];
    
    PUser *testfriend1 = [[PUser alloc] init];
    testfriend1.nickname = @"乐瑟乐瑟";
    [_friendList addObject:testfriend1];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    MyFriendPersonalPageViewController *personalPageViewController = [[MyFriendPersonalPageViewController alloc] initWithNibName:@"MyFriendPersonalPageViewController" bundle:nil];
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
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
    
    PUser *tempfriend = [_friendList objectAtIndex:indexPath.row];
//    cell.lblNickName.text = tempfriend.nickname;
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 57;
}

@end
