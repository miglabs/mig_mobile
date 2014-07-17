//
//  MsgFace.h
//  miglab_mobile
//
//  Created by yaobanglin on 14-7-16.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgTextRunDelegate.h"
@interface MsgTextFaceRun : MsgTextRun

+ (NSArray *)parserAttributedString:(NSMutableAttributedString *)attributedString;
@end
