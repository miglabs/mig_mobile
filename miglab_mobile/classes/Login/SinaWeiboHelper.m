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
    
#if 1
    // test
    UIImage* shareImage = [[UIImage_ext GetInstance] createLyricShareImage:nil song:self.shareSong];
#endif
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLyricInfoSucceed:) name:NotificationNameGetShareInfoSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLyricInfoFailed:) name:NotificationNameGetShareInfoFailed object:nil];
    
    self.shareSong = tSong;
    
    NSString* uid = [UserSessionManager GetInstance].userid;
    NSString* accesstoken = [UserSessionManager GetInstance].accesstoken;
    NSString* tsongid = [NSString stringWithFormat:@"%lld", tSong.songid];
    NSString* ttype = STR_USER_SOURCE_SINA;
    NSString* tlatitude = [GlobalDataManager GetInstance].lastLatitude;
    NSString* tlongitude = [GlobalDataManager GetInstance].lastLongitude;
    
    MigLabAPI* migapi = [[MigLabAPI alloc] init];
    [migapi doGetShareInfo:uid token:accesstoken songid:tsongid type:ttype latitude:tlatitude longitude:tlongitude];
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

-(void)doShareToSinaWeibo:(LyricShare *)lyric {
    
    SinaWeibo *sinaweibo = [self sinaweibo];
    if ([sinaweibo isAuthValid] && ![sinaweibo isAuthorizeExpired]) {
        
        NSString *shareText = MIGTIP_WEIBO_SHARE_TEXT;
        
#if 0
        NSString *strLyric = lyric.lyric;
        
        UIImage *bgImage = [UIImage imageNamed:@"bg_mask_2.png"];
        UIImage *fgImage = [UIImage imageNamed:@"music_comment_avatar_big.png"];
        
        UIImage *resImage = [UIImage_ext drawImageIntoImage:bgImage andSrcImg:fgImage andFrame:CGRectMake(160, 0, 160, 160)];
        
        NSString *fontName = @"Helvetica";
        float fontSize = [UIImage_ext getFontSize:strLyric andFontName:fontName andSize:bgImage.size];
        
        UIFont *font = [UIFont fontWithName:fontName size:fontSize];
        
        
        UIImage *shareImage = [UIImage_ext imageFromText:resImage txt:strLyric andFont:font andFrame:CGRectMake(0, 0, resImage.size.width, resImage.size.height)];
#else
      
        UIImage* shareImage = [[UIImage_ext GetInstance] createLyricShareImage:lyric song:self.shareSong];
        
#endif
        
        [sinaweibo requestWithURL:@"statuses/upload.json" params:[NSMutableDictionary dictionaryWithObjectsAndKeys:shareText, @"status", shareImage, @"pic", nil] httpMethod:@"POST" delegate:self];
        
    } else {
        
        [sinaweibo logIn];
    }
    

}

#pragma mark - get share info
-(void)getLyricInfoSucceed:(NSNotification *)tNotification {
    
    NSDictionary *dicResult = (NSDictionary*)tNotification.userInfo;
    NSDictionary *dicLyric = [dicResult objectForKey:@"result"];
    
    LyricShare* ls = [LyricShare initWithNSDictionary:dicLyric];
    
    [self doShareToSinaWeibo:ls];
}

-(void)getLyricInfoFailed:(NSNotification *)tNotification {
    
    PLog(@"分享到新浪微博失败");
}

@end
