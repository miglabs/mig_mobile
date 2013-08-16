//
//  RootViewController.m
//  miglab_mobile
//
//  Created by apple on 13-8-16.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

@synthesize rootNavMenuView = _rootNavMenuView;

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
    
    [self hideTabBar];
    
    _rootNavMenuView = [[RootNavigationMenuView alloc] initRootNavigationMenuView:CGRectMake(0, 0, 320, 44)];
    [_rootNavMenuView.btnMenuFirst addTarget:self action:@selector(doSelectedFirstMenu:) forControlEvents:UIControlEventTouchUpInside];
    [_rootNavMenuView.btnMenuSecond addTarget:self action:@selector(doSelectedSecondMenu:) forControlEvents:UIControlEventTouchUpInside];
    [_rootNavMenuView.btnMenuThird addTarget:self action:@selector(doSelectedThridMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rootNavMenuView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hideTabBar{
    
    for (UIView *view in self.view.subviews) {
        
        if ([view isKindOfClass:[UITabBar class]]) {
            
            view.hidden = YES;
            
            break;
        }
        
    }
    
}

-(IBAction)doSelectedFirstMenu:(id)sender{
    
    NSLog(@"doSelectedFirstMenu...");
    
    self.selectedIndex = 0;
    [_rootNavMenuView setSelectedMenu:0];
    
}

-(IBAction)doSelectedSecondMenu:(id)sender{
    
    NSLog(@"doSelectedSecondMenu...");
    
    self.selectedIndex = 1;
    [_rootNavMenuView setSelectedMenu:1];
    
}

-(IBAction)doSelectedThridMenu:(id)sender{
    
    NSLog(@"doSelectedThridMenu...");
    
    self.selectedIndex = 2;
    [_rootNavMenuView setSelectedMenu:2];
    
}

@end
