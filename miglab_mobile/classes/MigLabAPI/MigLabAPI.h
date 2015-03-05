//
//  MigLabAPI.h
//  miglab_mobile
//
//  Created by pig on 13-6-23.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Song.h"
#import "Channel.h"
#import "Word.h"
#import "Mood.h"
#import "NearbyUser.h"
#import "ConfigFileInfo.h"
#import "CollectNum.h"
#import "SongComment.h"
#import "MessageInfo.h"
#import "apidefine.h"
#import "Barray.h"

//source（注册来源）：0,来源自身 1,来源于新浪微博 2,来源于腾讯微博 3,来源于QQ空间
typedef enum {
    SourceTypeMiglab = 0,
    SourceTypeSinaWeibo = 1,
    SourceTypeTencentWeibo = 2,
    SourceTypeTencentQQZone = 3,
    SourceTypeDouBan = 4
} SourceType;

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

/*
 获取用户信息
 */
-(void)doGetUserInfo:(NSString *)tUserName accessToken:(NSString *)tAccessToken;

/*
 注册用户信息
 */
-(void)doRegister:(NSString*)tusername password:(NSString*)tpassword nickname:(NSString*)tnickname source:(SourceType)tsourcetype session:(NSString*)tsession sex:(NSString*)tsex birthday:(NSString*)tbirthday location:(NSString*)tlocation head:(NSString*)thead;
-(void)doRegister:(NSString*)tusername password:(NSString*)tpassword nickname:(NSString*)tnickname source:(SourceType)tsourcetype session:(NSString*)tsession sex:(NSString*)tsex;
-(void)doRegister:(NSString*)tusername password:(NSString*)tpassword nickname:(NSString*)tnickname source:(SourceType)tsourcetype;

/*
 生成游客信息
 */
-(void)doGetGuestInfo;

/*
 更新用户信息
 */
-(void)doUpdateUserInfo:(NSString*)tuid token:(NSString*)ttoken nickname:(NSString*)tnickname gender:(NSString*)tgender birthday:(NSString*)tbirthday;
-(void)doUpdateUserInfoNickName:(NSString*)tuid token:(NSString*)ttoken nickname:(NSString*)tnickname;
-(void)doUpdateUserInfoGender:(NSString*)tuid token:(NSString*)ttoken gender:(NSString*)tgender;
-(void)doUpdateUserInfoBirthday:(NSString*)tuid token:(NSString*)ttoken birthday:(NSString*)tbirthday;


/************************* 歌曲 ****************************/
/*
 获取心情，场景歌曲(verified, 2013-08-28)
 */
-(void)doGetModeMusic:(NSString*)uid token:(NSString*)ttoken wordid:(NSString*)twordid mood:(NSString*)tmood num:(int)tnum;
-(void)doGetModeMusic:(NSString*)uid token:(NSString*)ttoken wordid:(NSString*)twordid mood:(NSString*)tmood;

/*
 获取频道的歌曲(verified, 2013-08-28)
 */
-(void)doGetMusicFromChannel:(NSString*)uid token:(NSString*)ttoken channel:(int)tchannel;

/*
 获取收藏的歌曲(verified, 2013-08-23)
 */
-(void)doGetCollectedSongs:(NSString*)uid token:(NSString*)ttoken taruid:(NSString*)ttaruid;

/*
 获取默认推荐歌曲歌曲(is this getdefsongs?)
 */
-(void)doGetDefaultMusic:(NSString*)ttype token:(NSString*)ttoken uid:(int)tuid;

/*
 非注册用户获取播放列表（verified, 2013-08－28）
 */
-(void)doGetDefaultGuestSongs;

/*
 获取豆瓣频道歌曲(verified, 2013-08-28)
 */
-(void)doGetDoubanChannelSong:(NSString*)uid token:(NSString*)ttoken channel:(NSString*)tchannel;

/*
 通过整体维度获取音乐(verified, 2013-08-28)
 */
-(void)doGetTypeSongs:(NSString*)uid token:(NSString*)ttoken typeid:(NSString *)ttypeid typeindex:(NSString *)ttypeindex moodid:(NSString*)tmoodid moodindex:(NSString*)tmoodindex sceneid:(NSString*)tsceneid sceneindex:(NSString*)tsceneindex channelid:(NSString*)tchannelid channelindex:(NSString*)tchannelindex num:(NSString*)tnum;

/*
 提交本地歌曲信息(verified, 2013-08-28)
 */
