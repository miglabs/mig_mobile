//
//  ShareContentView.m
//  miglab_mobile
//
//  Created by apple on 13-10-8.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "ShareContentView.h"

@implementation ShareContentView

@synthesize tvShareContent = _tvShareContent;
@synthesize lblPlaceHolder = _lblPlaceHolder;
@synthesize btnAt = _btnAt;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initShareContentView{
    
    //320,97
    self = [super initWithFrame:CGRectMake(0, 0, 320, 97)];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _tvShareContent = [[UITextView alloc] init];
        _tvShareContent.frame = CGRectMake(5, 5, 290, 60);
        _tvShareContent.backgroundColor = [UIColor clearColor];
        _tvShareContent.font = [UIFont fontOfApp:15.0f];
        [self addSubview:_tvShareContent];
        
        _lblPlaceHolder = [[UILabel alloc] init];
        _lblPlaceHolder.frame = CGRectMake(15, 10, 290, 21);
        _lblPlaceHolder.backgroundColor = [UIColor clearColor];
        _lblPlaceHolder.font = [UIFont fontOfApp:15.0f];
        _lblPlaceHolder.textAlignment = kTextAlignmentLeft;
        _lblPlaceHolder.textColor = [UIColor grayColor];
        _lblPlaceHolder.text = @"写点什么吧～";
        [self addSubview:_lblPlaceHolder];
        
        _btnAt = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnAt.frame = CGRectMake(265, 64, 26, 26);
        [_btnAt setImage:[UIImage imageWithName:@"share_at_icon" type:@"png"] forState:UIControlStateNormal];
        [self addSubview:_btnAt];
        
        UIImageView *seqImageView = [[UIImageView alloc] init];
        seqImageView.frame = CGRectMake(0, 96, 300, 1);
        seqImageView.image = [UIImage imageWithName:@"" type:@"png"];
//        [self addSubview:seqImageView];
        
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
