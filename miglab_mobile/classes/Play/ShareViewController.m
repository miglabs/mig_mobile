//
//  ShareViewController.m
//  miglab_mobile
//
//  Created by pig on 13-10-4.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "ShareViewController.h"
#import "ShareMenuCell.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

@synthesize dataTableView = _dataTableView;
@synthesize datalist = _datalist;

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
    
    self.view.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:241.0f/255.0f blue:237.0f/255.0f alpha:1.0f];
    
    //nav title
    self.navView.titleLabel.text = @"分享";
    self.bgImageView.hidden = YES;
    
    //body
    _dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45 + 10, kMainScreenWidth, kMainScreenHeight - 45 - 10) style:UITableViewStyleGrouped];
    _dataTableView.dataSource = self;
    _dataTableView.delegate = self;
    _dataTableView.backgroundColor = [UIColor clearColor];
    _dataTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _dataTableView.scrollEnabled = NO;
    [self.view addSubview:_dataTableView];
    
    NSDictionary *dicMenu0 = [NSDictionary dictionaryWithObjectsAndKeys:@"friend_myfriend_tip", @"MenuImageName", @"写点什么吧!", @"MenuText", nil];
    NSDictionary *dicMenu1 = [NSDictionary dictionaryWithObjectsAndKeys:@"friend_listening_tip", @"MenuImageName", @"分享到新浪微博", @"MenuText", nil];
    NSDictionary *dicMenu2 = [NSDictionary dictionaryWithObjectsAndKeys:@"friend_nearby_tip", @"MenuImageName", @"分享到腾讯微博", @"MenuText", nil];
    NSDictionary *dicMenu3 = [NSDictionary dictionaryWithObjectsAndKeys:@"friend_message_tip", @"MenuImageName", @"分享到QQ空间", @"MenuText", nil];
    NSArray *section0 = [NSArray arrayWithObjects:dicMenu0, dicMenu1, dicMenu2, dicMenu3, nil];
    
    NSDictionary *dicMenu10 = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"分享", nil];
    NSArray *section1 = [NSArray arrayWithObjects:dicMenu10, nil];
    _datalist = [NSArray arrayWithObjects:section0, section1, nil];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//override
-(IBAction)doBack:(id)sender{
    [super doBack:sender];
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)doShare:(id)sender{
    
//    PLog();
    
}

#pragma mark - UITableView delegate

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // ...
    
    
    
    //
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    PLog(@"section: %d", section);
    NSArray *sectionMenu = [_datalist objectAtIndex:section];
    return sectionMenu.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ShareMenuCell";
	ShareMenuCell *cell = (ShareMenuCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"ShareMenuCell" owner:self options:nil];
        cell = (ShareMenuCell *)[nibContents objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
    
    NSArray *section0 = [_datalist objectAtIndex:indexPath.section];
    NSDictionary *dicMenu = [section0 objectAtIndex:indexPath.row];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            //edit
            
        } else if (indexPath.row == 1) {
            
            
            cell.iconImageView.image = [UIImage imageWithName:[dicMenu objectForKey:@"MenuImageName"]];
            cell.lblDesc.text = [dicMenu objectForKey:@"MenuText"];
            
        }
        
        
        
    } else if (indexPath.section == 1) {
        
//       PLog()
        
    }
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

@end
