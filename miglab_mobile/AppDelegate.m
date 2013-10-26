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

#import "MainMenuViewController.h"

#import "HomeViewController.h"
#import "PUser.h"
#import "UserSessionManager.h"
#import "SinaWeibo.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <libDoubanAPIEngine/DOUService.h>

//test
#import "Song.h"
#import "SongDownloadManager.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navController = _navController;

@synthesize menuController = _menuController;
@synthesize homeViewController = _homeViewController;
@synthesize leftViewController = _leftViewController;
@synthesize rightViewController = _rightViewController;

@synthesize sinaweibo = _sinaweibo;

@synthesize tabBarController = _tabBarController;

//for crash
//-(void)installUncaughtExceptionHandler
//{
//    InstallUncaughtExceptionHandler();
//}

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
//    [self installUncaughtExceptionHandler];//
    
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
            
            [databaseManager insertUserAccout:@"liujun2458@163.com" password:@"123456"];
            
            PUser *user = [[PUser alloc] init];
            user.username = @"liujun2458@163.com";
            user.password = @"123456";
            [UserSessionManager GetInstance].currentUser = user;
            
            PLog(@"username: %@, password: %@", user.username, user.password);
            
        }
        
        //0-测试，1-左右侧滑菜单，2-播放菜单主页，3-确认左侧菜单后页面
        int initHomeViewType = 6;
        
        if (initHomeViewType == 0) {
            //
            
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
            
        } else if (initHomeViewType == 3) {
            
            MainMenuViewController *mainMenuViewController = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
            _navController = [[UINavigationController alloc] initWithRootViewController:mainMenuViewController];
            [_navController.navigationBar setHidden:YES];
            
            //menu
            DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:_navController];
            _leftViewController = [[LeftViewController alloc] initWithNibName:@"LeftViewController" bundle:nil];
            _rightViewController = [[RightViewController alloc] initWithNibName:@"RightViewController" bundle:nil];
            rootController.leftViewController = _leftViewController;
            rootController.rightViewController = _rightViewController;
            
            _menuController = rootController;
            self.window.rootViewController =  rootController;
            
        } else if (initHomeViewType == 4) {
            
            MusicViewController *musicViewController = [[MusicViewController alloc] initWithNibName:@"MusicViewController" bundle:nil];
            _navController = [[UINavigationController alloc] initWithRootViewController:musicViewController];
            _navController.navigationBar.hidden = YES;
            
            self.window.rootViewController = _navController;
            [self.window addSubview:self.navController.view];
            
        } else if (initHomeViewType == 5) {
            
            GeneViewController *geneViewController = [[GeneViewController alloc] initWithNibName:@"GeneViewController" bundle:nil];
            MusicViewController *musicViewController = [[MusicViewController alloc] initWithNibName:@"MusicViewController" bundle:nil];
            FriendViewController *friendViewController = [[FriendViewController alloc] initWithNibName:@"FriendViewController" bundle:nil];
            
            geneViewController.hidesBottomBarWhenPushed = YES;
            musicViewController.hidesBottomBarWhenPushed = YES;
            friendViewController.hidesBottomBarWhenPushed = YES;
            
            //初始化TabBarViewController
            _tabBarController = [[PTabBarViewController alloc] initWithNibName:@"PTabBarViewController" bundle:nil];
            _tabBarController.viewControllers = [NSArray arrayWithObjects:geneViewController, musicViewController, friendViewController, nil];
            [_tabBarController doSelectedFirstMenu:nil];
            
            _navController = [[UINavigationController alloc] initWithRootViewController:_tabBarController];
            _navController.navigationBar.hidden = YES;
            
            self.window.rootViewController = _navController;
            [self.window addSubview:self.navController.view];
            
        } else if (initHomeViewType == 6) {
            
            RootViewController *rootViewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
            _navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
            _navController.navigationBar.hidden = YES;
            
            self.window.rootViewController = _navController;
            [self.window addSubview:self.navController.view];
            
        }
        
    }//
    
    //显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    //api test
    
    NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
    NSString *username = [UserSessionManager GetInstance].currentUser.username;
    NSString *password = [UserSessionManager GetInstance].currentUser.password;
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
    
    //[miglabAPI doPresentMusic:userid token:accesstoken touid:userid sid:22869];
    //[miglabAPI doSayHello:userid token:accesstoken touid:userid msg:@"hehe"];
    //[miglabAPI doGetPushMsg:userid token:accesstoken pageindex:@"1" pagesize:@"5"];
    //[miglabAPI doGetSongHistory:@"10343" token:@"12222" fromid:@"" count:@""];
    //[miglabAPI doGetMyNearMusicMsgNumber:@"10343" token:@"121" radius:@"10000" location:@"30.292207031178,120.0855621569"];
    //[miglabAPI doCommentSong:@"1" token:@"2" songid:@"22869" comment:@"haha, nan ting si le"];
    //[miglabAPI doGetSongComment:@"1" token:@"2" songid:@"12323" count:@"1" fromid:@"1"];
    //[miglabAPI doRegister:@"archerhehe2" password:@"12345678" nickname:@"archerhehe2" source:SourceTypeSinaWeibo session:@"1" sex:@"1"];
    
