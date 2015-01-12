//
//  ChatNotification.h
//  miglab_chat
//
//  Created by 180 on 14-4-3.
//  Copyright (c) 2014年 180. All rights reserved.
//

#import <Foundation/Foundation.h>


enum ChatNotificationType
{
    FACEBOARD_SEND,//表情键盘发送
    FACEBOARD_SELECT,//表情键盘选中表情
    FACEBOARD_DEL,//表情键盘删除
    INPUTBOARD_CLOSE,//关闭系统或表情键盘
    CHATMESSAGE_SEND,//发送聊天消息
    CHATMESSAGE_RELOAD,//重新加载列表内的聊天消息
    CHATSERVER_CONNENT,//连接聊天服务器
    CHATSERVER_LOAD,//加载聊天内容选择最优服务端
    CHATSERVER_ONTUSERINFO,
    CHATSERVER_OPPINFO,
    CHATSERVER_JOIN,//加入聊天
    CHATSERVER_LOGIN,//登陆聊天
    CHATSERVER_QUITCHAT,//退出聊天
    CHATSERVER_QUITSRV,//通知聊天服务器退出
    TOUCH_SHOW_USERINFOS//点击头像显示个人信息
    
};

@interface ChatNotification : NSObject <NSCopying, NSCoding>

@property          id           object;
@property          NSInteger  type;

- (id)  init:(NSInteger) type obj:(id) object;
@end

@interface ChatNotification (NSNotificationCreation)
{
    
}
@end

@protocol ChatNotificationDelegate <NSObject>

-(void) onChatNotification:(ChatNotification*) notification;

@end

@interface ChatNotificationCenter : NSObject
+ (void) postNotification:(ChatNotification*) data;
+ (void) postNotification:(NSInteger) type obj:(id) obj;
+ (void) addObserver:(id)observer selector:(SEL)aSelector;
+ (void) removeObserver:(id)observer;

@property (nonatomic, assign) id<ChatNotificationDelegate> delegate;
- (id) init:(id) observer;
@end



