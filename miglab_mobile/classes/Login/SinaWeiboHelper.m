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

@implementation SinaWeiboHelper

+ (id)sharedInstance
{
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SinaWeiboHelper alloc] init];
    });
    
    return sharedInstance;
}

/**
 * 登录微博
 */
- (void)doSinaWeiboLogin
{
    _sinaWeiboHelperStatus = SinaWeiboHelperStatusLogin;
    
    [self removeAuthData];
    
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo logIn];
}

//sina weibo
- (SinaWeibo *)sinaweibo
{
    //sina weibo
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.sinaweibo) {
        appDelegate.sinaweibo.delegate = self;
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
- (void)updateSinaWeibo:(Song *)tSong
{
    _sinaWeiboHelperStatus = SinaWeiboHelperStatusUpdate;
    
    self.shareSong = tSong;
    
    NSString *statuses = [NSString stringWithFormat:@"我安装了#咪呦#  @咪呦miyou 咪呦 听对的音乐，遇见对的人。下载咪呦: http://itunes.apple.com/cn/app/wei/id862410865"];
    if (tSong.songname) {
        statuses = [NSString stringWithFormat:@"我安装了#咪呦#  @咪呦miyou,【%@】正好是我想要听的。咪呦 听对的音乐，遇见对的人。下载咪呦: http://itunes.apple.com/cn/app/wei/id862410865", tSong.songname];
    }
    NSMutableDictionary *statusesDic = [NSMutableDictionary dictionaryWithObject:statuses forKey:@"status"];
    
    SinaWeibo *sinaweibo = [self sinaweibo];
    if ([sinaweibo isAuthValid]) {
        [sinaweibo requestWithURL:@"statuses/update.json" params:statusesDic httpMethod:@"POST" delegate:self];
    } else {
        [sinaweibo logIn];
    }
    
}

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

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    PLog(@"didFailWithError...%@", request.url);
    if ([request.url hasSuffix:@"users/show.json"]) {
        if (_delegate && [_delegate respondsToSelector:@selector(sinaWeiboLoginHelper:didFailWithError:)]) {
            [_delegate sinaWeiboLoginHelper:self didFailWithError:error];
        }
    } else if ([request.url hasSuffix:@"statuses/update.json"]) {
        if (_delegate && [_delegate respondsToSelector:@selector(sinaWeiboUpdateHelper:didFailWithError:)]) {
            [_delegate sinaWeiboUpdateHelper:self didFailWithError:error];
        }
    }
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    PLog(@"didFinishLoadingWithResult: %@", result);
    if ([request.url hasSuffix:@"users/show.json"]) {
        if (result && [result isKindOfClass:[NSDictionary class]]) {
            if (_delegate && [_delegate respondsToSelector:@selector(sinaWeiboLoginHelper:didFinishLoadingWithResult:)]) {
                [_delegate sinaWeiboLoginHelper:self didFinishLoadingWithResult:result];
            }
        }//if
    } else if ([request.url hasSuffix:@"statuses/update.json"]) {
        if (result && [result isKindOfClass:[NSDictionary class]]) {
            if (_delegate && [_delegate respondsToSelector:@selector(sinaWeiboUpdateHelper:didFinishLoadingWithResult:)]) {
                [_delegate sinaWeiboUpdateHelper:self didFinishLoadingWithResult:result];
            }
        }
    }
}

@end
