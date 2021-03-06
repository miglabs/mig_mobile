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
#import "LyricShare.h"

@implementation MigLabAPI

/*
 SSO的登录
 http://sso.miglab.com/cgi-bin/sp.fcgi?sp
 */
-(void)doAuthLogin:(NSString *)tusername password:(NSString *)tpassword{
    
    API_HEADER();
    
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
    
    API_FOOTER();
}

/*
 <!--请求Post-->
 http://sso.miglab.com/cgi-bin/sp.fcgi?sp
 */
-(void)doSsoLoginFirst:(NSString *)tusername password:(NSString *)tpassword{
    
    API_HEADER();
    
    PLog(@"LOGIN_SSO_SP_URL: %@", LOGIN_SSO_SP_URL);
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:LOGIN_SSO_SP_URL]];
    
    NSString* httpBody = [NSString stringWithFormat:@"username=%@&password=%@&clientid=0&token=miglab", tusername, tpassword];
    PLog(@"login first body: %@", httpBody);
    
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if (1 == status) {
                
                //成功之后保存用户名和密码
                [UserSessionManager GetInstance].currentUser.username = tusername;
                [UserSessionManager GetInstance].currentUser.password = tpassword;
                
                NSDictionary* dicTemp = [dicJson objectForKey:@"result"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameLoginSuccess object:nil userInfo:dicTemp];
                
            }
            else {
                
                PLog(@"login failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameLoginFailed object:nil userInfo:dicResult];
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
    
    API_FOOTER();
}

/*
 获取用户信息
 <!--请求Get-->
 http://open.fm.miglab.com/api/userinfo.fcgi
 */
-(void)doGetUserInfo:(NSString *)tUserName accessToken:(NSString *)tAccessToken{
    
    API_HEADER();
    
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
    
    API_FOOTER();
}

/*
 <!--请求POST-->
 THIRD_LOGIN
 */
-(void) doThirdLogin:(int) tmachine nickname:(NSString*)tnickname source:(SourceType)tsourcetype session:(NSString*)tsession imei:(NSString*) timei sex:(NSString*)tsex birthday:(NSString*)tbirthday location:(NSString*)tlocation head:(NSString*)thead latitude:(NSString*)tlatitude longitude:(NSString*)tlongitude{
    
    API_HEADER();
    
    NSString* thirdloginUrl = THIRD_LOGIN;
    PLog(@"thirdloginUrl: %@", thirdloginUrl);
    
    NSURL* url = [NSURL URLWithString:thirdloginUrl];
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSString* httpBody = [NSString stringWithFormat:@"machine=%d&nickname=%@&source=%d&session=%@&imei=%@&sex=%@&birthday=%@&location=%@&head=%@&latitude=%@&longitude=%@",tmachine,tnickname,tsourcetype,tsession,timei,tsex,tbirthday,tlocation,thead,tlatitude,tlongitude];
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
                NSDictionary* dicTemp = [dicJson objectForKey:@"result"];
                
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:dicTemp, @"result", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationThirdLoginSuccess object:nil userInfo:dicResult];
                
                //PUser* user = [PUser initWithNSDictionary:[dicJson objectForKey:@"result"]];
                //NSDictionary *dicResult = [NSDictionary dictionaryWithObjectsAndKeys:user, @"result", nil];
                
                //[[NSNotificationCenter defaultCenter] postNotificationName:NotificationThirdLoginSuccess object:nil userInfo:dicResult];
                
            } else if (0 == status || -1 == status) {
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                PLog(@"register operation failed: %@", msg);
                NSDictionary *dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationThirdLoginFailed object:nil userInfo:dicResult];
                
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
    
    API_FOOTER();
}

/*
 注册用户
 <!--请求POST-->
 HTTP_REGISTER
 */
-(void)doRegister:(NSString*)tusername password:(NSString*)tpassword nickname:(NSString*)tnickname source:(SourceType)tsourcetype session:(NSString*)tsession sex:(NSString*)tsex birthday:(NSString*)tbirthday location:(NSString*)tlocation head:(NSString*)thead{
    
    API_HEADER();
    
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
    
    API_FOOTER();
}

-(void)doRegister:(NSString *)tusername password:(NSString *)tpassword nickname:(NSString *)tnickname source:(SourceType)tsourcetype session:(NSString *)tsession sex:(NSString *)tsex {
    
    API_HEADER();
    
    NSString* tbirthday = @"0";
    NSString* tlocation = @"0";
    NSString* thead = @"0";
    
    [self doRegister:tusername password:tpassword nickname:tnickname source:tsourcetype session:tsession sex:tsex birthday:tbirthday location:tlocation head:thead];
    
    API_FOOTER();
}

-(void)doRegister:(NSString*)tusername password:(NSString*)tpassword nickname:(NSString*)tnickname source:(SourceType)tsourcetype {
    
    API_HEADER();
    
    if( SourceTypeMiglab == tsourcetype) {
        
        NSString* sex = @"";
        NSString* tsession = @"";
        tnickname = @"";
        
        [self doRegister:tusername password:tpassword nickname:tnickname source:tsourcetype session:tsession sex:sex];
    }
    
    API_FOOTER();
}

/*
 生成游客信息
 <!--请求Get-->
 HTTP_GUEST
 */