-(void)doRecordLocalSongs:(NSString*)uid token:(NSString*)ttoken source:(NSString*)tsource urlcode:(NSString*)turlcode name:(NSString*)tname content:(NSString*)tcontent;
-(void)doRecordLocalSongsSingle:(NSString*)uid token:(NSString*)ttoken source:(NSString*)tsource urlcode:(NSString*)turlcode name:(NSString*)tname song:(Song*)tsong;
-(void)doRecordLocalSongsArray:(NSString*)uid token:(NSString*)ttoken source:(NSString*)tsource urlcode:(NSString*)turlcode name:(NSString*)tname songs:(NSArray*)tsongs;

/*
 记录用户试听歌曲状态
 */
-(void)doRecordCurrentSong:(NSString*)uid token:(NSString*)ttoken lastsong:(NSString*)tlastsong cursong:(NSString*)tcursong mode:(NSString*)tmode typeid:(NSString*)ttypeid name:(NSString*)tname singer:(NSString*)tsinger state:(NSString*)tstate;

/*
 更新音乐纬度配置文件
 */
-(void)doUpdateConfigfile:(NSString*)uid token:(NSString*)ttoken version:(NSString*)tversion;

/*
 添加红心歌曲
 */
-(void)doCollectSong:(NSString*)uid token:(NSString*)ttoken sid:(NSString*)tsid modetype:(NSString*)tmodetype typeid:(NSString*)ttypeid;

/*
 歌曲拉黑
 */
-(void)doHateSong:(NSString*)uid token:(NSString *)ttoken sid:(long)tsid;

/*
 获取收藏歌曲数量和附近人收藏数量
 */
-(void)doCollectAndNearNum:(NSString*)uid token:(NSString*)ttoken taruid:(NSString*)ttaruid radius:(NSString*)tradius pageindex:(NSString*)tpageindex pagesize:(NSString*)tpagesize location:(NSString*)tlocation;

/*
 删除收藏歌曲
 */
-(void)doDeleteCollectedSong:(NSString*)uid token:(NSString *)ttoken songid:(NSString*)tsongid;

/*
 获取歌曲信息
 */
-(void)doGetSongInfo:(NSString*)uid token:(NSString*)ttoken songid:(NSString*)tsongid;

/*
 获取用户听歌记录(及红心歌单)
 */
-(void)doGetSongHistory:(NSString*)uid token:(NSString*)ttoken fromid:(NSString*)tfromid count:(NSString*)tcount;

/****************************************推送接口*******************************************/


/****************************************社交接口*******************************************/

/*
 设置用户位置 (2013-7-22)
 */
-(void)doSetUserPos:(NSString*)uid token:(NSString*)ttoken location:(NSString *)tlocation;

/*
 查找附近的人 (2013-7-22)
 */
-(void)doSearchNearby:(NSString*)uid token:(NSString*)ttoken location:(NSString *)tlocation radius:(int)tradius;

/*
 赠送歌曲
 */
-(void)doPresentMusic:(NSString *)uid token:(NSString*)ttoken touid:(NSString *)ttouid sid:(NSArray*)tsid;

/*
 附近人的音乐
 */
-(void)doGetNearMusic:(NSString*)uid token:(NSString*)ttoken radius:(NSString*)tradius pageindex:(NSString*)tpageindex pagesize:(NSString*)tpagesize location:(NSString*)tlocation;

/*
 评论歌曲
 */
-(void)doCommentSong:(NSString*)uid token:(NSString*)ttoken songid:(NSString*)tsongid comment:(NSString*)tcomment;
/*
 评论歌曲
 */
-(void) doCommentSong:(NSString*)uid token:(NSString*)ttoken songid:(NSString*)tsongid ttype:(NSString*)type ttypeid:(NSString*) tid comment:(NSString*)tcomment;
/*
 获取歌曲评论
 */
-(void)doGetSongComment:(NSString*)uid token:(NSString*)ttoken songid:(NSString*)tsongid count:(NSString*)tcount fromid:(NSString*)tfromid;

/*
 获取周围谁在听你的歌及消息
 */
-(void)doGetMyNearMusicMsgNumber:(NSString*)uid token:(NSString*)ttoken radius:(NSString*)tradius location:(NSString*)tlocation;

/*
 获取周围谁在听你红心的歌曲
 获取周围的人及歌曲
 */
-(void)doGetSameMusic:(NSString*)uid token:(NSString*)ttoken radius:(NSString*)tradius location:(NSString*)tlocation;
-(void)doGetNearUser:(NSString*)uid token:(NSString*)ttoken radius:(NSString*)tradius location:(NSString*)tlocation;

/*
 打招呼
 */
-(void)doSayHello:(NSString*)uid token:(NSString*)ttoken touid:(NSString*)ttouid msg:(NSString*)tmsg;

/*
 获取推送消息
 */
-(void)doGetPushMsg:(NSString*)uid token:(NSString*)ttoken pageindex:(NSString*)tpageindex pagesize:(NSString*)tpagesize;

