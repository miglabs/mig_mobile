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
@synthesize typeid = _typeid;
@synthesize moodid = _moodid;
@synthesize sceneid = _sceneid;

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
    
    PLog(@"Print Channel: channelId(%@), channelName(%@), channelPicUrl(%@), channelIndex(%d), typeid(%d), moodid(%d), sceneid(%d)", _channelId, _channelName, _channelPicUrl, _channelIndex, _typeid, _moodid, _sceneid);
    
}

@end
