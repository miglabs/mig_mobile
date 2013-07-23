//
//  LeftViewController.m
//  miglab_mobile
//
//  Created by apple on 13-7-3.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "LeftViewController.h"
#import "LeftViewCell.h"
#import "UIImage+PImageCategory.h"

#import "AppDelegate.h"
#import "DDMenuController.h"
#import "PlayViewController.h"
#import "HomeViewController.h"

//test
#import "LoginViewController.h"
#import "RegisterViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

@synthesize topUserInfoView = _topUserInfoView;
@synthesize btnUserAvatar = _btnUserAvatar;
@synthesize lblUserNickName = _lblUserNickName;
@synthesize userGenderImageView = _userGenderImageView;

@synthesize menuTableView = _menuTableView;
@synthesize tableTitles = _tableTitles;

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
    
    self.view.backgroundColor = [UIColor colorWithRed:46.0f/255.0f green:46.0f/255.0f blue:46.0f/255.0f alpha:1.0f];
    
    //top user info
    [self.view addSubview:_topUserInfoView];
    
    NSDictionary *dicMenu0 = [NSDictionary dictionaryWithObjectsAndKeys:@"left_menu_yinyuejiyin", @"MenuImageName", @"音乐基因", @"MenuText", nil];
    NSDictionary *dicMenu1 = [NSDictionary dictionaryWithObjectsAndKeys:@"left_menu_gedan", @"MenuImageName", @"歌单", @"MenuText", nil];
    NSDictionary *dicMenu2 = [NSDictionary dictionaryWithObjectsAndKeys:@"left_menu_haoyou", @"MenuImageName", @"好友", @"MenuText", nil];
    NSDictionary *dicMenu3 = [NSDictionary dictionaryWithObjectsAndKeys:@"left_menu_shezhi", @"MenuImageName", @"设置", @"MenuText", nil];
//    _tableTitles = [NSArray arrayWithObjects:@"音乐基因", @"歌单", @"好友", @"设置", nil];
    _tableTitles = [NSArray arrayWithObjects:dicMenu0, dicMenu1, dicMenu2, dicMenu3, nil];
    
    //计算tableview的高度和坐标，并设置tableview
    float tableheight = [_tableTitles count] * 50;
    float tableviewy = kMainScreenHeight - tableheight;
    
    //menu
    _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, tableviewy, kMainScreenWidth, tableheight) style:UITableViewStylePlain];
    _menuTableView.delegate = self;
    _menuTableView.dataSource = self;
    _menuTableView.backgroundColor = [UIColor clearColor];
//    _menuTableView.separatorColor = [UIColor darkGrayColor];
    _menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _menuTableView.scrollEnabled = NO;
    [self.view addSubview:_menuTableView];
    
    //middle desc
    UIImageView *descImageView = [[UIImageView alloc] init];
    descImageView.frame = CGRectMake((kMainScreenWidth - 92 - 60)/2, 70 + (tableviewy - 70 - 23)/2, 92, 23);
    descImageView.backgroundColor = [UIColor clearColor];
    descImageView.image = [UIImage imageWithName:@"left_menu_migfm" type:@"png"];
    [self.view addSubview:descImageView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // ...
    UINavigationController *nav = nil;
    if (indexPath.row == 0) {
        
        PlayViewController *playViewController = [[PlayViewController alloc] initWithNibName:@"PlayViewController" bundle:nil];
        nav = [[UINavigationController alloc] initWithRootViewController:playViewController];
        [nav setNavigationBarHidden:YES];
        
    } else if (indexPath.row == 1) {
        
        RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
        nav = [[UINavigationController alloc] initWithRootViewController:registerViewController];
        [nav setNavigationBarHidden:YES];
        
    } else if (indexPath.row == 2) {
        
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        nav = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        [nav setNavigationBarHidden:YES];
        
    } else {
        
        HomeViewController *homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
        nav = [[UINavigationController alloc] initWithRootViewController:homeViewController];
        [nav setNavigationBarHidden:YES];
        
    }
    
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController setRootController:nav animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tableTitles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"LeftViewTableCell";
	LeftViewCell *cell = (LeftViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"LeftViewCell" owner:self options:nil];
        cell = (LeftViewCell *)[nibContents objectAtIndex:0];
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
    
    return 50;
}

@end
