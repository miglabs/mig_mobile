//
//  Scene.m
//  miglab_mobile
//
//  Created by Archer_LJ on 13-7-19.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "Scene.h"

@implementation Scene

@synthesize typeid = _typeid;
@synthesize name = _name;

+(id)initWithNSDictionary:(NSDictionary *)dict {
    
    Scene* scene = nil;
    
    @try {
        
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            
            scene = [[Scene alloc] init];
            
            scene.typeid = [dict objectForKey:@"typeid"];
            scene.name = [dict objectForKey:@"name"];
            
        }
    }
    @catch (NSException *exception) {
        
        PLog(@"parser Scene failed...");
        
    }
    
    return scene;
    
}

@end
