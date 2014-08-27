//
//  apidefine.h
//  miglab_mobile
//
//  Created by Archer_LJ on 13-11-14.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#ifndef miglab_mobile_apidefine_h
#define miglab_mobile_apidefine_h

/* 列表分页数量 */
 #define MIG_PAGE_SIZE                          20

/* 屏幕的左上角x坐标 */
#define ORIGIN_X                                11.5

/* 最小歌词字号 */
#define MIN_LYRIC_FONT_SIZE                     8.0

/* UITableView 默认宽度 */
#define ORIGIN_WIDTH                            297

/* UITableViewCell 默认高度 */
#define CELL_HEIGHT                             57

/* 推荐歌曲的UITableViewCell高度 */
#define RECOMMAND_CELL_HEIGHT                   125

/* 底部播放器高度 */
#define BOTTOM_PLAYER_HEIGHT                    73

/* 新消息背景显示宽度 */
#define NEW_MSG_BG_SIZE                         24

/* 搜索范围默认距离 */
#define SEARCH_DISTANCE                         10000000

/* 赠送歌曲的默认数量限制 */
#define MAX_PRESENT_SONG_COUNT                  3

/* 打招呼的字数限制 */
#define MAX_SAYHI_COUNT                         30

/* 收到打招呼和送歌的行数显示限制 */
#define MAX_RECEIVE_DISPLAY_LINES               15

/* 一页中推送消息显示的数量 */
#define MSG_DISPLAY_COUNT                       10

/* 一页中歌友显示的数量 */
#define FRIEND_DISPLAY_COUNT                    10

/* 一页中附近歌友显示的数量 */
#define NEARFRIEND_DISPLAY_COUNT                10

/* 一页中附近歌曲显示的数量 */
#define NEARMUSIC_DISPLAY_COUNT                 10

/* 头像的宽度 */
#define AVATAR_RADIUS                           22

/* 头像的边框宽度 */
#define AVATAR_BORDER_WIDTH                     2

//根据音乐基因获取歌曲数量
#define GET_TYPE_SONGS_NUM                      5

/* 头像的边框颜色 */
#define AVATAR_BORDER_COLOR                     [UIColor whiteColor].CGColor

/* 登陆账号ID类别 */
#define LOGIN_MIGLAB                            0
#define LOGIN_SINA                              1
#define LOGIN_WEIXIN                            2
#define LOGIN_QQZONE                            3
#define LOGIN_DOUBAN                            4

/* 主界面和交友界面的引导图片数量 */
#define GUIDE_MAIN_NUMBER                       2
#define GUIDE_FIREND_NUMBER                     2

/* 新消息主界面提醒的大小 */
#define NEW_MSG_NUMBER_SIZE                     10


/* 性别 */
#define STR_MALE                                @"1"
#define STR_FEMALE                              @"0"

/* 用户来源 */
#define STR_USER_SOURCE_MIG                     @"0"
#define STR_USER_SOURCE_SINA                    @"1"
#define STR_USER_SOURCE_QQ                      @"2"
#define STR_USER_SOURCE_WEIXIN                  @"3"
#define STR_USER_SOURCE_DOUBAN                  @"4"

/* 天气 */
#define MIG_WEATHER_RAIN                        @"RAIN"
#define MIG_WEATHER_CLEAR_DAY                   @"CLEAR_DAY"
#define MIG_WEATHER_CLEAR_NIGHT                 @"CLEAR_NIGHT"
#define MIG_WEATHER_PARTLY_CLOUDY_DAY           @"PARTLY_CLOUDY_DAY"
#define MIG_WEATHER_PARTLY_CLOUDY_NIGHT         @"PARTLY_CLOUDY_NIGHT"
#define MIG_WEATHER_CLOUDY                      @"CLOUDY"
#define MIG_WEATHER_SLEET                       @"SLEET"
#define MIG_WEATHER_SNOW                        @"SNOW"
#define MIG_WEATHER_WIND                        @"WIND"
#define MIG_WEATHER_FOG                         @"FOG"


