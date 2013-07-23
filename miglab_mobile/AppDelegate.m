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
#import "PDatabaseManager.h"

#import "GuideViewController.h"

#import "MainMenuViewController.h"

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
        
        PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
        AccountOf3rdParty *lastAccount = [databaseManager getLastLoginUserAccount];
        if (lastAccount && lastAccount.accesstoken && lastAccount.accountid) {
            
            User *user = [[User alloc] init];
            user.username = lastAccount.username;
            user.password = lastAccount.password;
            user.userid = lastAccount.accountid;
            user.source = lastAccount.accounttype;
            [UserSessionManager GetInstance].currentUser = user;
            [UserSessionManager GetInstance].accesstoken = lastAccount.accesstoken;
            [UserSessionManager GetInstance].isLoggedIn = YES;
            
        } else {
            
            [databaseManager insertUserAccout:@"pig" password:@"pig"];
            
            User *user = [[User alloc] init];
            user.username = @"archer1234";
            user.password = @"123456";
            [UserSessionManager GetInstance].currentUser = user;
            
            PLog(@"username: %@, password: %@", user.username, user.password);
            
        }
        
        //0-测试，1-左右侧滑菜单，2-播放菜单主页
        int initHomeViewType = 1;
        
        if (initHomeViewType == 0) {
            //
            TestViewController *testViewController = [[TestViewController alloc] initWithNibName:@"TestViewController" bundle:nil];
            _navController = [[UINavigationController alloc] initWithRootViewController:testViewController];
            _navController.navigationBar.hidden = YES;
            
            self.window.rootViewController = _navController;
            [self.window addSubview:self.navController.view];
            
        } else if (initHomeViewType == 1) {
            
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
            
        } else if (initHomeViewType == 2) {
            
            MainMenuViewController *mainMenuViewController = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
            _navController = [[UINavigationController alloc] initWithRootViewController:mainMenuViewController];
            _navController.navigationBar.hidden = YES;
            
            self.window.rootViewController = _navController;
            [self.window addSubview:self.navController.view];
            
        }
        
    }//
    
    //api test
    NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
    NSString *username = [UserSessionManager GetInstance].currentUser.username;
    NSString *password = [UserSessionManager GetInstance].currentUser.password;
    NSString *userid = [UserSessionManager GetInstance].currentUser.userid;
    
    MigLabAPI *miglabAPI = [[MigLabAPI alloc] init];
    [miglabAPI doGetWorkOfMood:userid token:accesstoken];
    [miglabAPI doGetWorkOfScene:userid token:accesstoken];
    
    [miglabAPI doGetModeMusic:userid token:accesstoken wordid:@"1" mood:@"mm"];
    
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
    
    //处理本地推送提醒，一段时间未使用软件则提示
//    [self doLocalNotification];
    
}

//处理本地推送提醒，一段时间未使用软件则提示
-(void)doLocalNotification{
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    /*
     1、几天不见，榜单又有更新喽，快来看看有什么好歌吧
     2、这么多天不来好声音，伦家都感觉不会再爱了~
     3、“你伤害了我，却一笑而过，你肿么可以许久不来看我。。。”讨厌~
     4、几天没见，好声音好想里呀~~快来看看吧~
     5、好声音重磅打造，海量新歌上线，快来欢唱吧~
     */
    NSArray *alertBodyList = [NSArray arrayWithObjects:@"几天不见，榜单又有更新喽，快来看看有什么好歌吧", @"这么多天不来好声音，伦家都感觉不会再爱了~", @"\"你伤害了我，却一笑而过，你肿么可以许久不来看我。。。\"讨厌~", @"几天没见，好声音好想里呀~~快来看看吧~", @"好声音重磅打造，海量新歌上线，快来欢唱吧~", nil];
    int nAlertBodyListSize = [alertBodyList count];
    
    NSDate *nowDate = [NSDate new];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];
    NSString *strHour = [formatter stringFromDate:nowDate];
    NSLog(@"strHour: %@, %d", strHour, [@"0" intValue]);
    int nHour = [strHour intValue];
    
    long addSecond = 72 * 3600;
    if (nHour < 9) {
        addSecond += (9 - nHour) * 3600;
    } else if (nHour == 13) {
        addSecond += 3600;
    } else if (nHour >= 21) {
        addSecond += (24 - nHour + 9) * 3600;//延后小时
    }
    
    for (int i=0; i<10; i++) {
        
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        if (localNotification) {
            NSLog(@"support local notification...");
            
            //一个月制定10个，按月循环启动
            addSecond += 3600 * 72 * i;
            //随机显示消息内容
            int rnd = random() % nAlertBodyListSize;
            NSString *strAlertBody = [alertBodyList objectAtIndex:rnd];
            
            NSLog(@"addSecond: %ld, rnd: %d, strAlertBody: %@", addSecond, rnd, strAlertBody);
            
            localNotification.fireDate = [nowDate dateByAddingTimeInterval:addSecond];
            localNotification.timeZone = [NSTimeZone defaultTimeZone];
            localNotification.alertBody = strAlertBody;
            localNotification.hasAction = YES;
            localNotification.soundName = @"sound.caf";
            localNotification.repeatInterval = kCFCalendarUnitMonth;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            
        }//if
        
    }//for
    
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
