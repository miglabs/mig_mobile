//
//  MsgViewDelegate.h
//  miglab_mobile
//
//  Created by yaobanglin on 14-7-16.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MsgTextRun.h"
@class MsgTextView;
@protocol MsgTextViewDelegate <NSObject>

@optional
- (void)msgTextView:(MsgTextView *)view touchesBegan:(MsgTextRun *)msgText;
- (void)msgTextView:(MsgTextView *)view touchesEnded:(MsgTextRun *)msgText;
- (void)msgTextView:(MsgTextView *)view touchesCancelled:(MsgTextRun *)msgText;
@end
