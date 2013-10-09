//
//  ShareViewController.m
//  miglab_mobile
//
//  Created by pig on 13-10-4.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

@synthesize dataTableView = _dataTableView;
@synthesize datalist = _datalist;

@synthesize shareContentView = _shareContentView;

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
    NSDictionary *dicMenu1 = [NSDictionary dictionaryWithObjectsAndKeys:@"share_sinaweibo_share_icon.png", @"MenuImageName", @"分享到新浪微博", @"MenuText", nil];
    NSDictionary *dicMenu2 = [NSDictionary dictionaryWithObjectsAndKeys:@"share_tencentweibo_share_icon.png", @"MenuImageName", @"分享到腾讯微博", @"MenuText", nil];
    NSDictionary *dicMenu3 = [NSDictionary dictionaryWithObjectsAndKeys:@"share_qqzone_share_icon.png", @"MenuImageName", @"分享到QQ空间", @"MenuText", nil];
    NSArray *section0 = [NSArray arrayWithObjects:dicMenu0, dicMenu1, dicMenu2, dicMenu3, nil];
    
    NSDictionary *dicMenu10 = [NSDictionary dictionaryWithObjectsAndKeys:@"share_button_share_bg.png", @"MenuImageName", @"分享", @"MenuText", nil];
    NSArray *section1 = [NSArray arrayWithObjects:dicMenu10, nil];
    _datalist = [NSArray arrayWithObjects:section0, section1, nil];
    
    //
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doHideKeyborad:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
//    [self.view addGestureRecognizer:tapGestureRecognizer];
    
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
    
    PLog(@"doShare...");
    
}

-(void)doShare2SinaWeibo{
    
    PLog(@"doShare2SinaWeibo...");
    
}

-(void)doShare2TencentWeibo{
    
    PLog(@"doShare2TencentWeibo...");
    
//    TCAddShareDic *params = [TCAddShareDic dictionary];
//    params.paramTitle = @"腾讯内部addShare接口测试";
//    params.paramComment = @"风云乔帮主";
//    params.paramSummary =  @"乔布斯被认为是计算机与娱乐业界的标志性人物，同时人们也把他视作麦金塔计算机、iPod、iTunes、iPad、iPhone等知名数字产品的缔造者，这些风靡全球亿万人的电子产品，深刻地改变了现代通讯、娱乐乃至生活的方式。";
//    params.paramImages = @"http://img1.gtimg.com/tech/pics/hv1/95/153/847/55115285.jpg";
//    params.paramUrl = @"http://www.qq.com";
//	
//	if(![_tencentOAuth addShareWithParams:params]){
//        [self showInvalidTokenOrOpenIDMessage];
//    }
    
}

-(void)doShare2QQZone{
    
    PLog(@"doShare2QQZone...");
    
}

-(IBAction)doHideKeyborad:(id)sender{
    
    PLog(@"doHideKeyborad...");
    
    [_shareContentView.tvShareContent resignFirstResponder];
    
}

-(IBAction)doShowAt:(id)sender{
    
    PLog(@"doShowAt...");
    
}

#pragma mark - UITextViewDelegate

//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    
//    PLog(@"textViewShouldBeginEditing...");
//    
//}
//
//- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
//    
//    PLog(@"textViewShouldEndEditing...");
//    
//}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    //textview长度为0
    if (_shareContentView.tvShareContent.text.length == 0) {
        //判断是否为删除键
        if ([text isEqualToString:@""]) {
            _shareContentView.lblPlaceHolder.hidden = NO;
        } else {
            _shareContentView.lblPlaceHolder.hidden = YES;
        }
    } else if (_shareContentView.tvShareContent.text.length == 1) {
        //判断是否为删除键
        if ([text isEqualToString:@""]) {
            _shareContentView.lblPlaceHolder.hidden = NO;
        } else {
            _shareContentView.lblPlaceHolder.hidden = YES;
        }
    } else {
        _shareContentView.lblPlaceHolder.hidden = YES;
    }
    
    
    return YES;
}

#pragma mark - UITableView delegate

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // ...
    
    PLog(@"didSelectRowAtIndexPath, indexPath.section: %d, indexPath.row: %d", indexPath.section, indexPath.row);
    
    if (indexPath.section == 1) {
        [self doShare:nil];
    }
    
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
    
    static NSString *CellIdentifier = @"TableViewCell";
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellAccessoryDisclosureIndicator reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                _shareContentView = [[ShareContentView alloc] initShareContentView];
                _shareContentView.tag = 111;
                _shareContentView.tvShareContent.delegate = self;
                _shareContentView.tvShareContent.returnKeyType = UIReturnKeyDone;
                
                [_shareContentView.btnAt addTarget:self action:@selector(doShowAt:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell.contentView addSubview:_shareContentView];
            } else {
                ShareMenuView *shareMenuView = [[ShareMenuView alloc] initShareMenuView];
                shareMenuView.tag = 222;
                [cell.contentView addSubview:shareMenuView];
            }
        } else if (indexPath.section == 1) {
            
            UIButton *btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
            btnShare.frame = CGRectMake(0, 0, 300, 44);
            btnShare.tag = 333;
            [btnShare setBackgroundImage:[UIImage imageNamed:@"share_button_share_bg.png"] forState:UIControlStateNormal];
            [btnShare setTitle:@"分享" forState:UIControlStateNormal];
            cell.backgroundView = btnShare;
            
        }
        
	}
    
    NSArray *section0 = [_datalist objectAtIndex:indexPath.section];
    NSDictionary *dicMenu = [section0 objectAtIndex:indexPath.row];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            //edit _shareContentView
//            ShareContentView *tempView = (ShareContentView *)[cell.contentView viewWithTag:111];
            
            
        } else {
            
            ShareMenuView *tempView = (ShareMenuView *)[cell.contentView viewWithTag:222];
            tempView.iconImageView.image = [UIImage imageNamed:[dicMenu objectForKey:@"MenuImageName"]];
            tempView.lblDesc.text = [dicMenu objectForKey:@"MenuText"];
            
        }
        
        
        
    } else if (indexPath.section == 1) {
        
        //
        
    }
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 97;
    }
    
    return 45;
}

@end
