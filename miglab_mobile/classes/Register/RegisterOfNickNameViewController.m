//
//  RegisterOfNickNameViewController.m
//  miglab_mobile
//
//  Created by pig on 13-7-31.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "RegisterOfNickNameViewController.h"

@interface RegisterOfNickNameViewController ()

@end

@implementation RegisterOfNickNameViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doBack:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
