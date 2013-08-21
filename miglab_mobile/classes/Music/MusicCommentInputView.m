//
//  MusicCommentInputView.m
//  miglab_mobile
//
//  Created by pig on 13-8-21.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "MusicCommentInputView.h"

@implementation MusicCommentInputView

@synthesize commentTextField = _commentTextField;
@synthesize btnSendComent = _btnSendComent;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
