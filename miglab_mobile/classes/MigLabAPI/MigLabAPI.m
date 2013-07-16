//
//  MigLabAPI.m
//  miglab_mobile
//
//  Created by pig on 13-6-23.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "MigLabAPI.h"
#import "MigLabConfig.h"

#import "AFHTTPRequestOperation.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "UserSessionManager.h"
#import "Song.h"

@implementation MigLabAPI

/*
 SSO的登录
 http://sso.miglab.com/cgi-bin/sp.fcgi?sp
 */
-(void)doAuthLogin:(NSString *)tusername password:(NSString *)tpassword{
    
    NSLog(@"username: %@, password: %@", tusername, tpassword);
    
    if (!tusername || tusername.length == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameUsernameIsNull object:nil userInfo:nil];
        return;
    }
    
    if (!tpassword || tpassword.length == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNamePasswordIsNull object:nil userInfo:nil];
        return;
    }
    
    [self doSsoLoginFirst:tusername password:tpassword];
    
}

/*
 <!--请求Get-->
 http://sso.miglab.com/cgi-bin/sp.fcgi?sp
 */
-(void)doSsoLoginFirst:(NSString *)tusername password:(NSString *)tpassword{
    
    NSLog(@"LOGIN_SSO_SP_URL: %@", LOGIN_SSO_SP_URL);
    
    NSURL *url = [NSURL URLWithString:LOGIN_SSO_SP_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"result: %@", result);
        
        NSArray *resultList = [result componentsSeparatedByString:@"?"];
        if ([resultList count] == 2) {
            
            NSString *postUrl = [resultList objectAtIndex:0];
            NSString *postContent = [resultList objectAtIndex:1];
            NSString *secondPostContent = [NSString stringWithFormat:@"username=%@&password=%@&%@", tusername, tpassword, postContent];
            
            [self doSsoLoginSecond:postUrl param:secondPostContent];
            
        } else {
            
            NSLog(@"doSsoLoginFirst failure...");
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameLoginFailed object:nil userInfo:nil];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"failure: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameLoginFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}

/*
 将第一步返回值URL和RequestID解析出来
 <!--请求POST-->
 http://sso.miglab.com/cgi-bin/idp.fcgi
 */
-(void)doSsoLoginSecond:(NSString *)ssoSecondUrl param:(NSString *)strParam{
    
    NSString *loginSsoSecondUrl = ssoSecondUrl;
    NSLog(@"loginSsoSecondUrl: %@", loginSsoSecondUrl);
    
    NSURL *url = [NSURL URLWithString:loginSsoSecondUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[strParam dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"result: %@", result);
        NSArray *resultList = [result componentsSeparatedByString:@"?"];
        if ([resultList count] == 2) {
            
            NSString *postUrl = [resultList objectAtIndex:0];
            NSString *postContent = [resultList objectAtIndex:1];
            
            [self doSsoLoginThird:postUrl param:postContent];
            
        } else {
            
            NSLog(@"doSsoLoginSecond failure...");
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameLoginFailed object:nil userInfo:nil];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"failure: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameLoginFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}

/*
 将第二步内容得URL和内容解析出来
 <!--请求POST-->
 http://fm.miglab.com/cgi-bin/sp.fcgi
 */
-(void)doSsoLoginThird:(NSString *)ssoThirdUrl param:(NSString *)strParam{
    
    NSString *loginSsoThirdUrl = ssoThirdUrl;
    NSLog(@"loginSsoThirdUrl: %@", loginSsoThirdUrl);
    
    NSURL *url = [NSURL URLWithString:loginSsoThirdUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[strParam dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"result AccessToken: %@", result);
        NSDictionary *dicResult = [NSDictionary dictionaryWithObjectsAndKeys:result, @"AccessToken", nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameLoginSuccess object:nil userInfo:dicResult];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"failure: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameLoginFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}

/*
 获取用户信息
 <!--请求Get-->
 http://open.fm.miglab.com/api/userinfo.fcgi
 */
-(void)doGetUserInfo:(NSString *)tUserName accessToken:(NSString *)tAccessToken{
    
    NSString *getUserInfoUrl = [NSString stringWithFormat:@"%@?username=%@&token=%@", GET_USER_INFO, tUserName, tAccessToken];
    NSLog(@"getUserInfoUrl: %@", getUserInfoUrl);
    
    NSURL *url = [NSURL URLWithString:getUserInfoUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            PLog(@"dicJson: %@", dicJson);
            
        }
        @catch (NSException *exception) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetUserInfoFailed object:nil userInfo:nil];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"failure: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetUserInfoFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}

/*
 注册用户
 <!--请求POST-->
 HTTP_REGISTER
 */
-(void)doRegister:(NSString*)tusername password:(NSString*)tpassword nickname:(NSString*)tnickname source:(int)tsource {
    
    NSString* registerUrl = HTTP_REGISTER;
    PLog(@"registerUrl: %@", registerUrl);
    
    NSURL* url = [NSURL URLWithString:registerUrl];
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];

    NSString* httpBody = [NSString stringWithFormat:@"username=%@&password=%@&nickname=%@&source=%d", tusername, tpassword, tnickname, tsource];
    PLog(@"httpBody: %@", httpBody);
    
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
        PLog(@"dicJson: %@", dicJson);
        
        int status = [[dicJson objectForKey:@"status"] intValue];
        
        if (1 == status) {
            
            PLog(@"register operation succeeded");
            
            User* user = [User initWithNSDictionary:[dicJson objectForKey:@"result"]];
            NSDictionary *dicResult = [NSDictionary dictionaryWithObjectsAndKeys:user, @"result", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameRegisterSuccess object:nil userInfo:dicResult];
            
        } else if (0 == status || -1 == status) {
            
            NSString* msg = [dicJson objectForKey:@"msg"];
            PLog(@"register operation failed: %@", msg);
            NSDictionary *dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameRegisterFailed object:nil userInfo:dicResult];
            
        } else {
            
            NSDictionary *dicResult = [NSDictionary dictionaryWithObjectsAndKeys:@"未知错误", @"msg", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameRegisterFailed object:nil userInfo:dicResult];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"register failure: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameRegisterFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}

/*
 生成游客信息
 <!--请求Get-->
 HTTP_GUEST
 */
-(void)doGetGuestInfo {
    
    PLog(@"guest url: %@", HTTP_GUEST);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:HTTP_GUEST]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
        int status = [dicJson objectForKey:@"status"];
        
        if(1 == status) {
            
            PLog(@"get guest operation succeeded");
            
            User* user = [User initWithNSDictionary:[dicJson objectForKey:@"result"]];
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:user, "result", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetGuestSuccess object:nil userInfo:dicResult];
            
        }
        else {
            
            PLog(@"get guest operation failed");
            
            NSString* msg = [dicJson objectForKey:@"msg"];
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetUserInfoFailed object:nil userInfo:dicResult];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"get guest failure: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetUserInfoFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}

/*
 更新用户信息
 <!--请求POST-->
 HTTP_UPDATEUSER
 */
-(void)doUpdateUserInfo:(NSString *)tuid token:(NSString *)ttoken username:(NSString *)tusername nickname:(NSString *)tnickname gender:(NSString *)tgender birthday:(NSString *)tbirthday location:(NSString *)tlocation source:(NSString *)tsource head:(NSString *)thead {
    
    PLog(@"update user information url: %@", HTTP_UPDATEUSER);
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:HTTP_UPDATEUSER]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    NSString* httpBody = [NSString stringWithFormat:@"uid=%@&token=%@&username=%@&nickname=%@&gender=%@&birthday=%@&location=%@&source=%@&head=%@&", tuid, ttoken, tusername, tnickname, tgender, tbirthday, tlocation, tsource, thead];
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] init];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
        int status = [dicJson objectForKey:@"status"];
        
        if(1 == status) {
            
            PLog(@"update user information operation succeed");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateUserSuccess object:nil userInfo:nil];
            
        }
        else {
            
            PLog(@"update user information operation failed");
            
            NSString* msg = [dicJson objectForKey:@"msg"];
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateUserFailed object:nil userInfo:dicResult];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"update user information failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateUserFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}

/*
 获取默认推荐歌曲接口
 <!--请求Get-->
 http://open.fm.miglab.com/api/song.fcgi?token=AAOfv3WG35avZspzKhoeodwv2MFd8zYxOUFENUNCMUFBNjgwMDAyRTI2&uid=10001
 */
-(void)doGetDefaultMusic:(NSString *)ttype token:(NSString *)ttoken uid:(int)tuid {

    NSString* musicUrl = HTTP_DEFAULTMUSIC;
    PLog(@"musicUrl: %@", musicUrl);
    
    NSURL* url = [NSURL URLWithString:musicUrl];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

        NSDictionary* dicJson = JSON;
        int status = [dicJson objectForKey:@"status"];
        
        if(1 == status)
        {
            Song* song = [Song initWithNSDictionary:[dicJson objectForKey:@"result"]];
            NSDictionary* dicSong = [NSDictionary dictionaryWithObjectsAndKeys:song, @"song", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetDefaultMusicSuccess object:nil userInfo:dicSong];
        }
        else
        {
            NSString* msg = [dicJson objectForKey:@"msg"];
            NSDictionary* dicError = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetDefaultMusicFailed object:nil userInfo:dicError];
        }
        
            
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
    
        PLog(@"failure: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetDefaultMusicFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
}

/*
添加歌曲到收藏列表
 <!--请求POST-->
 HTTP_ADDFAVORITE
 */
-(void)doAddFavorite:(NSString *)ttoken uid:(int)tuid sid:(long)tsid {
    
    PLog(@"add favorite url: %@", HTTP_ADDFAVORITE);
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:HTTP_ADDFAVORITE]];
    
    NSString* httpBody = [NSString stringWithFormat:@"token=%@&uid=%d&songid=%ld", ttoken, tuid, tsid];
    
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary* dicJson = JSON;
        int status = [dicJson objectForKey:@"status"];
        
        if(1 == status) {
            
            PLog(@"operation succeed");
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameAddFavoriteSuccess object:nil userInfo:nil];
            
        }
        else {
            
            NSString* msg = [dicJson objectForKey:@"msg"];
            PLog(@"operation failed: %@", msg);
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameAddFavoriteFailed object:nil userInfo:dicResult];
            
        }
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        PLog(@"failure: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameAddFavoriteFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}

/*
 添加黑名单
 <!--请求POST-->
 HTTP_ADDBLACKLIST
 */
-(void)doAddBlacklist:(NSString *)ttoken uid:(int)tuid sid:(long)tsid {
    
    PLog(@"add blacklist url: %@", HTTP_ADDBLACKLIST);
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:HTTP_ADDBLACKLIST]];
    
    NSString* httpBody = [NSString stringWithFormat:@"token=%@&uid=%d&songid=%ld", ttoken, tuid, tsid];
    
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary* dicJson = JSON;
        int status = [dicJson objectForKey:@"status"];
        
        if(1 == status) {
            
            PLog(@"operation succeed");
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameAddBlacklistSuccess object:nil userInfo:nil];
            
        }
        else {
            
            NSString* msg = [dicJson objectForKey:@"msg"];
            PLog(@"operation failed: %@", msg);
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameAddBlacklistFailed object:nil userInfo:dicResult];
            
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        PLog(@"failure: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameAddBlacklistFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}

/*
 赠送歌曲
 <!--请求POST-->
 HTTP_PRESENTMUSIC
 */
-(void)doPresentMusic:(int)senduid touid:(int)ttouid token:(NSString*)ttoken sid:(long)tsid {
    
    PLog(@"present music url: %@", HTTP_PRESENTMUSIC);
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:HTTP_PRESENTMUSIC]];
    
    NSString* httpBody = [NSString stringWithFormat:@"senduid=%d&touid=%d&token=%@&songid=%ld", senduid, ttouid, ttoken, tsid];
    
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary* dicJson = JSON;
        int status = [dicJson objectForKey:@"status"];
        
        if(1 == status) {
            
            PLog(@"operation succeeded");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNamePresentMusicSuccess object:nil userInfo:nil];
            
        }
        else {
            
            PLog(@"operation failed");
            
            NSString* msg = [dicJson objectForKey:@"msg"];
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNamePresentMusicFailed object:nil userInfo:dicResult];
            
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        PLog(@"failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNamePresentMusicFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}

/*
 分享歌曲
 <!--请求POST-->
 HTTP_SHAREMUSIC
 */
-(void)doShareMusic:(int)uid token:(NSString *)ttoken sid:(long)tsid platform:(int)tplatform {
    
    PLog(@"share music url: %@", HTTP_SHAREMUSIC);
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:HTTP_SHAREMUSIC]];
    
    NSString* httpBody = [NSString stringWithFormat:@"uid=%d&token=%@&songid=%ld&platform=%d", uid, ttoken, tsid, tplatform];
    
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary* dicJson = JSON;
        int status = [dicJson objectForKey:@"status"];
        
        if(1 == status) {
            
            PLog(@"operation succeeded");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameShareMusicSuccess object:nil userInfo:nil];
            
        }
        else {
            
            PLog(@"operation failed");
            
            NSString* msg = [dicJson objectForKey:@"msg"];
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameShareMusicFailed object:nil userInfo:dicResult];
            
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        PLog(@"failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameShareMusicFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}

/*
 上传用户本地歌曲信息
 <!--请求POST-->
 HTTP_UPLOADMUSIC
 */
-(void)doUploadMusic:(int)uid token:(NSString *)ttoken sid:(long)tsid enter:(int)tenter urlcode:(int)turlcode content:(long)tcontent {
    
    PLog(@"upload music url:%@", HTTP_UPLOADMUSIC);
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:HTTP_UPLOADMUSIC]];
    
    NSString* httpBody = @"hehe";//TODO JSON

    NSMutableURLRequest* request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary* dicJson = JSON;
        int status = [dicJson objectForKey:@"status"];
        
        if(1 == status) {
            
            PLog(@"operation succeeded");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameUploadMusicSuccess object:nil userInfo:nil];
        }
        else {
            
            PLog(@"operation failed");
            
            NSString* msg = [dicJson objectForKey:@"msg"];
            
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameUploadMusicFailed object:nil userInfo:dicResult];
            
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        PLog(@"failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameUploadMusicFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}


/*
 获取附近用户
 <!--请求GET-->
 HTTP_NEARBYUSER
 */
-(void)doGetNearbyUser:(int)uid token:(NSString *)ttoken page:(int)tpage{
    
    NSString* url = [NSString stringWithFormat:@"%@&token=%@&uid=%d&page=%d", HTTP_NEARBYUSER,  ttoken, uid, tpage];
    PLog(@"get nearby user url: %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary* dicJson = JSON;
        int status = [dicJson objectForKey:@"status"];
        
        if(1 == status) {
            
            PLog(@"operation succeeded");
            
            //TODO add user
            
        }
        else {
            
            PLog(@"operation failed");
            
            NSString* msg = [dicJson objectForKey:@"msg"];
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameNearbyUserFailed object:nil userInfo:dicResult];
            
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        PLog(@"failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameNearbyUserFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}

/*
 获取用户歌单
 <!--请求GET-->
 HTTP_GETUSERLIST
 */
-(void)doGetListFromUser:(int)uid sid:(long)tsid token:(NSString *)ttoken {
    
    NSString* url = [NSString stringWithFormat:@"%@&token=%@&uid=%d&sid=%ld", HTTP_GETUSERLIST, ttoken, uid, tsid];
    PLog(@"get list from user url: %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary* dicJson = JSON;
        int status = [dicJson objectForKey:@"status"];
        
        if(1 == status) {
            
            PLog(@"operation succeeded");
            
            Song* song = [Song initWithNSDictionary:[dicJson objectForKey:@"result"]];
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:song, @"song", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameUserListSuccess object:nil userInfo:dicResult];
            
        }
        else {
            
            PLog(@"operation failed");
            
            NSString* msg = [dicJson objectForKey:@"msg"];
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameUserListFailed object:nil userInfo:dicResult];
            
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        PLog(@"failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameUserListFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}

/*
 获取用户正在听的歌曲
 <!--请求GET-->
 HTTP_GETPLAYINGMUSIC
 */
-(void)doGetPlayingMusicFromUser:(int)uid token:(NSString *)ttoken begin:(int)tbegin page:(int)tpage {
    
    NSString* url = [NSString stringWithFormat:@"%@&token=%@&uid=%d", HTTP_GETPLAYINGMUSIC, ttoken, uid];
    PLog(@"playing music url: %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary* dicJson = JSON;
        int status = [dicJson objectForKey:@"status"];
        
        if(1 == status) {
            
            PLog(@"operation succeeded");
            
            Song* song = [Song initWithNSDictionary:[dicJson objectForKey:@"result"]];
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:song, @"song", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNamePlayingMusicSuccess object:nil userInfo:dicResult];
            
        }
        else {
            
            PLog(@"operation failed");
            
            NSString* msg = [dicJson objectForKey:@"msg"];
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNamePlayingMusicFailed object:nil userInfo:dicResult];
            
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        PLog(@"failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNamePlayingMusicFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}

/*
 获取频道目录
 <!--请求GET-->
 HTTP_GETCHANNEL
 */
-(void)doGetChannel:(int)uid token:(NSString *)ttoken num:(int)tnum {
    
    NSString* url = [NSString stringWithFormat:@"%@&num=%d&token=%@&uid=%d", HTTP_GETCHANNEL, tnum, ttoken, uid];
    PLog(@"get channel url: %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary* dicJson = JSON;
        int status = [dicJson objectForKey:@"status"];
        
        if(1 == status) {
            
            
            
        }
        else {
            
            PLog(@"operation failed");
            
            NSString* msg = [dicJson objectForKey:@"msg"];
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetChannelFailed object:nil userInfo:dicResult];
            
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        PLog(@"failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetChannelFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}

/*
 获取频道歌曲
 <!--请求GET-->
 HTTP_GETCHANNELMUSIC
 */
-(void)doGetMusicFromChannel:(int)uid token:(NSString *)ttoken channel:(int)tchannel {
    
    NSString* url = [NSString stringWithFormat:@"%@&channel=%d&token=%@&uid=%d", HTTP_GETCHANNELMUSIC, uid, ttoken, tchannel];
    PLog(@"get channel music url: %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        ;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        
        
    }];
    
    [operation start];
    
}

/*
 获取心情，场景词描述
 <!--请求GET-->
 HTTP_MODESCENE
 */
-(void)doGetModeScene:(int)uid token:(NSString *)ttoken decword:(NSString *)tdecword {
    
    NSString* url = [NSString stringWithFormat:@"%@&decword=%@&token=%@&uid=%d", HTTP_MODESCENE, tdecword, ttoken, uid];
    PLog(@"get mode scene url: %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:HTTP_MODESCENE]];
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary* dicJson = JSON;
        int status = [dicJson objectForKey:@"status"];
        
        if(1 == status) {
            
            PLog(@"operation succeeded");
            
            //TODO, send content
            
        }
        else {
            
            PLog(@"operation failed");
            
            NSString* msg = [dicJson objectForKey:@"msg"];
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameModeSceneFailed object:nil userInfo:dicResult];
            
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        PLog(@"failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameModeSceneFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}

/*
 获取心情，场景歌曲
 <!--请求GET-->
 HTTP_MODEMUSIC
 */
-(void)doGetModeMusic:(int)uid token:(NSString *)ttoken wordid:(NSString *)twordid mood:(NSString *)tmood {
    
    NSString* url = [NSString stringWithFormat:@"%@?wordid=%@&mode=%@&token=%@&uid=%d", HTTP_MODEMUSIC, twordid, tmood, ttoken, uid];
    PLog(@"get mode music url: %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary* dicJson = JSON;
        int status = [dicJson objectForKey:@"status"];
        
        if(1 == status) {
            
            PLog(@"operation succeeded");
            
        }
        else {
            
            PLog(@"operation failed");
            
            NSString* msg = [dicJson objectForKey:@"msg"];
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameModeMusicFailed object:nil userInfo:dicResult];
            
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        PLog(@"failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameModeMusicFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}

/*
 获取心绪地图
 <!--请求GET-->
 HTTP_MODEMAP
 */
-(void)doGetModeMap:(int)uid token:(NSString *)ttoken sid:(int)tsid {
    
    NSString* url = [NSString stringWithFormat:@"%@?token=%@&uid=%d&sid=%d", HTTP_MODEMAP, ttoken, uid, tsid];
    PLog(@"mode map url: %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:HTTP_MODEMAP]];
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary* dicJson = JSON;
        int status = [dicJson objectForKey:@"status"];
        
        if(1 == status) {
            
            PLog(@"operation succeeded");
            
        }
        else {
            
            PLog(@"operation failed");
            
            NSString* msg = [dicJson objectForKey:@"msg"];
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameModeMapFailed object:nil userInfo:dicResult];
            
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        PLog(@"failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameModeMapFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}


@end
