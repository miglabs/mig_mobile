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
    
    PLog(@"username: %@, password: %@", tusername, tpassword);
    
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
    
    PLog(@"LOGIN_SSO_SP_URL: %@", LOGIN_SSO_SP_URL);
    
    NSURL *url = [NSURL URLWithString:LOGIN_SSO_SP_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            PLog(@"result: %@", result);
            
            NSArray *resultList = [result componentsSeparatedByString:@"?"];
            if ([resultList count] == 2) {
                
                NSString *postUrl = [resultList objectAtIndex:0];
                NSString *postContent = [resultList objectAtIndex:1];
                NSString *secondPostContent = [NSString stringWithFormat:@"username=%@&password=%@&%@", tusername, tpassword, postContent];
                
                [self doSsoLoginSecond:postUrl param:secondPostContent];
                
            } else {
                
                PLog(@"doSsoLoginFirst failure...");
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameLoginFailed object:nil userInfo:nil];
                
            }
            
        }
        @catch (NSException *exception) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameLoginFailed object:nil userInfo:nil];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"failure: %@", error);
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
    PLog(@"loginSsoSecondUrl: %@", loginSsoSecondUrl);
    
    NSURL *url = [NSURL URLWithString:loginSsoSecondUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[strParam dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            PLog(@"result: %@", result);
            NSArray *resultList = [result componentsSeparatedByString:@"?"];
            if ([resultList count] == 2) {
                
                NSString *postUrl = [resultList objectAtIndex:0];
                NSString *postContent = [resultList objectAtIndex:1];
                
                [self doSsoLoginThird:postUrl param:postContent];
                
            } else {
                
                PLog(@"doSsoLoginSecond failure...");
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameLoginFailed object:nil userInfo:nil];
                
            }
            
        }
        @catch (NSException *exception) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameLoginFailed object:nil userInfo:nil];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"failure: %@", error);
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
    PLog(@"loginSsoThirdUrl: %@", loginSsoThirdUrl);
    
    NSURL *url = [NSURL URLWithString:loginSsoThirdUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[strParam dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSString *strAccessToken = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            PLog(@"result AccessToken: %@, strAccessToken: %@", result, strAccessToken);
            NSDictionary *dicResult = [NSDictionary dictionaryWithObjectsAndKeys:strAccessToken, @"AccessToken", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameLoginSuccess object:nil userInfo:dicResult];
            
        }
        @catch (NSException *exception) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameLoginFailed object:nil userInfo:nil];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"failure: %@", error);
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
    PLog(@"getUserInfoUrl: %@", getUserInfoUrl);
    
    NSURL *url = [NSURL URLWithString:getUserInfoUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            PLog(@"dicJson: %@", dicJson);
            
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if(1 == status) {
                
                PLog(@"get user information operation succeeded");
                
                PUser* user = [PUser initWithNSDictionary:[dicJson objectForKey:@"result"]];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:user, @"result", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetUserInfoSuccess object:nil userInfo:dicResult];
                
            } else {
                
                PLog(@"get user information operation failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetUserInfoFailed object:nil userInfo:dicResult];
                
            }
            
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据失败:(";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetUserInfoFailed object:nil userInfo:dicResult];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"failure: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetUserInfoFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}

/*
 注册用户
 <!--请求POST-->
 HTTP_REGISTER
 */
-(void)doRegister:(NSString*)tusername password:(NSString*)tpassword nickname:(NSString*)tnickname source:(SourceType)tsourcetype session:(NSString*)tsession sex:(NSString*)tsex birthday:(NSString*)tbirthday location:(NSString*)tlocation head:(NSString*)thead{
    
    NSString* registerUrl = HTTP_REGISTER;
    PLog(@"registerUrl: %@", registerUrl);
    
    NSURL* url = [NSURL URLWithString:registerUrl];
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];

    NSString* httpBody = [NSString stringWithFormat:@"username=%@&password=%@&nickname=%@&source=%d&session=%@&sex=%@&birthday=%@&location=%@&head=%@", tusername, tpassword, tnickname, tsourcetype, tsession, tsex, tbirthday, tlocation, thead];
    PLog(@"httpBody: %@", httpBody);
    
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            PLog(@"dicJson: %@", dicJson);
            
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if (1 == status) {
                
                PLog(@"register operation succeeded");
                
                PUser* user = [PUser initWithNSDictionary:[dicJson objectForKey:@"result"]];
                NSDictionary *dicResult = [NSDictionary dictionaryWithObjectsAndKeys:user, @"result", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameRegisterSuccess object:nil userInfo:dicResult];
                
            } else if (0 == status || -1 == status) {
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                PLog(@"register operation failed: %@", msg);
                NSDictionary *dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameRegisterFailed object:nil userInfo:dicResult];
                
            } else {
                
                NSString* msg = @"未知错误:(";
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameRegisterFailed object:nil userInfo:dicResult];
                
            }
            
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据信息失败:(";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameRegisterFailed object:nil userInfo:dicResult];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"register failure: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameRegisterFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}

-(void)doRegister:(NSString *)tusername password:(NSString *)tpassword nickname:(NSString *)tnickname source:(SourceType)tsourcetype session:(NSString *)tsession sex:(NSString *)tsex {
    
    NSString* tbirthday = @"0";
    NSString* tlocation = @"0";
    NSString* thead = @"0";
    
    [self doRegister:tusername password:tpassword nickname:tnickname source:tsourcetype session:tsession sex:tsex birthday:tbirthday location:tlocation head:thead];
}

-(void)doRegister:(NSString*)tusername password:(NSString*)tpassword nickname:(NSString*)tnickname source:(SourceType)tsourcetype {
    
    if( SourceTypeMiglab == tsourcetype) {
        
        NSString* sex = @"";
        NSString* tsession = @"";
        tnickname = @"";
        
        [self doRegister:tusername password:tpassword nickname:tnickname source:tsourcetype session:tsession sex:sex];
    }
}

/*
 生成游客信息
 <!--请求Get-->
 HTTP_GUEST
 */
