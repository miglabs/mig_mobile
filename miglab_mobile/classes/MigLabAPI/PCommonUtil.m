//
//  PCommonUtil.m
//  miglab_mobile
//
//  Created by pig on 13-6-27.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PCommonUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import "GTMBase64.h"

@implementation PCommonUtil

+(NSString *)md5Encode:(NSString *)str{
    @try {
        if(str && [str isKindOfClass:[NSString class]]){
            const char *cStr = [str UTF8String];
            unsigned char result[16];
            CC_MD5(cStr, strlen(cStr), result);
            
            return [NSString stringWithFormat:
                    @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                    result[0], result[1], result[2], result[3],
                    result[4], result[5], result[6], result[7],
                    result[8], result[9], result[10], result[11],
                    result[12], result[13], result[14], result[15]
                    ];
        }
    }
    @catch (NSException *exception) {
        //NSLog(@"PCommonUtil md5 encode error...please check: %@", str);
    }
    
    return str;
}

+(NSString *)encodeBase64:(NSString *)str{
    if (str && [str isKindOfClass:[NSString class]]) {
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        return [[NSString alloc] initWithData:[GTMBase64 encodeData:data] encoding:NSUTF8StringEncoding];
    }
    return str;
}

+(NSString *)decodeBase64:(NSString *)str{
    if (str && [str isKindOfClass:[NSString class]]) {
        return [[NSString alloc] initWithData:[GTMBase64 decodeString:str] encoding:NSUTF8StringEncoding];
    }
    return str;
}

+(NSString *)encodeUrlParameter:(NSString *)param{
    if (param) {
//        return (NSString *)
//        CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                                  (__bridge CFStringRef)param,
//                                                                  NULL,
//                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
//                                                                  kCFStringEncodingUTF8));
        return [param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    return param;
}



+(NSString *)decodeUrlParameter:(NSString *)param{
    if (param) {
        return [param stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    return param;
}


@end
