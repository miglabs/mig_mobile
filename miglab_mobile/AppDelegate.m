//
//  AppDelegate.m
//  miglab_mobile
//
//  Created by pig on 13-6-1.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "AppDelegate.h"
//#import "UncaughtExceptionHandler.h"
#import "MigLabConfig.h"
#import "MobClick.h"
#import <AVFoundation/AVFoundation.h>
#import "AFNetworkActivityIndicatorManager.h"
#import "PDatabaseManager.h"

#import "GuideViewController.h"

#import "RootViewController.h"
#import "GeneViewController.h"
#import "MusicViewController.h"
#import "FriendViewController.h"
#import "MessageViewController.h"

#import "MainMenuViewController.h"

#import "PUser.h"
#import "UserSessionManager.h"
#import "GlobalDataManager.h"
#import "SinaWeibo.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <libDoubanAPIEngine/DOUService.h>
#import <Crashlytics/Crashlytics.h>
#import <sys/utsname.h>

//test
#import "Song.h"
#import "SongDownloadManager.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navController = _navController;

@synthesize sinaweibo = _sinaweibo;

- (void)umengTrack {
    
    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
//    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    
    [MobClick updateOnlineConfig];  //在线参数配置
    
}

//这种方式后台，可以连续播放非网络请求歌曲。遇到网络请求歌曲就废，需要后台申请task
-(void)setAudioSession{
    
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
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //Crashlytics
    [Crashlytics startWithAPIKey:@"13b0dd85b007ad78249b02fc26fa3972dff8da79"];
    
    //登录后，可记录用户信息. 替换里面的字符串， USER_ID，USER_EMAIL，USER_NAME
    [Crashlytics setUserIdentifier:@"USER_ID_VALUE"];
    [Crashlytics setUserEmail:@"USER_EMAIL_VALUE"];
    [Crashlytics setUserName:@"USER_NAME_VALUE"];
    
    //友盟的方法本身是异步执行，所以不需要再异步调用
    [self umengTrack];
    
    //这种方式后台，可以连续播放非网络请求歌曲。遇到网络请求歌曲就废，需要后台申请task
    [self setAudioSession];
    
    //add by zhuruhong 20130728
    //Once the view has loaded then we can register to begin recieving controls and we can become the first responder
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    //网络请求指示器
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    //douban
    DOUService *service = [DOUService sharedInstance];
    service.clientId = DOUBAN_API_KEY;
    service.clientSecret = DOUBAN_PRIVATE_KEY;
    
    //向微信注册
    [WXApi registerApp:WEIXIN_APP_ID];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
#ifdef DEBUG
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
#endif
    
    //增加标识，用于判断是否是第一次启动应用...
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"FirstLaunch"]) {
        
        [GlobalDataManager GetInstance].isMainMenuFirstLaunch = YES;
        [GlobalDataManager GetInstance].isGeneMenuFirstLaunch = NO;
        [GlobalDataManager GetInstance].isFirendMenuFirstLaunch = YES;
        [GlobalDataManager GetInstance].isProgramFirstLaunch = YES;
        [GlobalDataManager GetInstance].isDetailPlayFirstLaunch = YES;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstLaunch"];
        
    } else {
        
        [GlobalDataManager GetInstance].isMainMenuFirstLaunch = NO;
        [GlobalDataManager GetInstance].isGeneMenuFirstLaunch = NO;
        [GlobalDataManager GetInstance].isFirendMenuFirstLaunch = NO;
        [GlobalDataManager GetInstance].isProgramFirstLaunch = NO;
        [GlobalDataManager GetInstance].isDetailPlayFirstLaunch = NO;
    }
    
    /* Begin show main menu */
    {
        PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
        AccountOf3rdParty *lastAccount = [databaseManager getLastLoginUserAccount];
        int loginstatus = [databaseManager getLoginStatusInfo];
        if ( loginstatus && lastAccount && lastAccount.accesstoken && lastAccount.accountid) {
            
            PUser *tempuser = [databaseManager getUserInfoByAccountId:lastAccount.accountid];
            if (tempuser) {
                
                tempuser.password = lastAccount.password;
                
                [UserSessionManager GetInstance].currentUser = tempuser;
                [UserSessionManager GetInstance].userid = tempuser.userid;
                [UserSessionManager GetInstance].accesstoken = tempuser.token;
                [UserSessionManager GetInstance].accounttype = tempuser.source;
                [UserSessionManager GetInstance].isLoggedIn = YES;
            }
            
        } else {
            
//            [databaseManager insertUserAccout:@"liujun2458@163.com" password:@"123456"];
//            
//            PUser *user = [[PUser alloc] init];
//            user.username = @"liujun2458@163.com";
//            user.password = @"123456";
//            [UserSessionManager GetInstance].currentUser = user;
//            
//            PLog(@"username: %@, password: %@", user.username, user.password);
            
        }
        
        _rootViewController = [RootViewController sharedInstance];
        _navController = [[UINavigationController alloc] initWithRootViewController:_rootViewController];
        _navController.navigationBar.hidden = YES;
        
        self.window.rootViewController = _navController;
        [self.window addSubview:self.navController.view];
        
    }//
    
    // 初始化全局变量
    {
        NSDictionary* deviceNamesByCode =
                            @{@"i386"      :@"Simulator",
                              @"iPod1,1"   :@"iPod Touch",      // (Original)
                              @"iPod2,1"   :@"iPod Touch",      // (Second Generation)
                              @"iPod3,1"   :@"iPod Touch",      // (Third Generation)
                              @"iPod4,1"   :@"iPod Touch",      // (Fourth Generation)
                              @"iPhone1,1" :@"iPhone",          // (Original)
                              @"iPhone1,2" :@"iPhone",          // (3G)
                              @"iPhone2,1" :@"iPhone",          // (3GS)
                              @"iPad1,1"   :@"iPad",            // (Original)
                              @"iPad2,1"   :@"iPad",            //
                              @"iPad3,1"   :@"iPad",            // (3rd Generation)
                              @"iPhone3,1" :@"iPhone 4",        //
                              @"iPhone4,1" :@"iPhone 4S",       //
                              @"iPhone5,1" :@"iPhone 5",        // (model A1428, AT&T/Canada)
                              @"iPhone5,2" :@"iPhone 5",        // (model A1429, everything else)
                              @"iPad3,4"   :@"iPad",            // (4th Generation)
                              @"iPad2,5"   :@"iPad Mini",       // (Original)
                              @"iPhone5,3" :@"iPhone 5c",       // (model A1456, A1532 | GSM)
                              @"iPhone5,4" :@"iPhone 5c",       // (model A1507, A1516, A1526 (China), A1529 | Global)
                              @"iPhone6,1" :@"iPhone 5s",       // (model A1433, A1533 | GSM)
                              @"iPhone6,2" :@"iPhone 5s",       // (model A1457, A1518, A1528 (China), A1530 | Global)
                              @"iPad4,1"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Wifi
                              @"iPad4,2"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Cellular
                              @"iPad4,4"   :@"iPad Mini",       // (2nd Generation iPad Mini - Wifi)
                              @"iPad4,5"   :@"iPad Mini"        // (2nd Generation iPad Mini - Cellular)
                              };
        
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString* code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        NSString* deviceName = [deviceNamesByCode objectForKey:code];
        
        if ([deviceName isEqualToString:@"iPhone 5c"]
            || [deviceName isEqualToString:@"iPhone 5s"]
            || [deviceName isEqualToString:@"iPhone 5"]) {
            
            [GlobalDataManager GetInstance].isLongScreen = YES;
        }
        else {
            
            [GlobalDataManager GetInstance].isLongScreen = NO;
        }
        
        if ([deviceName isEqualToString:@"iPad Air"]
            || [deviceName isEqualToString:@"iPad"]) {
            
            [GlobalDataManager GetInstance].isPad = YES;
        }
        else {
            
            [GlobalDataManager GetInstance].isPad = NO;
        }
        
        double version = [[UIDevice currentDevice].systemVersion doubleValue];
        [GlobalDataManager GetInstance].isIOS7Up = version >= 7 ? YES : NO;
    }
    
    //显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    //NSString *username = [UserSessionManager GetInstance].currentUser.username;
    //NSString *password = [UserSessionManager GetInstance].currentUser.password;
    NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
    NSString *userid = [UserSessionManager GetInstance].currentUser.userid;
    
    MigLabAPI *miglabAPI = [[MigLabAPI alloc] init];
    
    if ([UserSessionManager GetInstance].isLoggedIn && NO) {
        
        [miglabAPI doGetWorkOfMood:userid token:accesstoken];
        [miglabAPI doGetWorkOfScene:userid token:accesstoken];
        [miglabAPI doGetModeMusic:userid token:accesstoken wordid:@"1" mood:@"mm" num:2];
        [miglabAPI doGetModeMusic:userid token:accesstoken wordid:@"3" mood:@"ms" num:8];
        
        [miglabAPI doGetChannel:userid token:accesstoken num:10];
        [miglabAPI doGetMusicFromChannel:userid token:accesstoken channel:3];
        
        //[miglabAPI doHateSong:accesstoken uid:userid sid:99993];
        
        //获取频道
        [miglabAPI doGetChannel:userid token:accesstoken num:10];
        
        [miglabAPI doGetDefaultGuestSongs];
        
    }
    
    //
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //注册device token
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert];
    
    if (launchOptions) {
        
        NSDictionary* pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
        if (pushNotificationKey) {
            
            /* 如果程序是通过消息启动的，在这里做处理 */
        }
    }
    
    
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
    
    //add by zhuruhong 20130728
    //End recieving events
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    
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
            int rnd = rand() % nAlertBodyListSize;
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
    
    //add by zhuruhong 20130728
    //Once the view has loaded then we can register to begin recieving controls and we can become the first responder
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
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
    
    if ([[url absoluteString] hasPrefix:@"tencent"]) {
        return [TencentOAuth HandleOpenURL:url];
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
    
    if ([[url absoluteString] hasPrefix:@"tencent"]) {
        return [TencentOAuth HandleOpenURL:url];
    }
    
    return YES;
}