//    [miglabAPI doRegister:@"archerhehe2" password:@"12345678" nickname:@"archerhehe2" source:SourceTypeSinaWeibo session:@"1" sex:@"1"];
    //[miglabAPI doGetNearMusic:@"1" token:@"2" radius:@"10000" pageindex:@"1" pagesize:@"5" location:@"30.30022,120.127393"];
    //[miglabAPI doDeleteCollectedSong:@"1" token:@"2" songid:@"22869"];
    //[miglabAPI doGetSongInfo:@"1" token:@"2" songid:@"22869"];
    //[miglabAPI doRecordCurrentSong:@"1" token:@"2" lastsong:@"22869" cursong:@"22869" mode:@"1" typeid:@"1" name:@"hehh" singer:@"archer" state:@"1"];
    
    
    //[miglabAPI doGetTypeSongs:@"1" token:@"2" moodid:@"1" moodindex:@"2" sceneid:@"2" sceneindex:@"2" channelid:@"1" channelindex:@"2" num:@"5"];
//    [miglabAPI doCollectSong:@"1" token:@"2" sid:@"22869" modetype:@"2" typeid:@"7"];
    //[miglabAPI doHateSong:@"1" token:@"2" sid:@"22869"];
    //[miglabAPI doCollectAndNearNum:@"1" token:@"2" taruid:@"5" radius:@"1000" pageindex:@"0" pagesize:@"10" location:@"30.30022,120.127393"];
    
    /*
    NSString *testuserid = @"10026";
    NSString *testaccesstoken = @"AAOfv3WG35avZspzKhoeodwv2MFd80M2OEVDODFEOTIyRTk1MkJBMzNC";
    [miglabAPI doGetModeMusic:testuserid token:testaccesstoken wordid:@"1" mood:@"mm"];
    [miglabAPI doAddMoodRecord:testuserid token:testaccesstoken wordid:@"1" songid:99993];
    [miglabAPI doSetUserPos:testuserid token:testaccesstoken location:@"30.30022,120.127393"];
    [miglabAPI doSearchNearby:testuserid token:testaccesstoken location:@"30.30022,120.127393" radius:1000];
    */
    
    /*
    testuserid = @"10000";
    testaccesstoken = @"AAOfv3WG35avZspzKhoeodwv2MFd8zYxOUFENUNCMUFBNjgwMDAyRTI2";
    [miglabAPI doGetMoodMap:testuserid token:testaccesstoken];
    [miglabAPI doGetMoodParent:testuserid token:testaccesstoken];
    */
    
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

@end
