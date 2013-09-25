//
//  UIFont+PFontCategory.h
//  miglab_mobile
//
//  Created by apple on 13-9-25.
//  Copyright (c) 2013年 pig. All rights reserved.
//

typedef enum {
    PFontTypeNormal0,
    PFontTypeNormal1,
    PFontTypeNormal2
} PFontType;

@interface UIFont (PFontCategory)

+(UIFont *)fontName:(NSString *)fontName size:(CGFloat)fontSize;
+(UIFont *)fontOfSystem:(CGFloat)fontSize;
+(UIFont *)fontWithType:(PFontType)pFontType;

@end
