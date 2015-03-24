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

//app id
#define APPLE_ID 862410865

//友盟
#define UMENG_APPKEY                        @"54b72c25fd98c533ef0003a5"

//友盟统计渠道定义
#define APP_CHANNEL_ID                      @"咪哟"

//新浪账号-音乐随我意移动版
#define SINA_WEIBO_APP_KEY                  @"4082577001"
#define SINA_WEIBO_APP_SECRET               @"ffceb9ce49142b68f18d84fa216ea350"
#define SINA_WEIBO_APP_REDIRECTURI          @"http://42.121.14.108/3rdauth/sinaweibo/callback.php"

#define TENCENT_WEIBO_APP_KEY               @"100525100"//@"222222"
#define TENCENT_WEIBO_APP_SECRET            @"1ead0b3a8e5ab032a8cd15d10f4ed61c"
#define TENCENT_WEIBO_APP_REDIRECTURI       @""

#define DOUBAN_API_KEY                      @"0765fe87cdc0cd0a1631fb976942671e"
#define DOUBAN_PRIVATE_KEY                  @"1b45aca692b49482"
#define DOUBAN_REDIRECTURL                  @"http://42.121.14.108/3rdauth/douban/callback.php"

// 仅用于此 demo, level 较低，大量使用时会遇到访问限制。实际使用，请重新申请。
//#define DOUBAN_API_KEY                      @"04e0b2ab7ca02a8a0ea2180275e07f9e"
//#define DOUBAN_PRIVATE_KEY                  @"4275ee2fa3689a2f"
//#define DOUBAN_REDIRECTURL                  @"http://www.douban.com/location/mobile"

//#define DOUBAN_API_KEY                      @"03050784c61576ff090f168e524064fd"
//#define DOUBAN_PRIVATE_KEY                  @"42a147f6632f7b4c"
//#define DOUBAN_REDIRECTURL                  @"http://www.douban.com/location/mobile"

#define WEIXIN_APP_ID                       @"wx8975da7e04f500b3"
#define WEIXIN_APP_KEY                      @""

#define AES256_SECRET                       @"ce6dd4ab9ae4f14aa7982a43453cc173"


#define BARRAYCOMM_TIME                         1

#define ALONE_CHAT                              1 //单聊
#define GROUP_CHAT                              3 //群聊
//#define TEMP_CHAT                               3 //临时聊

#define RGB(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

/*
 * 用于切换不同域名地址
 * IS_DEBUG_SERVER: 0-未使用，1-正式，2-测试
 */

#ifdef DEBUG
#define IS_DEBUG_SERVER 1
#else
#define IS_DEBUG_SERVER 1
#endif

#if (0 == IS_DEBUG_SERVER)

#define HTTP_SSO_DOMAIN                                     @"http://sso.miglab.com/"
#define HTTP_DOMAIN                                         @"http://open.fm.miglab.com/"
#define HTTP_API_DOMAIN                                     @"http://open.fm.miglab.com/"

#elif (1 == IS_DEBUG_SERVER)

#define HTTP_SSO_DOMAIN                                     @"http://42.121.14.108/"
#define HTTP_DOMAIN                                         @"http://42.121.14.108/"
#define HTTP_API_DOMAIN                                     @"http://42.121.14.108/"

#elif (2 == IS_DEBUG_SERVER)

#define HTTP_SSO_DOMAIN                                     @"http://112.124.49.59/"
#define HTTP_DOMAIN                                         @"http://112.124.49.59/"
#define HTTP_API_DOMAIN                                     @"http://112.124.49.59/"

#endif

/* 所有接口的标准开头和标准结尾 */
#define API_HEADER()    
#define API_FOOTER()

/*
 * 宏控制开关
 */
// 使用QQ登陆
#ifndef USE_QQ_LOGIN
    #define USE_QQ_LOGIN 1
#endif

// 咪哟账号登陆
#ifndef USE_MIYO_LOGIN
 #define USE_MIYO_LOGIN 0
#endif


// 开启隐私
#ifndef USE_PRIVATE
    #define USE_PRIVATE 0
#endif

// 开启附近好音乐的扫描（重新找好音乐）
#ifndef USE_NEARMUSIC_SEARCH
    #define USE_NEARMUSIC_SEARCH 0
#endif

// 开启我的音乐中的编辑功能
#ifndef USE_LIKE_MUSIC_EDIT
    #define USE_LIKE_MUSIC_EDIT 0
#endif

// 开启附近好音乐的编辑功能
#ifndef USE_NEARMUSIC_EDIT
    #define USE_NEARMUSIC_EDIT 0
#endif

// 开启功能
#ifndef USE_FUNCTION_SETTING
    #define USE_FUNCTION_SETTING 0
#endif

// 开启昵称修改
#ifndef USE_NICKNAME_SETTING
    #define USE_NICKNAME_SETTING 1
#endif

