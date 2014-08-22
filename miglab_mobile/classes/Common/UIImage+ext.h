//
//  UIImage+ext.h
//  miglab_mobile
//
//  Created by Archer_LJ on 14-8-11.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LyricShare.h"

@interface UIImage_ext : NSObject

@property (nonatomic, assign) CIContext *imgContext;

+(UIImage_ext *)GetInstance;

-(UIImage *)imageFromText:(UIImage *)image txt:(NSString *)text andFont:(UIFont*)font andFrame:(CGRect)frame;

-(UIImage *)drawImageIntoImage:(UIImage *)dstImg andSrcImg:(UIImage *)srcImg andFrame:(CGRect)frame;

-(UIImage *)createLyricShareImage:(LyricShare*)ls song:(Song*)tsong;

-(float)getFontSize:(NSString*)str andFontName:(NSString*)fontName andSize:(CGSize)size;

@end
