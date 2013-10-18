//
//  SettingOfModifyNicknameViewController.m
//  miglab_mobile
//
//  Created by apple on 13-9-4.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "SettingOfModifyNicknameViewController.h"
#import "UserSessionManager.h"

@interface SettingOfModifyNicknameViewController ()

@end

@implementation SettingOfModifyNicknameViewController

@synthesize textBgImageView = _textBgImageView;
@synthesize nicknameTextField = _nicknameTextField;
@synthesize lblErrorMessage = _lblErrorMessage;

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
    
    //nav bar
    self.navView.titleLabel.text = @"修改昵称";
    self.bgImageView.hidden = YES;
    
    CGRect textbgframe = _textBgImageView.frame;
    textbgframe.origin.y += self.topDistance;
    _textBgImageView.frame = textbgframe;
    
    //body
    CGRect nicknameframe = _nicknameTextField.frame;
    nicknameframe.origin.y += self.topDistance;
    _nicknameTextField.frame = nicknameframe;
    _nicknameTextField.delegate = self;
    _nicknameTextField.returnKeyType = UIReturnKeyDone;
    _nicknameTextField.textColor = [UIColor colorWithRed:61.0f/255.0f green:61.0f/255.0f blue:61.0f/255.0f alpha:1.0f];
    _nicknameTextField.text = [UserSessionManager GetInstance].currentUser.nickname;
    
    //error
    CGRect errormessageframe = _lblErrorMessage.frame;
    errormessageframe.origin.y += self.topDistance;
    _lblErrorMessage.frame = errormessageframe;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doSaveNickname:(id)sender{
    
    PLog(@"doSaveNickname...");
    
}

-(IBAction)doHideKeyBoard:(id)sender{
    
    PLog(@"doHideKeyBoard...");
    
    [_nicknameTextField resignFirstResponder];
    
}

#pragma UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self doSaveNickname:nil];
    
    return YES;
}

@end
