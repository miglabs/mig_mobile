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

/* UITableView 默认宽度 */
#define ORIGIN_WIDTH                            297

/* UITableViewCell 默认高度 */
#define CELL_HEIGHT                             57

/* 推荐歌曲的UITableViewCell高度 */
#define RECOMMAND_CELL_HEIGHT                   125

/* 底部播放器高度 */
#define BOTTOM_PLAYER_HEIGHT                    73

/* 搜索范围默认距离 */
#define SEARCH_DISTANCE                         10000000

/* 赠送歌曲的默认数量限制 */
#define MAX_PRESENT_SONG_COUNT                  3

/* 打招呼的字数限制 */
#define MAX_SAYHI_COUNT                         30

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



/* 性别 */
#define STR_MALE                                @"1"
#define STR_FEMALE                              @"0"

/* 用户来源 */
#define STR_USER_SOURCE_MIG                     @"0"
#define STR_USER_SOURCE_SINA                    @"1"
#define STR_USER_SOURCE_QQ                      @"2"
#define STR_USER_SOURCE_WEIXIN                  @"3"
#define STR_USER_SOURCE_DOUBAN                  @"4"



/* 默认推荐语 */
#define MIGTIP_DEFAULT_RECOMMAND                @"来听听嘛~"

/* 未登录提示语 */
#define MIGTIP_UNLOGIN                          @"您还没有登录哦~~~"

/* 正在发送提示语 */
#define MIGTIP_SENDING_MESSAGE                  @"正在发送消息哦~~~"

/* 空邮箱提示语 */
#define MIGTIP_EMPTY_EMAIL                      @"邮箱不能为空哦~~~"

/* 错误邮箱格式 */
#define MIGTIP_WRONG_EMAIL_FMT                  @"邮箱格式错误"

/* 空密码提示语 */
#define MIGTIP_EMPTY_PASSWORD                   @"密码不能为空哦~~~"

/* 加载提示语 */
#define MIGTIP_LOADING                          @"加载中..."

/* 修改昵称失败提示语 */
#define MIGTIP_ERROR_CHANGE_NICKNAME            @"修改昵称失败，该昵称可能已被占用..."

/* 修改昵称成功提示语 */
#define MIGTIP_CHANGE_NICKNAME_SUCCESS          @"修改昵称成功啦~~~"

/* 确定 */
#define MIGTIP_OK                               @"确定"

/* 取消 */
#define MIGTIP_CANCEL                           @"取消"


/* --------------------- 地址定义 --------------------- */
#define URL_DEFAULT_HEADER_IMAGE                @"http://face.miu.miglab.com/default.jpg"


/* --------------------- 消息定义 --------------------- */

/* 歌曲播放完毕，需要添加新的歌曲进来 */
#define NotificationNameNeedAddList             @"NotificationNameNeedAddList"

/* 用户从登录窗口登录成功 */
#define NotificationNameLoginSuccessByUser      @"NotificationNameLoginSuccessByUser"


/* 播放器实例事件 */
#define NotificationNamePlayerStart             @"NotificationNamePlayerStart"
#define NotificationNamePlayerStop              @"NotificationNamePlayerStop"
#define NotificationNamePlayerNext              @"NotificationNamePlayerNext"

#endif