-(void)doGetGuestInfo {
    
    PLog(@"guest url: %@", HTTP_GUEST);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:HTTP_GUEST]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            PLog(@"dicJson: %@", dicJson);
            
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if(1 == status) {
                
                PLog(@"get guest operation succeeded");
                
                PUser* user = [PUser initWithNSDictionary:[dicJson objectForKey:@"result"]];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:user, @"result", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetGuestSuccess object:nil userInfo:dicResult];
                
            }
            else {
                
                PLog(@"get guest operation failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetUserInfoFailed object:nil userInfo:dicResult];
                
            }
            
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据失败:(";
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
-(void)doUpdateUserInfo:(NSString*)uid token:(NSString *)ttoken username:(NSString *)tusername nickname:(NSString *)tnickname gender:(NSString *)tgender birthday:(NSString *)tbirthday location:(NSString *)tlocation source:(NSString *)tsource head:(NSString *)thead {
    
    PLog(@"update user information url: %@", HTTP_UPDATEUSER);
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:HTTP_UPDATEUSER]];
    
    NSString* httpBody = [NSString stringWithFormat:@"uid=%@&token=%@&username=%@&nickname=%@&gender=%@&birthday=%@&location=%@&source=%@&head=%@", uid, ttoken, tusername, tnickname, tgender, tbirthday, tlocation, tsource, thead];
    PLog(@"update user information body: %@", httpBody);
    
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] init];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
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
            
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据信息失败:(";
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
        
        @try {
            
            NSDictionary* dicJson = JSON;
            int status = [[dicJson objectForKey:@"status"] intValue];
            
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
            
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据信息失败:(";
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
 添加黑名单
 <!--请求POST-->
 HTTP_ADDBLACKLIST
 */
-(void)doHateSong:(NSString*)uid token:(NSString *)ttoken sid:(long)tsid {
    
    PLog(@"do hate song url: %@", HTTP_HATESONG);
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:HTTP_HATESONG]];
    
    NSString* httpBody = [NSString stringWithFormat:@"token=%@&uid=%@&songid=%ld", ttoken, uid, tsid];
    
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        @try {
            
            NSDictionary* dicJson = JSON;
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if(1 == status) {
                
                PLog(@"doHateSong operation succeed");
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameHateSongSuccess object:nil userInfo:nil];
                
            }
            else {
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                PLog(@"doHateSong operation failed: %@", msg);
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameHateSongFailed object:nil userInfo:dicResult];
                
            }
            
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据信息失败:(";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameHateSongFailed object:nil userInfo:dicResult];
            
        }
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        PLog(@"doHateSong failure: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameHateSongFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}

/*
 赠送歌曲
 <!--请求POST-->
 HTTP_PRESENTMUSIC
 */
-(void)doPresentMusic:(NSString *)uid token:(NSString*)ttoken touid:(NSString *)ttouid sid:(long)tsid {
    
    PLog(@"present music url: %@", HTTP_PRESENTMUSIC);
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:HTTP_PRESENTMUSIC]];
    
    NSString* httpBody = [NSString stringWithFormat:@"uid=%@&token=%@&touid=%@&songid=%ld", uid, ttoken, ttouid, tsid];
    PLog(@"present song body: %@", httpBody);
    
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if(1 == status) {
                
                PLog(@"present song operation succeeded");
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNamePresentMusicSuccess object:nil userInfo:nil];
                
            }
            else {
                
                PLog(@"present song operation failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNamePresentMusicFailed object:nil userInfo:dicResult];
            }
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据信息失败:(";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNamePresentMusicFailed object:nil userInfo:dicResult];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"present song failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNamePresentMusicFailed object:nil userInfo:nil];
    }];
    
    [operation start];
    
}

/*
 分享歌曲
 <!--请求POST-->
 HTTP_SHAREMUSIC
 */