// 开启分享按钮
#ifndef USE_SHARE
    #define USE_SHARE 1
#endif

// 开启本地播放功能
#ifndef USE_LOCAL_PLAY
    #define USE_LOCAL_PLAY 0
#endif

// 使用新的新浪微博登陆
#ifndef USE_NEW_SINA_SDK
    #define USE_NEW_SINA_SDK 1
#endif

// 使用新版流播放器
#ifndef USE_NEW_AUDIO_PLAY
    #define USE_NEW_AUDIO_PLAY 1
#endif

// 使用AudioStreamer自带的读取文件错误提醒
#ifndef USE_AS_ORG_READFILE_ERROR
    #define USE_AS_ORG_READFILE_ERROR 0
#endif

#ifndef USE_LOGIN_HELPER
#define USE_LOGIN_HELPER 0
#endif



//登陆
//登陆第一次验证地址 @"http://sso.miglab.com/cgi-bin/sp.fcgi?sp"
#define LOGIN_SSO_SP_URL                                    [NSString stringWithFormat:@"%@%@",HTTP_SSO_DOMAIN,@"cgi-bin/login.fcgi"]
//用户名为空
#define NotificationNameUsernameIsNull                      @"NotificationNameUsernameIsNull"
//密码为空
#define NotificationNamePasswordIsNull                      @"NotificationNamePasswordIsNull"
//登陆授权失败
#define NotificationNameLoginFailed                         @"NotificationNameLoginFailed"
//登陆成功
#define NotificationNameLoginSuccess                        @"NotificationNameLoginSuccess"

/*
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
#define HTTP_UPDATEUSER                                     [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/updateusr.fcgi"]
#define NotificationUpdateUserSuccess                       @"NotificationUpdateUserSuccess"
#define NotificationUpdateUserFailed                        @"NotificationUpdateUserFailed"
*/
//默认推荐歌曲
#define HTTP_DEFAULTMUSIC                                   [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"api/song.fcgi?token=AAOfv3WG35avZspzKhoeodwv2MFd8zYxOUFENUNCMUFBNjgwMDAyRTI2&uid=10001"]
#define NotificationNameGetDefaultMusicSuccess              @"NotificationNameGetDefaultMusicSuccess"
#define NotificationNameGetDefaultMusicFailed               @"NotificationNameGetDefaultMusicFailed"

/*
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
*/
/*
//赠送歌曲
#define HTTP_PRESENTMUSIC                                   [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/presentsong.fcgi"]
#define NotificationNamePresentMusicSuccess                 @"NotificationNamePresentMusicSuccess"
#define NotificationNamePresentMusicFailed                  @"NotificationNamePresentMusicFailed"

//分享歌曲
#define HTTP_SHAREMUSIC                                     [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"api/sharesong.fcgi"]
#define NotificationNameShareMusicSuccess                   @"NotificationNameShareMusicSuccess"
#define NotificationNameShareMusicFailed                    @"NotificationNameShareMusicFailed"
*/
//上传用户本地歌曲信息
/*
#define HTTP_UPLOADMUSIC                                    [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"api/updatesong.fcgi"]
#define NotificationNameUploadMusicSuccess                  @"NotificationNameUploadMusicSuccess"
#define NotificationNameUploadMusicFailed                   @"NotificationNameUploadMusicFailed"
*/

//获取用户歌单
/*
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
*/
/*
//获取附近用户
#define HTTP_NEARBYUSER                                     [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"api/getusrpos.fcgi"]
#define NotificationNameNearbyUserSuccess                   @"NotificationNameNearbyUserSuccess"
#define NotificationNameNearbyUserFailed                    @"NotificationNameNearbyUserFailed"

//设置用户位置 (2013-7-22)
#define HTTP_SETUSERPOS                                     [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/setuserpos.fcgi"]
#define NotificationNameSetUserPosSuccess                   @"NotificationNameSetUserPosSuccess"
#define NotificationNameSetUserPosFailed                    @"NotificationNameSetUserPosFailed"

//查找附近的人 (2013-7-22)
#define HTTP_SEARCHNEARBY                                   [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/searchnearby.fcgi"]
#define NotificationNameSearchNearbySuccess                 @"NotificationNameSearchNearbySuccess"
#define NotificationNameSearchNearbyFailed                  @"NotificationNameSearchNearbyFailed"*/

//非注册用户获取播放列表（2013-08－17）
#define HTTP_GETDEFAULTGUESTSONGS                           [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/getdefguestsongs.fcgi"]
#define NotificationNameGetDefaultGuestSongsSuccess         @"NotificationNameGetDefaultGuestSongsSuccess"
#define NotificationNameGetDefaultGuestSongsFailed          @"NotificationNameGetDefaultGuestSongsFailed"

