//
//  LeftViewController.m
//  miglab_mobile
//
//  Created by apple on 13-7-3.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "LeftViewController.h"
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
    
    _tableTitles = [NSArray arrayWithObjects:@"首页", @"test", @"系统设置", @"关于我们", nil];
    
    //计算tableview的高度和坐标，并设置tableview
    float height = [_tableTitles count] * 44;
    float tableviewy = [[UIScreen mainScreen] bounds].size.height - 20 - height;
    
    //menu
    _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, tableviewy, 320.0f, height) style:UITableViewStylePlain];
    _menuTableView.delegate = self;
    _menuTableView.dataSource = self;
    _menuTableView.backgroundColor = [UIColor brownColor];
    _menuTableView.separatorColor = [UIColor darkGrayColor];
    _menuTableView.scrollEnabled = NO;
    [self.view addSubview:_menuTableView];
    
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
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    cell.textLabel.text = [_tableTitles objectAtIndex:indexPath.row];
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

@end
