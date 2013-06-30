//
//  MigLabConfig.h
//  miglab_mobile
//
//  Created by pig on 13-6-23.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#ifndef miglab_mobile_MigLabConfig_h
#define miglab_mobile_MigLabConfig_h

#ifdef DEBUG
#define PLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define PLog(format, ...)
#endif

/*
 * 用于切换不同域名地址
 */
#define IS_DEBUG_SERVER 1

#if (0 == IS_DEBUG_SERVER)

#define HTTP_DOMAIN                                         @"http://www/i.aspx"

#elif (1 == IS_DEBUG_SERVER)

//登陆第一次验证地址
#define LOGIN_SSO_SP_URL                                    @"http://sso.miglab.com/cgi-bin/sp.fcgi?sp"
//获取用户信息
#define GET_USER_INFO                                       @"http://open.fm.miglab.com/api/userinfo.fcgi"

//#define GET_USER_ID                                         @"http://fm.miglab.com/cgi-bin/getid.fcgi"

#define HTTP_DOMAIN                                         @"http://www./i.aspx"

#endif

//登陆
//用户名为空
#define NotificationNameUsernameIsNull                      @"NotificationNameUsernameIsNull"
//密码为空
#define NotificationNamePasswordIsNull                      @"NotificationNamePasswordIsNull"
//登陆授权失败
#define NotificationNameLoginFailed                         @"NotificationNameLoginFailed"
//登陆成功
#define NotificationNameLoginSuccess                        @"NotificationNameLoginSuccess"

//获取用户信息
#define NotificationNameGetUserIdSuccess                    @"NotificationNameGetUserIdSuccess"
#define NotificationNameGetUserIdFailed                     @"NotificationNameGetUserIdFailed"


//下载失败
#define NotificationNameDownloadFailed                      @"NotificationNameDownloadFailed"
//下载进度
#define NotificationNameDownloadProcess                     @"NotificationNameDownloadProcess"
//下载成功
#define NotificationNameDownloadSuccess                     @"NotificationNameDownloadSuccess"


//注册
#define HTTP_REGISTER                                       @"http://open.fm.miglab.com/api/regedit.fcgi"

#endif
