//
//  MusicViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-13.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "MusicViewController.h"
#import "MusicSourceMenuCell.h"

#import "OnlineViewController.h"
#import "LikeViewController.h"
#import "NearMusicViewController.h"
#import "LocalViewController.h"

@interface MusicViewController ()

@end

@implementation MusicViewController

@synthesize bodyTableView = _bodyTableView;
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
    
    //body
    _bodyTableView = [[UITableView alloc] init];
    _bodyTableView.frame = CGRectMake(11.5, 45 + 10, 297, kMainScreenHeight - 45 - 10 - 10 - 73 - 10);
//    _bodyTableView.frame = CGRectMake(11.5, 10, 297, kMainScreenHeight - 45 - 10 - 10 - 73 - 10);
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
    _tableTitles = [NSArray arrayWithObjects:dicMenu0, dicMenu1, dicMenu2, dicMenu3, nil];
    
    //player
//    self.playerMenuView.frame = CGRectMake(11.5, kMainScreenHeight - 45 - 73 - 10, 297, 73);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//override
-(IBAction)doPlayerAvatar:(id)sender{
    
    [super doPlayerAvatar:sender];
    PLog(@"gene doPlayerAvatar...");
    
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
        
        OnlineViewController *onlineViewController = [[OnlineViewController alloc] initWithNibName:@"OnlineViewController" bundle:nil];
        [self.topViewcontroller.navigationController pushViewController:onlineViewController animated:YES];
        
    } else if (indexPath.row == 1) {
        
        LikeViewController *likeViewController = [[LikeViewController alloc] initWithNibName:@"LikeViewController" bundle:nil];
        [self.topViewcontroller.navigationController pushViewController:likeViewController animated:YES];
        
    } else if (indexPath.row == 2) {
        
        NearMusicViewController *nearMusicViewController = [[NearMusicViewController alloc] initWithNibName:@"NearMusicViewController" bundle:nil];
        [self.topViewcontroller.navigationController pushViewController:nearMusicViewController animated:YES];
        
    } else if (indexPath.row == 3) {
        
        LocalViewController *localViewController = [[LocalViewController alloc] initWithNibName:@"LocalViewController" bundle:nil];
        [self.topViewcontroller.navigationController pushViewController:localViewController animated:YES];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
