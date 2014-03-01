//
//  NSString+PStringCategory.m
//  itime
//
//  Created by pig on 13-1-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "NSString+PStringCategory.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (PStringCategory)

/*
 * 根据图片全名取名称
 */
-(NSString *)getImageName{
    NSRange searchRange = [self rangeOfString:@"."];
    if(NSNotFound != searchRange.location){
        return [self substringToIndex:searchRange.location];
    }else{
        return self;
    }
}

/*
 * 根据图片全名取扩展名
 */
-(NSString *)getImageType{
    NSRange searchRange = [self rangeOfString:@"."];
    if(NSNotFound != searchRange.location){
        return [self substringFromIndex:searchRange.location + 1];
    }else{
        return @"png";
    }
}

/*
 * 获取星座
 */
+(NSString *)getConstellation:(int)month day:(int)tday {
    
    NSString *ret = @"";
    
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    
    if (month < 1 || month > 12 || month < 1 || month > 31){
        return ret;
    }
    
    if(month == 2 && tday > 29) {
        
        return ret;
        
    }else if(month == 4 || month == 6 || month == 9 || month == 11) {
        
        if (tday > 30) {
            
            return ret;
        }
    }
    
    ret = [NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(month * 2 - (tday < [[astroFormat substringWithRange:NSMakeRange((month - 1), 1)] intValue] - (-19)) * 2, 2)]];
    
    return ret;
}

@end
