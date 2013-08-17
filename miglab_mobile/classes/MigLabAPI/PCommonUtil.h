//
//  PCommonUtil.h
//  miglab_mobile
//
//  Created by pig on 13-6-27.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MigLabConfig.h"

#define IS_RETINA ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)? YES: NO
#define FRAMELOG(a) NSLog(@"frame log: %f %f %f %f", a.frame.origin.x, a.frame.origin.y, a.frame.size.width, a.frame.size.height)
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define DEGREES_2_RADIANS(x) (0.0174532925 * (x))

@interface PCommonUtil : NSObject

+(NSString *)md5Encode:(NSString *)str;
+(NSString *)encodeBase64:(NSString *)str;
+(NSString *)decodeBase64:(NSString *)str;
+(NSString *)encodeUrlParameter:(NSString *)param;
+(NSString *)decodeUrlParameter:(NSString *)param;

+(NSData *)encodeAesAndBase64DataFromStr:(NSString *)str secretKey:(NSString *)secretKey;
+(NSString *)encodeAesAndBase64StrFromStr:(NSString *)str secretKey:(NSString *)secretKey;
+(NSData *)decodeAesAndBase64DataFromStr:(NSString *)str secretKey:(NSString *)secretKey;
+(NSString *)decodeAesAndBase64StrFromStr:(NSString *)str secretKey:(NSString *)secretKey;
+(NSString *)encodeAesAndBase64StrFromStr:(NSString *)str;
+(NSString *)decodeAesAndBase64StrFromStr:(NSString *)str;

//制作图片遮罩(注意：需要有一张原图是带alpha通道的图片，和一个不带alpha通道的遮罩图)
+(UIImage *)maskImage:(UIImage *)baseImage withImage:(UIImage *)theMaskImage;
//获取带有alpha通道的扇形进度圆圈
+(UIImage *)getCircleProcessImageWithAlpha:(CGSize)imageSize progress:(float)progress;
//获取不含有alpha通道的扇形进度圆圈
+(UIImage *)getCircleProcessImageWithNoneAlpha:(CGSize)imageSize progress:(float)progress;
+(void)saveImage2Cache:(UIImage *)timage;

@end
