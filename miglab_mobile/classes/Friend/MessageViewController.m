//
//  MessageViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-20.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageInfoCell.h"
#import "MessageInfo.h"
#import "FriendOfReceiveHiViewController.h"
#import "FriendOfReceiveMusicViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

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
    
    //nav
    CGRect navViewFrame = self.navView.frame;
    float posy = navViewFrame.origin.y + navViewFrame.size.height;//ios6-45, ios7-65
    
    //nav bar
    self.navView.titleLabel.text = @"消息";
    
    //body
    _dataTableView = [[UITableView alloc] init];
    _dataTableView.frame = CGRectMake(11.5, posy + 10, 297, kMainScreenHeight + self.topDistance - posy - 10 - 10 - 73 - 10);
    _dataTableView.dataSource = self;
    _dataTableView.delegate = self;
    _dataTableView.backgroundColor = [UIColor clearColor];
    _dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView *bodyBgImageView = [[UIImageView alloc] init];
    bodyBgImageView.frame = CGRectMake(11.5, posy + 10, 297, kMainScreenHeight + self.topDistance - posy - 10 - 10 - 73 - 10);
    bodyBgImageView.image = [UIImage imageWithName:@"body_bg" type:@"png"];
    _dataTableView.backgroundView = bodyBgImageView;
    [self.view addSubview:_dataTableView];
    
    //
    _datalist = [[NSMutableArray alloc] init];
    
    //
    MessageInfo *mi0 = [[MessageInfo alloc] init];
    mi0.content = @"使对方看";
    mi0.messagetype = 1;
    [_datalist addObject:mi0];
    
    MessageInfo *mi1 = [[MessageInfo alloc] init];
    mi1.content = @"使对方看w额投入";
    mi1.messagetype = 2;
    [_datalist addObject:mi1];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // ...
    
    MessageInfo *messageInfo = [_datalist objectAtIndex:indexPath.row];
    if (messageInfo.messagetype == 1) {
        
        FriendOfReceiveHiViewController *receiveHiViewController = [[FriendOfReceiveHiViewController alloc] initWithNibName:@"FriendOfReceiveHiViewController" bundle:nil];
        [self.navigationController pushViewController:receiveHiViewController animated:YES];
        
    } else if (messageInfo.messagetype == 2) {
        
        FriendOfReceiveMusicViewController *receiveMusicViewController = [[FriendOfReceiveMusicViewController alloc] initWithNibName:@"FriendOfReceiveMusicViewController" bundle:nil];
        [self.navigationController pushViewController:receiveMusicViewController animated:YES];
        
    } else if (messageInfo.messagetype == 3) {
        
    }
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_datalist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MessageInfoCell";
	MessageInfoCell *cell = (MessageInfoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"MessageInfoCell" owner:self options:nil];
        cell = (MessageInfoCell *)[nibContents objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
    
    MessageInfo *messageInfo = [_datalist objectAtIndex:indexPath.row];
    cell.lblMessageType.text = @"使地方 评论了song";
    cell.lblContent.text = messageInfo.content;
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 57;
}

@end