-(void)doShareMusic:(NSString *)uid token:(NSString *)ttoken sid:(long)tsid platform:(int)tplatform{
    
    PLog(@"share music url: %@", HTTP_SHAREMUSIC);
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:HTTP_SHAREMUSIC]];
    
    NSString* httpBody = [NSString stringWithFormat:@"uid=%@&token=%@&songid=%ld&platform=%d", uid, ttoken, tsid, tplatform];
    
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        @try {
            
            NSDictionary* dicJson = JSON;
            int status = [[dicJson objectForKey:@"status"] intValue];
            
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
            
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据信息失败:(";
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
-(void)doUploadMusic:(NSString *)uid token:(NSString *)ttoken sid:(long)tsid enter:(int)tenter urlcode:(int)turlcode content:(long)tcontent{
    
    PLog(@"upload music url:%@", HTTP_UPLOADMUSIC);
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:HTTP_UPLOADMUSIC]];
    
    NSString* httpBody = @"hehe";//TODO JSON

    NSMutableURLRequest* request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        @try {
            
            NSDictionary* dicJson = JSON;
            int status = [[dicJson objectForKey:@"status"] intValue];
            
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
            
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据信息失败:(";
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
-(void)doGetNearbyUser:(NSString *)uid token:(NSString *)ttoken page:(int)tpage{
    
    NSString* url = [NSString stringWithFormat:@"%@&token=%@&uid=%@&page=%d", HTTP_NEARBYUSER,  ttoken, uid, tpage];
    PLog(@"get nearby user url: %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        @try {
            
            NSDictionary* dicJson = JSON;
            int status = [[dicJson objectForKey:@"status"] intValue];
            
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
            
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据信息失败:(";
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
-(void)doGetListFromUser:(NSString *)uid sid:(long)tsid token:(NSString *)ttoken{
    
    NSString* url = [NSString stringWithFormat:@"%@&token=%@&uid=%@&sid=%ld", HTTP_GETUSERLIST, ttoken, uid, tsid];
    PLog(@"get list from user url: %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        @try {
            
            NSDictionary* dicJson = JSON;
            int status = [[dicJson objectForKey:@"status"] intValue];
            
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
            
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据信息失败:(";
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
-(void)doGetPlayingMusicFromUser:(NSString *)uid token:(NSString *)ttoken begin:(int)tbegin page:(int)tpage{
    
    NSString* url = [NSString stringWithFormat:@"%@&token=%@&uid=%@", HTTP_GETPLAYINGMUSIC, ttoken, uid];
    PLog(@"playing music url: %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        @try {
            
            NSDictionary* dicJson = JSON;
            int status = [[dicJson objectForKey:@"status"] intValue];
            
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
            
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据信息失败:(";
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
-(void)doGetChannel:(NSString*)uid token:(NSString *)ttoken num:(int)tnum {
    
    NSString* url = [NSString stringWithFormat:@"%@?num=%d&token=%@&uid=%@", HTTP_GETCHANNEL, tnum, ttoken, uid];
    PLog(@"get channel url: %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            PLog(@"dicJson: %@", dicJson);
            
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if(1 == status) {
                
                PLog(@"get channel operation succeeded");
                
                NSDictionary* dicTemp = [dicJson objectForKey:@"result"];
                NSArray* dicChannels = [dicTemp objectForKey:@"channle"];
                
                NSMutableArray* channel = [[NSMutableArray alloc] init];
                
                for (int i=0; i<[dicChannels count]; i++) {
                    
                    Channel *tempChannel = [Channel initWithNSDictionary:[dicChannels objectAtIndex:i]];
                    [tempChannel log];
                    
                    [channel addObject:tempChannel];
                }
                
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:channel, @"result", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetChannelSuccess object:nil userInfo:dicResult];
                
            }
            else {
                
                PLog(@"get channel operation failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetChannelFailed object:nil userInfo:dicResult];
                
            }
            
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据失败:(";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetChannelFailed object:nil userInfo:dicResult];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
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
-(void)doGetMusicFromChannel:(NSString*)uid token:(NSString *)ttoken channel:(int)tchannel {
    
    NSString* url = [NSString stringWithFormat:@"%@?uid=%@&token=%@&channel=%d", HTTP_GETCHANNELMUSIC, uid, ttoken, tchannel];
    PLog(@"get channel music url: %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            PLog(@"dicJson: %@", dicJson);
            
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if(1 == status) {
                
                PLog(@"get music from channel operation succeeded");
                
                NSDictionary* dicTemp = [dicJson objectForKey:@"result"];
                NSArray* arrChannels = [dicTemp objectForKey:@"channel"];
                
                NSMutableArray* songList = [[NSMutableArray alloc] init];
                
                for (int i=0; i<[arrChannels count]; i++) {
                    
                    Song *tempsong = [Song initWithNSDictionary:[arrChannels objectAtIndex:i]];
                    [tempsong log];
                    
                    [songList addObject:tempsong];
                }
                
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:songList, @"result", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetChannelMusicSuccess object:nil userInfo:dicResult];
                
            }
            else {
                
                PLog(@"get music from channel operation failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetChannelMusicFailed object:nil userInfo:dicResult];
                
            }
            
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据失败:(";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetChannelMusicFailed object:nil userInfo:dicResult];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"get music from channel failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetChannelMusicFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}

/*
 获取心情词描述
 <!--请求GET-->
 HTTP_MODESCENE
 */
-(void)doGetWorkOfMood:(NSString*)uid token:(NSString*)ttoken{
    
    NSString* url = [NSString stringWithFormat:@"%@?decword=mood&token=%@&uid=%@", HTTP_MOODSCENE, ttoken, uid];
    PLog(@"get mood url: %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if(1 == status) {
                
                PLog(@"get mood operation succeeded");
                
                NSDictionary* dicTemp = [dicJson objectForKey:@"result"];
                NSArray* wordlist = [dicTemp objectForKey:@"word"];
                int wordcount = [wordlist count];
                
                NSMutableArray* moodList = [[NSMutableArray alloc] init];
                
                for (int i=0; i<wordcount; i++) {
                    
                    Word *tempword = [Word initWithNSDictionary:[wordlist objectAtIndex:i]];
                    tempword.mode = @"mm";
                    [tempword log];
                    
                    [moodList addObject:tempword];
                }
                
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:moodList, @"result", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameMoodSuccess object:nil userInfo:dicResult];
                
            } else {
                
                PLog(@"get mood operation failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameMoodFailed object:nil userInfo:dicResult];
                
            }
            
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据失败:(";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameMoodFailed object:nil userInfo:dicResult];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"get mood failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameMoodFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}

/*
 获取场景词描述
 <!--请求GET-->
 HTTP_MOODSCENE
 */
-(void)doGetWorkOfScene:(NSString*)uid token:(NSString*)ttoken{
    
    NSString* url = [NSString stringWithFormat:@"%@?decword=scene&token=%@&uid=%@", HTTP_MOODSCENE, ttoken, uid];
    PLog(@"get scene url: %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if(1 == status) {
                
                PLog(@"get scene operation succeeded");
                
                NSDictionary* dicTemp = [dicJson objectForKey:@"result"];
                NSArray* wordlist = [dicTemp objectForKey:@"word"];
                int wordcount = [wordlist count];
                
                NSMutableArray* moodList = [[NSMutableArray alloc] init];
                
                for (int i=0; i<wordcount; i++) {
                    
                    Word *tempword = [Word initWithNSDictionary:[wordlist objectAtIndex:i]];
                    tempword.mode = @"ms";
                    [tempword log];
                    
                    [moodList addObject:tempword];
                }
                
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:moodList, @"result", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSceneSuccess object:nil userInfo:dicResult];
                
            } else {
                
                PLog(@"get scene operation failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSceneFailed object:nil userInfo:dicResult];
                
            }
            
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据失败:(";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSceneFailed object:nil userInfo:dicResult];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"get scene failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSceneFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}

/*
 获取心情，场景歌曲
 <!--请求GET-->
 HTTP_MODEMUSIC
 */
-(void)doGetModeMusic:(NSString*)uid token:(NSString *)ttoken wordid:(NSString *)twordid mood:(NSString *)tmood num:(int)tnum{
    
    NSString* url = [NSString stringWithFormat:@"%@?wordid=%@&mode=%@&token=%@&uid=%@&num=%d", HTTP_MODEMUSIC, twordid, tmood, ttoken, uid, tnum];
    PLog(@"get mode music url: %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
//            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            PLog(@"doGetModeMusic result: %@", result);
//            NSData *tempData = [result dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if(1 == status) {
                
                PLog(@"get mode music operation succeeded");
                
                int tempwordid = 0;
                if ([tmood isEqualToString:@"mm"]) {
                    tempwordid = [twordid intValue];
                }
                
                NSDictionary* dicTemp = [dicJson objectForKey:@"result"];
                NSArray *songlist = [dicTemp objectForKey:@"song"];
                int songcount = [songlist count];
                
                NSMutableArray* songInfoList = [[NSMutableArray alloc] init];
                for (int i=0; i<songcount; i++) {
                    
                    Song *song = [Song initWithNSDictionary:[songlist objectAtIndex:i]];
                    song.wordid = tempwordid;
                    [song log];
                    
                    [songInfoList addObject:song];
                }
                
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:songInfoList, @"result", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameModeMusicSuccess object:nil userInfo:dicResult];
                
            }
            else {
                
                PLog(@"get mode music operation failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameModeMusicFailed object:nil userInfo:dicResult];
                
            }
            
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据失败:(";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameModeMusicFailed object:nil userInfo:dicResult];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"get mood music failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameModeMusicFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}

-(void)doGetModeMusic:(NSString *)uid token:(NSString *)ttoken wordid:(NSString *)twordid mood:(NSString *)tmood{
    [self doGetModeMusic:uid token:ttoken wordid:twordid mood:tmood num:10];
}

/*
 获取心绪地图
 <!--请求GET-->
 HTTP_MODEMAP
 */
-(void)doGetMoodMap:(NSString *)uid token:(NSString *)ttoken{
    
    NSString* url = [NSString stringWithFormat:@"%@?token=%@&uid=%@", HTTP_MOODMAP, ttoken, uid];
    PLog(@"get mood map url: %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if(1 == status) {
                
                PLog(@"get mood map operation succeeded");
                
                NSDictionary* dicTemp = [dicJson objectForKey:@"result"];
                NSArray *moodlist = [dicTemp objectForKey:@"mood"];
                int moodcount = [moodlist count];
                
                NSMutableArray* moodInfoList = [[NSMutableArray alloc] init];
                for (int i=0; i<moodcount; i++) {
                    
                    Mood *mood = [Mood initWithNSDictionary:[moodlist objectAtIndex:i]];
                    [mood log];
                    
                    [moodInfoList addObject:mood];
                }
                
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:moodInfoList, @"result", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameMoodMapSuccess object:nil userInfo:dicResult];
                
            }
            else {
                
                PLog(@"get mood map operation failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameMoodMapFailed object:nil userInfo:dicResult];
                
            }
            
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据信息失败:(";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameMoodMapFailed object:nil userInfo:dicResult];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameMoodMapFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}

/*
 获取心绪类别名称
 <!--请求GET-->
 HTTP_MOODPARENT
 */
-(void)doGetMoodParent:(NSString *)uid token:(NSString *)ttoken{
    
    NSString* url = [NSString stringWithFormat:@"%@?token=%@&uid=%@", HTTP_MOODPARENT, ttoken, uid];
    PLog(@"get mood parent url: %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if(1 == status) {
                
                PLog(@"get mood parent operation succeeded");
                
                NSDictionary* dicTemp = [dicJson objectForKey:@"result"];
                NSArray *moodlist = [dicTemp objectForKey:@"mood"];
                int moodcount = [moodlist count];
                
                NSMutableArray* moodInfoList = [[NSMutableArray alloc] init];
                for (int i=0; i<moodcount; i++) {
                    
                    Mood *mood = [Mood initWithNSDictionary:[moodlist objectAtIndex:i]];
                    [mood log];
                    
                    [moodInfoList addObject:mood];
                }
                
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:moodInfoList, @"result", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameMoodParentSuccess object:nil userInfo:dicResult];
                
            }
            else {
                
                PLog(@"get mood parent operation failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameMoodParentFailed object:nil userInfo:dicResult];
                
            }
            
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据信息失败:(";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameMoodParentFailed object:nil userInfo:dicResult];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameMoodParentFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}

/*
 提交用户当前状态
 <!--请求POST-->
 HTTP_ADDMOODRECORD
 */
-(void)doAddMoodRecord:(NSString*)uid token:(NSString*)ttoken wordid:(int)twordid songid:(long long)tsongid{
    
    PLog(@"add mood record url: %@", HTTP_ADDMOODRECORD);
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:HTTP_ADDMOODRECORD]];
    
    NSString* httpBody = [NSString stringWithFormat:@"token=%@&uid=%@&wordid=%d&songid=%lld", ttoken, uid, twordid, tsongid];
    PLog(@"add mood record body: %@", httpBody);
    
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if(1 == status) {
                
                PLog(@"add mood record operation succeeded");
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameAddMoodRecordSuccess object:nil userInfo:nil];
            } else {
                
                PLog(@"add mood record operation failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameAddMoodRecordFailed object:nil userInfo:dicResult];
                
            }
            
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据信息失败:(";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameAddMoodRecordFailed object:nil userInfo:dicResult];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameAddMoodRecordFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}

/*
 设置用户位置 (2013-7-22)
 HTTP_SETUSERPOS
 POST
 */
-(void)doSetUserPos:(NSString*)uid token:(NSString*)ttoken location:(NSString *)tlocation{
    
    PLog(@"set user pos url: %@", HTTP_SETUSERPOS);
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:HTTP_SETUSERPOS]];
    
    NSString* httpBody = [NSString stringWithFormat:@"token=%@&uid=%@&location=%@", ttoken, uid, tlocation];
    PLog(@"set user pos body: %@", httpBody);
    
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if(1 == status) {
                
                PLog(@"set user pos operation succeeded");
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSetUserPosSuccess object:nil userInfo:nil];
            } else {
                
                PLog(@"set user pos operation failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSetUserPosFailed object:nil userInfo:dicResult];
                
            }
            
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据信息失败:(";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSetUserPosFailed object:nil userInfo:dicResult];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSetUserPosFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}

/*
 查找附近的人 (2013-7-22)
 HTTP_SEARCHNEARBY
 GET
 */
-(void)doSearchNearby:(NSString*)uid token:(NSString*)ttoken location:(NSString *)tlocation radius:(int)tradius {
    
    NSString* url = [NSString stringWithFormat:@"%@?token=%@&uid=%@&location=%@&radius=%d", HTTP_SEARCHNEARBY, ttoken, uid, tlocation, tradius];
    PLog(@"search nearby url: %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
//            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            PLog(@"result: %@", result);
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if(1 == status) {
                
                PLog(@"search nearby operation succeeded");
                
                NSDictionary* dicTemp = [dicJson objectForKey:@"result"];
                NSArray *nearuserlist = [dicTemp objectForKey:@"nearUser"];
                int nearusercount = [nearuserlist count];
                
                NSMutableArray *nearbyUserInfoList = [[NSMutableArray alloc] init];
                for (int i=0; i<nearusercount; i++) {
                    
                    NearbyUser *nearbyuser = [NearbyUser initWithNSDictionary:[nearuserlist objectAtIndex:i]];
                    [nearbyuser log];
                    
                    [nearbyUserInfoList addObject:nearbyuser];
                }
                
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:nearbyUserInfoList, @"result", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSearchNearbySuccess object:nil userInfo:dicResult];
                
            }
            else {
                
                PLog(@"search nearby operation failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSearchNearbyFailed object:nil userInfo:dicResult];
                
            }
            
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据信息失败:(";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSearchNearbyFailed object:nil userInfo:dicResult];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSearchNearbyFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}

/*
 非注册用户获取播放列表（2013-08－17）
 */
-(void)doGetDefaultGuestSongs{
    
    NSString* url = [NSString stringWithFormat:@"%@", HTTP_GETDEFAULTGUESTSONGS];
    PLog(@"get default guest songs url: %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if(1 == status) {
                
                PLog(@"get default guest songs operation succeeded");
                
                NSDictionary* dicTemp = [dicJson objectForKey:@"result"];
                NSArray *songlist = [dicTemp objectForKey:@"song"];
                int songcount = [songlist count];
                
                NSMutableArray* songInfoList = [[NSMutableArray alloc] init];
                for (int i=0; i<songcount; i++) {
                    
                    Song *song = [Song initWithNSDictionary:[songlist objectAtIndex:i]];
                    [song log];
                    
                    [songInfoList addObject:song];
                }
                
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:songInfoList, @"result", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetDefaultGuestSongsSuccess object:nil userInfo:dicResult];
                
            }
            else {
                
                PLog(@"get default guest songs operation failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetDefaultGuestSongsFailed object:nil userInfo:dicResult];
                
            }
            
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据失败:(";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetDefaultGuestSongsFailed object:nil userInfo:dicResult];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"get default guest songs failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetDefaultGuestSongsFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
}

/*
 获取收藏的歌曲
 <!--请求GET-->
 HTTP_CLTSONGS
 */
-(void)doGetCollectedSongs:(NSString *)uid token:(NSString *)ttoken taruid:(NSString*)ttaruid {
    
    NSString* url = [NSString stringWithFormat:@"%@?uid=%@&token=%@&taruid=%@", HTTP_GETCLTSONGS, uid, ttoken, ttaruid];
    PLog(@"get collected songs url:%@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if(1 == status) {
                
                PLog(@"get collected songs succeeded");
                
                NSDictionary* dicTemp = [dicJson objectForKey:@"result"];
                NSArray* songlist = [dicTemp objectForKey:@"song"];
                int songcount = [songlist count];
                
                NSMutableArray* songInfoList = [[NSMutableArray alloc] init];
                
                for (int i=0; i<songcount; i++) {
                    
                    Song* song = [Song initWithNSDictionary:[songlist objectAtIndex:i]];
                    [song log];
                    
                    [songInfoList addObject:song];
                }
                
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:songInfoList, @"result", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetCollectedSongsSuccess object:nil userInfo:dicResult];
            }
            else {
                
                PLog(@"get collected music failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetCollectedSongsFailed object:nil userInfo:dicResult];
         
            }
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据失败...";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetCollectedSongsFailed object:nil userInfo:dicResult];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"get collected songs failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetCollectedSongsFailed object:nil userInfo:nil];
    }];
    
    [operation start];
}

/*
 获取豆瓣的频道歌曲
 <!--请求GET-->
 HTTP_GETDBCHANNELSONG
 */
-(void)doGetDoubanChannelSong:(NSString*)uid token:(NSString*)ttoken channel:(NSString*)tchannel {
    
    NSString* url = [NSString stringWithFormat:@"%@?uid=%@&token=%@&channel=%@", HTTP_GETDBCHANNELSONG, uid, ttoken, tchannel];
    PLog(@"get douban channel song url: %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if(1 == status) {
                
                PLog(@"get douban channel song operation succeeded");
                
                NSDictionary* dicTemp = [dicJson objectForKey:@"result"];
                NSArray* songlist = [dicTemp objectForKey:@"channel"];
                int songcount = [songlist count];
                
                NSMutableArray* songInfoList = [[NSMutableArray alloc] init];
                for (int i=0; i<songcount; i++) {
                    
                    Song* song = [Song initWithNSDictionary:[songlist objectAtIndex:i]];
                    [song log];
                    
                    [songInfoList addObject:song];
                }
                
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:songInfoList, @"result", nil];
        
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetDbChannelSongSuccess object:nil userInfo:dicResult];
        
            }
            else {
                
                PLog(@"get douban channel song opeation failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetDbChannelSongFailed object:nil userInfo:dicResult];
            }
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据失败";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetDbChannelSongFailed object:nil userInfo:dicResult];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"get douban channel song failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetDbChannelSongFailed object:nil userInfo:nil];
    }];
    
    [operation start];
    
}

/*
 通过整体纬度获取音乐
 <!--请求GET-->
 HTTP_GETTYPESONGS
 */
-(void)doGetTypeSongs:(NSString*)uid token:(NSString*)ttoken typeid:(NSString *)ttypeid typeindex:(NSString *)ttypeindex moodid:(NSString *)tmoodid moodindex:(NSString *)tmoodindex sceneid:(NSString *)tsceneid sceneindex:(NSString *)tsceneindex channelid:(NSString *)tchannelid channelindex:(NSString *)tchannelindex num:(NSString *)tnum{
    
    NSString* url = [NSString stringWithFormat:@"%@?uid=%@&token=%@&typeid=%@&typeindex=%@&moodid=%@&moodindex=%@&sceneid=%@&sceneindex=%@&channelid=%@&channelindex=%@&num=%@", HTTP_GETTYPESONGS, uid, ttoken, ttypeid, ttypeindex, tmoodid, tmoodindex, tsceneid, tsceneindex, tchannelid, tchannelindex, tnum];
    PLog(@"get type songs url: %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if(1 == status) {
                
                PLog(@"get type songs operation succeeded");
                
                NSDictionary* dicTemp = [dicJson objectForKey:@"result"];
                NSArray* songlist = [dicTemp objectForKey:@"song"];
                int songcount = [songlist count];
                
                NSMutableArray* songInfos = [[NSMutableArray alloc] init];
                
                for(int i=0; i<songcount; i++) {
                    
                    Song* song = [Song initWithNSDictionary:[songlist objectAtIndex:i]];
                    song.channelid = tchannelid;
                    song.typeid = ttypeid;
                    song.moodid = tmoodid;
                    song.sceneid = tsceneid;
                    
                    [songInfos addObject:song];
                }
                
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:songInfos, @"result", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetTypeSongsSuccess object:nil userInfo:dicResult];
            }
            else {
                
                PLog(@"get type songs operation failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetTypeSongsFailed object:nil userInfo:dicResult];
            }
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据失败";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetTypeSongsFailed object:nil userInfo:dicResult];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"get type songs failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetTypeSongsFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
}

/*
 提交本地歌曲信息(2013-08-19)
 <!--请求POST-->
 HTTP_RECORDLOCALSONGS
 */
-(void)doRecordLocalSongs:(NSString*)uid token:(NSString*)ttoken source:(NSString*)tsource urlcode:(NSString*)turlcode name:(NSString*)tname content:(NSString*)tcontent {
    
    NSString* url = [NSString stringWithFormat:@"uid=%@&token=%@&source=%@&urlcode=%@&name=%@&content=%@", uid, ttoken, tsource, turlcode, tname, tcontent];
    PLog(@"record local songs url: %@", url);
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:HTTP_RECORDLOCALSONGS]];
    
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[url dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        @try {
            
            NSDictionary* dicJson = JSON;
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if(1 == status) {
                
                PLog(@"record local songs operation succeeded");
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameRecordLocalSongsSuccess object:nil userInfo:nil];
            }
            else {
                
                PLog(@"record local songs operation failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameRecordLocalSongsFailed object:nil userInfo:dicResult];
            }
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据信息失败";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameRecordLocalSongsFailed object:nil userInfo:dicResult];
            
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        PLog(@"record local songs failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameRecordLocalSongsFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
}

-(void)doRecordLocalSongsSingle:(NSString *)uid token:(NSString *)ttoken source:(NSString *)tsource urlcode:(NSString *)turlcode name:(NSString *)tname song:(Song *)tsong {
    
    if(tsong != nil) {
        
        NSString* songcontent = [NSString stringWithFormat:@"{\"music\":[{\"name\":\"%@\",\"singer\":\"%@\"}]}", tsong.songname, tsong.artist];

        PLog(@"do record local song single: %@", songcontent);
        
        [self doRecordLocalSongs:uid token:ttoken source:tsource urlcode:turlcode name:tname content:songcontent];
    }
}

-(void)doRecordLocalSongsArray:(NSString *)uid token:(NSString *)ttoken source:(NSString *)tsource urlcode:(NSString *)turlcode name:(NSString *)tname songs:(NSArray *)tsongs {
    
    if(tsongs != nil) {
        
        int songcount = [tsongs count];
        NSMutableString* maincontent = [[NSMutableString alloc] init];
        
        for (int i=0; i<songcount; i++) {
            
            Song* song = [tsongs objectAtIndex:i];
            
            NSString* singlesong = [NSString stringWithFormat:@"{\"name\":\"%@\",\"singer\":\"%@\"}", song.songname, song.artist];
            
            if(0 == i) {
                
                [maincontent appendString:singlesong];
            }
            else {
                
                [maincontent appendFormat:@",%@", singlesong];
            }
        }
        
        NSString* tcontent = [NSString stringWithFormat:@"{\"music\":[%@]}", maincontent];
        
        PLog(@"do record local song array: %@", tcontent);
        
        [self doRecordLocalSongs:uid token:ttoken source:tsource urlcode:turlcode name:tname content:tcontent];
    }
}

/*
 获取推送消息
 <!--请求GET-->
 HTTP_GETPUSHMSG
 */
-(void)doGetPushMsg:(NSString*)uid token:(NSString*)ttoken pageindex:(NSString*)tpageindex rec:(NSString*)trec {
    
    NSString* url = [NSString stringWithFormat:@"%@?uid=%@&token=%@&Page_index=%@&Rec_per_page=%@", HTTP_GETPUSHMSG, uid, ttoken, tpageindex, trec];
    PLog(@"get push message url: %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if (1 == status) {
                
                PLog(@"get push message operation succeeded");
                
            }
        }
        @catch (NSException *exception) {
            
            ;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
    [operation start];
}

/*
 更新音乐纬度配置文件
 <!--请求GET-->
 HTTP_UPDATECONFIGFILE
 */
-(void)doUpdateConfigfile:(NSString*)uid token:(NSString*)ttoken version:(NSString*)tversion {
    
    NSString* url = [NSString stringWithFormat:@"%@?uid=%@&token=%@&version=%@", HTTP_UPDATECONFIGFILE, uid, ttoken, tversion];
    PLog(@"update config file url: %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if(1 == status) {
                
                PLog(@"update config file operation succeeded");
                
                NSDictionary* dicTemp = [dicJson objectForKey:@"result"];
                ConfigFileInfo* cfi = [ConfigFileInfo initWithNSDictionary:dicTemp];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:cfi, @"result", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameUpdateConfigSuccess object:nil userInfo:dicResult];
                
            }
            else {
                
                PLog(@"update config file operation failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameUpdateConfigFailed object:nil userInfo:dicResult];
            }
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据失败";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameUpdateConfigFailed object:nil userInfo:dicResult];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"update config file failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameUpdateConfigFailed object:nil userInfo:nil];
    }];
    
    [operation start];
}

/*
 记录用户试听歌曲状态
 <!--请求POST-->
 HTTP_RECORDCURSONG
 */
-(void)doRecordCurrentSong:(NSString*)uid token:(NSString*)ttoken lastsong:(NSString*)tlastsong cursong:(NSString*)tcursong mode:(NSString*)tmode typeid:(NSString*)ttypeid name:(NSString*)tname singer:(NSString*)tsinger state:(NSString*)tstate {
    
    PLog(@"record current song url: %@", HTTP_RECORDCURSONG);
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:HTTP_RECORDCURSONG]];
    
    NSString* httpBody = [NSString stringWithFormat:@"uid=%@&token=%@&lastsong=%@&cursong=%@&mode=%@&name=%@&singer=%@&state=%@&typeid=%@", uid, ttoken, tlastsong, tcursong, tmode, tname, tsinger, tstate, ttypeid];
    PLog(@"record current song body: %@", httpBody);
    
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if(1 == status) {
                
                PLog(@"record current song operation succeeded");
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameRecordCurSongSuccess object:nil userInfo:nil];
            }
            else {
                
                PLog(@"record current song operation failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameRecordCurSongFailed object:nil userInfo:dicResult];
                
            }
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据失败";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameRecordCurSongFailed object:nil userInfo:dicResult];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"update config file failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameRecordCurSongFailed object:nil userInfo:nil];
    }];
    
    [operation start];
}

/*
 添加红心歌曲
 <!--POST-->
 HTTP_COLLECTSONG
 */
-(void)doCollectSong:(NSString*)uid token:(NSString*)ttoken sid:(NSString*)tsid modetype:(NSString*)tmodetype typeid:(NSString*)ttypeid {
    
    PLog(@"collect song url: %@", HTTP_COLLECTSONG);
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:HTTP_COLLECTSONG]];
    
    NSString* httpBody = [NSString stringWithFormat:@"uid=%@&token=%@&songid=%@&modetype=%@&typeid=%@", uid, ttoken, tsid, tmodetype, ttypeid];
    PLog(@"collect song body: %@", httpBody);
    
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if(1 == status) {
                
                PLog(@"collect song operation succeeded");
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameCollectSongSuccess object:nil userInfo:nil];
            }
            else {
                
                PLog(@"collect song operation failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameCollectSongFailed object:nil userInfo:dicResult];
                
            }
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据失败";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameCollectSongFailed object:nil userInfo:dicResult];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"collect song failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameCollectSongFailed object:nil userInfo:nil];
    }];
    
    [operation start];
}

/*
 拉黑歌曲
 <!--请求POST-->
 HTTP_HATESONG
 */
-(void)doAddHateSong:(NSString*)uid token:(NSString*)ttoken sid:(NSString*)tsid {
    
    PLog(@"hate song url: %@", HTTP_HATESONG);
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:HTTP_HATESONG]];
    
    NSString* httpBody = [NSString stringWithFormat:@"uid=%@&token=%@&songid=%@", uid, ttoken, tsid];
    PLog(@"hate song body: %@", httpBody);
    
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [dicJson objectForKey:@"status"];
            
            if(1 == status) {
                
                PLog(@"hate song operation succeeded");
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameHateSongSuccess object:nil userInfo:nil];
            }
            else {
                
                PLog(@"hate song operation failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameHateSongFailed object:nil userInfo:dicResult];
            }
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据失败";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameHateSongFailed object:nil userInfo:dicResult];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"hate song failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameHateSongFailed object:nil userInfo:nil];
    }];
    
    [operation start];
}

/*
 获取收藏歌曲数量和附近人收藏数量
 <!--GET-->
 HTTP_COLLECTANDNEARNUM
 */
-(void)doCollectAndNearNum:(NSString*)uid token:(NSString*)ttoken taruid:(NSString*)ttaruid radius:(NSString*)tradius pageindex:(NSString*)tpageindex pagesize:(NSString*)tpagesize location:(NSString*)tlocation {
    
    NSString* url = [NSString stringWithFormat:@"%@?uid=%@&token=%@&taruid=%@&radius=%@&page_index=%@&page_size=%@&location=%@", HTTP_COLLECTANDNEARNUM, uid, ttoken, ttaruid, tradius, tpageindex, tpagesize, tlocation];
    PLog(@"collect and near number url: %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if (1 == status) {
                
                PLog(@"collect and near number operation succeeded");
                
                NSDictionary* dicTemp = [dicJson objectForKey:@"result"];
                CollectNum* cn = [CollectNum initWithNSDictionary:dicTemp];
                
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:cn, @"result", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameCollectAndNearNumSuccess object:nil userInfo:dicResult];
            }
            else {

                PLog(@"collect and near number operation failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameCollectAndNearNumFailed object:nil userInfo:dicResult];
            }
        }
        @catch (NSException *exception) {
        
            NSString* msg = @"解析返回数据失败";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameCollectAndNearNumFailed object:nil userInfo:dicResult];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"collect and near number failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameCollectAndNearNumFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
}

/*
 删除收藏歌曲
 POST
 HTTP_DELETECOLLECTSONG
 */
-(void)doDeleteCollectedSong:(NSString*)uid token:(NSString *)ttoken songid:(NSString*)tsongid {
    
    PLog(@"delete collect song url: %@", HTTP_DELETECOLLECTSONG);
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:HTTP_DELETECOLLECTSONG]];
    
    NSString* httpBody = [NSString stringWithFormat:@"uid=%@&token=%@&songid=%@", uid, ttoken, tsongid];
    PLog(@"delete collect song body: %@", httpBody);
    
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if(1 == status) {
                
                PLog(@"delete collect song operation succeed");
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameDeleteCollectSongSuccess object:nil userInfo:nil];
            }
            else {
                
                PLog(@"delete collect song operation failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameDeleteCollectSongFailed object:nil userInfo:dicResult];
            }
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据失败";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameDeleteCollectSongFailed object:nil userInfo:dicResult];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"delete collect song failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameDeleteCollectSongFailed object:nil userInfo:nil];
    }];
    
    [operation start];
}

