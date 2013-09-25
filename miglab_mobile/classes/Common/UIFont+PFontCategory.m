//
//  UIFont+PFontCategory.m
//  miglab_mobile
//
//  Created by apple on 13-9-25.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "UIFont+PFontCategory.h"

@implementation UIFont (PFontCategory)

+(UIFont *)fontName:(NSString *)fontName size:(CGFloat)fontSize{
    return [UIFont fontWithName:fontName size:fontSize];
}

+(UIFont *)fontOfSystem:(CGFloat)fontSize{
    return [UIFont systemFontOfSize:fontSize];
}

+(UIFont *)fontWithType:(PFontType)pFontType{
    
    if (pFontType == PFontTypeNormal0) {
        return [UIFont systemFontOfSize:14.0f];
    }
    
    return [UIFont systemFontOfSize:14.0f];
}

@end
