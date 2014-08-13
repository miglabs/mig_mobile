//
//  UIImage+ext.h
//  miglab_mobile
//
//  Created by Archer_LJ on 14-8-11.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage_ext : NSObject

+(UIImage *)addText:(UIImage *)img text:(NSString *)txt;
+(UIImage *)imageFromText:(UIImage *)image txt:(NSString *)text;

@end
