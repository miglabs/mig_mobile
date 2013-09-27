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

/*
 * 20  26   30  34
 * 四种混用
 */
+(UIFont *)fontOfApp:(CGFloat)fontSize{
    return [UIFont fontName:@"MicrosoftYaHei" size:fontSize];
//    return [UIFont fontName:@"STHeitiTC-Light" size:fontSize];
//    return [UIFont fontWithName:@"STHeitiTC-Medium" size:fontSize];
}

@end
