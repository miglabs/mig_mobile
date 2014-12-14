//
//  ChatMsg.h
//  miglab_chat
//
//  Created by 180 on 14-4-1.
//  Copyright (c) 2014年 180. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatDef.h"
#include<stdio.h>
#include<stdint.h>

@interface ChatUserInfo : NSObject
@property (nonatomic) int64_t uid;
@property (nonatomic) int64_t nicknumber;
@property (nonatomic, copy) NSString* nickname;
@property (nonatomic, copy) NSString* picurl;
@end

@interface ChatMsg : NSObject
@property (nonatomic)       int64_t         send_user_id;
@property (nonatomic)       int64_t         recv_user_id;
@property (nonatomic)       int64_t         msg_id;
@property (nonatomic)       BOOL            iscurrentusersend;
@property (nonatomic)       BOOL            isNeedShowTime;
@property (nonatomic, copy) NSString*       send_nickname;
@property (nonatomic, copy) NSString*       timeInterval;
@property (nonatomic, copy) NSString*       msg_content;
@property (nonatomic, copy) NSString*       msg_time;
@property (nonatomic)       ChatUserInfo*   send_user_info;

-(id) init;
-(id) init:(NSDictionary *)dic;
-(id) init:(NSString*) msg send_id:(int64_t) send_id recv_id:(int64_t) recv_id msg_id:(int64_t) msg_id;
-(id) init:(NSString*) msg send_nickname:(NSString*) nickname send_id:(int64_t) send_id recv_id:(int64_t) recv_id msg_id:(int64_t) msg_id;

#ifndef NEW_MSGVIEW
-(NSArray*) getMsg;
-(CGSize) getViewSize;
#endif
@end

