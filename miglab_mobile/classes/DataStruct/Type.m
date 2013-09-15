//
//  Type.m
//  miglab_mobile
//
//  Created by pig on 13-8-18.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "Type.h"

@implementation Type

@synthesize typeid = _typeid;
@synthesize name = _name;
@synthesize typeIndex = _typeIndex;
@synthesize picname = _picname;
@synthesize desc = _desc;
@synthesize changenum = _changenum;

//类别
+(id)initWithNSDictionary:(NSDictionary*)dict{
    
    Type *type = nil;
    
    @try {
        
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            
            type = [[Type alloc] init];
            type.typeid = [[dict objectForKey:@"typeid"] intValue];
            type.name = [dict objectForKey:@"name"];
            
        }
    }
    @catch (NSException *exception) {
        PLog(@"parser Type failed...");
    }
    
    return type;
}

-(void)log{
    
    PLog(@"Print Type: typeid(%d), name(%@), typeIndex(%d), picname(%@), desc(%@)", _typeid, _name, _typeIndex, _picname, _desc);
    
}

@end
