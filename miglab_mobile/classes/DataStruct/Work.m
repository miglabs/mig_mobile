//
//  Work.m
//  miglab_mobile
//
//  Created by apple on 13-7-23.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "Work.h"

@implementation Work

@synthesize index = _index;
@synthesize typeid = _typeid;
@synthesize name = _name;
@synthesize workMode = _workMode;

+(id)initWithNSDictionary:(NSDictionary *)dict {
    
    Work *work = nil;
    
    @try {
        
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            
            work = [[Work alloc] init];
            work.index = [[dict objectForKey:@"index"] intValue];
            work.typeid = [[dict objectForKey:@"typeid"] intValue];
            work.name = [dict objectForKey:@"name"];
            
        }
    }
    @catch (NSException *exception) {
        PLog(@"parser Work failed...");
    }
    
    return work;
    
}

-(void)log{
    
    PLog(@"Print Work: index(%d), typeid(%d), name(%@), workMode(%@)", _index, _typeid, _name, _workMode);
    
}

@end
