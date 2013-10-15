//
//  PCustomNavigationBarView.m
//  itime
//
//  Created by pig on 13-4-19.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PCustomNavigationBarView.h"

@implementation PCustomNavigationBarView

@synthesize bgImageView = _bgImageView;
@synthesize titleLabel = _titleLabel;
@synthesize leftButton = _leftButton;
@synthesize rightButton = _rightButton;

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

- (id)initCustomNavigationBarView:(NSString *)tTitle{
    
    //适配ios7
    int topdistance = 0;
    UIImage *baseNavBg = [UIImage imageWithName:@"base_navigation_bg" type:@"png"];
    long losVersion = [[UIDevice currentDevice].systemVersion floatValue] * 10000;
    if (losVersion >= 70000) {
        topdistance = 20;
        baseNavBg = [UIImage imageWithName:@"base_navigation_bg_ios7" type:@"png"];
    }
    
    self = [super initWithFrame:CGRectMake(0, 0, 320, 44 + topdistance)];
    if (self) {
        _bgImageView = [[UIImageView alloc] initWithImage:baseNavBg];
        _bgImageView.frame = CGRectMake(0, 0, 320, 44 + topdistance);
        [self addSubview:_bgImageView];
        [_bgImageView release];
        
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFrame:CGRectMake(60, 12 + topdistance, 200, 21)];
        [_titleLabel setText:tTitle];
        [_titleLabel setTextAlignment:UITextAlignmentCenter];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setFont:[UIFont fontOfApp:20.0f]];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setShadowOffset:CGSizeMake(0, 1)];
        [self addSubview:_titleLabel];
        [_titleLabel release];
        
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setFrame:CGRectMake(4, 0 + topdistance, 44, 44)];
        [_leftButton setHidden:YES];
        [self addSubview:_leftButton];
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setFrame:CGRectMake(262, 6, 53, 31)];
        [_rightButton setHidden:YES];
        [self addSubview:_rightButton];
        
    }
    return self;
}

- (id)initWithTitle:(NSString *)tTitle bgImageView:(NSString *)tImageName
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 44)];
    if (self) {
        UIImage *bgimage = [UIImage imageNamed:tImageName];
        _bgImageView = [[UIImageView alloc] initWithImage:bgimage];
        _bgImageView.frame = CGRectMake(0, 0, 320, 44);
        [self addSubview:_bgImageView];
        [_bgImageView release];
        
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFrame:CGRectMake(60, 12, 200, 21)];
        [_titleLabel setText:tTitle];
        [_titleLabel setTextAlignment:UITextAlignmentCenter];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setFont:[UIFont fontOfApp:20.0f]];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setShadowOffset:CGSizeMake(0, 1)];
        [self addSubview:_titleLabel];
        [_titleLabel release];
        
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setFrame:CGRectMake(5, 6, 53, 31)];
        [_leftButton setHidden:YES];
        [self addSubview:_leftButton];
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setFrame:CGRectMake(262, 6, 53, 31)];
        [_rightButton setHidden:YES];
        [self addSubview:_rightButton];
        
    }
    return self;
}

@end