/*
//获取收藏的歌曲(2013-08-18)
#define HTTP_GETCLTSONGS                                    [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/getcltsongs.fcgi"]
#define NotificationNameGetCollectedSongsSuccess            @"NotificationNameGetCollectedSongsSuccess"
#define NotificationNameGetCollectedSongsFailed             @"NotificationNameGetCollectedSongsFailed"
*/
//获取豆瓣的频道歌曲（2013-08-19）
#define HTTP_GETDBCHANNELSONG                               [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/db_channel_song.fcgi"]
#define NotificationNameGetDbChannelSongSuccess             @"NotificationNameGetDbChannelSongSuccess"
#define NotificationNameGetDbChannelSongFailed              @"NotificationNameGetDbChannelSongFailed"
/*
//通过整体纬度获取音乐(2013-08-19)
#define HTTP_GETTYPESONGS                                   [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/gettypesongs.fcgi"]
#define NotificationNameGetTypeSongsSuccess                 @"NotificationNameGetTypeSongsSuccess"
#define NotificationNameGetTypeSongsFailed                  @"NotificationNameGetTypeSongsFailed"

//提交本地歌曲信息(2013-08-19)
#define HTTP_RECORDLOCALSONGS                               [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/recordlocalsongs.fcgi"]
#define NotificationNameRecordLocalSongsSuccess             @"NotificationNameRecordLocalSongsSuccess"
#define NotificationNameRecordLocalSongsFailed              @"NotificationNameRecordLocalSongsFailed"
*/
/*
//获取推送消息(2013-08-20)
#define HTTP_GETPUSHMSG                                     [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/getpushmsg.fcgi"]
#define NotificationNameGetPushMsgSuccess                          @"NotificationNameGetPushMsgSuccess"
#define NotificationNameGetPushMsgFailed                    @"NotificationNameGetPushMsgFailed"

//记录用户试听歌曲状态
#define HTTP_RECORDCURSONG                                  [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/recordcursong.fcgi"]
#define NotificationNameRecordCurSongSuccess                @"NotificationNameRecordCurSongSuccess"
#define NotificationNameRecordCurSongFailed                 @"NotificationNameRecordCurSongFailed"

//更新音乐纬度配置文件
#define HTTP_UPDATECONFIGFILE                               [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/updateconfigfile.fcgi"]
#define NotificationNameUpdateConfigSuccess                 @"NotificationNameUpdateConfigSuccess"
#define NotificationNameUpdateConfigFailed                  @"NotificationNameUpdateConfigFailed"
*/
//添加红心歌曲
/*
#define HTTP_COLLECTSONG                                    [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/collectsong.fcgi"]
#define NotificationNameCollectSongSuccess                  @"NotificationNameCollectSongSuccess"
#define NotificationNameCollectSongFailed                   @"NotificationNameCollectSongFailed"
 */

/*
//获取收藏歌曲数量和附近人收藏数量
#define HTTP_COLLECTANDNEARNUM                              [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/collectandnearnum.fcgi"]
#define NotificationNameCollectAndNearNumSuccess            @"NotificationNameCollectAndNearNumSuccess"
#define NotificationNameCollectAndNearNumFailed             @"NotificationNameCollectAndNearNumFailed"
*/
/*
//删除收藏歌曲
#define HTTP_DELETECOLLECTSONG                              [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/delcltsong.fcgi"]
#define NotificationNameDeleteCollectSongSuccess            @"NotificationNameDeleteCollectSongSuccess"
#define NotificationNameDeleteCollectSongFailed             @"NotificationNameDeleteCollectSongFailed"

//获取歌曲信息
#define HTTP_GETSONGINFO                                    [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/getsonginfo.fcgi"]
#define NotificationNameGetSongInfoSuccess                  @"NotificationNameGetSongInfoSuccess"
#define NotificationNameGetSongInfoFailed                   @"NotificationNameGetSongInfoFailed"
*/
/*
//附近人的音乐
#define HTTP_GETNEARMUSIC                                   [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/nearmusic.fcgi"]
#define NotificationNameGetNearMusicSuccess                 @"NotificationNameGetNearMusicSuccess"
#define NotificationNameGetNearMusicFailed                  @"NotificationNameGetNearMusicFailed"
*/
// 评论歌曲
/*
#define HTTP_COMMENTSONG                                    [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/commentsong.fcgi"]
#define NotificationNameCommentSongSuccess                  @"NotificationNameCommentSongSuccess"
#define NotificationNameCommentSongFailed                   @"NotificationNameCommentSongFailed"

// 获取歌曲评论
#define HTTP_GETCOMMENT                                     [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/get_comment.fcgi"]
#define NotificationNameGetCommentSuccess                   @"NotificationNameGetCommentSuccess"
#define NotificationNameGetCommentFailed                    @"NotificationNameGetCommentFailed"
*/
/*
// 获取周围谁在听你的歌及消息
#define HTTP_GETMYNEARMUSICMSGNUM                           [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/musicfri.fcgi"]
#define NotificationNameGetMyNearMusicMsgNumSuccess         @"NotificationNameGetMyNearMusicMsgNumSuccess"
#define NotificationNameGetMyNearMusicMsgNumFailed          @"NotificationNameGetMyNearMusicMsgNumFailed"

// 获取周围谁在听你红心的歌曲
#define HTTP_GETSANMEMUSIC                                  [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/samemusic.fcgi"]
#define NotificationNameGetSameMusicSuccess                 @"NotificationNameGetSameMusicSuccess"
#define NotificationNameGetSameMusicFailed                  @"NotificationNameGetSameMusicFailed"

// 获取周围的人及音乐
#define HTTP_GETNEARUSER                                    [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/nearuser.fcgi"]
#define NotificationNameGetNearUserSuccess                  @"NotificationNameGetNearUserSuccess"
#define NotificationNameGetNearUserFailed                   @"NotificationNameGetNearUserFailed"*/

