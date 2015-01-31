//
//  UIImage+ext.m
//  miglab_mobile
//
//  Created by Archer_LJ on 14-8-11.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import "UIImage+ext.h"
#import "GlobalDataManager.h"
#import "UIImage+BlurredFrame.h"
#import "UserSessionManager.h"
#import "MigWeather.h"

@implementation UIImage_ext

@synthesize imgContext = _imgContext;

+(UIImage_ext *)GetInstance {
    
    static UIImage_ext* instance = nil;

    @synchronized(self) {
        
        if (nil == instance) {
            
            instance = [[self alloc] init];
        }
    }
    
    return instance;
}

-(UIImage *)imageFromText:(UIImage *)image txt:(NSString *)text andFont:(UIFont *)font andFrame:(CGRect)frame{
    
    UIGraphicsBeginImageContext(image.size);
    [image drawAtPoint:CGPointZero];
    
    [[UIColor whiteColor] set];
    
    [text drawInRect:frame withFont:font];
    
    UIImage *finalImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImg;
}

-(UIImage *)drawImageIntoImage:(UIImage *)dstImg andSrcImg:(UIImage *)srcImg andFrame:(CGRect)frame {
    
    UIGraphicsBeginImageContext(dstImg.size);
    
    [dstImg drawInRect:CGRectMake(0, 0, dstImg.size.width, dstImg.size.height)];
    
    [srcImg drawInRect:frame blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage *finalImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return finalImg;
}

-(float)getFontSize:(NSString *)str andFontName:(NSString *)fontName andSize:(CGSize)size{
    
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

-(BOOL)isAllChineseChar:(NSString *)str {
    
    if (MIG_NOT_EMPTY_STR(str)) {
        
        int length = [str length];
        
        for (int i=0; i<length; i++) {
            
            NSString* subStr = [str substringWithRange:NSMakeRange(i, 1)];
            
            /* 需要特殊排除的字符 */
            if ([subStr isEqualToString:@"/"] || [subStr isEqualToString:@"."]) {
                
                continue;
            }
            
            const char * cString = [subStr UTF8String];
            
            if (strlen(cString) != 3) {
                
                return NO;
            }
        }
        
        return YES;
    }
    
    return NO;
}

/* 此处是分享歌词的图片生成的主要代码 */
-(UIImage *)createLyricShareImage:(LyricShare *)ls song:(Song *)tsong {
    
    NSString* fontname = @"Helvetica";
    NSString *szBgImg;
    BOOL isAllChinese = NO;
    
    NSString *szSongName = tsong.songname;
    NSString *szArtist = tsong.artist;
    
    
    float fSongName = 58;
    float fArtist = 40;
    float fLyric = 30;
    float fMode = 40;
    float fTemperature = 40;
    float fDate = 22;
    float fAddress = 24;
    float fToast = 24;
    
    
    /* 测试是否全部为中文 */
    isAllChinese = [self isAllChineseChar:szSongName] && [self isAllChineseChar:szArtist];
    
     //检测是否有歌词
    if (MIG_NOT_EMPTY_STR([GlobalDataManager GetInstance].curSongTypeName)&&MIG_NOT_EMPTY_STR(ls.lyric)) {

        szBgImg = [NSString stringWithFormat:@"%@.jpg", [GlobalDataManager GetInstance].curSongTypeName];
    }
    else {
    
        szBgImg = @"share_default.png";
    }
    
   
    
    UIImage* bgImg;
    UIImage* mainIconImg = [UIImage imageNamed:@"main_logo_white.png"];
    UIImage* iconImg = [UIImage imageNamed:@"code.png"];
    UIImage* weatherImg = [UIImage imageNamed:[MigWeather getWeatherIconName:ls.weather]];
    int imgWidth, imgHeight;
    CGRect songNameRect, artistRect, lyricRect, weatherRect, modeRect, temperatureRect, dateRect, addressRect, mainIconRect, toastRect, iconRect;
    CGRect rcGroupUp, rcGroupDown, rcGroupBottom;
    
    bgImg = [UIImage imageNamed:szBgImg];
    
    imgWidth = bgImg.size.width;
    imgHeight = bgImg.size.height;
    
    rcGroupUp = CGRectMake(484, 44, 156, 156);
    rcGroupDown = CGRectMake(484, 210, 156, 156);
    rcGroupBottom = CGRectMake(0, imgHeight - 140, imgWidth, 140);
    
    lyricRect = CGRectMake(0, 366 + 12, imgWidth, imgHeight - 366 - 140);
    
    if (isAllChinese) {
        
        songNameRect = CGRectMake(60, 44, 58, 1000);
        artistRect = CGRectMake(158, 210, 40, 1000);
    }
    else {
        
        /* 获取需要使用的frame大小 */
        CGSize maxsize = CGSizeMake(360, 166);
        CGSize stringSize = [szSongName sizeWithFont:[UIFont fontWithName:fontname size:fSongName] constrainedToSize:maxsize];
        
        songNameRect = CGRectMake(60, 210 - stringSize.height, 360, stringSize.height);
        artistRect = CGRectMake(144, 210+20, 276, 50);
    }
    
    weatherRect = CGRectMake(484 + 43, 60, 70, 58);
    modeRect = CGRectMake(484, 128, 156, 48);
    
    temperatureRect = CGRectMake(484, 230, 156, 48);
    dateRect = CGRectMake(484, 282, 156, 25);
    addressRect = CGRectMake(484, 311, 156, 35);
    
    mainIconRect = CGRectMake(34, imgHeight - 140 + 20, 130, 100);
    toastRect = CGRectMake(38 + 140, imgHeight - 140 + 18, imgWidth - 38 - 140 - 38 - 96, 140);
    iconRect = CGRectMake(38 + 140 + toastRect.size.width, imgHeight - 140 + 22, 96, 96);
    
    //没有歌词不加载
    if(MIG_NOT_EMPTY_STR(ls.lyric)){
        bgImg = [bgImg applyLightEffectAtFrame:rcGroupUp];
        bgImg = [bgImg applyLightEffectAtFrame:rcGroupDown];
    }
    bgImg = [bgImg applyLightEffectAtFrame:rcGroupBottom];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    NSString *szLyric = ls.lyric;
    NSString *szTemperature = ls.temprature;
    NSString *szDate = [NSString stringWithFormat:@"%04d/%02d/%02d", [comps year], [comps month], [comps day]];
    NSString *szAddress = ls.address;
    NSString *szToast = MIGTIP_THE_GOAL;
    //NSString *szMode = ls.description;
    NSString * szMode = ls.mdescription;
    
    UIGraphicsBeginImageContext(CGSizeMake(imgWidth, imgHeight));
    [bgImg drawInRect:CGRectMake(0, 0, imgWidth, imgHeight)];
    [mainIconImg drawInRect:mainIconRect];
    [iconImg drawInRect:iconRect];
    
    if(MIG_NOT_EMPTY_STR(ls.lyric)){
        [weatherImg drawInRect:weatherRect];
    }
    
    [[UIColor whiteColor] set];
    
    if (MIG_NOT_EMPTY_STR(szSongName)&&MIG_NOT_EMPTY_STR(ls.lyric)) {
        
        if (isAllChinese) {
            
            int count = [szSongName length];
            int stride = fSongName;
            CGRect curRect = songNameRect;
            UIFont *songnameFont = [UIFont fontName:fontname size:fSongName];
            
            /* 限制歌名的长度为8个字 */
            count = count > 8 ? 8 : count;
            
            /* 如果歌名小于等于2个字，把起始位置往下放一点，为了美观 */
            if (count <= 2) {
                
                curRect.origin.y += (3 - count) * fSongName;
            }
            
            for (int i=0; i<count; i++) {
                
                [[szSongName substringWithRange:NSMakeRange(i, 1)] drawInRect:curRect withFont:songnameFont lineBreakMode:UILineBreakModeWordWrap alignment:NSTextAlignmentCenter];
                
                curRect.origin.y += stride;
                
                if (curRect.origin.y > 1000) {
                    
                    break;
                }
            }
        }
        else {
        
            [szSongName drawInRect:songNameRect withFont:[UIFont fontWithName:fontname size:fSongName] lineBreakMode:UILineBreakModeWordWrap alignment:NSTextAlignmentLeft];
        }
    }
    
    if (MIG_NOT_EMPTY_STR(szArtist)&&MIG_NOT_EMPTY_STR(ls.lyric)) {
        
        if (isAllChinese) {
            
            int count = [szArtist length];
            int stride = fArtist;
            CGRect curRect = artistRect;
            UIFont *artistFont = [UIFont fontName:fontname size:fArtist];
            
            for (int i=0; i<count; i++) {
                
                [[szArtist substringWithRange:NSMakeRange(i, 1)] drawInRect:curRect withFont:artistFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
                
                curRect.origin.y += stride;
                
                if (curRect.origin.y > 1000) {
                    
                    break;
                }
            }
        }
        else {
        
            [szArtist drawInRect:artistRect withFont:[UIFont fontWithName:fontname size:fArtist] lineBreakMode:UILineBreakModeWordWrap alignment:NSTextAlignmentLeft];
        }
    }
    
    if (MIG_NOT_EMPTY_STR(szLyric)&&MIG_NOT_EMPTY_STR(ls.lyric)) {
        
        int count = [szLyric length];
        int lstart = 0;
        int lend = 0;
        int i = 0;
        int stride = fLyric + 30;
        UIFont *lyricFont = [UIFont fontWithName:fontname size:fLyric];
        CGRect curRect = lyricRect;
        NSString *curLine;
        
        for (i=0; i<count; i++) {
            
            if ([szLyric characterAtIndex:i] == '\n' || [szLyric characterAtIndex:i] == '\r') {
                
                lend = i;
                
                //copy
                if (lstart == 0) {
                    
                    curLine = [szLyric substringWithRange:NSMakeRange(lstart, lend - lstart)];
                }
                else {
                    
                    // remove \n
                    curLine = [szLyric substringWithRange:NSMakeRange(lstart + 1, lend - lstart - 1)];
                }
                
                [curLine drawInRect:curRect withFont:lyricFont lineBreakMode:UILineBreakModeWordWrap alignment:NSTextAlignmentCenter];
                curRect.origin.y += stride;
                
                if (curRect.origin.y + stride > imgHeight - 140) {
                    
                    break;
                }
                
                lstart = lend;
            }
        }
        
        if (i == count) {
            
            curLine = [szLyric substringWithRange:NSMakeRange(lstart + 1, i - lstart - 1)];
            [curLine drawInRect:curRect withFont:lyricFont lineBreakMode:UILineBreakModeWordWrap alignment:NSTextAlignmentCenter];
        }
        
        //[szLyric drawInRect:lyricRect withFont:[UIFont fontWithName:fontname size:fLyric] lineBreakMode:UILineBreakModeWordWrap alignment:NSTextAlignmentCenter];
    }
    
    if (MIG_NOT_EMPTY_STR(szMode)&&MIG_NOT_EMPTY_STR(ls.lyric)) {
        
        [szMode drawInRect:modeRect withFont:[UIFont fontWithName:fontname size:fMode] lineBreakMode:UILineBreakModeWordWrap alignment:NSTextAlignmentCenter];
    }
    
    if (MIG_NOT_EMPTY_STR(szTemperature)&&MIG_NOT_EMPTY_STR(ls.lyric)) {
        
        [szTemperature drawInRect:temperatureRect withFont:[UIFont fontWithName:fontname size:fTemperature] lineBreakMode:UILineBreakModeWordWrap alignment:NSTextAlignmentCenter];
    }
    
    if (MIG_NOT_EMPTY_STR(szDate)&&MIG_NOT_EMPTY_STR(ls.lyric)) {
        
        [szDate drawInRect:dateRect withFont:[UIFont fontWithName:fontname size:fDate] lineBreakMode:UILineBreakModeWordWrap alignment:NSTextAlignmentCenter];
    }
    
    if (MIG_NOT_EMPTY_STR(szAddress)&&MIG_NOT_EMPTY_STR(ls.lyric)) {
        
        [szAddress drawInRect:addressRect withFont:[UIFont fontWithName:fontname size:fAddress] lineBreakMode:UILineBreakModeWordWrap alignment:NSTextAlignmentCenter];
    }
    
    if (MIG_NOT_EMPTY_STR(szToast)) {
        
        int count = [szToast length];
        int lstart = 0;
        int lend = 0;
        int i = 0;
        int stride = fToast + 12;
        UIFont *toastFont = [UIFont fontWithName:fontname size:fToast];
        CGRect curRect = toastRect;
        NSString *curLine;
        
        for (i=0; i<count; i++) {
            
            if ([szToast characterAtIndex:i] == '\n') {
                
                lend = i;
                
                //copy
                if (lstart == 0) {
                    
                    curLine = [szToast substringWithRange:NSMakeRange(lstart, lend - lstart)];
                }
                else {
                    
                    // remove \n
                    curLine = [szToast substringWithRange:NSMakeRange(lstart + 1, lend - lstart - 1)];
                }
                
                [curLine drawInRect:curRect withFont:toastFont];
                curRect.origin.y += stride;
                
                lstart = lend;
            }
        }
        
        if (i == count) {
            
            curLine = [szToast substringWithRange:NSMakeRange(lstart + 1, i - lstart - 1)];
            [curLine drawInRect:curRect withFont:toastFont];
        }
        
        //[szToast drawInRect:toastRect withFont:[UIFont fontWithName:fontname size:fToast]];
    }
    
    UIImage* shareImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    //UIImageWriteToSavedPhotosAlbum(shareImg, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    return shareImg;
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    NSString *msg = nil;
    
    if (error == nil) {
        
        msg = @"保存图片成功";
    }
    else {
        
        msg = @"保存图片失败";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"存图" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alert show];
}

@end
