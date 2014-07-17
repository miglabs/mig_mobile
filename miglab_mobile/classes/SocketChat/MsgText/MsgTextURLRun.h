//
//  MsgURL.h
//  miglab_mobile
//
//  Created by yaobanglin on 14-7-16.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgTextRun.h"
@interface MsgTextURLRun : MsgTextRun


+ (NSArray *)parserAttributedString:(NSMutableAttributedString *)attributedString;

@end
