//
//  UIImage+ext.m
//  miglab_mobile
//
//  Created by Archer_LJ on 14-8-11.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import "UIImage+ext.h"

@implementation UIImage_ext

+(UIImage *)addText:(UIImage *)img text:(NSString *)txt angle:(CGFloat)fAngle startPos:(CGPoint)sPos red:(CGFloat)fRed green:(CGFloat)fGreen blue:(CGFloat)fBlue size:(int)tsize{
    
    //get image width and height
    int w = img.size.width;
    int h = img.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //create a graphic context with CGBitmapContextCreate
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGContextSetRGBFillColor(context, 0.0, 1.0, 1.0, 1);
    
    char* text = (char *)[txt cStringUsingEncoding:NSUTF8StringEncoding];
    CGContextSelectFont(context, "Georgia", tsize, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetRGBFillColor(context, fRed, fGreen, fBlue, 1);
    
    CGContextSetTextMatrix(context, CGAffineTransformMakeRotation( fAngle ));
    CGContextShowTextAtPoint(context, sPos.x, sPos.y, text, strlen(text));
    
    //Create image ref from the context
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return [UIImage imageWithCGImage:imageMasked];
}

+(UIImage *)addText:(UIImage *)img text:(NSString *)txt {
    
    return [self addText:img text:txt angle:0 startPos:CGPointMake(20, 20) red:255 green:255 blue:255 size:30];
}

+(UIImage *)imageFromText:(UIImage *)image txt:(NSString *)text {
    
    UIGraphicsBeginImageContext(image.size);
    [image drawAtPoint:CGPointZero];
    
    //[text drawAtPoint:CGPointMake(10, 10) withFont:[UIFont systemFontOfSize:30]];
    [text drawInRect:CGRectMake(10, 10, image.size.width, image.size.height) withFont:[UIFont systemFontOfSize:30]];
    
    UIImage *finalImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImg;
}

@end
