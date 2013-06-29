//
//  Song.m
//  miglab_mobile
//
//  Created by apple on 13-6-27.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "Song.h"

@implementation Song

@synthesize songId = _songId;
@synthesize songName = _songName;
@synthesize artist = _artist;
@synthesize duration = _duration;
@synthesize songUrl = _songUrl;
@synthesize lrcUrl = _lrcUrl;
@synthesize coverUrl = _coverUrl;
@synthesize like = _like;

+(id)initWithNSDictionary:(NSDictionary *)dict{
    
    Song *song = nil;
    
    @try {
        
        song = [[Song alloc] init];
        song.songId = [[dict objectForKey:@""] longLongValue];
        song.songName = [dict objectForKey:@"songname"];
        song.artist = [dict objectForKey:@"artist"];
        song.duration = [dict objectForKey:@"duration"];
        song.songUrl = [dict objectForKey:@"songurl"];
        song.lrcUrl = [dict objectForKey:@"lrcurl"];
        song.coverUrl = [dict objectForKey:@"coverurl"];
        song.like = [dict objectForKey:@"like"];
        
    }
    @catch (NSException *exception) {
        NSLog(@"parser Song failed...please check");
    }
    
    return song;
}

@end
