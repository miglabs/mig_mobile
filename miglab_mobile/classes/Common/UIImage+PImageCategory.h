//
//  UIImage+PImageCategory.h
//  itime
//
//  Created by pig on 13-1-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PImageCategory)

+(UIImage *)imageWithName:(NSString *)tName;
+(UIImage *)imageWithName:(NSString *)tName type:(NSString *)tType;
+(UIImage *)imageWithName:(NSString *)tName type:(NSString *)tType leftCapWidth:(NSInteger)tWidth topCapHeight:(NSInteger)tHeight;
+(UIImage *)createRoundedRectImage:(UIImage *)image size:(CGSize)size radius:(int)r;
+(UIImage *)scaleImage:(UIImage *)image scaleToSize:(CGSize)size;

@end