/* 米格用户id */
#define MIG_USER_ACCOUNT_ID                     @"666"

/* 默认推荐语 */
#define MIGTIP_DEFAULT_RECOMMAND                @"来听听嘛~"

/* 未登录提示语 */
#define MIGTIP_UNLOGIN                          @"点蓝色头像赶紧登陆吧~~"

/* 登录失败提示语*/
#define MIGTIP_LOGIN_ERROR                      @"账号或密码错误~~"

/* 正在发送提示语 */
#define MIGTIP_SENDING_MESSAGE                  @"我们正在为你勾搭~~"

/* 空邮箱提示语 */
#define MIGTIP_EMPTY_EMAIL                      @"邮箱不能为空哦~~~"

/* 错误邮箱格式 */
#define MIGTIP_WRONG_EMAIL_FMT                  @"邮箱格式错误"

/* 空密码提示语 */
#define MIGTIP_EMPTY_PASSWORD                   @"密码不能为空哦~~~"

/* 加载提示语 */
#define MIGTIP_LOADING                          @"咪呦在拼命加载..."

/*加载聊天*/
#define MIGTIP_HIS_CHAT                         @"加载聊天"

/*重新登录*/
#define MIGTIP_RELOGIN                          @"重新登录"

/* 修改昵称成功提示语 */
#define MIGTIP_CHANGE_NICKNAME_SUCCESS          @"修改昵称成功啦~~~"

/* 修改昵称失败提示语 */
#define MIGTIP_CHANGE_NICKNAME_FAILED           @"修改昵称失败，该昵称可能已被占用..."

/* 修改生日成功 */
#define MIGTIP_CHANGE_BIRTHDAY_SUCCESS          @"修改生日成功啦~~~"

/* 修改生日失败 */
#define MIGTIP_CHANGE_BIRTHDAY_FAILED           @"修改生日失败，请稍后重试..."

/* 修改性别成功 */
#define MIGTIP_CHANGE_GENDER_SUCCESS            @"修改性别成功啦~~~"

/* 修改性别失败 */
#define MIGTIP_CHANGE_GENDER_FAILED             @"修改性别失败，请稍后重试..."

/* 没有歌友 */
#define MIGTIP_NO_FRIENDS                       @"您还没有歌友哦"

/* 获取歌友失败 */
#define MIGTIP_GET_NEAR_FRIEND_FAILED           @"您附近没有歌友:("

/* 获取收藏歌曲失败 */
#define MIGTIP_GET_COLLECT_SONG_FAILED          @"收藏歌曲获取失败:("

/* 附近的好音乐获取失败 */
#define MIGTIP_GET_NEAR_SONG_FAILED             @"附近的好音乐获取失败:("

/* 发送消息的类型不对 */
#define MIGTIP_WRONG_MSG_TYPE                   @"信息格式不正确, 无法显示"

/* 歌曲拉黑成功 */
#define MIGTIP_HATE_SONG_SUCCEED                @"歌曲拉黑成功:)"

/* 歌曲拉黑失败 */
#define MIGTIP_HATE_SONG_FAILED                 @"歌曲拉黑失败:("

/* 歌曲收藏成功 */
#define MIGTIP_COLLECT_SONG_SUCCEED             @"歌曲收藏成功:)"

/* 歌曲收藏失败 */
#define MIGTIP_COLLECT_SONG_FAILED              @"歌曲收藏失败:("

/* 分享新浪微博成功 */
#define MIGTIP_SHARE_TO_SINA_WEIBO_SUCCEED      @"分享新浪微博成功～"

/* 分享新浪微博失败 */
#define MIGTIP_SHARE_TO_SINA_WEIBO_FAILED       @"分享新浪微博失败了～"

/* 分享QQ成功 */
#define MIGTIP_SHARE_TO_QQ_SUCCEED              @"发表说说成功～"

