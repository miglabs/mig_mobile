//
//  MigLabAPI.m
//  miglab_mobile
//
//  Created by pig on 13-6-23.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "MigLabAPI.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "PCommonUtil.h"

@implementation MigLabAPI

+(void)doSsoLoginFirst{
    
    NSString *getLoginSsoUrl = @"http://sso.miglab.com/cgi-bin/sp.fcgi?sp";
    NSLog(@"getLoginSsoUrl: %@", getLoginSsoUrl);
    
    NSURL *url = [NSURL URLWithString:getLoginSsoUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"result: %@", result);
        
        NSArray *resultList = [result componentsSeparatedByString:@"?"];
        for (int i=0; i<[resultList count]; i++) {
            NSLog(@"resultList%d: %@", i, [resultList objectAtIndex:i]);
        }
        
        if ([resultList count] == 2) {
            NSString *postUrl = [resultList objectAtIndex:0];
            NSString *postContent = [resultList objectAtIndex:1];
            NSString *username = @"test@miglab.com";
            NSString *password = @"123456";
            
            NSString *post_content = [NSString stringWithFormat:@"username=%@&password=%@&%@", username, password, postContent];
            
            NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
            [dicParam setValue:post_content forKey:@"post_content"];
            
//            [dicParam setValue:username forKey:@"username"];
//            [dicParam setValue:password forKey:@"password"];
//            
//            NSArray *contentList = [postContent componentsSeparatedByString:@"&"];
//            int contentCount = [contentList count];
//            for (int i=0; i<contentCount; i++) {
//                
//                NSString *strParam = [contentList objectAtIndex:i];
//                NSArray *paramlist = [strParam componentsSeparatedByString:@"="];
//                if ([paramlist count] == 2) {
//                    
//                    NSString *paramkey = [paramlist objectAtIndex:0];
//                    NSString *paramvalue = [paramlist objectAtIndex:1];
//                    NSString *decodeParamValue = [PCommonUtil decodeUrlParameter:paramvalue];
//                    NSLog(@"paramkey: %@, paramvalue: %@, decodeParamValue: %@", paramkey, paramvalue, decodeParamValue);
//                    
//                    [dicParam setValue:paramvalue forKey:paramkey];
//                }//end if
//                
//            }
            
            
            
            [self doSsoLoginSecond:postUrl param:dicParam];
            
        } else {
            
            NSLog(@"doSsoLoginFirst failure...");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"failure: %@", error);
        
    }];
    
    [operation start];
    
}

+(void)doSsoLoginSecond:(NSString *)ssoSecondUrl param:(NSDictionary *)dicParam{
    
    NSString *loginSsoSecondUrl = ssoSecondUrl;
    NSLog(@"loginSsoSecondUrl: %@", loginSsoSecondUrl);
    
    NSURL *url = [NSURL URLWithString:loginSsoSecondUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:dicParam constructingBodyWithBlock:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"result: %@", result);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"failure: %@", error);
        
    }];
    
    [operation start];
    
}

@end
