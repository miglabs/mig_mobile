//
//  Channel.h
//  miglab_mobile
//
//  Created by Archer_LJ on 13-7-14.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Channel : NSObject

@property (nonatomic, assign) int channelId; //频道id
@property (nonatomic, retain) NSString* channelName; //频道名称
@property (nonatomic, retain) NSString* channelPicUrl; //频道封面图片地址

+(id)initWithNSDictionary:(NSDictionary*)dict;

@end