/* 分享QQ失败 */
#define MIGTIP_SHARE_TO_QQ_FAILED               @"发表说说失败了～"

/* 拒绝搭讪 */
#define MIGTIP_REJECT_SAY_HELLO                 @"对方拒绝您的搭讪"

/* 拒绝送歌 */
#define MIGTIP_REJECT_SEND_SONG                 @"对方拒绝你的歌曲了"

/* 没有输入内容 */
#define MIGTIP_NO_CONTENT                       @"您还没有输入任何字哦"

/* 达到送歌数量限制 */
#define MIGTIP_1INT_REACH_MAX_SEND_SONG         @"对不起，最多只能送%d首歌哦~~~"

/* 分享成功 */
#define MIGTIP_SHARING_SUCCEED                  @"分享成功~~~"

/* 分享失败 */
#define MIGTIP_SHARING_FAILED                   @"网络似乎有问题，请稍后再试-_-#"

/* 选择一首歌 */
#define MIGTIP_CHOOSE_ONE_SONG                  @"请选择一首歌"

/* 新浪微博分享词 */
#define MIGTIP_WEIBO_SHARE_TEXT_4S              @"分享一首[%@]单曲, <%@ - %@>(来自@咪哟miyo)(#听对的音乐遇见对的人#)试听下载地址%@"

/* 确定 */
#define MIGTIP_OK                               @"确定"

/* 取消 */
#define MIGTIP_CANCEL                           @"取消"

/* 警告 */
#define MIGTIP_WARNING                          @"Warning"

/* 网络不稳定 */
#define MIGTIP_UNSTABLE_NETWORK                 @"您的网络好像不稳定哦~~~"

/* 没有打开定位服务 */
#define MIGTIP_LOCATION_CLOSE                   @"赶快打开定位服务，来体验极致酷炫的功能吧~~~"

/* 没有安装微信 */
#define MIGTIP_NOT_FOUND_WEIXIN                 @"您还没有安装微信，无法使用此功能，请先下载"

/* 微信版本过低 */
#define MIGTIP_WEIXIN_OUT_OF_DATE               @"您当前的微信版本过低，无法支持此功能，请更新微信至最新版本"

/* 咪哟标语 */
#define MIGTIP_THE_GOAL                         @"咪哟...\n对的地方，对的时刻\n听对的音乐，遇见对的人"

/* 微信分享地址 */
#define SHARE_WEIXIN_ADDRESS_1LONG              @"http://weixin.share.miyomate.com?songid=%lld&from=1&isappinstalled=1"

/* QQ空间分享地址 */
#define SHARE_QQZONE_ADDRESS_1LONG              @"http://qzone.share.miyomate.com/?songid=%lld&from=timeline&isappinstalled=1"

/* 微博分享地址 */
#define SHARE_WEIBO_ADDRESS_1LONG               @"http://weibo.share.miyomate.com/?songid=%lld"


/* --------------------- 地址定义 --------------------- */
#define URL_DEFAULT_HEADER_IMAGE                @"http://face.miu.miyomate.com/system.jpg"


/* --------------------- 消息定义 --------------------- */

/* 歌曲播放完毕，需要添加新的歌曲进来 */
#define NotificationNameNeedAddList             @"NotificationNameNeedAddList"

/* 用户从登录窗口登录成功 */
#define NotificationNameLoginSuccessByUser      @"NotificationNameLoginSuccessByUser"


/* 播放器实例事件 */
#define NotificationNamePlayerStart             @"NotificationNamePlayerStart"
#define NotificationNamePlayerStop              @"NotificationNamePlayerStop"
#define NotificationNamePlayerNext              @"NotificationNamePlayerNext"

/* 代码分支功能 */
#define USE_NEW_LOAD    1
#define USE_ARTIST_SONGNAME 0

/* ------------------ 宏函数定义 ---------------------- */
#define MIG_NOT_EMPTY_STR(x)                     (x && ![x isEqualToString:@""])

#endif
