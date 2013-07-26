//
//  Word.m
//  miglab_mobile
//
//  Created by pig on 13-7-25.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "Word.h"

@implementation Word

@synthesize index = _index;
@synthesize typeid = _typeid;
@synthesize name = _name;
@synthesize mode = _mode;

+(id)initWithNSDictionary:(NSDictionary *)dict {
    
    Word *word = nil;
    
    @try {
        
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            
            word = [[Word alloc] init];
            word.index = [[dict objectForKey:@"index"] intValue];
            word.typeid = [[dict objectForKey:@"typeid"] intValue];
            word.name = [dict objectForKey:@"name"];
            
        }
    }
    @catch (NSException *exception) {
        PLog(@"parser Word failed...");
    }
    
    return word;
    
}

-(void)log{
    
    PLog(@"Print Word: index(%d), typeid(%d), name(%@), mode(%@)", _index, _typeid, _name, _mode);
    
}

@end
