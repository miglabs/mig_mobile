//
//  ShareChooseView.m
//  miglab_mobile
//
//  Created by apple on 13-9-25.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "ShareChooseView.h"

@implementation ShareChooseView

@synthesize btnFirst = _btnFirst;
@synthesize lblFirst = _lblFirst;
@synthesize btnSecond = _btnSecond;
@synthesize lblSecond = _lblSecond;
@synthesize btnThird = _btnThird;
@synthesize lblThird = _lblThird;
@synthesize btnFour = _btnFour;
@synthesize lblFour = _lblFour;
@synthesize btnFive = _btnFive;
@synthesize lblFive = _lblFive;
@synthesize btnSix = _btnSix;
@synthesize lblSix = _lblSix;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initShareChooseView{
    
    self = [super initWithFrame:CGRectMake(0, 0, 320, 200)];
    if (self) {
        
        //1
        UIImage *firstImage = [UIImage imageWithName:@"weixin_normal@2x" type:@"png"];
        _btnFirst = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnFirst setTag:201];
        [_btnFirst setFrame:CGRectMake(26, 15, 70, 70)];
        [_btnFirst setImage:firstImage forState:UIControlStateNormal];
        
        _lblFirst = [[UILabel alloc] init];
        [_lblFirst setBackgroundColor:[UIColor clearColor]];
        [_lblFirst setFrame:CGRectMake(25, 79, 73, 21)];
        [_lblFirst setText:@"微信朋友圈"];
        [_lblFirst setTextColor:[UIColor whiteColor]];
        [_lblFirst setShadowColor:[UIColor darkTextColor]];
        [_lblFirst setTextAlignment:kTextAlignmentCenter];
        [_lblFirst setFont:[UIFont fontOfSystem:14.0f]];
        [self addSubview:_btnFirst];
        [self addSubview:_lblFirst];
        
        //2
        UIImage *secondImage = [UIImage imageWithName:@"weixin_share@2x" type:@"png"];
        _btnSecond = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSecond setTag:202];
        [_btnSecond setFrame:CGRectMake(125, 15, 70, 70)];
        [_btnSecond setImage:secondImage forState:UIControlStateNormal];
        
        _lblSecond = [[UILabel alloc] init];
        [_lblSecond setBackgroundColor:[UIColor clearColor]];
        [_lblSecond setFrame:CGRectMake(124, 79, 73, 21)];
        [_lblSecond setText:@"微信好友"];
        [_lblSecond setTextColor:[UIColor whiteColor]];
        [_lblSecond setShadowColor:[UIColor darkTextColor]];
        [_lblSecond setTextAlignment:kTextAlignmentCenter];
        [_lblSecond setFont:[UIFont fontOfSystem:14.0f]];
        [self addSubview:_btnSecond];
        [self addSubview:_lblSecond];
        
        //3
        UIImage *thirdImage = [UIImage imageWithName:@"sina_weibo_normal@2x" type:@"png"];
        _btnThird = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnThird setTag:203];
        [_btnThird setFrame:CGRectMake(221, 15, 70, 70)];
        [_btnThird setImage:thirdImage forState:UIControlStateNormal];
        
        _lblThird = [[UILabel alloc] init];
        [_lblThird setBackgroundColor:[UIColor clearColor]];
        [_lblThird setFrame:CGRectMake(220, 79, 73, 21)];
        [_lblThird setText:@"新浪微博"];
        [_lblThird setTextColor:[UIColor whiteColor]];
        [_lblThird setShadowColor:[UIColor darkTextColor]];
        [_lblThird setTextAlignment:kTextAlignmentCenter];
        [_lblThird setFont:[UIFont fontOfSystem:14.0f]];
        [self addSubview:_btnThird];
        [self addSubview:_lblThird];
        
        // 4
        UIImage *fourImage = [UIImage imageWithName:@"qq_share@2x" type:@"png"];
        _btnFour = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnFour setTag:204];
        [_btnFour setFrame:CGRectMake(26, 104, 70, 70)];
        [_btnFour setImage:fourImage forState:UIControlStateNormal];
        
        _lblFour = [[UILabel alloc] init];
        [_lblFour setBackgroundColor:[UIColor clearColor]];
        [_lblFour setFrame:CGRectMake(25, 169, 73, 21)];
        [_lblFour setText:@"QQ好友"];
        [_lblFour setTextColor:[UIColor whiteColor]];
        [_lblFour setShadowColor:[UIColor darkTextColor]];
        [_lblFour setTextAlignment:kTextAlignmentCenter];
        [_lblFour setFont:[UIFont fontOfSystem:14.0f]];
        [self addSubview:_btnFour];
        [self addSubview:_lblFour];
        
        // 5
        UIImage *fiveImage = [UIImage imageWithName:@"qzone_normal@2x" type:@"png"];
        _btnFive = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnFive setTag:205];
        [_btnFive setFrame:CGRectMake(125, 104, 70, 70)];
        [_btnFive setImage:fiveImage forState:UIControlStateNormal];
        
        _lblFive = [[UILabel alloc] init];
        [_lblFive setBackgroundColor:[UIColor clearColor]];
        [_lblFive setFrame:CGRectMake(124, 169, 73, 21)];
        [_lblFive setText:@"QQ空间"];
        [_lblFive setTextColor:[UIColor whiteColor]];
        [_lblFive setShadowColor:[UIColor darkTextColor]];
        [_lblFive setTextAlignment:kTextAlignmentCenter];
        [_lblFive setFont:[UIFont fontOfSystem:14.0f]];
        [self addSubview:_btnFive];
        [self addSubview:_lblFive];

        /*
        
        //6
        UIImage *sixImage = [UIImage imageWithName:@"sms_normal@2x" type:@"png"];
        _btnSix = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSix setTag:206];
        [_btnSix setFrame:CGRectMake(221, 104, 70, 70)];
        [_btnSix setImage:sixImage forState:UIControlStateNormal];
        
        _lblSix = [[UILabel alloc] init];
        [_lblSix setBackgroundColor:[UIColor clearColor]];
        [_lblSix setFrame:CGRectMake(206, 169, 101, 21)];
        [_lblSix setText:@"短信发给好友"];
        [_lblSix setTextColor:[UIColor whiteColor]];
        [_lblSix setShadowColor:[UIColor darkTextColor]];
        [_lblSix setTextAlignment:kTextAlignmentCenter];
        [_lblSix setFont:[UIFont fontOfSystem:14.0f]];
        [self addSubview:_btnSix];
        [self addSubview:_lblSix];
        */
        
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
