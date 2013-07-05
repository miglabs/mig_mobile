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
        
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"result: %@", result);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"failure: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetUserIdFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}

/*
 注册用户
 <!--请求POST-->
 http://open.fm.miglab.com/api/regedit.fcgi
 */
-(void)doRegister:(NSString*)tusername password:(NSString*)tpassword nickname:(NSString*)tnickname gender:(int)tgender birthday:(NSString*)tbirthday location:(NSString*)tlocation age:(int)tage source:(int)tsource head:(NSString*)thead{
    
    NSString* registerUrl = HTTP_REGISTER;
    NSLog(@"registerUrl: %@", registerUrl);
    
    NSURL* url = [NSURL URLWithString:registerUrl];
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSString* httpBody = [NSString stringWithFormat:@"username=%@&password=%@&nickname=%@&gender=%d&birthday=%@&location=%@&age=%d&source=%d&head=%@", tusername, tpassword, tnickname, tgender, tbirthday, tlocation, tage, tsource, thead];
    NSLog(@"httpBody: %@", httpBody);
    
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary *dicJson = JSON;
        PLog(@"result: %@", dicJson);
        
        int status = [[dicJson objectForKey:@"status"] intValue];
        if (-1 == status) {
            
            NSString* msg = [dicJson objectForKey:@"msg"];
            NSLog(@"server issue: %@", msg);
            NSDictionary *dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameRegisterFailed object:nil userInfo:dicResult];
            
        } else if (0 == status) {
            
            NSString* msg = [dicJson objectForKey:@"msg"];
            NSLog(@"Operation failed: %@", msg);
            NSDictionary *dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameRegisterFailed object:nil userInfo:dicResult];
            
        } else if (1 == status) {
            
            NSLog(@"Operation succeeded");
            
            User* user = [User initWithNSDictionary:[dicJson objectForKey:@"result"]];
            NSDictionary *dicResult = [NSDictionary dictionaryWithObjectsAndKeys:user, @"result", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameRegisterSuccess object:nil userInfo:dicResult];
            
        } else {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameRegisterFailed object:nil userInfo:nil];
            
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"failure: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameRegisterFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}

/*
 获取默认推荐歌曲接口
 <!--请求Get-->
 http://open.fm.miglab.com/api/song.fcgi?token=AAOfv3WG35avZspzKhoeodwv2MFd8zYxOUFENUNCMUFBNjgwMDAyRTI2&uid=10001
 */
-(void)getDefaultMusic:(NSString *)ttype token:(NSString *)ttoken uid:(int)tuid {

    NSString* musicUrl = HTTP_DEFAULTMUSIC;
    NSLog(@"musicUrl: %@", musicUrl);
    
    NSURL* url = [NSURL URLWithString:musicUrl];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

        NSDictionary* dicJson = JSON;
        int status = [dicJson objectForKey:@"status"];
        
        if(1 == status)
        {
            Song* song = [dicJson objectForKey:@"song"];
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
    
        NSLog(@"failure: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetDefaultMusicFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
}

@end
