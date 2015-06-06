//
//  SinaWeiboHelper.m
//  miglab_mobile
//
//  Created by pig on 14-5-18.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import "SinaWeiboHelper.h"
#import "AppDelegate.h"
#import "UserSessionManager.h"
#import "PDatabaseManager.h"
#import "UIImage+ext.h"
#import "SVProgressHUD.h"
#import "GlobalDataManager.h"

@implementation SinaWeiboHelper

BOOL _firstLoadObserver = YES;

+ (id)sharedInstance
{
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SinaWeiboHelper alloc] init];
        [sharedInstance doInit];
    });
    
    return sharedInstance;
}

- (void)doInit {
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:SINA_WEIBO_APP_KEY];
}

/**
 * 登录微博
 */
- (void)doSinaWeiboLogin
{
    _sinaWeiboHelperStatus = SinaWeiboHelperStatusLogin;
    
    [self removeAuthData];
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = SINA_WEIBO_APP_REDIRECTURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SinaWeiboHelper",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    
    return [WeiboSDK handleOpenURL:url delegate:self];
}

// WeiboSDK Delegate
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    
    if ([response isKindOfClass:WBAuthorizeResponse.class]) {
        
        // 授权成功
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            
            NSString *userid = [(WBAuthorizeResponse *)response userID];
            NSString *accesstoken = [(WBAuthorizeResponse *)response accessToken];
            NSDate *expirateDate = [(WBAuthorizeResponse *)response expirationDate];
            
            AccountOf3rdParty *sinaAccount = [[AccountOf3rdParty alloc] init];
            sinaAccount.accountid = userid;
            sinaAccount.accesstoken = accesstoken;
            sinaAccount.expirationdate = expirateDate;
            sinaAccount.accounttype = SourceTypeSinaWeibo;
            
            [UserSessionManager GetInstance].accounttype = SourceTypeSinaWeibo;
            [UserSessionManager GetInstance].currentUser.sinaAccount = sinaAccount;
            [UserSessionManager GetInstance].currentUser.source = SourceTypeSinaWeibo;
            
            // storeAuthData
            NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                                      accesstoken, @"AccessTokenKey",
                                      expirateDate, @"ExpirationDateKey",
                                      userid, @"UserIDKey", nil];
            [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // 新浪微博授权成功, 获取用户信息
            [self getUserInfo];
        }
    }
}


-(void)doShareToSinaWeibo:(LyricShare *)lyric {
    
    if ([UserSessionManager GetInstance].isLoggedIn) {
        
        Song* shareSong = self.shareSong;
        NSString *szLyric = nil;
        
        if (lyric) {
            
            szLyric = lyric.lyric;
        }
        
        NSString *shareText = [NSString stringWithFormat:MIGTIP_WEIBO_SHARE_TEXT_4S, [GlobalDataManager GetInstance].curSongTypeName, shareSong.songname, shareSong.artist, [NSString stringWithFormat:SHARE_WEIBO_ADDRESS_1LONG, shareSong.songid]];
        
        UIImage* shareImage = nil;
        
        shareImage = [[UIImage_ext GetInstance] createLyricShareImage:lyric song:self.shareSong];
        
        NSDictionary *authData = [[NSUserDefaults standardUserDefaults] objectForKey:@"SinaWeiboAuthData"];
        NSString *accesstoken = [authData objectForKey:@"AccessTokenKey"];
        
        [WBHttpRequest requestWithAccessToken:accesstoken url:@"https://upload.api.weibo.com/2/statuses/upload.json" httpMethod:@"POST" params:[NSMutableDictionary dictionaryWithObjectsAndKeys:shareText, @"status", shareImage, @"pic", nil] delegate:self withTag:@"upload"];
        
    } else {
        
        [self doSinaWeiboLogin];
    }
}

- (void)getUserInfo {
    
    NSString *weibouserid = [UserSessionManager GetInstance].currentUser.sinaAccount.accountid;
    NSString *accesstoken = [UserSessionManager GetInstance].currentUser.sinaAccount.accesstoken;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:weibouserid forKey:@"uid"];
    
    [WBHttpRequest requestWithAccessToken:accesstoken url:@"https://api.weibo.com/2/users/show.json" httpMethod:@"GET" params:dic delegate:self withTag:@"userinfo"];
}

