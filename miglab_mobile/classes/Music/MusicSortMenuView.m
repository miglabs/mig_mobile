//
//  MusicSortMenuView.m
//  miglab_mobile
//
//  Created by pig on 13-8-31.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "MusicSortMenuView.h"

@implementation MusicSortMenuView

@synthesize btnSortFirst = _btnSortFirst;
@synthesize btnSortSecond = _btnSortSecond;
@synthesize btnSortThird = _btnSortThird;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initMusicSortMenuView{
    
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, 297, 45);
        self.backgroundColor = [UIColor clearColor];
        
        _btnSortFirst = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSortFirst.frame = CGRectMake(5, 11, 89, 23);
        UIImage *image1 = [UIImage imageWithName:@"music_button_sort0" type:@"png"];
        [_btnSortFirst setImage:image1 forState:UIControlStateNormal];
        [self addSubview:_btnSortFirst];
        
        _btnSortSecond = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSortSecond.frame = CGRectMake(5 + 5 + 89, 11, 89, 23);
        UIImage *image2 = [UIImage imageWithName:@"music_button_sort1" type:@"png"];
        [_btnSortSecond setImage:image2 forState:UIControlStateNormal];
        [self addSubview:_btnSortSecond];
        
        _btnSortThird = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSortThird.frame = CGRectMake(5 + 89 + 5 + 5 + 89 + 5 + 5, 11, 89, 23);
        UIImage *image3 = [UIImage imageWithName:@"music_button_sort2" type:@"png"];
        [_btnSortThird setImage:image3 forState:UIControlStateNormal];
        [self addSubview:_btnSortThird];
        
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
