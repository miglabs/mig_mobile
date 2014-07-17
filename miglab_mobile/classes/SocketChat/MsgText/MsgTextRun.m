//
//  MsgTextRun.m
//  miglab_mobile
//
//  Created by yaobanglin on 14-7-16.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import "MsgTextRun.h"
NSString * const kMsgTextRunAttributedName = @"kMsgTextRunAttributedName";

@implementation MsgTextRun

- (void)addAttributedString:(NSMutableAttributedString *)attributedString range:(NSRange)range
{
    [attributedString addAttribute:kMsgTextRunAttributedName value:self range:range];
    
    self.font = [attributedString attribute:NSFontAttributeName atIndex:0 longestEffectiveRange:nil inRange:range];
}


- (void)drawWithRect:(CGRect)rect
{
   
}

+ (NSArray *)parserAttributedString:(NSMutableAttributedString *)attributedString
{
    [NSException raise:NSInternalInconsistencyException
     
                format:@"You must override %@ in a subclass",NSStringFromSelector(_cmd)];
    return nil;
}

@end
