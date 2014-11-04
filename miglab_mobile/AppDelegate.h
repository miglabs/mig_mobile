//
//  AppDelegate.h
//  miglab_mobile
//
//  Created by pig on 13-6-1.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "BPush.h"

#import "RootViewController.h"

@class SinaWeibo;

@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate, BPushDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, strong) RootViewController *rootViewController;

@property (nonatomic, retain) SinaWeibo *sinaweibo;

@end