// 获取用户听歌记录
/*
#define HTTP_GETSONGHISTORY                                 [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/getuserhis.fcgi"]
#define NotificationNameGetSongHistorySuccess               @"NotificationNameGetSongHistorySuccess"
#define NotificationNameGetSongHistoryFailed                @"NotificationNameGetSongHistoryFailed"
*/
/*
// 打招呼
#define HTTP_SAYHELLO                                       [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/sayhello.fcgi"]
#define NotificationNameSayHelloSuccess                     @"NotificationNameSayHelloSuccess"
#define NotificationNameSayHelloFailed                      @"NotificationNameSayHelloFailed"
*//*
// 获取歌友
#define HTTP_GETMUSICUSER                                   [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/getmusicuser.fcgi"]
#define NotificationNameGetMusicUserSuccess                 @"NotificationNameGetMusicUserSuccess"
#define NotificationNameGetMusicUserFailed                  @"NotificationNameGetMusicUserFailed"
*/
/*
#define HTTP_CONFIGPUSH                                     [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/setuserconfigofpush.fcgi"]
#define NotificationNameConfigPushSuccess                   @"NotificationNameConfigPushSuccess"
#define NotificationNameConfigPushFailed                    @"NotificationNameConfigPushFailed"
 */
/*
// 获取歌词分享信息
#define HTTP_GETSHAREINFO                                   [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/getshareinfo.fcgi"]
#define NotificationNameGetShareInfoSuccess                 @"NotificationNameGetShareInfoSuccess"
#define NotificationNameGetShareInfoFailed                  @"NotificationNameGetShareInfoFailed"
*/
//获取聊天服务器
/*
#define HTTP_GETSC                                          [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/getsc.fcgi"]
#define NotificationNameGetSCSuccess                        @"NotificationNameGetSCSuccess"
#define NotificationNameGetSCFailed                         @"NotificationNameGetSCFailed"

//获取聊天记录
#define HTTP_HISTCHAT                                       [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/hischat.fcgi"]
#define NotificationNameHisChatSuccess                      @"NotificationNameHisChatSuccess"
#define NotificationNameHisChatFailed                       @"NotificationNameHisChatFailed"
*/
/*
// 提交分享结果
#define HTTP_SENDSHARERESULT                                [NSString stringWithFormat:@"%@%@",HTTP_API_DOMAIN,@"cgi-bin/shareresult.fcgi"]
#define NotificationNameSendShareResultSuccess              @"NotificationNameSendShareResultSuccess"
#define NotificationNameSendShareResultFailed               @"NotificationNameSendShareResultFailed"
 */



//新接口地址================================================================================================
//接口地址修改
//http://112.124.49.59/cgi-bin/miyo/soc/v1/getlocation.fcgi?uid=10008&token=eaed123
//HOST + 路径 + 项目名 + 插件 + 版本 + 接口名
#define PATH                @"cgi-bin"
#define PRO                 @"testmiyo"
//module
#define SOCMOD              @"soc"
#define CHATMOD             @"chat"
#define MUSICMOD            @"music"
#define LBSMOD              @"lbs"
#define USRMOD              @"usr"
#define USERMOD             @"user"

//版本
#define VERSION             @"v1"

#define SOC_INTERFACE     [NSString stringWithFormat:@"%@%@/%@/%@/%@/",HTTP_API_DOMAIN,PATH,PRO,SOCMOD,VERSION]

#define CHAT_INTERFACE    [NSString stringWithFormat:@"%@%@/%@/%@/%@/",HTTP_API_DOMAIN,PATH,PRO,CHATMOD,VERSION]

#define MUSIC_INTERFACE   [NSString stringWithFormat:@"%@%@/%@/%@/%@/",HTTP_API_DOMAIN,PATH,PRO,MUSICMOD,VERSION]

#define LBS_INTERFACE   [NSString stringWithFormat:@"%@%@/%@/%@/%@/",HTTP_API_DOMAIN,PATH,PRO,LBSMOD,VERSION]