/*
 获取歌友
 */
-(void)doGetMusicUser:(NSString*)uid token:(NSString*)ttoken fromid:(NSString*)tfromid count:(NSString*)tcount;

/****************************************保留接口*******************************************/


/*
 分享歌曲
 */
-(void)doShareMusic:(NSString *)uid token:(NSString*)ttoken sid:(long)tsid platform:(int)tplatform;

/*
 上传本地歌曲信息
 */
-(void)doUploadMusic:(NSString *)uid token:(NSString*)ttoken sid:(long)tsid enter:(int)tenter urlcode:(int)turlcode content:(long)tcontent;

/*
 获取附近的人
 */
-(void)doGetNearbyUser:(NSString *)uid token:(NSString*)ttoken page:(int)tpage;

/*
 获取某个用户歌单
 */
-(void)doGetListFromUser:(NSString *)uid sid:(long)tsid token:(NSString*)ttoken;

/*
 获取用户正在听的歌曲
 */
-(void)doGetPlayingMusicFromUser:(NSString *)uid token:(NSString*)ttoken begin:(int)tbegin page:(int)tpage;

/*
 获取频道目录
 */
-(void)doGetChannel:(NSString*)uid token:(NSString*)ttoken num:(int)tnum;

/*
 获取心情词描述 20130723 by pig
 */
-(void)doGetWorkOfMood:(NSString*)uid token:(NSString*)ttoken;

/*
 获取场景词描述 20130723 by pig
 */
-(void)doGetWorkOfScene:(NSString*)uid token:(NSString*)ttoken;

/*
 获取心绪地图
 */
-(void)doGetMoodMap:(NSString *)uid token:(NSString *)ttoken;

/*
 获取心绪类别名称
 */
-(void)doGetMoodParent:(NSString *)uid token:(NSString *)ttoken;

/*
 提交用户当前状态
 */
-(void)doAddMoodRecord:(NSString*)uid token:(NSString*)ttoken wordid:(int)twordid songid:(long long)tsongid;

/*
 设置推送配置
 */
-(void)doConfigPush:(NSString*)uid token:(NSString*)ttoken devicetoken:(NSString*)tdevicetoken isreceive:(NSString*)tisreceive begintime:(NSString*)tbegintime endtime:(NSString*)tendtime;

/*
 获取歌词分享信息
 */
-(void)doGetShareInfo:(NSString*)uid token:(NSString*)ttoken songid:(NSString*)tsongid type:(NSString*)ttype mode:(NSString *)tmode index:(NSString *)tindex latitude:(NSString*)tlatitude longitude:(NSString*)tlongitude;


/*
 获取最空闲的聊天地址
 
*/
-(void) doGetSC:(int64_t)platformid uid:(int64_t)tuid  tid:(int64_t) ttid;

/*
 获取聊天记录
 
*/
-(void) doGetHisChat:(int64_t)platformid uid:(int64_t) tuid  tid:(int64_t) ttid token:(NSString*)ttoken minmsgid:(int64_t) tminmsgid;

/*
 返回分享结果
 */
-(void)doSendShareResult:(NSString*)uid token:(NSString*)ttoken plat:(NSString *)share_plat songid:(NSString*)tsongid;

/*
 提交百度推送信息
 */
-(void)doSendBPushInfo:(NSString*)uid token:(NSString*)ttoken channelid:(NSString*)tchannelid userid:(NSString*)tuserid tag:(NSString*)ttag pkg:(NSString*)tpkg machine:(NSString*) tmachine appid:(NSString*) tappid requestid:(NSString*) trequestid;

/*
 根据类别获取弹幕即评论内容
 */

-(void)doGetBarrayComm:(NSString*)uid ttoken:(NSString*)token ttype:(NSString*) type
        ttid:(NSString*) tid tmsgid:(NSString*) msgid tsongid:(NSString*) songid;

/*
 获取当前位置相关信息
 */

-(void)doGetLocation:(NSString*)uid ttoken:(NSString*) token tlatitude:(NSString*)latitude
    tlongitude:(NSString*)longitude;


/*
 第三方登陆
 */

-(void) doThirdLogin:(int) tmachine nickname:(NSString*)tnickname source:(SourceType)tsourcetype session:(NSString*)tsession imei:(NSString*) timei sex:(NSString*)tsex birthday:(NSString*)tbirthday location:(NSString*)tlocation head:(NSString*)thead latitude:(NSString*)tlatitude longitude:(NSString*)tlongitude;


/*
 登陆日志
 */

-(void) doLoginRecord:(NSString*)uid ttoken:(NSString*) token latitude:(NSString*)tlatitude longitude:(NSString*)tlongitude;
@end
