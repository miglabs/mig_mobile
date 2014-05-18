//
//  TencentHelper.m
//  miglab_mobile
//
//  Created by pig on 14-5-18.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import "TencentHelper.h"
#import "UserSessionManager.h"

@implementation TencentHelper

+ (id)sharedInstance
{
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TencentHelper alloc] init];
    });
    
    return sharedInstance;
}

- (void)initTencentAndLogin
{
    //tencent
    _permissions = [NSArray arrayWithObjects:
                    kOPEN_PERMISSION_GET_USER_INFO,
                    kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                    kOPEN_PERMISSION_ADD_ALBUM,
                    kOPEN_PERMISSION_ADD_IDOL,
                    kOPEN_PERMISSION_ADD_ONE_BLOG,
                    kOPEN_PERMISSION_ADD_PIC_T,
                    kOPEN_PERMISSION_ADD_SHARE,
                    kOPEN_PERMISSION_ADD_TOPIC,
                    kOPEN_PERMISSION_CHECK_PAGE_FANS,
                    kOPEN_PERMISSION_DEL_IDOL,
                    kOPEN_PERMISSION_DEL_T,
                    kOPEN_PERMISSION_GET_FANSLIST,
                    kOPEN_PERMISSION_GET_IDOLLIST,
                    kOPEN_PERMISSION_GET_INFO,
                    kOPEN_PERMISSION_GET_OTHER_INFO,
                    kOPEN_PERMISSION_GET_REPOST_LIST,
                    kOPEN_PERMISSION_LIST_ALBUM,
                    kOPEN_PERMISSION_UPLOAD_PIC,
                    kOPEN_PERMISSION_GET_VIP_INFO,
                    kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                    kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
                    kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                    nil];
    
    if (!_tencentOAuth) {
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:TENCENT_WEIBO_APP_KEY
                                                andDelegate:self];
    }
    [_tencentOAuth authorize:_permissions inSafari:NO];
    
}

- (void)doTencentLogin
{
    _tencentHelperStatus = TencentHelperStatusLogin;
    
    [self initTencentAndLogin];
    
}

/**
 * 发布一条说说
 */
- (void)addTopic:(Song *)tSong
{
    _tencentHelperStatus = TencentHelperStatusAddTopic;
    
    self.shareSong = tSong;
    
    if ([_tencentOAuth isSessionValid]) {
        
        NSString *statuses = [NSString stringWithFormat:@"我安装了#咪呦#  @咪呦miyou 咪呦 听对的音乐，遇见对的人。下载咪呦: http://itunes.apple.com/cn/app/wei/id862410865"];
        if (tSong.songname) {
            statuses = [NSString stringWithFormat:@"我安装了#咪呦#  @咪呦miyou,【%@】正好是我想要听的。咪呦 听对的音乐，遇见对的人。下载咪呦: http://itunes.apple.com/cn/app/wei/id862410865", tSong.songname];
        }
        
        TCAddTopicDic *params = [TCAddTopicDic dictionary];
        params.paramCon = statuses;
        params.paramThirdSource = @"1";
        if (![_tencentOAuth sendAPIRequest:params callback:self]) {
            if (_delegate && [_delegate respondsToSelector:@selector(tencentAddTopicHelper:didFailWithError:)]) {
                [_delegate tencentAddTopicHelper:self didFailWithError:nil];
            }
        }
    } else {
        [self initTencentAndLogin];
    }
}

/**
 * 微博
 */
- (void)addWeibo:(Song *)tSong
{
    _tencentHelperStatus = TencentHelperStatusAddWeibo;
    
    self.shareSong = tSong;
    
    if ([_tencentOAuth isSessionValid]) {
        
        NSString *statuses = [NSString stringWithFormat:@"我安装了#咪呦#  @咪呦miyou 咪呦 听对的音乐，遇见对的人。下载咪呦: http://itunes.apple.com/cn/app/wei/id862410865"];
        if (tSong.songname) {
            statuses = [NSString stringWithFormat:@"我安装了#咪呦#  @咪呦miyou,【%@】正好是我想要听的。咪呦 听对的音乐，遇见对的人。下载咪呦: http://itunes.apple.com/cn/app/wei/id862410865", tSong.songname];
        }
        
        WeiBo_add_t_POST *request = [[WeiBo_add_t_POST alloc] init];
        request.param_content = statuses;
        request.param_compatibleflag = @"0x2|0x4|0x8|0x20";
        
        if (![_tencentOAuth sendAPIRequest:request callback:self]) {
            if (_delegate && [_delegate respondsToSelector:@selector(tencentAddTopicHelper:didFailWithError:)]) {
                [_delegate tencentAddTopicHelper:self didFailWithError:nil];
            }
        }
    } else {
        [self initTencentAndLogin];
    }
    
}

