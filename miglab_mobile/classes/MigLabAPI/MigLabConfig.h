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


////下载失败
//#define NotificationNameDownloadFailed                      @"NotificationNameDownloadFailed"
////下载进度
//#define NotificationNameDownloadProcess                     @"NotificationNameDownloadProcess"
////下载成功
//#define NotificationNameDownloadSuccess                     @"NotificationNameDownloadSuccess"


//注册
#define HTTP_REGISTER                                       @"http://42.121.14.108/cgi-bin/regedit.fcgi"
#define NotificationNameRegisterSuccess                     @"NotificationNameRegisterSuccess"
#define NotificationNameRegisterFailed                      @"NotificationNameRegisterFailed"

//游客信息
#define HTTP_GUEST                                          @"http://open.fm.miglab.com/api/guest.fcgi"
#define NotificationNameGetGuestSuccess                     @"NotificationNameGetGuestSuccess"
#define NotificationNameGetGuestFailed                      @"NotificationNameGetGuestFailed"

//更新用户信息
#define HTTP_UPDATEUSER                                     @"http://open.fm.miglab.com/api/usrupdate.fcgi"
#define NotificationUpdateUserSuccess                       @"NotificationUpdateUserSuccess"
#define NotificationUpdateUserFailed                        @"NotificationUpdateUserFailed"

//默认推荐歌曲
#define HTTP_DEFAULTMUSIC                                   @"http://open.fm.miglab.com/api/song.fcgi?token=AAOfv3WG35avZspzKhoeodwv2MFd8zYxOUFENUNCMUFBNjgwMDAyRTI2&uid=10001"
#define NotificationNameGetDefaultMusicSuccess              @"NotificationNameGetDefaultMusicSuccess"
#define NotificationNameGetDefaultMusicFailed               @"NotificationNameGetDefaultMusicFailed"

//添加收藏
#define HTTP_ADDFAVORITE                                    @"http://open.fm.miglab.com/api/collectsong.fcgi"
#define NotificationNameAddFavoriteSuccess                  @"NotificationNameAddFavoriteSuccess"
#define NotificationNameAddFavoriteFailed                   @"NotificationNameAddFavoriteFailed"

//添加黑名单
#define HTTP_ADDBLACKLIST                                   @"http://open.fm.miglab.com/api/hatsong.fcgi"
#define NotificationNameAddBlacklistSuccess                 @"NotificationNameAddBlacklistSuccess"
#define NotificationNameAddBlacklistFailed                  @"NotificationNameAddBlacklistFailed"

//赠送歌曲
#define HTTP_PRESENTMUSIC                                   @"http://open.fm.miglab.com/api/sendsong.fcgi"
#define NotificationNamePresentMusicSuccess                 @"NotificationNamePresentMusicSuccess"
#define NotificationNamePresentMusicFailed                  @"NotificationNamePresentMusicFailed"

//分享歌曲
#define HTTP_SHAREMUSIC                                     @"http://open.fm.miglab.com/api/sharesong.fcgi"
#define NotificationNameShareMusicSuccess                   @"NotificationNameShareMusicSuccess"
#define NotificationNameShareMusicFailed                    @"NotificationNameShareMusicFailed"

//上传用户本地歌曲信息
#define HTTP_UPLOADMUSIC                                    @"http://open.fm.miglab.com/api/updatesong.fcgi"
#define NotificationNameUploadMusicSuccess                  @"NotificationNameUploadMusicSuccess"
#define NotificationNameUploadMusicFailed                   @"NotificationNameUploadMusicFailed"

//获取附近用户
#define HTTP_NEARBYUSER                                     @"http://open.fm.miglab.com/api/getusrpos.fcgi"
#define NotificationNameNearbyUserSuccess                   @"NotificationNameNearbyUserSuccess"
#define NotificationNameNearbyUserFailed                    @"NotificationNameNearbyUserFailed"

//获取用户歌单
#define HTTP_GETUSERLIST                                    @"http://open.fm.miglab.com/api/getsonglist.fcgi"
#define NotificationNameUserListSuccess                     @"NotificationNameUserListSuccess"
#define NotificationNameUserListFailed                      @"NotificationNameUserListFailed"

//获取用户正在听的歌曲
#define HTTP_GETPLAYINGMUSIC                                @"http://open.fm.miglab.com/api/nearsong.fcgi"
#define NotificationNamePlayingMusicSuccess                 @"NotificationNamePlayingMusicSuccess"
#define NotificationNamePlayingMusicFailed                  @"NotificationNamePlayingMusicFailed"

//获取频道目录
#define HTTP_GETCHANNEL                                     @"http://open.fm.miglab.com/api/cgi-bin/channel.fcgi"
#define NotificationNameGetChannelSuccess                   @"NotificationNameGetChannelSuccess"
#define NotificationNameGetChannelFailed                    @"NotificationNameGetChannelFailed"

//获取频道的歌曲
#define HTTP_GETCHANNELMUSIC                                @"http://open.fm.miglab.com/api/cgi-bin/channel_song.fcgi"
#define NotificationNameGetChannelMusicSuccess              @"NotificationNameGetChannelMusicSuccess"
#define NotificationNameGetChannelMusicFailed               @"NotificationNameGetChannelMusicFailed"

//获取心情场景词描述
#define HTTP_MODESCENE                                      @"http://open.fm.miglab.com/api/cgi-bin/getword.fcgi"
#define NotificationNameModeSceneSuccess                    @"NotificationNameModeSceneSuccess"
#define NotificationNameModeSceneFailed                     @"NotificationNameModeSceneFailed"

//获取心情场景歌曲
#define HTTP_MODEMUSIC                                      @"http://open.fm.miglab.com/api/cgi-bin/word_song.fcgi"
#define NotificationNameModeMusicSuccess                    @"NotificationNameModeMusicSuccess"
#define NotificationNameModeMusicFailed                     @"NotificationNameModeMusicFailed"


#endif