-(void)doGetGuestInfo {
    
    API_HEADER();
    
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
    
    API_FOOTER();
}

/*
 更新用户信息
 <!--请求POST-->
 HTTP_UPDATEUSER
 */
-(void)doUpdateUserInfo:(NSString*)tuid token:(NSString*)ttoken nickname:(NSString*)tnickname gender:(NSString*)tgender birthday:(NSString*)tbirthday {
    
    API_HEADER();
    
    PLog(@"update user information url: %@", HTTP_UPDATEUSER);
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:HTTP_UPDATEUSER]];
    
    NSString* httpBody = [NSString stringWithFormat:@"uid=%@&token=%@&nickname=%@&gender=%@&birthday=%@", tuid, ttoken, tnickname, tgender, tbirthday];
    PLog(@"update user information body: %@", httpBody);
    
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
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
    
    API_FOOTER();
}

-(void)doUpdateUserInfoNickName:(NSString *)tuid token:(NSString *)ttoken nickname:(NSString *)tnickname {
    
    API_HEADER();
    
    NSString* szGender = [NSString stringWithFormat:@"%d", [UserSessionManager GetInstance].currentUser.gender];
    NSString* szBirthday = [UserSessionManager GetInstance].currentUser.birthday;
    
    [self doUpdateUserInfo:tuid token:ttoken nickname:tnickname gender:szGender birthday:szBirthday];
    
    API_FOOTER();
}

-(void)doUpdateUserInfoGender:(NSString *)tuid token:(NSString *)ttoken gender:(NSString *)tgender {
    
    API_HEADER();
    
    NSString* szNickname = [UserSessionManager GetInstance].currentUser.nickname;
    NSString* szBirthday = [UserSessionManager GetInstance].currentUser.birthday;
    
    [self doUpdateUserInfo:tuid token:ttoken nickname:szNickname gender:tgender birthday:szBirthday];
    
    API_FOOTER();
}

-(void)doUpdateUserInfoBirthday:(NSString *)tuid token:(NSString *)ttoken birthday:(NSString *)tbirthday {
    
    API_HEADER();
    
    NSString* szGender = [NSString stringWithFormat:@"%d", [UserSessionManager GetInstance].currentUser.gender];
    NSString* szNickname = [UserSessionManager GetInstance].currentUser.nickname;
    
    [self doUpdateUserInfo:tuid token:ttoken nickname:szNickname gender:szGender birthday:tbirthday];
    
    API_FOOTER();
}

/*
 获取默认推荐歌曲接口
 <!--请求Get-->
 http://open.fm.miglab.com/api/song.fcgi?token=AAOfv3WG35avZspzKhoeodwv2MFd8zYxOUFENUNCMUFBNjgwMDAyRTI2&uid=10001
 */
-(void)doGetDefaultMusic:(NSString *)ttype token:(NSString *)ttoken uid:(int)tuid {
    
    API_HEADER();

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
    
    API_FOOTER();
}

/*
 添加黑名单
 <!--请求POST-->
 HTTP_ADDBLACKLIST
 */
-(void)doHateSong:(NSString*)uid token:(NSString *)ttoken sid:(long)tsid {
    
    API_HEADER();
    
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
    
    API_FOOTER();
}

/*
 赠送歌曲
 <!--请求POST-->
 HTTP_PRESENTMUSIC
 */
-(void)doPresentMusic:(NSString *)uid token:(NSString*)ttoken touid:(NSString *)ttouid sid:(NSArray*)tsid {
    
    API_HEADER();
    
    PLog(@"present music url: %@", HTTP_PRESENTMUSIC);
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:HTTP_PRESENTMUSIC]];
    
    int sendSongCount = [tsid count];
    NSMutableString* mainstring = [[NSMutableString alloc] init];
    
    for (int i=0; i<sendSongCount; i++) {
        
        Song* cursong = [tsid objectAtIndex:i];
        
        NSString* singlesong = [NSString stringWithFormat:@"{\"songid\":\"%lld\",\"msg\":\"%@\"}", cursong.songid, cursong.presentMsg];
        
        if (0 == i) {
            
            [mainstring appendString:singlesong];
        }
        else {
            
            [mainstring appendString:[NSString stringWithFormat:@",%@", singlesong]];
        }
    }
    
    NSString* msg = [NSString stringWithFormat:@"{\"song\":[%@]}", mainstring];
    
    NSString* httpBody = [NSString stringWithFormat:@"uid=%@&token=%@&touid=%@&msg=%@", uid, ttoken, ttouid, msg];
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
    
    API_FOOTER();
}

/*
 分享歌曲
 <!--请求POST-->
 HTTP_SHAREMUSIC
 */
-(void)doShareMusic:(NSString *)uid token:(NSString *)ttoken sid:(long)tsid platform:(int)tplatform{
    
    API_HEADER();
    
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
    
    API_FOOTER();
}

/*
 上传用户本地歌曲信息
 <!--请求POST-->
 HTTP_UPLOADMUSIC
 */
-(void)doUploadMusic:(NSString *)uid token:(NSString *)ttoken sid:(long)tsid enter:(int)tenter urlcode:(int)turlcode content:(long)tcontent{
    
    API_HEADER();
    
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
    
    API_FOOTER();
}


/*
 获取附近用户
 <!--请求GET-->
 HTTP_NEARBYUSER
 */
