//
//  NearMusicState.m
//  miglab_mobile
//
//  Created by Archer_LJ on 13-9-7.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "NearMusicState.h"

@implementation NearMusicState

@synthesize nearuser = _nearuser;
@synthesize song = _song;
@synthesize songstate = _songstate;

+(id)initWithNSDictionary:(NSDictionary *)dict {
    
    NearMusicState* nms = nil;
    
    @try {
        
        if(dict && [dict isKindOfClass:[NSDictionary class]]) {
            
            nms = [[NearMusicState alloc] init];
            
            nms->_songstate = [[dict objectForKey:@"songstat"] intValue];
            nms->_song = [Song initWithNSDictionary:[dict objectForKey:@"music"]];
            nms->_nearuser = [NearbyUser initWithNSDictionary:[dict objectForKey:@"users"]];
        }
    }
    @catch (NSException *exception) {
        
        PLog(@"parser NearMusicState failed...");
    }
    
    return nms;
}

-(void)log {
    
    PLog(@"Print NearMusicState: songstat(%d)", _songstate);
    [_song log];
    [_nearuser log];
}

@end