#pragma mark TencentLoginDelegate method

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin
{
    // 登录成功
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length]) {
        PLog(@"_tencentOAuth.openId: %@", _tencentOAuth.openId);
        PLog(@"_tencentOAuth.accessToken: %@", _tencentOAuth.accessToken);
        PLog(@"_tencentOAuth.expirationDate: %@", _tencentOAuth.expirationDate);
        
        AccountOf3rdParty *tencentAccount = [[AccountOf3rdParty alloc] init];
        tencentAccount.accountid = _tencentOAuth.openId;
        tencentAccount.accesstoken = _tencentOAuth.accessToken;
        tencentAccount.expirationdate = _tencentOAuth.expirationDate;
        tencentAccount.accounttype = SourceTypeTencentWeibo;
        
        [UserSessionManager GetInstance].accounttype = SourceTypeTencentWeibo;
        [UserSessionManager GetInstance].currentUser.tencentAccount = tencentAccount;
        [UserSessionManager GetInstance].currentUser.source = SourceTypeTencentWeibo;
        
        if(![_tencentOAuth getUserInfo]){
            if (_delegate && [_delegate respondsToSelector:@selector(tencentLoginHelper:didFailWithError:)]) {
                [_delegate tencentLoginHelper:self didFailWithError:nil];
            }
        }//
        
    } else {
        PLog(@"登录不成功 没有获取accesstoken");
        if (_delegate && [_delegate respondsToSelector:@selector(tencentLoginHelper:didFailWithError:)]) {
            [_delegate tencentLoginHelper:self didFailWithError:nil];
        }
    }
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled){
        PLog(@"用户取消登录");
    }
	else {
        PLog(@"登录失败");
	}
    if (_delegate && [_delegate respondsToSelector:@selector(tencentLoginHelper:didFailWithError:)]) {
        [_delegate tencentLoginHelper:self didFailWithError:nil];
    }
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork
{
    PLog(@"无网络连接，请设置网络");
    if (_delegate && [_delegate respondsToSelector:@selector(tencentLoginHelper:didFailWithError:)]) {
        [_delegate tencentLoginHelper:self didFailWithError:nil];
    }
}

#pragma mark TencentSessionDelegate method

/**
 * 获取用户个人信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getUserInfoResponse.exp success
 *          错误返回示例: \snippet example/getUserInfoResponse.exp fail
 */
- (void)getUserInfoResponse:(APIResponse*) response
{
    if (response.retCode == URLREQUEST_SUCCEED) {
        PLog(@"response.jsonResponse: %@", response.jsonResponse);
        NSDictionary *result = response.jsonResponse;
        
        switch (_tencentHelperStatus) {
            case TencentHelperStatusLogin:
            {
                if (_delegate && [_delegate respondsToSelector:@selector(tencentLoginHelper:didFinishLoadingWithResult:)]) {
                    [_delegate tencentLoginHelper:self didFinishLoadingWithResult:result];
                }
            }
                break;
            case TencentHelperStatusAddTopic:
            {
                [self addTopic:_shareSong];
            }
                break;
            case TencentHelperStatusAddWeibo:
            {
                [self addWeibo:_shareSong];
            }
                break;
                
            default:
                break;
        }
        
	} else {
		if (_delegate && [_delegate respondsToSelector:@selector(tencentLoginHelper:didFailWithError:)]) {
            [_delegate tencentLoginHelper:self didFailWithError:nil];
        }
	}
}

/**
 * 分享到QZone回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/addShareResponse.exp success
 *          错误返回示例: \snippet example/addShareResponse.exp fail
 */
- (void)addShareResponse:(APIResponse*) response
{
    PLog(@"addShareResponse...");
}

/**
 * 在QZone中发表一条说说回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/addTopicResponse.exp success
 *          错误返回示例: \snippet example/addTopicResponse.exp fail
 */
- (void)addTopicResponse:(APIResponse*) response
{
    PLog(@"addTopicResponse...");
    
    if (response.retCode == URLREQUEST_SUCCEED) {
        PLog(@"response.jsonResponse: %@", response.jsonResponse);
        NSDictionary *result = response.jsonResponse;
        
        switch (_tencentHelperStatus) {
            case TencentHelperStatusLogin:
            {
                if (_delegate && [_delegate respondsToSelector:@selector(tencentAddTopicHelper:didFinishLoadingWithResult:)]) {
                    [_delegate tencentAddTopicHelper:self didFinishLoadingWithResult:result];
                }
            }
                break;
            case TencentHelperStatusAddTopic:
            {
                [self addTopic:_shareSong];
            }
                break;
                
            default:
                break;
        }
        
        
	} else {
		if (_delegate && [_delegate respondsToSelector:@selector(tencentAddTopicHelper:didFailWithError:)]) {
            [_delegate tencentAddTopicHelper:self didFailWithError:nil];
        }
	}
}

#pragma mark TCAPIRequestDelegate method

- (void)cgiRequest:(TCAPIRequest *)request didResponse:(APIResponse *)response
{
    if (URLREQUEST_SUCCEED == response.retCode && kOpenSDKErrorSuccess == response.detailRetCode) {
        NSMutableString *str=[NSMutableString stringWithFormat:@""];
        for (id key in response.jsonResponse)
        {
            [str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(tencentAddWeiboHelper:didFinishLoadingWithResult:)]) {
            [_delegate tencentAddWeiboHelper:self didFinishLoadingWithResult:[NSDictionary dictionaryWithObject:str forKey:@"result"]];
        }
    } else {
        NSString *errMsg = [NSString stringWithFormat:@"errorMsg:%@\n%@", response.errorMsg, [response.jsonResponse objectForKey:@"msg"]];
        PLog(@"errMsg: %@", errMsg);
        
        if (_delegate && [_delegate respondsToSelector:@selector(tencentAddWeiboHelper:didFailWithError:)]) {
            [_delegate tencentAddWeiboHelper:self didFailWithError:nil];
        }
    }
}

@end