#define USR_INTERFACE   [NSString stringWithFormat:@"%@%@/%@/%@/%@/",HTTP_API_DOMAIN,PATH,PRO,USRMOD,VERSION]
#define USER_INTERFACE   [NSString stringWithFormat:@"%@%@/%@/%@/%@/",HTTP_API_DOMAIN,PATH,PRO,USERMOD,VERSION]


//////////////////////////////////////////////////社交///////////////////////////////////////////////////////////////
//获取当前天气和城市
#define HTTP_LOCATIONINFO                                    [NSString stringWithFormat:@"%@%@",SOC_INTERFACE,@"getlocation.fcgi"]
#define NotificationNameLocationSuccess                     @"NotificationNameLocationSuccess"
#define NotificationNameLocationFailed                      @"NotificationNameLocationFailed"

//获取弹幕和评论
#define HTTP_BARRAYCOMM                                       [NSString stringWithFormat:@"%@%@",SOC_INTERFACE,@"getbarragecomm.fcgi"]
#define NotificationBarryCommSuccess                     @"NotificationBarryCommSuccess"
#define NotificationBarryCommFailed                      @"NotificationBarryCommFailed"

//提交deviceToken /因换成百度推送 故暂时不调用
#define HTTP_CONFIGPUSH                                     [NSString stringWithFormat:@"%@%@",SOC_INTERFACE,@"setuserconfigofpush.fcgi"]
#define NotificationNameConfigPushSuccess                   @"NotificationNameConfigPushSuccess"
#define NotificationNameConfigPushFailed                    @"NotificationNameConfigPushFailed"

//赠送歌曲
#define HTTP_PRESENTMUSIC                                   [NSString stringWithFormat:@"%@%@",SOC_INTERFACE,@"presentsong.fcgi"]
#define NotificationNamePresentMusicSuccess                 @"NotificationNamePresentMusicSuccess"
#define NotificationNamePresentMusicFailed                  @"NotificationNamePresentMusicFailed"

// 打招呼
#define HTTP_SAYHELLO                                       [NSString stringWithFormat:@"%@%@",SOC_INTERFACE,@"sayhello.fcgi"]
#define NotificationNameSayHelloSuccess                     @"NotificationNameSayHelloSuccess"
#define NotificationNameSayHelloFailed                      @"NotificationNameSayHelloFailed"

#define HTTP_GETPUSHMSG                                     [NSString stringWithFormat:@"%@%@",SOC_INTERFACE,@"getpushmsg.fcgi"]
#define NotificationNameGetPushMsgSuccess                          @"NotificationNameGetPushMsgSuccess"
#define NotificationNameGetPushMsgFailed                    @"NotificationNameGetPushMsgFailed"

// 评论歌曲
#define HTTP_COMMENTSONG                                    [NSString stringWithFormat:@"%@%@",SOC_INTERFACE,@"commentsong.fcgi"]
#define NotificationNameCommentSongSuccess                  @"NotificationNameCommentSongSuccess"
#define NotificationNameCommentSongFailed                   @"NotificationNameCommentSongFailed"

// 获取歌曲评论
#define HTTP_GETCOMMENT                                     [NSString stringWithFormat:@"%@%@",SOC_INTERFACE,@"get_comment.fcgi"]
#define NotificationNameGetCommentSuccess                   @"NotificationNameGetCommentSuccess"
#define NotificationNameGetCommentFailed                    @"NotificationNameGetCommentFailed"

// 获取歌友
#define HTTP_GETMUSICUSER                                   [NSString stringWithFormat:@"%@%@",SOC_INTERFACE,@"getmusicuser.fcgi"]
#define NotificationNameGetMusicUserSuccess                 @"NotificationNameGetMusicUserSuccess"
#define NotificationNameGetMusicUserFailed                  @"NotificationNameGetMusicUserFailed"

// 获取歌词分享信息
#define HTTP_GETSHAREINFO                                   [NSString stringWithFormat:@"%@%@",SOC_INTERFACE,@"getshareinfo.fcgi"]
#define NotificationNameGetShareInfoSuccess                 @"NotificationNameGetShareInfoSuccess"
#define NotificationNameGetShareInfoFailed                  @"NotificationNameGetShareInfoFailed"

// 提交分享结果
#define HTTP_SENDSHARERESULT                                [NSString stringWithFormat:@"%@%@",SOC_INTERFACE,@"shareresult.fcgi"]
#define NotificationNameSendShareResultSuccess              @"NotificationNameSendShareResultSuccess"
#define NotificationNameSendShareResultFailed               @"NotificationNameSendShareResultFailed"

//分享歌曲
#define HTTP_SHAREMUSIC                                     [NSString stringWithFormat:@"%@%@",SOC_INTERFACE,@"sharesong.fcgi"]
#define NotificationNameShareMusicSuccess                   @"NotificationNameShareMusicSuccess"
#define NotificationNameShareMusicFailed                    @"NotificationNameShareMusicFailed"




