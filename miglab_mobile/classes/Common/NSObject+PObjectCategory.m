//
//  NSObject+PObjectCategory.m
//  miglab_mobile
//
//  Created by pig on 13-6-30.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "NSObject+PObjectCategory.h"

@implementation NSObject (PObjectCategory)

+(id)checkDataIsNull:(id)obj{
    
    if ([obj isEqual:[NSNull null]]) {
        return nil;
    } else {
        
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *trimedString = [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([trimedString length] == 0) {
                return nil;
            }
            
        } else if ([obj isKindOfClass:[NSArray class]]) {
            if ([obj count] == 0) {
                return nil;
            }
        }
        
    }
    
    return obj;
}

@end
