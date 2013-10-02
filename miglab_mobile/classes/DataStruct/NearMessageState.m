//
//  NearMessageState.m
//  miglab_mobile
//
//  Created by Archer_LJ on 13-10-2.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "NearMessageState.h"

@implementation NearMessageState

@synthesize user = _user;
@synthesize msg = _msg;

+(id)initWithNSDictionary:(NSDictionary *)dict {
    
    NearMessageState* nms = nil;
    
    @try {
        
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            
            nms = [[NearMessageState alloc] init];
            
            nms->_user = [dict objectForKey:@"user"];
            nms->_msg = [dict objectForKey:@"msg"];
        }
    }
    @catch (NSException *exception) {
        
        PLog(@"parser NearMessageState failed...");
    }
    
    return nms;
}

-(void)log {
    
    [_user log];
    //[_msg log];
}

@end
