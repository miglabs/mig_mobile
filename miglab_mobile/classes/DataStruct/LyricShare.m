//
//  LyricShare.m
//  miglab_mobile
//
//  Created by Archer_LJ on 14-8-16.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import "LyricShare.h"

@implementation LyricShare

+(id)initWithNSDictionary:(NSDictionary *)dict {
    
    LyricShare *ls = nil;
    
    @try {
        
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            
            ls = [[LyricShare alloc] init];
            
            ls.songId = [dict objectForKey:@"id"];
            ls.lyric = [dict objectForKey:@"lyric"];
            ls.weather = [dict objectForKey:@"weather"];
            ls.temprature = [dict objectForKey:@"temp"];
            ls.address = [dict objectForKey:@"address"];
        }
    }
    @catch (NSException *exception) {
        
        PLog(@"parser lyric share structure failed...");
    }
    
    return ls;
}

@end
