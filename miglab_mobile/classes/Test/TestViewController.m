//
//  TestViewController.m
//  miglab_mobile
//
//  Created by apple on 13-6-27.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

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
    
    MigLabAPI *miglabAPI = [[MigLabAPI alloc] init];
    [miglabAPI doRegister:@"pig1" password:@"pig1" nickname:@"pig1" gender:1 birthday:@"2013-06-30" location:@"浙江" age:100 source:1 head:@"image"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
