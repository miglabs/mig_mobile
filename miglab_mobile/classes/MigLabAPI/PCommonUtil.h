//
//  PCommonUtil.h
//  miglab_mobile
//
//  Created by pig on 13-6-27.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IS_RETINA ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)? YES: NO
#define FRAMELOG(a) NSLog(@"%f %f %f %f", a.frame.origin.x, a.frame.origin.y, a.frame.size.width, a.frame.size.height)
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface PCommonUtil : NSObject

+(NSString *)md5Encode:(NSString *)str;
+(NSString *)encodeBase64:(NSString *)str;
+(NSString *)decodeBase64:(NSString *)str;
+(NSString *)encodeUrlParameter:(NSString *)param;
+(NSString *)decodeUrlParameter:(NSString *)param;


@end
