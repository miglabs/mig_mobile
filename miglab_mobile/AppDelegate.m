//
//  AppDelegate.m
//  miglab_mobile
//
//  Created by pig on 13-6-1.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "AppDelegate.h"
#import "UncaughtExceptionHandler.h"
#import <AVFoundation/AVFoundation.h>
#import "AFNetworkActivityIndicatorManager.h"
#import "GuideViewController.h"
#import "HomeViewController.h"
#import "User.h"
#import "UserSessionManager.h"
#import "SinaWeibo.h"

//test
#import "Song.h"
#import "SongDownloadManager.h"
#import "TestViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navController = _navController;

@synthesize menuController = _menuController;
@synthesize homeViewController = _homeViewController;
@synthesize leftViewController = _leftViewController;
@synthesize rightViewController = _rightViewController;

@synthesize sinaweibo = _sinaweibo;

//for crash
-(void)installUncaughtExceptionHandler
{
    InstallUncaughtExceptionHandler();
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self installUncaughtExceptionHandler];//
    
    //这种方式后台，可以连续播放非网络请求歌曲。遇到网络请求歌曲就废，需要后台申请task
    /*
     * AudioSessionInitialize用于处理中断处理，
     * AVAudioSession主要调用setCategory和setActive方法来进行设置，
     * AVAudioSessionCategoryPlayback一般用于支持后台播放
     */
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *setCategoryError = nil;
    [session setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    NSError *activationError = nil;
    [session setActive:YES error:&activationError];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //增加标识，用于判断是否是第一次启动应用...
    if (NO && ![[NSUserDefaults standardUserDefaults] boolForKey:@"FirstLaunch"]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstLaunch"];
        
        GuideViewController *guideViewController = [[GuideViewController alloc] initWithNibName:@"GuideViewController" bundle:nil];
        _navController = [[UINavigationController alloc] initWithRootViewController:guideViewController];
        _navController.navigationBar.hidden = YES;
        
        self.window.rootViewController = _navController;
        [self.window addSubview:self.navController.view];
        
    } else {
        
        User *user = [[User alloc] init];
        user.username = @"archer1234";
        user.password = @"123456";
        [UserSessionManager GetInstance].currentUser = user;
        
        PLog(@"username: %@, password: %@", user.username, user.password);
        
        BOOL doTest = NO;
        
        if (doTest) {
            //
            TestViewController *testViewController = [[TestViewController alloc] initWithNibName:@"TestViewController" bundle:nil];
            _navController = [[UINavigationController alloc] initWithRootViewController:testViewController];
            _navController.navigationBar.hidden = YES;
            
            self.window.rootViewController = _navController;
            [self.window addSubview:self.navController.view];
            
        } else {
            
            _homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
            _navController = [[UINavigationController alloc] initWithRootViewController:_homeViewController];
            [_navController.navigationBar setHidden:YES];
            
            //menu
            DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:_navController];
            _leftViewController = [[LeftViewController alloc] initWithNibName:@"LeftViewController" bundle:nil];
            _rightViewController = [[RightViewController alloc] initWithNibName:@"RightViewController" bundle:nil];
            rootController.leftViewController = _leftViewController;
            rootController.rightViewController = _rightViewController;
            
            _menuController = rootController;
            self.window.rootViewController =  rootController;
        }
        
    }//
    
    //
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSLog(@"applicationDidEnterBackground...");
    
    [application beginReceivingRemoteControlEvents];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSLog(@"applicationDidBecomeActive...");
    [_sinaweibo applicationDidBecomeActive];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma something
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    if ([[url absoluteString] hasPrefix:@"wx"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    if ([[url absoluteString] hasPrefix:@"sinaweibosso"]) {
        return [_sinaweibo handleOpenURL:url];
    }
    
    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    if ([[url absoluteString] hasPrefix:@"wx"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    if ([[url absoluteString] hasPrefix:@"sinaweibosso"]) {
        return [_sinaweibo handleOpenURL:url];
    }
    
    return YES;
}

@end