/*
-(void)doGetNearbyUser:(NSString *)uid token:(NSString *)ttoken page:(int)tpage{
    
    API_HEADER();
    
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
    
    API_FOOTER();
}*/

/*
 获取用户歌单
 <!--请求GET-->
 HTTP_GETUSERLIST
 */
-(void)doGetListFromUser:(NSString *)uid sid:(long)tsid token:(NSString *)ttoken{
    
    API_HEADER();
    
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
    
    API_FOOTER();
}

/*
 根据类别获取弹幕即评论内容
 */

-(void)doGetBarrayComm:(NSString*)uid ttoken:(NSString*)token ttype:(NSString*) type
                  ttid:(NSString*) tid tmsgid:(NSString*) msgid tsongid:(NSString*) songid{
    API_HEADER();
    NSString* url = [NSString stringWithFormat:@"%@?platform=10000&token=%@&uid=%@&ttype=%@&tid=%@&msgid=%@", HTTP_BARRAYCOMM, token, uid, type, tid, msgid];
    PLog(@"BarrayComm url: %@", url);
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        @try {
            
            NSDictionary* dicJson = JSON;
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if(1 == status) {
                
                PLog(@"operation succeeded");
                
                NSDictionary* dicTemp = [dicJson objectForKey:@"result"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationBarryCommSuccess
                        object:nil userInfo:dicTemp];
                
            }
            else {
                
                PLog(@"operation failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationBarryCommFailed object:nil userInfo:dicResult];
                
            }
            
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据信息失败:(";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationBarryCommFailed object:nil userInfo:dicResult];
            
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        PLog(@"failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationBarryCommFailed object:nil userInfo:nil];
        
    }];
    
    [operation start];
    
    API_FOOTER();
}


/*
 获取用户正在听的歌曲
 <!--请求GET-->
 HTTP_GETPLAYINGMUSIC
 */
/*
-(void)doGetPlayingMusicFromUser:(NSString *)uid token:(NSString *)ttoken begin:(int)tbegin page:(int)tpage{
    
    API_HEADER();
    
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
    
    API_FOOTER();
}*/

/*
 获取频道目录
 <!--请求GET-->
 HTTP_GETCHANNEL
 */
-(void)doGetChannel:(NSString*)uid token:(NSString *)ttoken num:(int)tnum {
    
    API_HEADER();
    
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
    
    API_FOOTER();
}

/*
 获取频道歌曲
 <!--请求GET-->
 HTTP_GETCHANNELMUSIC
 */
-(void)doGetMusicFromChannel:(NSString*)uid token:(NSString *)ttoken channel:(int)tchannel {
    
    API_HEADER();
    
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
    
    API_FOOTER();
}

/*
 获取心情词描述
 <!--请求GET-->
 HTTP_MODESCENE
 */
-(void)doGetWorkOfMood:(NSString*)uid token:(NSString*)ttoken{
    
    API_HEADER();
    
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
    
    API_FOOTER();
}

/*
 获取场景词描述
 <!--请求GET-->
 HTTP_MOODSCENE
 */
-(void)doGetWorkOfScene:(NSString*)uid token:(NSString*)ttoken{
    
    API_HEADER();
    
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
    
    API_FOOTER();
}

/*
 获取心情，场景歌曲
 <!--请求GET-->
 HTTP_MODEMUSIC
 */
-(void)doGetModeMusic:(NSString*)uid token:(NSString *)ttoken wordid:(NSString *)twordid mood:(NSString *)tmood num:(int)tnum{
    
    API_HEADER();
    
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
    
    API_FOOTER();
}

-(void)doGetModeMusic:(NSString *)uid token:(NSString *)ttoken wordid:(NSString *)twordid mood:(NSString *)tmood{
    
    API_HEADER();
    
    [self doGetModeMusic:uid token:ttoken wordid:twordid mood:tmood num:10];
    
    API_FOOTER();
}

/*
 获取心绪地图
 <!--请求GET-->
 HTTP_MODEMAP
 */
-(void)doGetMoodMap:(NSString *)uid token:(NSString *)ttoken{
    
    API_HEADER();
    
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
    
    API_FOOTER();
}

/*
 获取心绪类别名称
 <!--请求GET-->
 HTTP_MOODPARENT
 */
-(void)doGetMoodParent:(NSString *)uid token:(NSString *)ttoken{
    
    API_HEADER();
    
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
    
    API_FOOTER();
}

/*
 提交用户当前状态
 <!--请求POST-->
 HTTP_ADDMOODRECORD
 */
-(void)doAddMoodRecord:(NSString*)uid token:(NSString*)ttoken wordid:(int)twordid songid:(long long)tsongid{
    
    API_HEADER();
    
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
    
    API_FOOTER();
}

/*
 设置用户位置 (2013-7-22)
 HTTP_SETUSERPOS
 POST
 */
-(void)doSetUserPos:(NSString*)uid token:(NSString*)ttoken location:(NSString *)tlocation{
    
    API_HEADER();
    
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
    
    API_FOOTER();
}

/*
 查找附近的人 (2013-7-22)
 HTTP_SEARCHNEARBY
 GET
 */
-(void)doSearchNearby:(NSString*)uid token:(NSString*)ttoken location:(NSString *)tlocation radius:(int)tradius {
    
    API_HEADER();
    
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
 
    API_FOOTER();
}

/*
 非注册用户获取播放列表（2013-08－17）
 */
-(void)doGetDefaultGuestSongs{
    
    API_HEADER();
    
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
    
    API_FOOTER();
}

/*
 获取收藏的歌曲
 <!--请求GET-->
 HTTP_CLTSONGS
 */
-(void)doGetCollectedSongs:(NSString *)uid token:(NSString *)ttoken taruid:(NSString*)ttaruid {
    
    API_HEADER();
    
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
    
    API_FOOTER();
}

/*
 获取豆瓣的频道歌曲
 <!--请求GET-->
 HTTP_GETDBCHANNELSONG
 */
-(void)doGetDoubanChannelSong:(NSString*)uid token:(NSString*)ttoken channel:(NSString*)tchannel {
    
    API_HEADER();
    
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
    
    API_FOOTER();
}

-(void)doGetDimensions:(NSString*)uid token:(NSString*)ttoken typeid:(NSString *)ttypeid typeindex:(NSString *)ttypeindex moodid:(NSString*)tmoodid moodindex:(NSString*)tmoodindex sceneid:(NSString*)tsceneid sceneindex:(NSString*)tsceneindex channelid:(NSString*)tchannelid channelindex:(NSString*)tchannelindex num:(NSString*)tnum{
    API_HEADER();
    
    NSString* url = [NSString stringWithFormat:@"%@?uid=%@&token=%@&typeid=%@&typeindex=%@&moodid=%@&moodindex=%@&sceneid=%@&sceneindex=%@&channelid=%@&channelindex=%@&num=%@", HTTP_GETDIMENSION, uid, ttoken, ttypeid, ttypeindex, tmoodid, tmoodindex, tsceneid, tsceneindex, tchannelid, tchannelindex, tnum];
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
    
    API_FOOTER();
}
/*
 通过整体纬度获取音乐
 <!--请求GET-->
 HTTP_GETTYPESONGS
 */
-(void)doGetTypeSongs:(NSString*)uid token:(NSString*)ttoken typeid:(NSString *)ttypeid typeindex:(NSString *)ttypeindex moodid:(NSString *)tmoodid moodindex:(NSString *)tmoodindex sceneid:(NSString *)tsceneid sceneindex:(NSString *)tsceneindex channelid:(NSString *)tchannelid channelindex:(NSString *)tchannelindex num:(NSString *)tnum{
    
    API_HEADER();
    
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
    
    API_FOOTER();
}

/*
 提交本地歌曲信息(2013-08-19)
 <!--请求POST-->
 HTTP_RECORDLOCALSONGS
 */
-(void)doRecordLocalSongs:(NSString*)uid token:(NSString*)ttoken source:(NSString*)tsource urlcode:(NSString*)turlcode name:(NSString*)tname content:(NSString*)tcontent {
    
    API_HEADER();
    
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
    
    API_FOOTER();
}

-(void)doRecordLocalSongsSingle:(NSString *)uid token:(NSString *)ttoken source:(NSString *)tsource urlcode:(NSString *)turlcode name:(NSString *)tname song:(Song *)tsong {
    
    API_HEADER();
    
    if(tsong != nil) {
        
        NSString* songcontent = [NSString stringWithFormat:@"{\"music\":[{\"name\":\"%@\",\"singer\":\"%@\"}]}", tsong.songname, tsong.artist];

        PLog(@"do record local song single: %@", songcontent);
        
        [self doRecordLocalSongs:uid token:ttoken source:tsource urlcode:turlcode name:tname content:songcontent];
    }
    
    API_FOOTER();
}

-(void)doRecordLocalSongsArray:(NSString *)uid token:(NSString *)ttoken source:(NSString *)tsource urlcode:(NSString *)turlcode name:(NSString *)tname songs:(NSArray *)tsongs {
    
    API_HEADER();
    
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
    
    API_FOOTER();
}

/*
 获取推送消息
 <!--请求GET-->
 HTTP_GETPUSHMSG
 */
-(void)doGetPushMsg:(NSString*)uid token:(NSString*)ttoken pageindex:(NSString*)tpageindex pagesize:(NSString*)tpagesize {
    
    API_HEADER();
    
    NSString* url = [NSString stringWithFormat:@"%@?uid=%@&token=%@&page_index=%@&page_size=%@", HTTP_GETPUSHMSG, uid, ttoken, tpageindex, tpagesize];
    PLog(@"get push message url: %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if (1 == status) {
                
                PLog(@"get push message operation succeeded");
                
                NSArray* infoArray = [dicJson objectForKey:@"result"];
                int infoArrayCount = [infoArray count];
                
                NSMutableArray* infoList = [[NSMutableArray alloc] init];
                
                for (int i=0; i<infoArrayCount; i++) {
                    
                    MessageInfo* msginfo = [MessageInfo initWithNSDictionary:[infoArray objectAtIndex:i]];
                    
                    [infoList addObject:msginfo];
                }
                
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:infoList, @"result", nil];
        
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetPushMsgSuccess object:nil userInfo:dicResult];
                
            }
            else {
                
                PLog(@"get push message operation failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetPushMsgFailed object:nil userInfo:dicResult];
            }
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据失败";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetPushMsgFailed object:nil userInfo:dicResult];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"get push message failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetPushMsgFailed object:nil userInfo:nil];
    }];
    
    [operation start];
    
    API_FOOTER();
}