- (void)updateSinaWeibo:(Song *)tSong
{
    _sinaWeiboHelperStatus = SinaWeiboHelperStatusUpdate;
    
    if (_firstLoadObserver) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLyricInfoSucceed:) name:NotificationNameGetShareInfoSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLyricInfoFailed:) name:NotificationNameGetShareInfoFailed object:nil];
        
        _firstLoadObserver = NO;
    }
    
    self.shareSong = tSong;
    
    NSString* uid = [UserSessionManager GetInstance].userid;
    NSString* accesstoken = [UserSessionManager GetInstance].accesstoken;
    NSString* tsongid = [NSString stringWithFormat:@"%lld", tSong.songid];
    NSString* ttype = STR_USER_SOURCE_SINA;
    NSString* tlatitude = [GlobalDataManager GetInstance].lastLatitude;
    NSString* tlongitude = [GlobalDataManager GetInstance].lastLongitude;
    NSString* tmode = [GlobalDataManager GetInstance].curSongType;
    NSString* tindex = [NSString stringWithFormat:@"%d", [GlobalDataManager GetInstance].curSongTypeId];
    
    [GlobalDataManager GetInstance].nShareSource = LOGIN_SINA;
    
    MigLabAPI* migapi = [[MigLabAPI alloc] init];
    [migapi doGetShareInfo:uid token:accesstoken songid:tsongid type:ttype mode:tmode index:tindex latitude:tlatitude longitude:tlongitude];
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
    
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result {
    
    NSDictionary *dicResult = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    int error = [[dicResult objectForKey:@"error_code"] intValue];
    
    if (error == 0) {
        
        if ([request.url hasSuffix:@"users/show.json"]) {
            if (_delegate && [_delegate respondsToSelector:@selector(sinaWeiboLoginHelper:didFinishLoadingWithResult:)]) {
                [_delegate sinaWeiboLoginHelper:self didFinishLoadingWithResult:dicResult];
            }
            
            [SVProgressHUD showErrorWithStatus:MIGTIP_LOGIN_SUCCEED];
        } else if ([request.url hasSuffix:@"statuses/update.json"]) {
            if (_delegate && [_delegate respondsToSelector:@selector(sinaWeiboUpdateHelper:didFinishLoadingWithResult:)]) {
                [_delegate sinaWeiboUpdateHelper:self didFinishLoadingWithResult:dicResult];
            }
            
            [SVProgressHUD showErrorWithStatus:MIGTIP_LOGIN_SUCCEED];
        }

    }
    else {
        
    }
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error {
    
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = NSLocalizedString(@"请求异常", nil);
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",error]
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"确定", nil)
                             otherButtonTitles:nil];
    [alert show];
}

#pragma mark - get share info
-(void)getLyricInfoSucceed:(NSNotification *)tNotification {
    
    if (LOGIN_SINA == [GlobalDataManager GetInstance].nShareSource) {
        
        [GlobalDataManager GetInstance].nShareSource = 0;
        
        NSDictionary *dicResult = (NSDictionary*)tNotification.userInfo;
        NSDictionary *dicLyric = [dicResult objectForKey:@"result"];
        
        LyricShare* ls = [LyricShare initWithNSDictionary:dicLyric];
        
        [self doShareToSinaWeibo:ls];
    }
}

-(void)getLyricInfoFailed:(NSNotification *)tNotification {
    
    PLog(@"分享到新浪微博失败");
    
    if (LOGIN_SINA == [GlobalDataManager GetInstance].nShareSource) {
        
        // 没有歌词，只分享文字
        [self doShareToSinaWeibo:nil];
        
        NSDictionary *dicResult = (NSDictionary *)tNotification.userInfo;
        NSString *msg = [dicResult objectForKey:@"msg"];
        
        if ([msg isEqualToString:@"没有歌词"]) {
            
        }
    }
}

