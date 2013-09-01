//
//  Mood.m
//  miglab_mobile
//
//  Created by apple on 13-7-31.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "Mood.h"

@implementation Mood

@synthesize day = _day;
@synthesize typeid = _typeid;
@synthesize name = _name;
@synthesize moodIndex = _moodIndex;

//心情
+(id)initWithNSDictionary:(NSDictionary*)dict{
    
    Mood *mood = nil;
    
    @try {
        
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            
            mood = [[Mood alloc] init];
            mood.day = [[dict objectForKey:@"day"] intValue];
            mood.typeid = [[dict objectForKey:@"typeid"] intValue];
            mood.name = [dict objectForKey:@"name"];
            
        }
    }
    @catch (NSException *exception) {
        PLog(@"parser Mood failed...");
    }
    
    return mood;
}

-(void)log{
    
    PLog(@"Print Mood: day(%d), typeid(%d), name(%@), moodIndex(%d)", _day, _typeid, _name, _moodIndex);
    
}

@end
