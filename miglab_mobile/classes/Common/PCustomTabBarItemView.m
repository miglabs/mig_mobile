//
//  PCustomTabBarItemView.m
//  itime
//
//  Created by pig on 13-1-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PCustomTabBarItemView.h"

@implementation PCustomTabBarItemView

@synthesize iconImageView;
@synthesize titleLabel;
@synthesize normalIconImage;
@synthesize selectedIcomImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame title:(NSString *)tTitle normalIconImage:(UIImage *)tNormalIconImage selectedIconImage:(UIImage *)tSelectedIconImage{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setNormalIconImage:tNormalIconImage];
        [self setSelectedIcomImage:tSelectedIconImage];
        
        //图标-位置坐标是从中间开始计算的
        UIImageView *tImageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-67.0f)/2, 0, 67.0f, 33.0f)];
        [tImageView setBackgroundColor:[UIColor clearColor]];
        [tImageView setImage:self.normalIconImage];
        [self setIconImageView:tImageView];
        [tImageView release];
        [self addSubview:self.iconImageView];
        
        //文字标题
        UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-23, frame.size.width, 20)];
        [tLabel setBackgroundColor:[UIColor clearColor]];
        [tLabel setTextAlignment:UITextAlignmentCenter];
        [tLabel setText:tTitle];
        [tLabel setNumberOfLines:0];
        [tLabel setFont:[UIFont systemFontOfSize:10]];
        [tLabel setTextColor:[UIColor whiteColor]];
        [self setTitleLabel:tLabel];
        [tLabel release];
        [self addSubview:self.titleLabel];
        
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame normalIconImage:(UIImage *)tNormalIconImage selectedIconImage:(UIImage *)tSelectedIconImage{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setNormalIconImage:tNormalIconImage];
        [self setSelectedIcomImage:tSelectedIconImage];
        
        //图标-位置坐标是从中间开始计算的
        UIImageView *tImageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-67.0f)/2, 0, 67.0f, 66.0f)];
        [tImageView setBackgroundColor:[UIColor clearColor]];
        [tImageView setImage:self.normalIconImage];
        [self setIconImageView:tImageView];
        [tImageView release];
        [self addSubview:self.iconImageView];
        
    }
    
    return self;
}

-(void)dealloc{
    
    [self setIconImageView:nil];
    [self setTitleLabel:nil];
    [self setNormalIconImage:nil];
    [self setSelectedIcomImage:nil];
    [super dealloc];
    
}

/*
 * 设置当前button被选中
 */
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    //加入设置事件
    if (selected) {
        self.iconImageView.image = self.selectedIcomImage;
        self.titleLabel.textColor = [UIColor colorWithRed:129.0/255.0 green:219.0/255.0 blue:97.0/255.0 alpha:1];//[UIColor whiteColor];
    }else{
        self.iconImageView.image = self.normalIconImage;
        self.titleLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    }
    
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
