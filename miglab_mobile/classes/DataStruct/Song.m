//
//  Song.m
//  miglab_mobile
//
//  Created by apple on 13-6-27.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "Song.h"

@implementation Song

@synthesize songid = _songid;
@synthesize songname = _songname;
@synthesize artist = _artist;
@synthesize duration = _duration;
@synthesize songurl = _songurl;
@synthesize lrcurl = _lrcurl;
@synthesize coverurl = _coverurl;
@synthesize like = _like;

@synthesize songCachePath = _songCachePath;

@synthesize whereIsTheSong = _whereIsTheSong;

+(id)initWithNSDictionary:(NSDictionary *)dict{
    
    Song *song = nil;
    
    @try {
        
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            
            song = [[Song alloc] init];
            song.songid = [[dict objectForKey:@"songid"] longLongValue];
            song.songname = [dict objectForKey:@"songname"];
            song.artist = [dict objectForKey:@"artist"];
            song.duration = [dict objectForKey:@"duration"];
            song.songurl = [dict objectForKey:@"songurl"];
            song.lrcurl = [dict objectForKey:@"lrcurl"];
            song.coverurl = [dict objectForKey:@"coverurl"];
            song.like = [dict objectForKey:@"like"];
            
        }
        
    }
    @catch (NSException *exception) {
        PLog(@"parser Song failed...please check");
    }
    
    return song;
}

@end