/*
 更新音乐纬度配置文件
 <!--请求GET-->
 HTTP_UPDATECONFIGFILE
 */
-(void)doUpdateConfigfile:(NSString*)uid token:(NSString*)ttoken version:(NSString*)tversion {
    
    API_HEADER();
    
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
    
    API_FOOTER();
}

/*
 记录用户试听歌曲状态
 <!--请求POST-->
 HTTP_RECORDCURSONG
 */
-(void)doRecordCurrentSong:(NSString*)uid token:(NSString*)ttoken lastsong:(NSString*)tlastsong cursong:(NSString*)tcursong mode:(NSString*)tmode typeid:(NSString*)ttypeid name:(NSString*)tname singer:(NSString*)tsinger state:(NSString*)tstate {
    
    API_HEADER();
    
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
                
                NSDictionary* dicTemp = [dicJson objectForKey:@"result"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:dicTemp, @"result", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameRecordCurSongSuccess object:nil userInfo:dicResult];
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
    
    API_FOOTER();
}

/*
 添加红心歌曲
 <!--POST-->
 HTTP_COLLECTSONG
 */
-(void)doCollectSong:(NSString*)uid token:(NSString*)ttoken sid:(NSString*)tsid modetype:(NSString*)tmodetype typeid:(NSString*)ttypeid {
    
    API_HEADER();
    
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
    
    API_FOOTER();
}

