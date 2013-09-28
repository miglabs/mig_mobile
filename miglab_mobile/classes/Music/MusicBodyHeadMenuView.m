//
//  MusicHeadMenuView.m
//  miglab_mobile
//
//  Created by pig on 13-8-31.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "MusicBodyHeadMenuView.h"

@implementation MusicBodyHeadMenuView

@synthesize lblDesc = _lblDesc;
@synthesize btnSort = _btnSort;
@synthesize btnEdit = _btnEdit;
@synthesize separatorImageView = _separatorImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initMusicBodyHeadMenuView{
    
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, 297, 45);
        self.backgroundColor = [UIColor clearColor];
        
        //body head
        _lblDesc = [[UILabel alloc] init];
        _lblDesc.frame = CGRectMake(16, 12, 140, 21);
        _lblDesc.backgroundColor = [UIColor clearColor];
        _lblDesc.font = [UIFont fontOfApp:13.0f];
        _lblDesc.text = @"优先推荐以下歌曲";
        _lblDesc.textAlignment = kTextAlignmentLeft;
        _lblDesc.textColor = [UIColor whiteColor];
        
        _btnSort = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSort.frame = CGRectMake(162, 8, 58, 28);
        UIImage *sortNorImage = [UIImage imageWithName:@"music_source_sort" type:@"png"];
        [_btnSort setImage:sortNorImage forState:UIControlStateNormal];
        
        _btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnEdit.frame = CGRectMake(230, 8, 58, 28);
        UIImage *editNorImage = [UIImage imageWithName:@"music_source_edit" type:@"png"];
        [_btnEdit setImage:editNorImage forState:UIControlStateNormal];
        
        _separatorImageView = [[UIImageView alloc] init];
        _separatorImageView.frame = CGRectMake(4, 45, 290, 1);
        _separatorImageView.image = [UIImage imageWithName:@"music_source_separator" type:@"png"];
        
        [self addSubview:_lblDesc];
        [self addSubview:_btnSort];
        [self addSubview:_btnEdit];
        [self addSubview:_separatorImageView];
        
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
