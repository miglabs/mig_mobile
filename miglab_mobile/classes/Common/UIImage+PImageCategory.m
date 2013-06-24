//
//  UIImage+PImageCategory.m
//  itime
//
//  Created by pig on 13-1-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "UIImage+PImageCategory.h"

static void addRoundedRectPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight){
    
    float fw, fh;
    
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);    //start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);   //top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); //top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);  //lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);    //back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

@implementation UIImage (PImageCategory)

+(UIImage *)imageWithName:(NSString *)tName{
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:tName ofType:@"png"]];
}

+(UIImage *)imageWithName:(NSString *)tName type:(NSString *)tType{
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:tName ofType:tType]];
}

+(UIImage *)imageWithName:(NSString *)tName type:(NSString *)tType leftCapWidth:(NSInteger)tWidth topCapHeight:(NSInteger)tHeight{
    UIImage *tempImage = [UIImage imageWithName:tName type:tType];
    return [tempImage stretchableImageWithLeftCapWidth:tWidth topCapHeight:tHeight];
}

+(UIImage *)createRoundedRectImage:(UIImage *)image size:(CGSize)size radius:(int)r{
    
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4*w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectPath(context, rect, r, r);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    
    return img;
}

//将一个UIImage 缩放变换到指定Size的UIImage
+(UIImage *)scaleImage:(UIImage *)image scaleToSize:(CGSize)size{
    //创建一个bitmap的context
    //并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    //绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //从当前context中创建一个改变大小后的图片
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

@end
