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

@end
