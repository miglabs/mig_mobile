//
//  UIImage+ext.m
//  miglab_mobile
//
//  Created by Archer_LJ on 14-8-11.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import "UIImage+ext.h"

@implementation UIImage_ext


+(UIImage *)imageFromText:(UIImage *)image txt:(NSString *)text andFont:(UIFont *)font andFrame:(CGRect)frame{
    
    UIGraphicsBeginImageContext(image.size);
    [image drawAtPoint:CGPointZero];
    
    [[UIColor whiteColor] set];
    
    [text drawInRect:frame withFont:font];
    
    UIImage *finalImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImg;
}

+(UIImage *)drawImageIntoImage:(UIImage *)dstImg andSrcImg:(UIImage *)srcImg andFrame:(CGRect)frame {
    
    UIGraphicsBeginImageContext(dstImg.size);
    
    [dstImg drawInRect:CGRectMake(0, 0, dstImg.size.width, dstImg.size.height)];
    
    [srcImg drawInRect:frame blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage *finalImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return finalImg;
}

+(float)getFontSize:(NSString *)str andFontName:(NSString *)fontName andSize:(CGSize)size{
    
    CGFloat finalFontSize = MIN_LYRIC_FONT_SIZE;
    BOOL foundSize = NO;
    
    do {
        
        CGSize charSize = [str sizeWithFont:[UIFont fontWithName:fontName size:finalFontSize] constrainedToSize:CGSizeMake(size.width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeCharacterWrap];
        
        if (charSize.height > size.height) {
            
            foundSize = YES;
        }
        else {
            
            finalFontSize += 1.0;
        }
        
    }while (!foundSize);
    
    return finalFontSize;
}

+(UIImage *)createLyricShareImage:(LyricShare *)ls song:(Song *)tsong {
    
    NSString* fontname = @"Helvetica";
    
    float bgwidth = 320;
    float bgheight = 480;
    float halfWidth = bgwidth / 2;
    float quadWidth = bgwidth / 4;
    float oxWidth = bgwidth / 8;
    float halfHeight = bgheight / 2;
    float quadHeight = bgheight / 4;
    float oxHeight = bgheight / 8;
    
    // 背景图
    UIImage* bgImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tsong.coverurl]]];
    //CGRect bgImgRect = CGRectMake(0, 0, bgImg.size.width, bgImg.size.height);
    CGRect bgImgRect = CGRectMake(0, 0, bgwidth, bgheight);
    NSLog(@"junliu 0");
    
    UIGraphicsBeginImageContext(bgImgRect.size);
    
    [bgImg drawInRect:bgImgRect];
    
    [[UIColor whiteColor] set];
    
    
    // 歌词
    NSString* lyric = ls.lyric;
    if (lyric && ![lyric isEqualToString:@""]) {
        
        CGRect lyricRect = CGRectMake(quadWidth, halfHeight, halfWidth, halfHeight);
        float lyricFontSize = [self getFontSize:lyric andFontName:fontname andSize:CGSizeMake(lyricRect.size.width, lyricRect.size.height)];
        NSLog(@"junliu 1");
        [lyric drawInRect:lyricRect withFont:[UIFont fontWithName:fontname size:lyricFontSize]];
    }
    
    
    // 歌名
    NSString* songname = tsong.songname;
    if (songname && ![songname isEqualToString:@""]) {
        
        CGRect songnameRect = CGRectMake(0, 0, halfWidth, oxHeight);
        float songnameFontSize = [self getFontSize:songname andFontName:fontname andSize:CGSizeMake(songnameRect.size.width, songnameRect.size.height)];
        NSLog(@"junliu 2");
        [songname drawInRect:songnameRect withFont:[UIFont fontWithName:fontname size:songnameFontSize]];
    }
    
    
    // 歌手
    NSString* artist = tsong.artist;
    if (artist && ![artist isEqualToString:@""]) {
        
        CGRect artistRect = CGRectMake(quadWidth, oxHeight, quadWidth, oxHeight);
        float artistFontSize = [self getFontSize:artist andFontName:fontname andSize:CGSizeMake(artistRect.size.width, artistRect.size.height)];
        NSLog(@"junliu 3");
        [artist drawInRect:artistRect withFont:[UIFont fontWithName:fontname size:artistFontSize]];
    }
    
    
    // 情景
    NSString* mode = @"旅途中";
    if (mode && ![mode isEqualToString:@""]) {
        
        CGRect modeRect = CGRectMake(halfWidth, oxHeight, halfWidth, oxHeight);
        float modeFontSize = [self getFontSize:mode andFontName:fontname andSize:CGSizeMake(modeRect.size.width, modeRect.size.height)];
        NSLog(@"junliu 4");
        [mode drawInRect:modeRect withFont:[UIFont fontWithName:fontname size:modeFontSize]];
    }
    
    
    // 温度
    NSString* temperature = ls.temprature;
    if (temperature && ![temperature isEqualToString:@""]) {
        
        CGRect tempRect = CGRectMake(halfWidth, quadHeight, halfWidth, oxHeight);
        float tempFontSize = [self getFontSize:temperature andFontName:fontname andSize:CGSizeMake(tempRect.size.width, tempRect.size.height)];
        NSLog(@"junliu 5");
        [temperature drawInRect:tempRect withFont:[UIFont fontWithName:fontname size:tempFontSize]];
    }
    
    
    // 日期
    NSString* date = @"2014/08/17";
    if (date && ![date isEqualToString:@""]) {
        
        CGRect dateRect = CGRectMake(halfWidth, oxHeight*3, halfWidth, oxHeight/2);
        float dateFontSize = [self getFontSize:date andFontName:fontname andSize:CGSizeMake(dateRect.size.width, dateRect.size.height)];
        NSLog(@"junliu 6");
        [date drawInRect:dateRect withFont:[UIFont fontWithName:fontname size:dateFontSize]];
    }
    
    
    // 地址
    NSString* address = ls.address;
    if (address && ![address isEqualToString:@""]) {
        
        CGRect addRect = CGRectMake(halfWidth, oxHeight*3+oxHeight/2, halfWidth, oxHeight/2);
        float addFontSize = [self getFontSize:address andFontName:fontname andSize:CGSizeMake(addRect.size.width, addRect.size.height)];
        NSLog(@"junliu 7");
        [address drawInRect:addRect withFont:[UIFont fontWithName:fontname size:addFontSize]];
    }
    
    UIImage* shareImg = UIGraphicsGetImageFromCurrentImageContext();
    NSLog(@"junliu 8");
    
    UIGraphicsEndImageContext();
    
    return shareImg;
}

@end
