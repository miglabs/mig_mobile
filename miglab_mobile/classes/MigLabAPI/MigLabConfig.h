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

#define SINA_WEIBO_APP_KEY                  @"1468499793"
#define SINA_WEIBO_APP_SECRET               @"ce6dd4ab9ae4f14aa7982a43453cc173"
#define SINA_WEIBO_APP_REDIRECTURI          @"https://api.weibo.com/oauth2/default.html"

#define AES256_SECRET                       @"ce6dd4ab9ae4f14aa7982a43453cc173"

/*
 * 用于切换不同域名地址
 */
#define IS_DEBUG_SERVER 1

#if (0 == IS_DEBUG_SERVER)

#define HTTP_DOMAIN                                         @"http://open.fm.miglab.com/"
#define HTTP_API_DOMAIN                                     @"http://open.fm.miglab.com/"

#elif (1 == IS_DEBUG_SERVER)

#define HTTP_DOMAIN                                         @"http://42.121.14.108/"
#define HTTP_API_DOMAIN                                     @"http://42.121.14.108/"

#endif

//登陆
//登陆第一次验证地址
#define LOGIN_SSO_SP_URL                                    @"http://sso.miglab.com/cgi-bin/sp.fcgi?sp"
//用户名为空
#define NotificationNameUsernameIsNull                      @"NotificationNameUsernameIsNull"
//密码为空
#define NotificationNamePasswordIsNull                      @"NotificationNamePasswordIsNull"
//登陆授权失败
#define NotificationNameLoginFailed                         @"NotificationNameLoginFailed"
//登陆成功
#define NotificationNameLoginSuccess                        @"NotificationNameLoginSuccess"

//获取用户信息
#define GET_USER_INFO                                       [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/userinfo.fcgi"]
#define NotificationNameGetUserInfoSuccess                  @"NotificationNameGetUserInfoSuccess"
#define NotificationNameGetUserInfoFailed                   @"NotificationNameGetUserInfoFailed"


//注册
#define HTTP_REGISTER                                       [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/regedit.fcgi"]
#define NotificationNameRegisterSuccess                     @"NotificationNameRegisterSuccess"
#define NotificationNameRegisterFailed                      @"NotificationNameRegisterFailed"

//游客信息
#define HTTP_GUEST                                          [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/guest.fcgi"]
#define NotificationNameGetGuestSuccess                     @"NotificationNameGetGuestSuccess"
#define NotificationNameGetGuestFailed                      @"NotificationNameGetGuestFailed"

//更新用户信息
#define HTTP_UPDATEUSER                                     [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/usrupdate.fcgi"]
#define NotificationUpdateUserSuccess                       @"NotificationUpdateUserSuccess"
#define NotificationUpdateUserFailed                        @"NotificationUpdateUserFailed"

//默认推荐歌曲
#define HTTP_DEFAULTMUSIC                                   [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"api/song.fcgi?token=AAOfv3WG35avZspzKhoeodwv2MFd8zYxOUFENUNCMUFBNjgwMDAyRTI2&uid=10001"]
#define NotificationNameGetDefaultMusicSuccess              @"NotificationNameGetDefaultMusicSuccess"
#define NotificationNameGetDefaultMusicFailed               @"NotificationNameGetDefaultMusicFailed"

//添加收藏
#define HTTP_ADDFAVORITE                                    [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"api/collectsong.fcgi"]
#define NotificationNameAddFavoriteSuccess                  @"NotificationNameAddFavoriteSuccess"
#define NotificationNameAddFavoriteFailed                   @"NotificationNameAddFavoriteFailed"

//添加黑名单
#define HTTP_ADDBLACKLIST                                   [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"api/hatsong.fcgi"]
#define NotificationNameAddBlacklistSuccess                 @"NotificationNameAddBlacklistSuccess"
#define NotificationNameAddBlacklistFailed                  @"NotificationNameAddBlacklistFailed"

//赠送歌曲
#define HTTP_PRESENTMUSIC                                   [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"api/sendsong.fcgi"]
#define NotificationNamePresentMusicSuccess                 @"NotificationNamePresentMusicSuccess"
#define NotificationNamePresentMusicFailed                  @"NotificationNamePresentMusicFailed"

//分享歌曲
#define HTTP_SHAREMUSIC                                     [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"api/sharesong.fcgi"]
#define NotificationNameShareMusicSuccess                   @"NotificationNameShareMusicSuccess"
#define NotificationNameShareMusicFailed                    @"NotificationNameShareMusicFailed"

//上传用户本地歌曲信息
#define HTTP_UPLOADMUSIC                                    [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"api/updatesong.fcgi"]
#define NotificationNameUploadMusicSuccess                  @"NotificationNameUploadMusicSuccess"
#define NotificationNameUploadMusicFailed                   @"NotificationNameUploadMusicFailed"

//获取附近用户
#define HTTP_NEARBYUSER                                     [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"api/getusrpos.fcgi"]
#define NotificationNameNearbyUserSuccess                   @"NotificationNameNearbyUserSuccess"
#define NotificationNameNearbyUserFailed                    @"NotificationNameNearbyUserFailed"

//获取用户歌单
#define HTTP_GETUSERLIST                                    [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"api/getsonglist.fcgi"]
#define NotificationNameUserListSuccess                     @"NotificationNameUserListSuccess"
#define NotificationNameUserListFailed                      @"NotificationNameUserListFailed"

//获取用户正在听的歌曲
#define HTTP_GETPLAYINGMUSIC                                [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"api/nearsong.fcgi"]
#define NotificationNamePlayingMusicSuccess                 @"NotificationNamePlayingMusicSuccess"
#define NotificationNamePlayingMusicFailed                  @"NotificationNamePlayingMusicFailed"

//获取频道目录
#define HTTP_GETCHANNEL                                     [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/channel.fcgi"]
#define NotificationNameGetChannelSuccess                   @"NotificationNameGetChannelSuccess"
#define NotificationNameGetChannelFailed                    @"NotificationNameGetChannelFailed"

//获取频道的歌曲
#define HTTP_GETCHANNELMUSIC                                [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/channel_song.fcgi"]
#define NotificationNameGetChannelMusicSuccess              @"NotificationNameGetChannelMusicSuccess"
#define NotificationNameGetChannelMusicFailed               @"NotificationNameGetChannelMusicFailed"

//获取心情场景词描述
#define HTTP_MODESCENE                                      [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/getword.fcgi"]
#define NotificationNameModeSceneSuccess                    @"NotificationNameModeSceneSuccess"
#define NotificationNameModeSceneFailed                     @"NotificationNameModeSceneFailed"

//获取心情场景歌曲
#define HTTP_MODEMUSIC                                      [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/word_song.fcgi"]
#define NotificationNameModeMusicSuccess                    @"NotificationNameModeMusicSuccess"
#define NotificationNameModeMusicFailed                     @"NotificationNameModeMusicFailed"

//获取心绪地图
#define HTTP_MODEMAP                                        [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"api/moodmap.fcgi"]
#define NotificationNameModeMapSuccess                      @"NotificationNameModeMapSuccess"
#define NotificationNameModeMapFailed                       @"NotificationNameModeMapFailed"


#endif
