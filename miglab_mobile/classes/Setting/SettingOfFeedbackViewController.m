//
//  SettingOfFeedbackViewController.m
//  miglab_mobile
//
//  Created by pig on 13-9-25.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "SettingOfFeedbackViewController.h"

@interface SettingOfFeedbackViewController ()

@end

@implementation SettingOfFeedbackViewController

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
    self.navView.titleLabel.text = @"向我吐槽";
    self.bgImageView.hidden = YES;
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
