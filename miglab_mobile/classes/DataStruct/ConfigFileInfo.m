//
//  ConfigFileInfo.m
//  miglab_mobile
//
//  Created by Archer_LJ on 13-8-28.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "ConfigFileInfo.h"

@implementation ConfigFileInfo

@synthesize version = _version;
@synthesize url = _url;
@synthesize filename = _filename;

+(id)initWithNSDictionary:(NSDictionary*)dict {
    
    ConfigFileInfo* cfi = nil;
    
    @try {
        
        if(dict && [dict isKindOfClass:[NSDictionary class]]) {
            
            cfi.version = [dict objectForKey:@"version"];
            cfi.url = [dict objectForKey:@"url"];
            cfi.filename = [dict objectForKey:@"filename"];
        }
    }
    @catch (NSException *exception) {
        
        PLog(@"parser config file failed .........");
    }
    
    return cfi;
}

@end
