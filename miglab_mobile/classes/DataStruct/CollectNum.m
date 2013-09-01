//
//  CollectNum.m
//  miglab_mobile
//
//  Created by Archer_LJ on 13-8-31.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "CollectNum.h"

@implementation CollectNum

@synthesize mynum = _mynum;
@synthesize nearnum = _nearnum;

+(id)initWithNSDictionary:(NSDictionary *)dict {
    
    CollectNum* cn = nil;
    
    @try {
        
        if(dict && [dict isKindOfClass:[NSDictionary class]]) {
            
            cn = [[CollectNum alloc] init];
            cn.mynum = [[dict objectForKey:@"mynum"] intValue];
            cn.nearnum = [[dict objectForKey:@"nearnum"] intValue];
        }
    }
    @catch (NSException *exception) {
        
        PLog(@"parser collect file failed");
    }
    
    return cn;
}

-(void)log {
    
    PLog(@"Print CollectNum: mynum(%d), nearnum(%d)", _mynum, _nearnum);
}

@end