/*
 拉黑歌曲
 <!--请求POST-->
 HTTP_HATESONG
 */
-(void)doAddHateSong:(NSString*)uid token:(NSString*)ttoken sid:(NSString*)tsid {
    
    API_HEADER();
    
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
    
    API_FOOTER();
}

/*
 获取收藏歌曲数量和附近人收藏数量
 <!--GET-->
 HTTP_COLLECTANDNEARNUM
 */
-(void)doCollectAndNearNum:(NSString*)uid token:(NSString*)ttoken taruid:(NSString*)ttaruid radius:(NSString*)tradius pageindex:(NSString*)tpageindex pagesize:(NSString*)tpagesize location:(NSString*)tlocation {
    
    API_HEADER();
    
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
    
    API_FOOTER();
}

/*
 删除收藏歌曲
 POST
 HTTP_DELETECOLLECTSONG
 */
-(void)doDeleteCollectedSong:(NSString*)uid token:(NSString *)ttoken songid:(NSString*)tsongid {
    
    API_HEADER();
    
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
    
    API_FOOTER();
}

/*
 获取歌曲信息
 GET
 HTTP_GETSONGINFO
 */
-(void)doGetSongInfo:(NSString*)uid token:(NSString*)ttoken songid:(NSString*)tsongid {
    
    API_HEADER();
    
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
    
    API_FOOTER();
}

/*
 附近人的音乐
 GET
 HTTP_GETNEARMUSIC
 */
-(void)doGetNearMusic:(NSString*)uid token:(NSString*)ttoken radius:(NSString*)tradius pageindex:(NSString*)tpageindex pagesize:(NSString*)tpagesize latitude:(NSString*)tlatitude longitude:(NSString*)tlongitude{
    
    API_HEADER();
    
    NSString* url = [NSString stringWithFormat:@"%@?uid=%@&token=%@&radius=%@&page_index=%@&page_size=%@&latitude=%@&longitude=%@", HTTP_NEARMUSC, uid, ttoken, tradius, tpageindex, tpagesize, tlatitude,tlongitude];
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
                    
                    MessageInfo* nms = [MessageInfo initWithNSDictionary:[nearmusicstate objectAtIndex:i]];
                    
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
    
    API_FOOTER();
}

/*
 评论歌曲
 POST
 HTTP_COMMENTSONG //评论添加当前歌曲类别 和类别ID
 */
-(void) doCommentSong:(NSString*)uid token:(NSString*)ttoken songid:(NSString*)tsongid ttype:(NSString*)type ttypeid:(NSString*) tid comment:(NSString*)tcomment{
    API_HEADER();
    
    PLog(@"comment song url: %@", HTTP_COMMENTSONG);
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:HTTP_COMMENTSONG]];
    
    NSString* httpBody = [NSString stringWithFormat:@"uid=%@&token=%@&songid=%@&comment=%@&type=%@&tid=%@", uid, ttoken, tsongid, tcomment,type,tid];
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
    
    API_FOOTER();
}
/*
 评论歌曲
 POST
 HTTP_COMMENTSONG
 */
-(void)doCommentSong:(NSString*)uid token:(NSString*)ttoken songid:(NSString*)tsongid comment:(NSString*)tcomment {
    
    API_HEADER();

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
    
    API_FOOTER();
}

/*
 获取歌曲评论
 GET
 HTTP_GETCOMMENT
 */
