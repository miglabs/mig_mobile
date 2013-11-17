//
//  MessageInfo.m
//  miglab_mobile
//
//  Created by pig on 13-8-25.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "MessageInfo.h"

@implementation MessageInfo

@synthesize messageid = _messageid;
@synthesize messagetype = _messagetype;
@synthesize content = _content;
@synthesize userInfo = _userInfo;
@synthesize song = _song;
@synthesize send_uid = _send_uid;
@synthesize to_uid = _to_uid;
@synthesize time = _time;
@synthesize songstat = _songstat;

+(id)initWithNSDictionary:(NSDictionary *)dict {
    
    MessageInfo* msginfo = nil;
    
    if(dict && [dict isKindOfClass:[NSDictionary class]]) {
        
        msginfo = [[MessageInfo alloc] init];
        
        NSDictionary* dicDetail = [dict objectForKey:@"detail"];
        
        msginfo.content = [dicDetail objectForKey:@"msg"];
        msginfo.send_uid = [dicDetail objectForKey:@"send_uid"];
        msginfo.to_uid = [dicDetail objectForKey:@"to_uid"];
        msginfo.songid = [dicDetail objectForKey:@"song_id"];
        msginfo.time = [dicDetail objectForKey:@"time"];
        msginfo.song = [Song initWithNSDictionary:[dicDetail objectForKey:@"music"]];
        msginfo.userInfo = [NearbyUser initWithNSDictionary:[dict objectForKey:@"userinfo"]];
        msginfo.songstat = [dicDetail objectForKey:@"songstat"];
        
        NSString* type = [dict objectForKey:@"type"];
        
        if([type isEqualToString:@"presentsong"]) {
            
            msginfo.messagetype = 2;
        }
        else if([type isEqualToString:@"sayhello"]) {
            
            msginfo.messagetype = 1;
        }
        else {
            
            msginfo.messagetype = -1;
        }
        
        msginfo.userInfo.songname = msginfo.song.songname;
        msginfo.userInfo.singer = msginfo.song.artist;
    }
    
    return msginfo;
}

@end
