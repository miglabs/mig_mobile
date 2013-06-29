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
 获取用户的id
 <!--请求Get-->
 http://fm.miglab.com/cgi-bin/getid.fcgi&token=AAOfv3WG35avZspzKhoeodwv2MFd8zkyRjUwRDIzQjI2QThCNzVGMzEx
 */
-(void)doGetUserId:(NSString *)tAccessToken{
    
    NSString *getUserIdUrl = [NSString stringWithFormat:@"%@?token=%@", GET_USER_ID, tAccessToken];
    NSLog(@"getUserIdUrl: %@", getUserIdUrl);
    
    NSURL *url = [NSURL URLWithString:getUserIdUrl];
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

@end