-(void)doGetSongComment:(NSString*)uid token:(NSString*)ttoken songid:(NSString*)tsongid count:(NSString*)tcount fromid:(NSString*)tfromid {
    
    API_HEADER();
    
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
                int totlesize = [[dicJson objectForKey:@"size"] intValue];
                int commentcount = 0;
                NSMutableArray* commentInfo = [[NSMutableArray alloc] init];
                
                if (totlesize > 0) {
                    
                    NSString* tsongid = [dicTemp objectForKey:@"songid"];
                    
                    NSArray* comments = [dicTemp objectForKey:@"comments"];
                    commentcount = [comments count];
                    
                    for (int i=0; i<commentcount; i++) {
                        
                        SongComment* sc = [SongComment initWithNSDictionary:[comments objectAtIndex:i]];
                        sc.songid = tsongid;
                        
                        [commentInfo addObject:sc];
                    }
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
    
    API_FOOTER();
}

/*
 获取周围谁在听你的歌
 获取周围的消息
 GET
 HTTP_GETMYNEARMUSICMSGNUM
 */
-(void)doGetMyNearMusicMsgNumber:(NSString *)uid token:(NSString *)ttoken radius:(NSString *)tradius location:(NSString *)tlocation {
    
    API_HEADER();
    
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
                
                NSDictionary* dicres = [dicJson objectForKey:@"result"];
                
                NSString* fri_num = [dicres objectForKey:@"fri_num"];
                NSString* music_num = [dicres objectForKey:@"music_num"];
                NSString* near_num = [dicres objectForKey:@"near_num"];
                NSString* msg_num = [dicres objectForKey:@"msg_num"];
                NSString* new_msg_num = [dicres objectForKey:@"new_msg_num"];
                
                NSMutableArray* numarray = [[NSMutableArray alloc] init];
                [numarray addObject:fri_num];
                [numarray addObject:music_num];
                [numarray addObject:near_num];
                [numarray addObject:msg_num];
                [numarray addObject:new_msg_num];
                
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
    
    API_FOOTER();
}

/*
 获取周围谁在听你红心的歌曲
 GET
 HTTP_GETSAMEMUSIC
 */
-(void)doGetSameMusic:(NSString *)uid token:(NSString *)ttoken radius:(NSString *)tradius location:(NSString *)tlocation {
    
    API_HEADER();
    
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
                    
                    MessageInfo* nms = [MessageInfo initWithNSDictionary:[musicarray objectAtIndex:i]];
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
    
    API_FOOTER();
}

/*
 获取周围歌友
 GET
 HTTP_GETNEARUSER
 */
-(void)doGetNearUser:(NSString *)uid token:(NSString *)ttoken radius:(NSString *)tradius latitude:(NSString*)tlatitude longitude:(NSString*)tlongitude; {
    
    API_HEADER();
    
    NSString* url = [NSString stringWithFormat:@"%@?uid=%@&token=%@&radius=%@&latitude=%@&longitude=%@", HTTP_GETNEARUSER, uid, ttoken, tradius, tlatitude,tlongitude];
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
                    
                    MessageInfo* nms = [MessageInfo initWithNSDictionary:[musicarray objectAtIndex:i]];
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
    
    API_FOOTER();
}

/*
 获取用户听歌记录
 HTTP_GETSONGHISTORY
 GET
 */
-(void)doGetSongHistory:(NSString *)uid token:(NSString *)ttoken fromid:(NSString *)tfromid count:(NSString *)tcount {
    
    API_HEADER();
    
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
    
    API_FOOTER();
}

/*
 打招呼
 HTTP_SAYHELLO
 POST
 */
-(void)doSayHello:(NSString *)uid token:(NSString *)ttoken touid:(NSString *)ttouid msg:(NSString *)tmsg {
    
    API_HEADER();
    
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
    
    API_FOOTER();
}

/*
 获取歌友
 GET
 HTTP_GETMUSICUSER
 */
-(void)doGetMusicUser:(NSString *)uid token:(NSString *)ttoken fromid:(NSString *)tfromid count:(NSString *)tcount {
    
    API_HEADER();
    
    NSString* url = [NSString stringWithFormat:@"%@?uid=%@&token=%@&fromid=%@&count=%@", HTTP_GETMUSICUSER, uid, ttoken, tfromid, tcount];
    PLog(@"get music user url: %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if (1 == status) {
                
                PLog(@"get music user opration succeeded");
                
                NSDictionary* dicTemp = [dicJson objectForKey:@"result"];
                NSArray* userArray = [dicTemp objectForKey:@"list"];
                int userArrayCount = [userArray count];
                
                NSMutableArray* userList = [[NSMutableArray alloc] init];
                
                for (int i=0; i<userArrayCount; i++) {
                    
                    MessageInfo* nms = [MessageInfo initWithNSDictionary:[userArray objectAtIndex:i]];
                    
                    [userList addObject:nms];
                }
                
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:userList, @"result", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetMusicUserSuccess object:nil userInfo:dicResult];
            }
            else {
                
                PLog(@"get music user opration failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetMusicUserFailed object:nil userInfo:dicResult];
            }
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据失败";
            
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetMusicUserFailed object:nil userInfo:dicResult];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"get music user failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetMusicUserFailed object:nil userInfo:nil];
    }];
    
    [operation start];
    
    API_FOOTER();
}

/*
 设置推送配置
 POST
 HTTP_CONFIGPUSH
 */
