//
//  MsgTextDelegate.m
//  chat
//
//  Created by yaobanglin on 14-7-17.
//  Copyright (c) 2014年 180. All rights reserved.
//

#import "MsgTextRunDelegate.h"

@implementation MsgTextRunDelegate


/**
 *  向字符串中添加相关Run类型属性
 */
- (void)addAttributedString:(NSMutableAttributedString *)attributedString range:(NSRange)range
{
    [super addAttributedString:attributedString range:range];
    
    CTRunDelegateCallbacks callbacks;
    callbacks.version    = kCTRunDelegateVersion1;
    callbacks.dealloc    = MsgTextDelegateDeallocCallback;
    callbacks.getAscent  = MsgTextDelegateGetAscentCallback;
    callbacks.getDescent = MsgTextDelegateGetDescentCallback;
    callbacks.getWidth   = MsgTextDelegateGetWidthCallback;
    
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&callbacks, (__bridge void*)self);
    [attributedString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:range];
    CFRelease(runDelegate);
    
    [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor clearColor].CGColor range:range];
}

#pragma mark - RunCallback

- (void)msgTextRunDealloc
{
    
}

- (CGFloat)msgTestRunGetAscent
{
    return self.font.ascender;
}

- (CGFloat)msgTestRunGetDescent
{
    return self.font.descender;
}

- (CGFloat)msgTestRunGetWidth
{
    return self.font.ascender - self.font.descender;
}

#pragma mark - RunDelegateCallback

void MsgTextDelegateDeallocCallback(void *refCon)
{
    if( refCon != nil )
    {
        MsgTextRunDelegate *run =(__bridge MsgTextRunDelegate *) refCon;
        [run msgTextRunDealloc];
    }
}

//--上行高度
CGFloat MsgTextDelegateGetAscentCallback(void *refCon)
{
    MsgTextRunDelegate *run =(__bridge MsgTextRunDelegate *) refCon;
    
    return [run msgTestRunGetAscent];
}

//--下行高度
CGFloat MsgTextDelegateGetDescentCallback(void *refCon)
{
    MsgTextRunDelegate *run =(__bridge MsgTextRunDelegate *) refCon;
    
    return [run msgTestRunGetDescent];
}

//-- 宽
CGFloat MsgTextDelegateGetWidthCallback(void *refCon)
{
    MsgTextRunDelegate *run =(__bridge MsgTextRunDelegate *) refCon;
    
    return [run msgTestRunGetWidth];
}


@end
