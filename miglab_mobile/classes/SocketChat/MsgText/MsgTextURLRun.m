//
//  MsgURL.m
//  miglab_mobile
//
//  Created by yaobanglin on 14-7-16.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import "MsgTextURLRun.h"

@implementation MsgTextURLRun


- (void)addAttributedString:(NSMutableAttributedString *)attributedString range:(NSRange)range
{
    [super addAttributedString:attributedString range:range];
    [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor blueColor].CGColor range:range];
}

+ (NSArray *)parserAttributedString:(NSMutableAttributedString *)attributedString
{
    NSString *string = attributedString.string;
    NSMutableArray *array = [NSMutableArray array];
    
    NSError *error = nil;;
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error == nil)
    {
        NSArray *arrayOfAllMatches = [regex matchesInString:string
                                                    options:0
                                                      range:NSMakeRange(0, [string length])];
        
        for (NSTextCheckingResult *match in arrayOfAllMatches)
        {
            NSString* substringForMatch = [string substringWithRange:match.range];
            
            MsgTextURLRun *msg = [[MsgTextURLRun alloc] init];
            msg.range    = match.range;
            msg.text     = substringForMatch;
            msg.isDraw = NO;
            [msg addAttributedString:attributedString range:match.range];
            [array addObject:msg ];
        }
    }
    
    return array;

}

@end
