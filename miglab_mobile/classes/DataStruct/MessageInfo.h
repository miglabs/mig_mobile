//
//  MessageInfo.h
//  miglab_mobile
//
//  Created by pig on 13-8-25.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUser.h"
#import "NearbyUser.h"
#import "Song.h"

@interface MessageInfo : NSObject

@property (nonatomic, assign) long long messageid;
@property (nonatomic, assign) int messagetype;      //1-打招呼，2-送歌曲，3-评论
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NearbyUser* userInfo;
@property (nonatomic, retain) Song* song;
@property (nonatomic, retain) NSString* songid;
@property (nonatomic, retain) NSString* send_uid;
@property (nonatomic, retain) NSString* to_uid;
@property (nonatomic, retain) NSString* time;

+(id)initWithNSDictionary:(NSDictionary*)dict;
-(void)log;

@end