/*
 获取歌曲信息
 GET
 HTTP_GETSONGINFO
 */
-(void)doGetSongInfo:(NSString*)uid token:(NSString*)ttoken songid:(NSString*)tsongid {
    
    NSString* url = [NSString stringWithFormat:@"%@?uid=%@&token=%@&songid=%@", HTTP_GETSONGINFO, uid, ttoken, tsongid];
    PLog(@"get song info url: %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if (1 == status) {
                
                PLog(@"get song info operation succeeded");
                
                Song* song = [Song initWithNSDictionary:[dicJson objectForKey:@"song"]];
                
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:song, @"result", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetSongInfoSuccess object:nil userInfo:dicResult];
            }
            else {
                
                PLog(@"get song info operation failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetSongInfoFailed object:nil userInfo:dicResult];
            }
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据失败";
            
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetSongInfoFailed object:nil userInfo:dicResult];
        }
     
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"get song info failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetSongInfoFailed object:nil userInfo:nil];
    }];
    
    [operation start];
}

/*
 附近人的音乐
 GET
 HTTP_GETNEARMUSIC
 */
-(void)doGetNearMusic:(NSString*)uid token:(NSString*)ttoken radius:(NSString*)tradius pageindex:(NSString*)tpageindex pagesize:(NSString*)tpagesize location:(NSString*)tlocation {
    
    NSString* url = [NSString stringWithFormat:@"%@?uid=%@&token=%@&radius=%@&page_index=%@&page_size=%@&location=%@", HTTP_GETNEARMUSIC, uid, ttoken, tradius, tpageindex, tpagesize, tlocation];
    PLog(@"get near music url: %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        bool SuccessButNULL = false; // 0:failed, 1:succeeded but null
       
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if(1 == status) {
                
                PLog(@"do get near music operation succeeded");
                
                SuccessButNULL = true;
                
                NSDictionary* dicTemp = [dicJson objectForKey:@"result"];
                
                NSArray* nearmusicstate = [dicTemp objectForKey:@"nearUser"];
                int nmscount = [nearmusicstate count];
                
                NSMutableArray* nmsInfos = [[NSMutableArray alloc] init];
                
                for (int i=0; i<nmscount; i++) {
                    
                    NearMusicState* nms = [NearMusicState initWithNSDictionary:[nearmusicstate objectAtIndex:i]];
                    
                    [nmsInfos addObject:nms];
                }
                
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:nmsInfos, @"result", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetNearMusicSuccess object:nil userInfo:dicResult];
            }
            else {
                
                PLog(@"do get near music operation failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetNearMusicFailed object:nil userInfo:dicResult];
            }
        }
        @catch (NSException *exception) {
            
            if (SuccessButNULL) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetNearMusicFailed object:nil userInfo:nil];
            }
            else {
                
                NSString* msg = @"解析返回数据失败";
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetNearMusicFailed object:nil userInfo:dicResult];
                
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"get near music failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetNearMusicFailed object:nil userInfo:nil];
    }];
    
    [operation start];
}