#if 0
//sina weibo
- (SinaWeibo *)sinaweibo
{
    //sina weibo
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.sinaweibo) {
        //appDelegate.sinaweibo.delegate = self;
        return appDelegate.sinaweibo;
    }
    
    appDelegate.sinaweibo = [[SinaWeibo alloc] initWithAppKey:SINA_WEIBO_APP_KEY appSecret:SINA_WEIBO_APP_SECRET appRedirectURI:SINA_WEIBO_APP_REDIRECTURI andDelegate:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        appDelegate.sinaweibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        appDelegate.sinaweibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        appDelegate.sinaweibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    }
    return appDelegate.sinaweibo;
}

- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
}

- (void)storeAuthData
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)getUserInfoFromSinaWeibo
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"users/show.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
}

/**
 * 分享微博
 */
#pragma mark - SinaWeibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    [self storeAuthData];
    
    switch (_sinaWeiboHelperStatus) {
        case SinaWeiboHelperStatusLogin:
        {
            AccountOf3rdParty *sinaAccount = [[AccountOf3rdParty alloc] init];
            sinaAccount.accountid = sinaweibo.userID;
            sinaAccount.accesstoken = sinaweibo.accessToken;
            sinaAccount.expirationdate = sinaweibo.expirationDate;
            sinaAccount.accounttype = SourceTypeSinaWeibo;
            
            [UserSessionManager GetInstance].accounttype = SourceTypeSinaWeibo;
            [UserSessionManager GetInstance].currentUser.sinaAccount = sinaAccount;
            [UserSessionManager GetInstance].currentUser.source = SourceTypeSinaWeibo;
            
            [self getUserInfoFromSinaWeibo];
        }
            break;
        case SinaWeiboHelperStatusUpdate:
        {
            [self updateSinaWeibo:_shareSong];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
    [self removeAuthData];
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
    [self removeAuthData];
}

#pragma mark - SinaWeiboRequest Delegate

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
{
    //PLog(@"didFailWithError...%@", request.url);
    if ([request.url hasSuffix:@"users/show.json"]) {
        if (_delegate && [_delegate respondsToSelector:@selector(sinaWeiboLoginHelper:didFailWithError:)]) {
            [_delegate sinaWeiboLoginHelper:self didFailWithError:error];
        }
    } else if ([request.url hasSuffix:@"statuses/update.json"]) {
        if (_delegate && [_delegate respondsToSelector:@selector(sinaWeiboUpdateHelper:didFailWithError:)]) {
            [_delegate sinaWeiboUpdateHelper:self didFailWithError:error];
        }
    }
    
    [SVProgressHUD showErrorWithStatus:MIGTIP_SHARING_FAILED];
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(id)result
{
    PLog(@"didFinishLoadingWithResult: %@", result);
    if ([request.url hasSuffix:@"users/show.json"]) {
        if (result && [result isKindOfClass:[NSDictionary class]]) {
            if (_delegate && [_delegate respondsToSelector:@selector(sinaWeiboLoginHelper:didFinishLoadingWithResult:)]) {
                [_delegate sinaWeiboLoginHelper:self didFinishLoadingWithResult:result];
            }
        }//if
        
        [SVProgressHUD showErrorWithStatus:MIGTIP_LOGIN_SUCCEED];
    } else if ([request.url hasSuffix:@"statuses/update.json"]) {
        if (result && [result isKindOfClass:[NSDictionary class]]) {
            if (_delegate && [_delegate respondsToSelector:@selector(sinaWeiboUpdateHelper:didFinishLoadingWithResult:)]) {
                [_delegate sinaWeiboUpdateHelper:self didFinishLoadingWithResult:result];
            }
        }
        
        [SVProgressHUD showErrorWithStatus:MIGTIP_LOGIN_SUCCEED];
    }
    
    [SVProgressHUD showErrorWithStatus:MIGTIP_SHARING_SUCCEED];
    
    // 发送分享结果
    MigLabAPI *miglapApi = [[MigLabAPI alloc] init];
    NSString *userid = [UserSessionManager GetInstance].userid;
    NSString *token = [UserSessionManager GetInstance].accesstoken;
    NSString *songid = [NSString stringWithFormat:@"%d", [GlobalDataManager GetInstance].curSongId];
    [miglapApi doSendShareResult:userid token:token plat:STR_USER_SOURCE_WEIXIN songid:songid];
}

#endif

@end