//////////////////////////////////////////////////音乐///////////////////////////////////////////////////////////////

//添加歌曲收藏
#define HTTP_COLLECTSONG                                    [NSString stringWithFormat:@"%@%@",MUSIC_INTERFACE,@"collectsong.fcgi"]
#define NotificationNameCollectSongSuccess                  @"NotificationNameCollectSongSuccess"
#define NotificationNameCollectSongFailed                   @"NotificationNameCollectSongFailed"

//取消歌曲收藏
#define HTTP_CANCELCOLLECTEDSONG                            [NSString stringWithFormat:@"%@%@",MUSIC_INTERFACE,@"delcltsong.fcgi"]
#define NotificationNameCancelCollectedSongSuccess          @"NotificationNameCancelCollectedSongSuccess"
#define NotificationNameCancelCollectedSongFailed           @"NotificationNameCancelCollectedSongFailed"


//删除收藏歌曲
#define HTTP_DELETECOLLECTSONG                              [NSString stringWithFormat:@"%@%@",MUSIC_INTERFACE,@"delcltsong.fcgi"]
#define NotificationNameDeleteCollectSongSuccess            @"NotificationNameDeleteCollectSongSuccess"
#define NotificationNameDeleteCollectSongFailed             @"NotificationNameDeleteCollectSongFailed"

//获取歌曲信息
#define HTTP_GETSONGINFO                                    [NSString stringWithFormat:@"%@%@",MUSIC_INTERFACE,@"cgetsonginfo.fcgi"]
#define NotificationNameGetSongInfoSuccess                  @"NotificationNameGetSongInfoSuccess"
#define NotificationNameGetSongInfoFailed                   @"NotificationNameGetSongInfoFailed"

//歌曲拉黑
#define HTTP_HATESONG                                       [NSString stringWithFormat:@"%@%@",MUSIC_INTERFACE,@"hatsong.fcgi"]
#define NotificationNameHateSongSuccess                     @"NotificationNameHateSongSuccess"
#define NotificationNameHateSongFailed                      @"NotificationNameHateSongFailed"

//上传用户本地歌曲信息
#define HTTP_UPLOADMUSIC                                    [NSString stringWithFormat:@"%@%@",MUSIC_INTERFACE,@"updatesong.fcgi"]
#define NotificationNameUploadMusicSuccess                  @"NotificationNameUploadMusicSuccess"
#define NotificationNameUploadMusicFailed                   @"NotificationNameUploadMusicFailed"

#define HTTP_GETUSERLIST                                    [NSString stringWithFormat:@"%@%@",MUSIC_INTERFACE,@"getsonglist.fcgi"]
#define NotificationNameUserListSuccess                     @"NotificationNameUserListSuccess"
#define NotificationNameUserListFailed                      @"NotificationNameUserListFailed"

//获取频道目录
#define HTTP_GETCHANNEL                                     [NSString stringWithFormat:@"%@%@",MUSIC_INTERFACE,@"channel.fcgi"]
#define NotificationNameGetChannelSuccess                   @"NotificationNameGetChannelSuccess"
#define NotificationNameGetChannelFailed                    @"NotificationNameGetChannelFailed"

//获取频道的歌曲
#define HTTP_GETCHANNELMUSIC                                [NSString stringWithFormat:@"%@%@",MUSIC_INTERFACE,@"channel_song.fcgi"]
#define NotificationNameGetChannelMusicSuccess              @"NotificationNameGetChannelMusicSuccess"
#define NotificationNameGetChannelMusicFailed               @"NotificationNameGetChannelMusicFailed"

//获取心情场景词描述
#define HTTP_MOODSCENE                                      [NSString stringWithFormat:@"%@%@",MUSIC_INTERFACE,@"getword.fcgi"]
#define NotificationNameMoodSuccess                         @"NotificationNameMoodSuccess"
#define NotificationNameMoodFailed                          @"NotificationNameMoodFailed"
#define NotificationNameSceneSuccess                        @"NotificationNameSceneSuccess"
#define NotificationNameSceneFailed                         @"NotificationNameSceneFailed"

//获取心情场景歌曲
#define HTTP_MODEMUSIC                                      [NSString stringWithFormat:@"%@%@",MUSIC_INTERFACE,@"word_song.fcgi"]
#define NotificationNameModeMusicSuccess                    @"NotificationNameModeMusicSuccess"
#define NotificationNameModeMusicFailed                     @"NotificationNameModeMusicFailed"

//获取心绪地图
#define HTTP_MOODMAP                                        [NSString stringWithFormat:@"%@%@",MUSIC_INTERFACE,@"moodmap.fcgi"]
#define NotificationNameMoodMapSuccess                      @"NotificationNameMoodMapSuccess"
#define NotificationNameMoodMapFailed                       @"NotificationNameMoodMapFailed"