/*
 评论歌曲
 POST
 HTTP_COMMENTSONG
 */
-(void)doCommentSong:(NSString*)uid token:(NSString*)ttoken songid:(NSString*)tsongid comment:(NSString*)tcomment {

    PLog(@"comment song url: %@", HTTP_COMMENTSONG);
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:HTTP_COMMENTSONG]];
    
    NSString* httpBody = [NSString stringWithFormat:@"uid=%@&token=%@&songid=%@&comment=%@", uid, ttoken, tsongid, tcomment];
    PLog(@"comment song body: %@", httpBody);
    
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if(status == 1) {
                
                PLog(@"comment song operation succeeded");
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameCommentSongSuccess object:nil userInfo:nil];
            }
            else {
                
                PLog(@"comment song operation failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameCommentSongFailed object:nil userInfo:dicResult];
            }
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据失败";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameCommentSongFailed object:nil userInfo:dicResult];
        }
     
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"comment song failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameCommentSongFailed object:nil userInfo:nil];
    }];
    
    [operation start];
}

/*
 获取歌曲评论
 GET
 HTTP_GETCOMMENT
 */
-(void)doGetSongComment:(NSString*)uid token:(NSString*)ttoken songid:(NSString*)tsongid count:(NSString*)tcount fromid:(NSString*)tfromid {
    
    NSString* url = [NSString stringWithFormat:@"%@?uid=%@&token=%@&songid=%@&count=%@&fromid=%@", HTTP_GETCOMMENT, uid, ttoken, tsongid, tcount, tfromid];
    PLog(@"get song comment url: %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation* operaion = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operaion setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        bool bReturnSucceed = false;
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if(1 == status) {
                
                PLog(@"get comment operation succeeded");
                
                bReturnSucceed = true;
                
                NSDictionary* dicTemp = [dicJson objectForKey:@"result"];
                NSString* tsongid = [dicTemp objectForKey:@"songid"];
                
                NSArray* comments = [dicTemp objectForKey:@"comments"];
                int commentcount = [comments count];
                
                NSMutableArray* commentInfo = [[NSMutableArray alloc] init];
                
                for (int i=0; i<commentcount; i++) {
                    
                    SongComment* sc = [SongComment initWithNSDictionary:[comments objectAtIndex:i]];
                    sc.songid = tsongid;
                    
                    [commentInfo addObject:sc];
                }
                
                if (commentcount == 0) {
                    
                    //没有评论，发送nil
                    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetCommentSuccess object:nil userInfo:nil];
                }
                else {
                    
                    NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:commentInfo, @"result", nil];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetCommentSuccess object:nil userInfo:dicResult];
                }
            }
            else {
                
                if(bReturnSucceed) {
                    
                    // return succeeded, but there is no comment
                    PLog(@"get comment operation succeeded, no comment");
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetCommentSuccess object:nil userInfo:nil];
                }
                else {
                    
                    PLog(@"get comment operation failed");
                    
                    NSString* msg = [dicJson objectForKey:@"msg"];
                    NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetCommentFailed object:nil userInfo:dicResult];
                }
            }
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据失败";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetCommentFailed object:nil userInfo:dicResult];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"get comment failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetCommentFailed object:nil userInfo:nil];
    }];
    
    [operaion start];
}

