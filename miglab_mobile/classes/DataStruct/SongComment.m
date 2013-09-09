//
//  SongComment.m
//  miglab_mobile
//
//  Created by Archer_LJ on 13-9-9.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "SongComment.h"

@implementation SongComment

@synthesize songid = _songid;
@synthesize createdtime = _createdtime;
@synthesize cid = _cid;
@synthesize text = _text;
@synthesize user = _user;

+(id)initWithNSDictionary:(NSDictionary *)dict {
    
    SongComment* sc = nil;
    
    @try {
        
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            
            sc = [[SongComment alloc] init];
            
            sc.songid = [dict objectForKey:@"songid"];
            sc.createdtime = [dict objectForKey:@"createdtime"];
            sc.cid = [dict objectForKey:@"id"];
            sc.text = [dict objectForKey:@"text"];
            sc.user = [PUser initWithNSDictionary:[dict objectForKey:@"user"]];
        }
    }
    @catch (NSException *exception) {
        
        PLog(@"parser song comment failed");
    }
    
    return  sc;
}

@end
