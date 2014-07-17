//
//  MsgTextRun.h
//  miglab_mobile
//
//  Created by yaobanglin on 14-7-16.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgTextRun.h"
#import <CoreText/CoreText.h>
@interface MsgTextRun : UIResponder

@property (nonatomic,copy  ) NSString *text;
@property (nonatomic,strong) UIFont   *font;
@property (nonatomic,assign) NSRange  range;
@property(nonatomic) BOOL isDraw;

- (void)addAttributedString:(NSMutableAttributedString *)attributedString range:(NSRange)range;
- (void)drawWithRect:(CGRect)rect;

+ (NSArray *)parserAttributedString:(NSMutableAttributedString *)attributedString;
@end
extern NSString * const kMsgTextRunAttributedName;