-(void)doConfigPush:(NSString *)uid token:(NSString *)ttoken devicetoken:(NSString *)tdevicetoken isreceive:(NSString *)tisreceive begintime:(NSString *)tbegintime endtime:(NSString *)tendtime {
    
    API_HEADER();
    
    PLog(@"config user push url: %@", HTTP_CONFIGPUSH);
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:HTTP_CONFIGPUSH]];
    
    NSString* httpBody = [NSString stringWithFormat:@"uid=%@&token=%@&devicetoken=%@&isreceive=%@&begintime=%@&endtime=%@", uid, ttoken, tdevicetoken, tisreceive, tbegintime, tendtime];
    PLog(@"config user push body: %@", httpBody);
    
    NSMutableURLRequest* request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if(1 == status) {
                
                PLog(@"config user push succeed");
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameConfigPushSuccess object:nil userInfo:nil];
            }
            else {
                
                PLog(@"config user push failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameConfigPushFailed object:nil userInfo:dicResult];
            }
        }
        @catch (NSException *exception) {
            
            NSString* msg = @"解析返回数据失败";
            NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameConfigPushFailed object:nil userInfo:dicResult];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"config user push failure: %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameConfigPushFailed object:nil userInfo:nil];
    }];
    
    [operation start];
    
    API_FOOTER();
}

/*
 获取歌词分享信息
 GET
 HTTP_GETSHAREINFO
 */
-(void)doGetShareInfo:(NSString *)uid token:(NSString *)ttoken songid:(NSString *)tsongid type:(NSString *)ttype mode:(NSString *)tmode index:(NSString *)tindex latitude:(NSString *)tlatitude longitude:(NSString *)tlongitude {
    
    API_HEADER();
    
    NSString* url = [NSString stringWithFormat:@"%@?uid=%@&token=%@&songid=%@&stype=%@&mode=%@&index=%@&latitude=%@&longitude=%@", HTTP_GETSHAREINFO, uid, ttoken, tsongid, ttype, tmode, tindex, tlatitude, tlongitude];
    PLog(@"get share info url : %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if (1 == status) {
                
                PLog(@"get share info succeed");
                
                NSDictionary* dicTemp = [dicJson objectForKey:@"result"];
                
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:dicTemp, @"result", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetShareInfoSuccess object:nil userInfo:dicResult];
            }
            else {
                
                PLog(@"get share info failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetShareInfoFailed object:nil userInfo:dicResult];
            }
        }
        @catch (NSException *exception) {
            
            PLog(@"解析返回数据失败%s", __FUNCTION__);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetShareInfoFailed object:nil userInfo:nil];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"get share info failed : %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetShareInfoFailed object:nil userInfo:nil];
    }];
    
    [operation start];
    
    API_FOOTER();
}

/*
 获取最空闲的聊天地址
 
 */
/*
-(void) doGetSC:(int64_t)platformid uid:(int64_t)tuid  tid:(int64_t) ttid{
    API_HEADER();
    NSString* url = [NSString stringWithFormat:@"%@?platformd=%lld&uid=%lld&tid=%lld",
                HTTP_GETSC,platformid,tuid,ttid];
    PLog(@"get SC info url:%@",url);
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if (1 == status) {
                
                PLog(@"get sc info succeed");
                
                NSDictionary* dicTemp = [dicJson objectForKey:@"result"];
                
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:dicTemp, @"result", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetSCSuccess object:nil userInfo:dicResult];
            }
            else {
                
                PLog(@"get sc info failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetSCFailed object:nil userInfo:dicResult];
            }
        }
        @catch (NSException *exception) {
            
            PLog(@"解析返回数据失败%s", __FUNCTION__);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetSCFailed object:nil userInfo:nil];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"get sc info failed : %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetShareInfoFailed object:nil userInfo:nil];
    }];
    
    [operation start];
    
    API_FOOTER();
}
*/

/*
 获取聊天记录
 
 */
/*
-(void) doGetHisChat:(int64_t)platformid uid:(int64_t) tuid  tid:(int64_t) ttid token:(NSString*)ttoken minmsgid:(int64_t) tminmsgid{
    API_HEADER();
    NSString* url = [NSString stringWithFormat:@"%@?platformid=%lld&uid=%lld&tid=%lld&token=%@&msgid=%lld",
                     HTTP_GETSC,platformid,tuid,ttid,ttoken,tminmsgid];
    PLog(@"get hischat info url:%@",url);
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if (1 == status) {
                
                PLog(@"get hischat  succeed");
                
                NSDictionary* dicTemp = [dicJson objectForKey:@"result"];
                
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:dicTemp, @"result", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameHisChatSuccess object:nil userInfo:dicResult];
            }
            else {
                
                PLog(@"get hischat failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameHisChatFailed object:nil userInfo:dicResult];
            }
        }
        @catch (NSException *exception) {
            
            PLog(@"解析返回数据失败%s", __FUNCTION__);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGetShareInfoFailed object:nil userInfo:nil];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"get hischat failed : %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameHisChatFailed object:nil userInfo:nil];
    }];
    
    [operation start];
    
    API_FOOTER();
}
*/
/*
 发送分享结果
 */
