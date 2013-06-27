//
//  MigLabAPI.h
//  miglab_mobile
//
//  Created by pig on 13-6-23.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MigLabAPI : NSObject

/*
 hosts:
 
 60.191.220.135   sso.miglab.com
 60.191.220.135   fm.miglab.com
 */

/*
 SSO的登录接口
 http://sso.miglab.com/cgi-bin/sp.fcgi?sp
 */
+(void)doSsoLoginFirst;
+(void)doSsoLoginSecond:(NSString *)ssoSecondUrl param:(NSString *)strParam;
+(void)doSsoLoginThird:(NSString *)ssoSecondUrl param:(NSString *)strParam;

@end
