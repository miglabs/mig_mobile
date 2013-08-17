//
//  PTabBarViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-17.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootNavigationMenuView.h"

@interface PTabBarViewController : UITabBarController

@property (nonatomic, retain) RootNavigationMenuView *rootNavMenuView;

-(void)hideTabBar;
-(IBAction)doSelectedFirstMenu:(id)sender;
-(IBAction)doSelectedSecondMenu:(id)sender;
-(IBAction)doSelectedThridMenu:(id)sender;

@end
