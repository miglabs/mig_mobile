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
@synthesize poi = _poi;
@synthesize send_uid = _send_uid;
@synthesize to_uid = _to_uid;
@synthesize time = _time;
@synthesize songstat = _songstat;

+(id)initWithNSDictionary:(NSDictionary *)dict {
    
    MessageInfo* msginfo = nil;
    
    if(dict && [dict isKindOfClass:[NSDictionary class]]) {
        
        msginfo = [[MessageInfo alloc] init];
        
        NSDictionary* dicDetail = [dict objectForKey:@"detail"];
        
        msginfo.song = [Song initWithNSDictionary:[dict objectForKey:@"music"]];
        msginfo.userInfo = [NearbyUser initWithNSDictionary:[dict objectForKey:@"userinfo"]];
        msginfo.poi = [PoiInfo initWithNSDictionary:[dict objectForKey:@"poi"]];
        msginfo.songstat = [dict objectForKey:@"songstat"];
        
        /* 根据字符串获取类型 */
        NSString* type = [dict objectForKey:@"type"];
        
        if([type isEqualToString:@"presentsong"]) {
            
            msginfo.messagetype = 2;
        }
        else if([type isEqualToString:@"sayhello"]) {
            
            msginfo.messagetype = 1;
        }
        else if ([type isEqualToString:@"leavemsg"]) {
            msginfo.messagetype = 3;
        }
        else {
            
            msginfo.messagetype = -1;
        }
        
        /* 其他自定义格式信息，根据接口不同，需要的值不同 */
        msginfo.content = [dicDetail objectForKey:@"msg"];
        msginfo.send_uid = [dicDetail objectForKey:@"send_uid"];
        msginfo.to_uid = [dicDetail objectForKey:@"to_uid"];
        msginfo.songid = [dicDetail objectForKey:@"song_id"];
        msginfo.time = [dicDetail objectForKey:@"time"];
        
        msginfo.userInfo.songname = msginfo.song.songname;
        msginfo.userInfo.singer = msginfo.song.artist;
    }
    
    return msginfo;
}

-(void)log {
    
    
}

@end
