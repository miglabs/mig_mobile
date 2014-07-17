//
//  MsgView.h
//  miglab_mobile
//
//  Created by yaobanglin on 14-7-16.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgTextViewDelegate.h"
@interface MsgTextView : UIControl

@property(nonatomic,weak) id<MsgTextViewDelegate> delegage;

@property (nonatomic,copy  ) NSString              *text;
@property (nonatomic,strong) UIFont                *font;
@property (nonatomic,strong) UIColor               *textColor; 
@property (nonatomic)        CGFloat               lineSpace;

+ (CGRect)getRectWithSize:(CGSize)size font:(UIFont *)font AttString:(NSMutableAttributedString *)attString;

+ (CGRect)getRectWithSize:(CGSize)size font:(UIFont *)font string:(NSString *)string lineSpace:(CGFloat )lineSpace;
@end
