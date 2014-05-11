//
//  PCustomTabBarViewController.m
//  itime
//
//  Created by pig on 13-1-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PCustomTabBarViewController.h"

@interface PCustomTabBarViewController ()

@end

@implementation PCustomTabBarViewController

@synthesize titleList;
@synthesize normalIconList;
@synthesize selectedIconList;
@synthesize pCustomTabBarView;

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
	// Do any additional setup after loading the view.
    
    [self initCustomTabBar];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self hideRealTabBar];
    
}

-(void)dealloc{
    
    [self setTitleList:nil];
    [self setNormalIconList:nil];
    [self setSelectedIconList:nil];
    [self setPCustomTabBarView:nil];
    [super dealloc];
    
}

-(void)initCustomTabBar{
    
    NSArray *tempTitleList = [NSArray arrayWithObjects:@"Live", @"", @"Profile", nil];
    [self setTitleList:tempTitleList];
    
    NSArray *tempNormalIconList = [NSArray arrayWithObjects:@"tab_live.png", @"tab_camera.png", @"tab_profile.png", nil];
    [self setNormalIconList:tempNormalIconList];
    [tempNormalIconList release];
    
    NSArray *tempSelectedIconList = [NSArray arrayWithObjects:@"tab_live.png", @"tab_camera_sel.png", @"tab_profile.png", nil];
    [self setSelectedIconList:tempSelectedIconList];
    [tempSelectedIconList release];
    
    PCustomTabBarView *tempCustomTabBarView = [[PCustomTabBarView alloc] initWithTitleList:self.titleList normalIconList:self.normalIconList selectedIconList:self.selectedIconList];
    [tempCustomTabBarView setDelegate:self];
    [self setPCustomTabBarView:tempCustomTabBarView];
    [tempCustomTabBarView release];
    
    self.pCustomTabBarView.frame = CGRectMake(0, self.view.frame.size.height-50, self.pCustomTabBarView.frame.size.width, self.pCustomTabBarView.frame.size.height);
    [self.view addSubview:self.pCustomTabBarView];
    
    
}

-(void)hideRealTabBar{
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITabBar class]]) {
            view.hidden = YES;
            break;
        }
    }
    
}

-(void)hideCustomTabBar{
    
    for (UIView *view in self.view.subviews) {
        if([view isKindOfClass:[PCustomTabBarView class]]){
            view.hidden = NO;
            break;
        }
    }
    
}

-(void)showCustomTabBar{
    
    for (UIView *view in self.view.subviews) {
        if([view isKindOfClass:[PCustomTabBarView class]]){
            view.hidden = YES;
            break;
        }
    }
    
}

#pragma PCustomTabBarView delegate
-(BOOL)selectedCustomTabBarItemViewIndex:(int)tIndex{
    
    /*
     * 通过实现b委托，将button的事件传递出来，切换到对应的viewcontroller
     */
    [self setSelectedIndex:tIndex];
    return YES;
    
}

@end
