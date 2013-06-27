//
//  MigLabConfig.h
//  miglab_mobile
//
//  Created by pig on 13-6-23.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#ifndef miglab_mobile_MigLabConfig_h
#define miglab_mobile_MigLabConfig_h

/*
 * 用于切换不同域名地址
 */
#define IS_DEBUG_SERVER 1

#if (0 == IS_DEBUG_SERVER)

#define HTTP_DOMAIN                                         @"http://www/i.aspx"

#elif (1 == IS_DEBUG_SERVER)

#define LOGIN_SSO_SP                                        @"http://sso.miglab.com/cgi-bin/sp.fcgi?sp"

#define HTTP_DOMAIN                                         @"http://www./i.aspx"

#endif


#define NotificationNameDownloadFailed                      @"NotificationNameDownloadFailed"


#endif
