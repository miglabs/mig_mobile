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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
    
    _lblinfo = [[UILabel alloc] initWithFrame:CGRectMake(ORIGIN_X, 80, ORIGIN_WIDTH, 60)];
    _lblinfo.text = @"想对Ta说些什么呢？";
    [self.view addSubview:_lblinfo];
    
    _text = [[UITextField alloc] initWithFrame:CGRectMake(ORIGIN_X, 140, ORIGIN_WIDTH, 50)];
    _text.placeholder = @"...";
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
    
    NSString* userid = [UserSessionManager GetInstance].userid;
    NSString* accesstoken = [UserSessionManager GetInstance].accesstoken;
    
    NSString* touserid = _touserid;
    NSString* content = [_text text];
    
    [self.miglabAPI doSayHello:userid token:accesstoken touid:touserid msg:content];
}

-(void)doSayHelloSuccess:(NSNotification *)tNotification {
    
    [SVProgressHUD showErrorWithStatus:@"打招呼成功啦！！！"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doSayHelloFailed:(NSNotification *)tNotification {
    
    [SVProgressHUD showErrorWithStatus:@"打招呼失败了:("];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - textfield delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [_text resignFirstResponder];
    
    return YES;
}


@end
