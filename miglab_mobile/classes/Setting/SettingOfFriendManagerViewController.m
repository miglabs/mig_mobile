//
//  SettingOfFriendManagerViewController.m
//  miglab_mobile
//
//  Created by pig on 13-9-7.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "SettingOfFriendManagerViewController.h"

@interface SettingOfFriendManagerViewController ()

@end

@implementation SettingOfFriendManagerViewController

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
    self.navView.titleLabel.text = @"黑名单管理";
    self.bgImageView.hidden = YES;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
