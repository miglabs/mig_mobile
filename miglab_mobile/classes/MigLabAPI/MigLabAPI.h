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

/************************* 用户 ****************************/

/*
 SSO的登录
 http://sso.miglab.com/cgi-bin/sp.fcgi?sp
 */
-(void)doAuthLogin:(NSString *)tusername password:(NSString *)tpassword;
-(void)doSsoLoginFirst:(NSString *)tusername password:(NSString *)tpassword;
-(void)doSsoLoginSecond:(NSString *)ssoSecondUrl param:(NSString *)strParam;
-(void)doSsoLoginThird:(NSString *)ssoThirdUrl param:(NSString *)strParam;

/*
 获取用户信息
 */
-(void)doGetUserInfo:(NSString *)tUserName accessToken:(NSString *)tAccessToken;

/*
 注册用户信息
 */
-(void)doRegister:(NSString*)tusername password:(NSString*)tpassword nickname:(NSString*)tnickname source:(int)tsource;

/*
 生成游客信息
 */
-(void)doGetGuestInfo;

/*
 更新用户信息
 */
-(void)doUpdateUserInfo:(NSString*)tuid token:(NSString*)ttoken username:(NSString*)tusername nickname:(NSString*)tnickname gender:(NSString*)tgender birthday:(NSString*)tbirthday location:(NSString*)tlocation source:(NSString*)tsource head:(NSString*)thead;


/************************* 歌曲 ****************************/

/*
 获取默认推荐歌曲歌曲
 */
-(void)doGetDefaultMusic:(NSString*)ttype token:(NSString*)ttoken uid:(int)tuid;

/*
 收藏歌曲
 */
-(void)doAddFavorite:(NSString*)ttoken uid:(int)tuid sid:(long)tsid;

/*
 歌曲拉黑
 */
-(void)doAddBlacklist:(NSString*)ttoken uid:(int)tuid sid:(long)tsid;

/*
 赠送歌曲
 */
-(void)doPresentMusic:(int)senduid touid:(int)ttouid token:(NSString*)ttoken sid:(long)tsid;


@end