-(void)doSendShareResult:(NSString*)uid token:(NSString*)ttoken plat:(NSString *)share_plat songid:(NSString*)tsongid {
    
    API_HEADER();
    
    NSString *url = [NSString stringWithFormat:@"%@?uid=%@&token=%@&share_plat=%@&songid=%@", HTTP_SENDSHARERESULT, uid, ttoken, share_plat, tsongid];
    PLog(@"send share result url: %@", url);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            
            int status = [[dicJson objectForKey:@"result"] intValue];
            
            if (1 == status) {
                
                PLog(@"send share result succeeded");
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSendShareResultSuccess object:nil userInfo:nil];
            }
            else {
                
                PLog(@"send share result failed");
                
                NSString *msg = [dicJson objectForKey:@"msg"];
                NSDictionary *dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSendShareResultFailed object:nil userInfo:dicResult];
            }
        }
        @catch (NSException *exception) {
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString* msg = @"解析返回数据失败";
        NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSendShareResultFailed object:nil userInfo:dicResult];
    }];
    
    [operation start];
    
    API_FOOTER();
}


-(void)doSendBPushInfo:(NSString*)uid token:(NSString*)ttoken channelid:(NSString*)tchannelid userid:(NSString*)tuserid tag:(NSString*)ttag pkg:(NSString*)tpkg machine:(NSString*) tmachine appid:(NSString*) tappid requestid:(NSString*) trequestid {
    
    API_HEADER();
    
    PLog(@"send bpush info url: %@", HTTP_SENDBPUSHINFO);
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:HTTP_SENDBPUSHINFO]];
    
    NSString *httpBody = [NSString stringWithFormat:@"platform=10000&uid=%@&token=%@&channel=%@&userid=%@&tag=%@&pkg_name=%@&machine=%@&appid=%@&requestid=%@", uid, ttoken, tchannelid, tuserid, ttag, tpkg,tmachine,tappid,trequestid];
    PLog(@"send bpush info body: %@", httpBody);
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if (status == 1) {
                
                PLog(@"send pbush info succeeded");
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSendBPushInfoSuccess object:nil userInfo:nil];
            }
            else {
                
                PLog(@"send pbush info failed");
                NSString *msg = [dicJson objectForKey:@"msg"];
                NSDictionary *dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSendBPushInfoFailed object:nil userInfo:dicResult];
            }
        }
        @catch (NSException *exception) {
            
            PLog(@"send pbush info failed");
            NSString *msg = @"解析返回数据失败";
            NSDictionary *dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSendBPushInfoFailed object:nil userInfo:dicResult];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"send pbush info failed");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSendBPushInfoFailed object:nil userInfo:nil];
    }];
    
    [operation start];
    
    API_FOOTER();
}

-(void)doGetLocation:(NSString*)uid ttoken:(NSString*) token tlatitude:(NSString*)latitude tlongitude:(NSString*)longitude{
    API_HEADER();
    
    //测试暂时不提交坐标
    //NSString* url = [NSString stringWithFormat:@"%@uid=%@&token=%@&latitude=%@&longitude=%@", HTTP_LOCATIONINFO, uid, token,latitude, longitude];
    NSString* url = [NSString stringWithFormat:@"%@?uid=%@&token=%@", HTTP_LOCATIONINFO, uid, token];
    PLog(@"get share info url : %@", url);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary* dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if (1 == status) {
                
                PLog(@"get share info succeed");
                
                NSDictionary* dicTemp = [dicJson objectForKey:@"result"];
                
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:dicTemp, @"result", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameLocationSuccess object:nil userInfo:dicResult];
            }
            else {
                
                PLog(@"get share info failed");
                
                NSString* msg = [dicJson objectForKey:@"msg"];
                NSDictionary* dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameLocationFailed object:nil userInfo:dicResult];
            }
        }
        @catch (NSException *exception) {
            
            PLog(@"解析返回数据失败%s", __FUNCTION__);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameLocationFailed object:nil userInfo:nil];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"get share info failed : %@", error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameLocationFailed object:nil userInfo:nil];
    }];
    
    [operation start];
    
    API_FOOTER();

}

-(void) doLoginRecord:(NSString*)uid ttoken:(NSString*) token latitude:(NSString*)tlatitude longitude:(NSString*)tlongitude{
    
    API_HEADER();
    PLog(@"login record url: %@", HTTP_LOGINRECORD);
    
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:HTTP_LOGINRECORD]];
    
    NSString *httpBody = [NSString stringWithFormat:@"uid=%@&token=%@&latitude=%@&longitude=%@", uid, token, tlatitude, tlongitude];
    PLog(@"login record info body: %@", httpBody);
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:nil parameters:nil];
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            
            NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:nil error:nil];
            int status = [[dicJson objectForKey:@"status"] intValue];
            
            if (status == 1) {
                
                PLog(@"send pbush info succeeded");
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameLogiReocrdSuccess object:nil userInfo:dicJson];
            }
            else {
                
                PLog(@"send pbush info failed");
                NSString *msg = [dicJson objectForKey:@"msg"];
                NSDictionary *dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameLogiReocrdFailed object:nil userInfo:dicResult];
            }
        }
        @catch (NSException *exception) {
            
            PLog(@"send pbush info failed");
            NSString *msg = @"解析返回数据失败";
            NSDictionary *dicResult = [NSDictionary dictionaryWithObjectsAndKeys:msg, @"msg", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSendBPushInfoFailed object:nil userInfo:dicResult];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PLog(@"send pbush info failed");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSendBPushInfoFailed object:nil userInfo:nil];
    }];
    
    [operation start];

     API_FOOTER();
}


@end
