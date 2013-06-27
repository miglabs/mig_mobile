//
//  PCommonUtil.h
//  miglab_mobile
//
//  Created by pig on 13-6-27.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCommonUtil : NSObject

+(NSString *)md5Encode:(NSString *)str;
+(NSString *)encodeBase64:(NSString *)str;
+(NSString *)decodeBase64:(NSString *)str;
+(NSString *)encodeUrlParameter:(NSString *)param;
+(NSString *)decodeUrlParameter:(NSString *)param;


@end
