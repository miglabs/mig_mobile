//
//  PCommonUtil.m
//  miglab_mobile
//
//  Created by pig on 13-6-27.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PCommonUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import "GTMBase64.h"

@implementation PCommonUtil

+(NSString *)md5Encode:(NSString *)str{
    @try {
        if(str && [str isKindOfClass:[NSString class]]){
            const char *cStr = [str UTF8String];
            unsigned char result[16];
            CC_MD5(cStr, strlen(cStr), result);
            
            return [NSString stringWithFormat:
                    @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                    result[0], result[1], result[2], result[3],
                    result[4], result[5], result[6], result[7],
                    result[8], result[9], result[10], result[11],
                    result[12], result[13], result[14], result[15]
                    ];
        }
    }
    @catch (NSException *exception) {
        //NSLog(@"PCommonUtil md5 encode error...please check: %@", str);
    }
    
    return str;
}

+(NSString *)encodeBase64:(NSString *)str{
    if (str && [str isKindOfClass:[NSString class]]) {
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        return [[NSString alloc] initWithData:[GTMBase64 encodeData:data] encoding:NSUTF8StringEncoding];
    }
    return str;
}

+(NSString *)decodeBase64:(NSString *)str{
    if (str && [str isKindOfClass:[NSString class]]) {
        return [[NSString alloc] initWithData:[GTMBase64 decodeString:str] encoding:NSUTF8StringEncoding];
    }
    return str;
}

+(NSString *)encodeUrlParameter:(NSString *)param{
    if (param) {
//        return (NSString *)
//        CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                                  (__bridge CFStringRef)param,
//                                                                  NULL,
//                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
//                                                                  kCFStringEncodingUTF8));
        return [param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    return param;
}



+(NSString *)decodeUrlParameter:(NSString *)param{
    if (param) {
        return [param stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    return param;
}

//制作图片遮罩(注意：需要有一张原图是带alpha通道的图片，和一个不带alpha通道的遮罩图)
+(UIImage *)maskImage:(UIImage *)baseImage withImage:(UIImage *)theMaskImage{
    
    UIGraphicsBeginImageContext(baseImage.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, baseImage.size.width, baseImage.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGImageRef maskRef = theMaskImage.CGImage;
    CGImageRef maskImage = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                             CGImageGetHeight(maskRef),
                                             CGImageGetBitsPerComponent(maskRef),
                                             CGImageGetBitsPerPixel(maskRef),
                                             CGImageGetBytesPerRow(maskRef),
                                             CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask([baseImage CGImage], maskImage);
    CGImageRelease(maskImage);//避免泄漏
    CGContextDrawImage(ctx, area, masked);
    CGImageRelease(masked);//避免泄漏
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

//获取带有alpha通道的扇形进度圆圈
+(UIImage *)getCircleProcessImageWithAlpha:(CGSize)imageSize progress:(float)progress{
    
    float width = imageSize.width;
    float height = imageSize.height;
    UIGraphicsBeginImageContext(imageSize);
    
    CGPoint centerPoint = CGPointMake(height / 2, width / 2);
    CGFloat radius = MIN(height, width) / 2;
    
    CGFloat radians = DEGREES_2_RADIANS((progress*359.9)-90);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor redColor] setFill];
    CGMutablePathRef progressPath = CGPathCreateMutable();
    CGPathMoveToPoint(progressPath, NULL, centerPoint.x, centerPoint.y);
    CGPathAddArc(progressPath, NULL, centerPoint.x, centerPoint.y, radius, DEGREES_2_RADIANS(270), radians, NO);
    CGPathCloseSubpath(progressPath);
    CGContextAddPath(context, progressPath);
    CGContextFillPath(context);
    CGPathRelease(progressPath);
    
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return pressedColorImg;
}

//获取不含有alpha通道的扇形进度圆圈
+(UIImage *)getCircleProcessImageWithNoneAlpha:(CGSize)imageSize progress:(float)progress{
    
    float width = imageSize.width;
    float height = imageSize.height;
    
    //圆心
    CGPoint centerPoint = CGPointMake(height / 2, width / 2);
    //半径
    CGFloat radius = MIN(height, width) / 2;
    //扇形开始角度
    CGFloat radians = DEGREES_2_RADIANS((360-progress*359.9)-270);
    
    //申请内存空间
    GLubyte * spriteData = (GLubyte *) calloc(width * height, sizeof(GLubyte));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapContext = CGBitmapContextCreate(spriteData, width, height, 8, width, colorSpace, kCGImageAlphaNone);
    CGContextSetFillColorSpace(bitmapContext, colorSpace);
    
    //绘制全部底色
    CGRect rectAll = CGRectMake(0, 0, width, height);
    CGContextSetFillColorWithColor(bitmapContext, [UIColor blackColor].CGColor);
    CGContextFillRect(bitmapContext, rectAll);
    
    CGContextSetFillColorWithColor(bitmapContext, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(bitmapContext, centerPoint.x, centerPoint.y);
    CGContextAddArc(bitmapContext, centerPoint.x, centerPoint.y, radius, DEGREES_2_RADIANS(90), radians, 0);
    CGContextClosePath(bitmapContext);
    CGContextFillPath(bitmapContext);
    
    //
    //    CGMutablePathRef progressPath = CGPathCreateMutable();
    //    CGPathMoveToPoint(progressPath, NULL, centerPoint.x, centerPoint.y);
    //    CGPathAddArc(progressPath, NULL, centerPoint.x, centerPoint.y, radius, DEGREES_2_RADIANS(270), radians, NO);
    //    CGPathCloseSubpath(progressPath);
    //    CGContextAddPath(bitmapContext, progressPath);
    //    CGContextFillPath(bitmapContext);
    //    CGPathRelease(progressPath);
    //
    
    CGImageRef processImageRef = CGBitmapContextCreateImage(bitmapContext);
    UIImage *processImage = [UIImage imageWithCGImage:processImageRef];
    
    return processImage;
}

@end