//获取心绪类别名称
#define HTTP_MOODPARENT                                     [NSString stringWithFormat:@"%@%@",MUSIC_INTERFACE,@"moodparent.fcgi"]
#define NotificationNameMoodParentSuccess                   @"NotificationNameMoodParentSuccess"
#define NotificationNameMoodParentFailed                    @"NotificationNameMoodParentFailed"

//提交用户当前状态
#define HTTP_ADDMOODRECORD                                  [NSString stringWithFormat:@"%@%@",MUSIC_INTERFACE,@"moodrcd.fcgi"]
#define NotificationNameAddMoodRecordSuccess                @"NotificationNameAddMoodRecordSuccess"
#define NotificationNameAddMoodRecordFailed                 @"NotificationNameAddMoodRecordFailed"

//获取收藏的歌曲
#define HTTP_GETCLTSONGS                                    [NSString stringWithFormat:@"%@%@",MUSIC_INTERFACE,@"getcltsongs.fcgi"]
#define NotificationNameGetCollectedSongsSuccess            @"NotificationNameGetCollectedSongsSuccess"
#define NotificationNameGetCollectedSongsFailed             @"NotificationNameGetCollectedSongsFailed"

//记录用户试听歌曲状态
#define HTTP_RECORDCURSONG                                  [NSString stringWithFormat:@"%@%@",MUSIC_INTERFACE,@"recordcursong.fcgi"]
#define NotificationNameRecordCurSongSuccess                @"NotificationNameRecordCurSongSuccess"
#define NotificationNameRecordCurSongFailed                 @"NotificationNameRecordCurSongFailed"

//更新音乐纬度配置文件
#define HTTP_UPDATECONFIGFILE                               [NSString stringWithFormat:@"%@%@",MUSIC_INTERFACE,@"updateconfigfile.fcgi"]
#define NotificationNameUpdateConfigSuccess                 @"NotificationNameUpdateConfigSuccess"
#define NotificationNameUpdateConfigFailed                  @"NotificationNameUpdateConfigFailed"

//通过整体纬度获取音乐
#define HTTP_GETTYPESONGS                                   [NSString stringWithFormat:@"%@%@",MUSIC_INTERFACE,@"gettypesongs.fcgi"]
#define HTTP_GETDIMENSION                                   [NSString stringWithFormat:@"%@%@",MUSIC_INTERFACE,@"getdimensions.fcgi"]
#define NotificationNameGetTypeSongsSuccess                 @"NotificationNameGetTypeSongsSuccess"
#define NotificationNameGetTypeSongsFailed                  @"NotificationNameGetTypeSongsFailed"

//提交本地歌曲信息
#define HTTP_RECORDLOCALSONGS                               [NSString stringWithFormat:@"%@%@",MUSIC_INTERFACE,@"recordlocalsongs.fcgi"]
#define NotificationNameRecordLocalSongsSuccess             @"NotificationNameRecordLocalSongsSuccess"
#define NotificationNameRecordLocalSongsFailed              @"NotificationNameRecordLocalSongsFailed"

// 获取用户听歌记录
#define HTTP_GETSONGHISTORY                                 [NSString stringWithFormat:@"%@%@",MUSIC_INTERFACE,@"getuserhis.fcgi"]
#define NotificationNameGetSongHistorySuccess               @"NotificationNameGetSongHistorySuccess"
#define NotificationNameGetSongHistoryFailed                @"NotificationNameGetSongHistoryFailed"

//////////////////////////////////////////////////定位相关///////////////////////////////////////////////////////////////


//设置用户位置 (2013-7-22)
#define HTTP_SETUSERPOS                                     [NSString stringWithFormat:@"%@%@",LBS_INTERFACE,@"setuserpos.fcgi"]
#define NotificationNameSetUserPosSuccess                   @"NotificationNameSetUserPosSuccess"
#define NotificationNameSetUserPosFailed                    @"NotificationNameSetUserPosFailed"

//查找附近的人 (2013-7-22)
#define HTTP_SEARCHNEARBY                                   [NSString stringWithFormat:@"%@%@",LBS_INTERFACE,@"searchnearby.fcgi"]
#define NotificationNameSearchNearbySuccess                 @"NotificationNameSearchNearbySuccess"
#define NotificationNameSearchNearbyFailed                  @"NotificationNameSearchNearbyFailed"

// 获取周围谁在听你的歌及消息
#define HTTP_GETMYNEARMUSICMSGNUM                           [NSString stringWithFormat:@"%@%@",LBS_INTERFACE,@"musicfri.fcgi"]
#define NotificationNameGetMyNearMusicMsgNumSuccess         @"NotificationNameGetMyNearMusicMsgNumSuccess"
#define NotificationNameGetMyNearMusicMsgNumFailed          @"NotificationNameGetMyNearMusicMsgNumFailed"

