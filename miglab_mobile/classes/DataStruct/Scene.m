//
//  Scene.m
//  miglab_mobile
//
//  Created by pig on 13-8-18.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "Scene.h"

@implementation Scene

@synthesize typeid = _typeid;
@synthesize name = _name;
@synthesize sceneIndex = _sceneIndex;
@synthesize picname = _picname;
@synthesize desc = _desc;
@synthesize changenum = _changenum;

//场景
+(id)initWithNSDictionary:(NSDictionary*)dict{
    
    Scene *scene = nil;
    
    @try {
        
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            
            scene = [[Scene alloc] init];
            scene.typeid = [[dict objectForKey:@"typeid"] intValue];
            scene.name = [dict objectForKey:@"name"];
            
        }
    }
    @catch (NSException *exception) {
        PLog(@"parser Scene failed...");
    }
    
    return scene;
}

-(void)log{
    
    PLog(@"Print Scene: typeid(%d), name(%@), sceneIndex(%d), picname(%@), desc(%@)", _typeid, _name, _sceneIndex, _picname, _desc);
    
}

@end
