//
//  AppDelegate.h
//  miglab_mobile
//
//  Created by pig on 13-6-1.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMenuController.h"
#import "HomeViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navController;

@property (nonatomic, retain) DDMenuController *menuController;
@property (nonatomic, retain) HomeViewController *homeViewController;
@property (nonatomic, retain) LeftViewController *leftViewController;
@property (nonatomic, retain) RightViewController *rightViewController;

@end