// 获取周围谁在听你红心的歌曲
#define HTTP_GETSANMEMUSIC                                  [NSString stringWithFormat:@"%@%@",LBS_INTERFACE,@"samemusic.fcgi"]
#define NotificationNameGetSameMusicSuccess                 @"NotificationNameGetSameMusicSuccess"
#define NotificationNameGetSameMusicFailed                  @"NotificationNameGetSameMusicFailed"

// 获取周围的人及音乐
#define HTTP_GETNEARUSER                                    [NSString stringWithFormat:@"%@%@",LBS_INTERFACE,@"nearuser.fcgi"]
#define NotificationNameGetNearUserSuccess                  @"NotificationNameGetNearUserSuccess"
#define NotificationNameGetNearUserFailed                   @"NotificationNameGetNearUserFailed"


//附近人的音乐
#define HTTP_GETNEARMUSIC                                   [NSString stringWithFormat:@"%@%@",LBS_INTERFACE,@"nearmusic.fcgi"]
#define NotificationNameGetNearMusicSuccess                 @"NotificationNameGetNearMusicSuccess"
#define NotificationNameGetNearMusicFailed                  @"NotificationNameGetNearMusicFailed"


//获取收藏歌曲数量和附近人收藏数量
#define HTTP_COLLECTANDNEARNUM                              [NSString stringWithFormat:@"%@%@",LBS_INTERFACE,@"collectandnearnum.fcgi"]
#define NotificationNameCollectAndNearNumSuccess            @"NotificationNameCollectAndNearNumSuccess"
#define NotificationNameCollectAndNearNumFailed             @"NotificationNameCollectAndNearNumFailed"
//////////////////////////////////////////////////用户管理///////////////////////////////////////////////////////////////

//第三方平台用户登录
#define THIRD_LOGIN                                         [NSString stringWithFormat:@"%@%@",USER_INTERFACE,@"thirdlogin.fcgi"]
#define NotificationThirdLoginSuccess                       @"NotificationNameThirdLoginSuccess"
#define NotificationThirdLoginFailed                        @"NotificationNameThirdLoginFailed"


//获取用户信息
#define GET_USER_INFO                                       [NSString stringWithFormat:@"%@%@",USR_INTERFACE,@"userinfo.fcgi"]
#define NotificationNameGetUserInfoSuccess                  @"NotificationNameGetUserInfoSuccess"
#define NotificationNameGetUserInfoFailed                   @"NotificationNameGetUserInfoFailed"


//注册
#define HTTP_REGISTER                                       [NSString stringWithFormat:@"%@%@",USR_INTERFACE,@"regedit.fcgi"]
#define NotificationNameRegisterSuccess                     @"NotificationNameRegisterSuccess"
#define NotificationNameRegisterFailed                      @"NotificationNameRegisterFailed"

//游客信息
#define HTTP_GUEST                                          [NSString stringWithFormat:@"%@%@",USR_INTERFACE,@"guest.fcgi"]
#define NotificationNameGetGuestSuccess                     @"NotificationNameGetGuestSuccess"
#define NotificationNameGetGuestFailed                      @"NotificationNameGetGuestFailed"

//登陆日志
#define HTTP_LOGINRECORD                                    [NSString stringWithFormat:@"%@%@",USER_INTERFACE,@"loginrecord.fcgi"]
#define NotificationNameLogiReocrdSuccess                    @"NotificationNameLogiReocrdSuccess"
#define NotificationNameLogiReocrdFailed                     @"NotificationNameLogiReocrdFailed"


//更新用户信息
#define HTTP_UPDATEUSER                                     [NSString stringWithFormat:@"%@%@",USER_INTERFACE,@"update.fcgi"]
#define NotificationUpdateUserSuccess                       @"NotificationUpdateUserSuccess"
#define NotificationUpdateUserFailed                        @"NotificationUpdateUserFailed"


// 提交百度推送信息
#define HTTP_SENDBPUSHINFO                                  [NSString stringWithFormat:@"%@%@",USR_INTERFACE,@"bdbindpush.fcgi"]
#define NotificationNameSendBPushInfoSuccess                @"NotificationNameSendBPushInfoSuccess"
#define NotificationNameSendBPushInfoFailed                 @"NotificationNameSendBPushInfoFailed"

//////////////////////////////////////////////////聊天///////////////////////////////////////////////////////////////
//获取群聊天记录
#define HTTP_GROUPMESSAGE                                      [NSString stringWithFormat:@"%@%@",CHAT_INTERFACE,@"groupmessage.fcgi"]

//获取点对点聊天记录
#define HTTP_ALONEMESSAGE                                      [NSString stringWithFormat:@"%@%@",CHAT_INTERFACE,@"alonemessage.fcgi"]

//获取聊天服务器
#define HTTP_GETIDLESC                                         [NSString stringWithFormat:@"%@%@",CHAT_INTERFACE,@"getsc.fcgi"]
#endif

