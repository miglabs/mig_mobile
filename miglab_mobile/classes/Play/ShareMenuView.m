//
//  ShareMenuView.m
//  miglab_mobile
//
//  Created by apple on 13-10-8.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "ShareMenuView.h"

@implementation ShareMenuView

@synthesize iconImageView = _iconImageView;
@synthesize lblDesc = _lblDesc;
@synthesize switchChoose = _switchChoose;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initShareMenuView{
    
    //320,44
    self = [super initWithFrame:CGRectMake(0, 0, 300, 45)];
    if (self) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.frame = CGRectMake(10, 7, 30, 30);
        _iconImageView.image = [UIImage imageWithName:@"share_sinaweibo_share_icon" type:@"png"];
        [self addSubview:_iconImageView];
        
        _lblDesc = [[UILabel alloc] init];
        _lblDesc.frame = CGRectMake(50, 12, 200, 21);
        _lblDesc.backgroundColor = [UIColor clearColor];
        _lblDesc.textAlignment = kTextAlignmentLeft;
        _lblDesc.textColor = [UIColor grayColor];
        [self addSubview:_lblDesc];
        
        _switchChoose = [[UISwitch alloc] init];
        CGRect chooseframe = _switchChoose.frame;
        _switchChoose.frame = CGRectMake(300 - chooseframe.size.width - 10, 8, chooseframe.size.width, chooseframe.size.height);
        [self addSubview:_switchChoose];
        
        UIImageView *seqImageView = [[UIImageView alloc] init];
        seqImageView.frame = CGRectMake(0, 44, 300, 1);
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
