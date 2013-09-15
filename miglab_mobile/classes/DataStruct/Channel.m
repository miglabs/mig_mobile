//
//  Channel.m
//  miglab_mobile
//
//  Created by Archer_LJ on 13-7-14.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "Channel.h"

@implementation Channel

@synthesize channelId = _channelId;
@synthesize channelName = _channelName;
@synthesize channelPicUrl = _channelPicUrl;
@synthesize channelIndex = _channelIndex;
//@synthesize typeid = _typeid;
@synthesize typeindex = _typeindex;
//@synthesize moodid = _moodid;
@synthesize moodindex = _moodindex;
//@synthesize sceneid = _sceneid;
@synthesize sceneindex = _sceneindex;
@synthesize changenum = _changenum;

+(id)initWithNSDictionary:(NSDictionary *)dict {
    
    Channel* channel = nil;
    
    @try {
        if( dict && [dict isKindOfClass:[NSDictionary class]] ) {
            
            channel = [[Channel alloc] init];
            channel.channelId = [dict objectForKey:@"id"];
            channel.channelName = [dict objectForKey:@"name"];
            channel.channelPicUrl = [dict objectForKey:@"pic"];
            
        }
    }
    @catch (NSException *exception) {
        
        PLog(@"parser Channel failed ... ");
        
    }
    
    return channel;
    
}

-(void)log{
    
//    PLog(@"Print Channel: channelId(%@), channelName(%@), channelPicUrl(%@), channelIndex(%d), typeid(%d), typeindex(%d), moodid(%d), moodindex(%d), sceneid(%d), sceneindex(%d)", _channelId, _channelName, _channelPicUrl, _channelIndex, _typeid, _typeindex, _moodid, _moodindex, _sceneid, _sceneindex);
    PLog(@"Print Channel: channelId(%@), channelName(%@), channelPicUrl(%@), channelIndex(%d), typeid(%d), typeindex(%d), moodid(%d), moodindex(%d), sceneid(%d), sceneindex(%d)", _channelId, _channelName, _channelPicUrl, _channelIndex, _typeindex, _typeindex, _moodindex, _moodindex, _sceneindex, _sceneindex);
    
}

@end