/*
 获取周围谁在听你的歌
 获取周围的消息
 GET
 HTTP_GETMYNEARMUSICMSGNUM
 */
-(void)doGetMyNearMusicMsgNumber:(NSString *)uid token:(NSString *)ttoken radius:(NSString *)tradius location:(NSString *)tlocation {
    
    NSString* url = [NSString stringWithFormat:@"%@?uid=%@&token=%@&radius=%@&location=%@", HTTP_GETMYNEARMUSICMSGNUM, uid, ttoken, tradius, tlocation];
    PLog(@"get my nearby music and message url:%@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            PLog(@"get my nearby music and message operation succeeded");
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if(1 == status) {
                
                int msg_num = [[dicJson objectForKey:@"msg_num"] intValue];
                int music_num = [[dicJson objectForKey:@"music_num"] intValue];
                
                NSMutableArray* numarray = [[NSMutableArray alloc] init];
                [numarray addObject:[NSNumber numberWithInt:msg_num]];
                [numarray addObject:[NSNumber numberWithInt:music_num]];
                
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:numarray, @"result", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetMyNearMusicMsgNumSuccess object:nil userInfo:dicResult];
                                
            }
            else {
                
                PLog(@"get my nearby music and message operation failed");
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetMyNearMusicMsgNumFailed object:nil userInfo:dicResult];
            }
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据失败";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetMyNearMusicMsgNumFailed object:nil userInfo:dicResult];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"get my nearby music and message failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetMyNearMusicMsgNumFailed object:nil userInfo:nil];
    }];
    
    [operation start];
}

