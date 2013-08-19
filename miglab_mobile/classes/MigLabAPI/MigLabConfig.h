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

//友盟
#define UMENG_APPKEY                        @"51f338a356240baf3a0723a0"

//友盟统计渠道定义
#define APP_CHANNEL_ID                      @"TEST"

#define SINA_WEIBO_APP_KEY                  @"1468499793"
#define SINA_WEIBO_APP_SECRET               @"ce6dd4ab9ae4f14aa7982a43453cc173"
#define SINA_WEIBO_APP_REDIRECTURI          @"https://api.weibo.com/oauth2/default.html"

#define TENCENT_WEIBO_APP_KEY               @"222222"
#define TENCENT_WEIBO_APP_SECRET            @""
#define TENCENT_WEIBO_APP_REDIRECTURI       @""

// 仅用于此 demo, level 较低，大量使用时会遇到访问限制。实际使用，请重新申请。
#define DOUBAN_API_KEY                      @"04e0b2ab7ca02a8a0ea2180275e07f9e"
#define DOUBAN_PRIVATE_KEY                  @"4275ee2fa3689a2f"
#define DOUBAN_REDIRECTURL                  @"http://www.douban.com/location/mobile"

#define WEIXIN_APP_ID                       @"wxc8d17a5ccdf1c33b"
#define WEIXIN_APP_KEY                      @""

#define AES256_SECRET                       @"ce6dd4ab9ae4f14aa7982a43453cc173"

/*
 * 用于切换不同域名地址
 */
#define IS_DEBUG_SERVER 2

#if (0 == IS_DEBUG_SERVER)

#define HTTP_SSO_DOMAIN                                     @"http://sso.miglab.com/"
#define HTTP_DOMAIN                                         @"http://open.fm.miglab.com/"
#define HTTP_API_DOMAIN                                     @"http://open.fm.miglab.com/"

#elif (1 == IS_DEBUG_SERVER)

#define HTTP_SSO_DOMAIN                                     @"http://60.191.220.135/"
#define HTTP_DOMAIN                                         @"http://42.121.14.108/"
#define HTTP_API_DOMAIN                                     @"http://42.121.14.108/"

#elif (2 == IS_DEBUG_SERVER)

#define HTTP_SSO_DOMAIN                                     @"http://60.191.220.135/"
#define HTTP_DOMAIN                                         @"http://112.124.49.59/"
#define HTTP_API_DOMAIN                                     @"http://112.124.49.59/"

#endif

//登陆
//登陆第一次验证地址 @"http://sso.miglab.com/cgi-bin/sp.fcgi?sp"
#define LOGIN_SSO_SP_URL                                    [NSString stringWithFormat:@"%@%@",HTTP_SSO_DOMAIN,@"cgi-bin/sp.fcgi?sp"]
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

//添加歌曲收藏
#define HTTP_COLLECTSONG                                    [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/collectsong.fcgi"]
#define NotificationNameCollectSongSuccess                  @"NotificationNameCollectSongSuccess"
#define NotificationNameCollectSongFailed                   @"NotificationNameCollectSongFailed"

//取消歌曲收藏
#define HTTP_CANCELCOLLECTEDSONG                            [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/delcltsong.fcgi"]
#define NotificationNameCancelCollectedSongSuccess          @"NotificationNameCancelCollectedSongSuccess"
#define NotificationNameCancelCollectedSongFailed           @"NotificationNameCancelCollectedSongFailed"

//歌曲拉黑
#define HTTP_HATESONG                                       [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/hatsong.fcgi"]
#define NotificationNameHateSongSuccess                     @"NotificationNameHateSongSuccess"
#define NotificationNameHateSongFailed                      @"NotificationNameHateSongFailed"

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
#define HTTP_MOODSCENE                                      [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/getword.fcgi"]
#define NotificationNameMoodSuccess                         @"NotificationNameMoodSuccess"
#define NotificationNameMoodFailed                          @"NotificationNameMoodFailed"
#define NotificationNameSceneSuccess                        @"NotificationNameSceneSuccess"
#define NotificationNameSceneFailed                         @"NotificationNameSceneFailed"

//获取心情场景歌曲
#define HTTP_MODEMUSIC                                      [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/word_song.fcgi"]
#define NotificationNameModeMusicSuccess                    @"NotificationNameModeMusicSuccess"
#define NotificationNameModeMusicFailed                     @"NotificationNameModeMusicFailed"

//获取心绪地图
#define HTTP_MOODMAP                                        [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/moodmap.fcgi"]
#define NotificationNameMoodMapSuccess                      @"NotificationNameMoodMapSuccess"
#define NotificationNameMoodMapFailed                       @"NotificationNameMoodMapFailed"

//获取心绪类别名称
#define HTTP_MOODPARENT                                     [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/moodparent.fcgi"]
#define NotificationNameMoodParentSuccess                   @"NotificationNameMoodParentSuccess"
#define NotificationNameMoodParentFailed                    @"NotificationNameMoodParentFailed"

//提交用户当前状态
#define HTTP_ADDMOODRECORD                                  [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/moodrcd.fcgi"]
#define NotificationNameAddMoodRecordSuccess                @"NotificationNameAddMoodRecordSuccess"
#define NotificationNameAddMoodRecordFailed                 @"NotificationNameAddMoodRecordFailed"

//设置用户位置 (2013-7-22)
#define HTTP_SETUSERPOS                                     [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/setuserpos.fcgi"]
#define NotificationNameSetUserPosSuccess                   @"NotificationNameSetUserPosSuccess"
#define NotificationNameSetUserPosFailed                    @"NotificationNameSetUserPosFailed"

//查找附近的人 (2013-7-22)
#define HTTP_SEARCHNEARBY                                   [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/searchnearby.fcgi"]
#define NotificationNameSearchNearbySuccess                 @"NotificationNameSearchNearbySuccess"
#define NotificationNameSearchNearbyFailed                  @"NotificationNameSearchNearbyFailed"

//非注册用户获取播放列表（2013-08－17）
#define HTTP_GETDEFAULTGUESTSONGS                           [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/getdefguestsongs.fcgi"]
#define NotificationNameGetDefaultGuestSongsSuccess         @"NotificationNameGetDefaultGuestSongsSuccess"
#define NotificationNameGetDefaultGuestSongsFailed          @"NotificationNameGetDefaultGuestSongsFailed"

//获取收藏的歌曲(2013-08-18)
#define HTTP_GETCLTSONGS                                    [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/getcltsongs.fcgi"]
#define NotificationNameGetCollectedSongsSuccess            @"NotificationNameGetCollectedSongsSuccess"
#define NotificationNameGetCollectedSongsFailed             @"NotificationNameGetCollectedSongsFailed"

//获取豆瓣的频道歌曲（2013-08-19）
#define HTTP_GETDBCHANNELSONG                               [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/db_channel_song.fcgi"]
#define NotificationNameGetDbChannelSongSuccess             @"NotificationNameGetDbChannelSongSuccess"
#define NotificationNameGetDbChannelSongFailed              @"NotificationNameGetDbChannelSongFailed"

//通过整体纬度获取音乐(2013-08-19)
#define HTTP_GETTYPESONGS                                   [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/gettypesongs.fcgi"]
#define NotificationNameGetTypeSongsSuccess                 @"NotificationNameGetTypeSongsSuccess"
#define NotificationNameGetTypeSongsFailed                  @"NotificationNameGetTypeSongsFailed"


#endif
