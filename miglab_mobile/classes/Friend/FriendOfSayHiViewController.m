//
//  FriendOfSayHiViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-23.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "FriendOfSayHiViewController.h"

@interface FriendOfSayHiViewController ()

@end

@implementation FriendOfSayHiViewController

@synthesize text = _text;
@synthesize lblinfo = _lblinfo;
@synthesize touserid = _touserid;
@synthesize isSendingMsg = _isSendingMsg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doSayHelloSuccess:) name:NotificationNameSayHelloSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doSayHelloFailed:) name:NotificationNameSayHelloFailed object:nil];
    }
    return self;
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameSayHelloSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameSayHelloFailed object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _isSendingMsg = NO;
    
    //nav
    CGRect navViewFrame = self.navView.frame;
    float posy = navViewFrame.origin.y + navViewFrame.size.height;//ios6-45, ios7-65
    
    //nav bar
    self.navView.titleLabel.text = @"打招呼";
    
    UIImage* sureImage = [UIImage imageWithName:@"friend_sayhi_button_ok" type:@"png"];
    [self.navView.rightButton setBackgroundImage:sureImage forState:UIControlStateNormal];
    self.navView.rightButton.frame = CGRectMake(268, 7.5+self.topDistance, 48, 29);
    [self.navView.rightButton setHidden:NO];
    [self.navView.rightButton addTarget:self action:@selector(doSayHello:) forControlEvents:UIControlEventTouchUpInside];
    
    posy += 10;
    
    _lblinfo = [[UILabel alloc] initWithFrame:CGRectMake(ORIGIN_X, posy, ORIGIN_WIDTH, 45)];
    _lblinfo.text = @"向ta说话打个招呼";
    _lblinfo.textColor = [UIColor grayColor];
    _lblinfo.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_lblinfo];
    
    posy += 55;
    
    _text = [[UITextField alloc] initWithFrame:CGRectMake(ORIGIN_X, posy, ORIGIN_WIDTH, 45)];
    _text.placeholder = @"30字以内";
    _text.textAlignment = UITextAlignmentLeft;
    _text.borderStyle = 3;
    _text.clearsOnBeginEditing = YES;
    _text.keyboardType = UIKeyboardTypeDefault;
    _text.returnKeyType = UIReturnKeyDone;
    _text.delegate = self;
    
    [self.view addSubview:_text];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)doSayHello:(id)sender {
    
    NSString* content = [_text text];
    int count = [content length];
    
    if (count <= 0) {
        
        [SVProgressHUD showErrorWithStatus:@"您还没有输入任何字哦"];
        return;
    }
    
    if (_isSendingMsg == NO) {
        
        if ([UserSessionManager GetInstance].isLoggedIn) {
            
            _isSendingMsg = YES;
            
            NSString* userid = [UserSessionManager GetInstance].userid;
            NSString* accesstoken = [UserSessionManager GetInstance].accesstoken;
            NSString* touserid = _touserid;
            
            [self.miglabAPI doSayHello:userid token:accesstoken touid:touserid msg:content];
        }
        else {
            
            [SVProgressHUD showErrorWithStatus:MIGTIP_UNLOGIN];
        }
    }
    else {
        
        [SVProgressHUD showErrorWithStatus:MIGTIP_SENDING_MESSAGE];
    }
}

-(void)doSayHelloSuccess:(NSNotification *)tNotification {
    
    [SVProgressHUD showErrorWithStatus:@"打招呼成功啦！！！"];
    
    _isSendingMsg = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doSayHelloFailed:(NSNotification *)tNotification {
    
    [SVProgressHUD showErrorWithStatus:@"打招呼失败了:("];
    
    _isSendingMsg = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - textfield delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [_text resignFirstResponder];
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString* temp = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (temp.length > MAX_SAYHI_COUNT) {
        
        return NO;
    }
    
    return YES;
}


@end