/*
 获取周围谁在听你红心的歌曲
 GET
 HTTP_GETSAMEMUSIC
 */
-(void)doGetSameMusic:(NSString *)uid token:(NSString *)ttoken radius:(NSString *)tradius location:(NSString *)tlocation {
    
    NSString* url = [NSString stringWithFormat:@"%@?uid=%@&token=%@&radius=%@&location=%@", HTTP_GETSANMEMUSIC, uid, ttoken, tradius, tlocation];
    PLog(@"get same music url:%@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if(1 == status) {
                
                PLog(@"get same music operation succeeded");
                
                NSDictionary* dicTemp = [dicJson objectForKey:@"result"];
                NSArray* musicarray = [dicTemp objectForKey:@"nearUser"];
                int musicarraycount = [musicarray count];
                
                NSMutableArray* musicList = [[NSMutableArray alloc] init];
                
                for (int i=0; i<musicarraycount; i++) {
                    
                    NearMusicState* nms = [NearMusicState initWithNSDictionary:[musicarray objectAtIndex:i]];
                    [musicList addObject:nms];
                }
                
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:musicList, @"result", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetSameMusicSuccess object:nil userInfo:dicResult];
                
            }
            else {
                
                PLog(@"get my same music operation failed");
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetSameMusicFailed object:nil userInfo:dicResult];
            }
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据失败";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetSameMusicFailed object:nil userInfo:dicResult];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"get my same music failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetSameMusicFailed object:nil userInfo:nil];
    }];
    
    [operation start];
}

