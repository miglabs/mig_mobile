//
//  Channel.h
//  miglab_mobile
//
//  Created by Archer_LJ on 13-7-14.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Channel : NSObject

@property (nonatomic, retain) NSString* channelId; //频道id
@property (nonatomic, retain) NSString* channelName; //频道名称
@property (nonatomic, retain) NSString* channelPicUrl; //频道封面图片地址
@property (nonatomic, assign) int channelIndex;         //位置索引
//@property (nonatomic, assign) int typeid;
@property (nonatomic, assign) int typeindex;
//@property (nonatomic, assign) int moodid;
@property (nonatomic, assign) int moodindex;
//@property (nonatomic, assign) int sceneid;
@property (nonatomic, assign) int sceneindex;
@property (nonatomic, assign) int changenum;

+(id)initWithNSDictionary:(NSDictionary*)dict;
-(void)log;

@end