#pragma weixin
-(void)onReq:(BaseReq *)req{
    //onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        //
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        //
    }
    
}

-(void)onResp:(BaseResp *)resp{
    //如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        NSLog(@"resp.errCode: %d, resp.description: %@", resp.errCode, resp.description);
    }
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString* device_token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    PLog(@"device token: %@", deviceToken);
    
    [UserSessionManager GetInstance].devicetoken = device_token;
    
    /* 如果用户已经登录，则发送一次数据 */
    if ([UserSessionManager GetInstance].isLoggedIn) {
        
        MigLabAPI* miglab = [[MigLabAPI alloc] init];
        
        NSString* userid = [UserSessionManager GetInstance].userid;
        NSString* accesstoken = [UserSessionManager GetInstance].accesstoken;
        
        [miglab doConfigPush:userid token:accesstoken devicetoken:device_token isreceive:@"1" begintime:@"08:00" endtime:@"23:55"];
    }
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    PLog(@"get device token failed");
}

-(void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    /* 处理推送消息 */
    PLog(@"receive message from push");
    
    /* 清理右上角的未读消息标记 */
    application.applicationIconBadgeNumber = 0;
    [application cancelAllLocalNotifications];
    
    /* 跳转到推送消息的页面 */
    MessageViewController* msgViewControl = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
    
    [self.navController pushViewController:msgViewControl animated:YES];
}

#ifdef DEBUG

void uncaughtExceptionHandler(NSException* exception) {
    
    PLog(@"CRASH: %@", exception);
    PLog(@"Stack Trace: %@", [exception callStackSymbols]);
}

#endif

@end