/*
 获取周围谁在听你红心的歌曲
 GET
 HTTP_GETSAMEMUSIC
 */
-(void)doGetNearUser:(NSString *)uid token:(NSString *)ttoken radius:(NSString *)tradius location:(NSString *)tlocation {
    
    NSString* url = [NSString stringWithFormat:@"%@?uid=%@&token=%@&radius=%@&location=%@", HTTP_GETNEARUSER, uid, ttoken, tradius, tlocation];
    PLog(@"get near user url:%@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if(1 == status) {
                
                PLog(@"get near user operation succeeded");
                
                NSDictionary* dicTemp = [dicJson objectForKey:@"result"];
                NSArray* musicarray = [dicTemp objectForKey:@"nearUser"];
                int musicarraycount = [musicarray count];
                
                NSMutableArray* musicList = [[NSMutableArray alloc] init];
                
                for (int i=0; i<musicarraycount; i++) {
                    
                    NearMusicState* nms = [NearMusicState initWithNSDictionary:[musicarray objectAtIndex:i]];
                    [musicList addObject:nms];
                }
                
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:musicList, @"result", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetNearUserSuccess object:nil userInfo:dicResult];
                
            }
            else {
                
                PLog(@"get my same music operation failed");
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetNearUserFailed object:nil userInfo:dicResult];
            }
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据失败";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetNearUserFailed object:nil userInfo:dicResult];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"get my same music failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetNearUserFailed object:nil userInfo:nil];
    }];
    
    [operation start];
}

/*
 获取用户听歌记录
 HTTP_GETSONGHISTORY
 GET
 */
-(void)doGetSongHistory:(NSString *)uid token:(NSString *)ttoken fromid:(NSString *)tfromid count:(NSString *)tcount {
    
    NSString* szfromid = [tfromid isEqualToString:@""] ? @"" : [NSString stringWithFormat:@"&fromid=%@", tfromid];
    NSString* szcount = [tcount isEqualToString:@""] ? @"" : [NSString stringWithFormat:@"&count=%@", tcount];
    
    NSString* url = [NSString stringWithFormat:@"%@?uid=%@&token=%@%@%@&islike=0", HTTP_GETSONGHISTORY, uid, ttoken, szfromid, szcount];
    PLog(@"get song history url: %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if(1 == status) {
                
                PLog(@"get user song history operation succeeded");
                
                NSArray* songArray = [dicJson objectForKey:@"history"];
                int songArrayCount = [songArray count];
                
                NSMutableArray* songLists = [[NSMutableArray alloc] init];
                
                for (int i=0; i<songArrayCount; i++) {
                    
                    Song* song = [Song initWithNSDictionary:[songArray objectAtIndex:i]];
                    
                    [songLists addObject:song];
                }
                
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:songLists, @"result", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetSongHistorySuccess object:nil userInfo:dicResult];
            }
            else {
                
                PLog(@"get user song history operation failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetSongHistoryFailed object:nil userInfo:dicResult];
            }
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据失败...";
            
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetSongHistoryFailed object:nil userInfo:dicResult];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"get user song history failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetSongHistoryFailed object:nil userInfo:nil];
    }];
    
    [operation start];
}

/*
 打招呼
 HTTP_SAYHELLO
 POST
 */
-(void)doSayHello:(NSString *)uid token:(NSString *)ttoken touid:(NSString *)ttouid msg:(NSString *)tmsg {
    
    PLog(@"say hello url: %@", HTTP_SAYHELLO);
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:HTTP_SAYHELLO]];
    
    NSString* httpBody = [NSString stringWithFormat:@"uid=%@&token=%@&touid=%@&msg=%@", uid, ttoken, ttouid, tmsg];
    PLog(@"say hello body: %@", httpBody);
    
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if (1 == status) {
                
                PLog(@"say hello operation succeeded");
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSayHelloSuccess object:nil userInfo:nil];
            }
            else {
                
                PLog(@"say hello operation failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSayHelloFailed object:nil userInfo:dicResult];
            }
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据失败";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSayHelloFailed object:nil userInfo:dicResult];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"say hello failure: %@", error);
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSayHelloFailed object:nil userInfo:nil];
    }];
    
    [operation start];
}


@end
