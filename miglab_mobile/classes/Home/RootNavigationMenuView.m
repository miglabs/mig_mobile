//
//  RootNavigationMenuView.m
//  miglab_mobile
//
//  Created by apple on 13-8-16.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "RootNavigationMenuView.h"
#import "SettingViewController.h"
#import "LoginMenuViewController.h"
#import "UIImage+PImageCategory.h"
#import "UserSessionManager.h"
#import "GlobalDataManager.h"
#import "MigLabConfig.h"

@implementation RootNavigationMenuView

@synthesize bgImageView = _bgImageView;
@synthesize btnMenuFirst = _btnMenuFirst;
@synthesize btnMenuSecond = _btnMenuSecond;
@synthesize btnMenuThird = _btnMenuThird;
@synthesize egoBtnAvatar = _egoBtnAvatar;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initRootNavigationMenuView{
    
    //适配ios7
    int topdistance = 0;
    UIImage *homeNavBg = [UIImage imageWithName:@"home_navigation_bg" type:@"png"];
    long losVersion = [[UIDevice currentDevice].systemVersion floatValue] * 10000;
    if (losVersion >= 70000) {
        topdistance = 20;
        homeNavBg = [UIImage imageWithName:@"home_navigation_bg_ios7" type:@"png"];
    }
    
    //    self = [super initWithFrame:CGRectMake(0, 0, 320, 44)];
    self = [super initWithFrame:CGRectMake(0, 0, 320, 44 + topdistance)];
    if (self) {
        _bgImageView = [[UIImageView alloc] initWithImage:homeNavBg];
        _bgImageView.frame = CGRectMake(0, 0, 320, 44 + topdistance);
        [self addSubview:_bgImageView];
        
        /* 不再使用间隔
        UIImage *separatorImage = [UIImage imageWithName:@"home_navigation_separator" type:@"png"];
        UIImageView *separatorImageView01 = [[UIImageView alloc] initWithImage:separatorImage];
        separatorImageView01.frame = CGRectMake(9+10+31+90, 0 + topdistance, 1, 42);
        [self addSubview:separatorImageView01];
        
        UIImageView *separatorImageView12 = [[UIImageView alloc] initWithImage:separatorImage];
        separatorImageView12.frame = CGRectMake(213, 0 + topdistance, 1, 42);
        [self addSubview:separatorImageView12];
        */
        UIImage *menuNorImage = [UIImage imageNamed:@"home_navigation_menu_sel.png"];
        UIImage *menuSelImage = [UIImage imageNamed:@"choose_line.png"];
        UIColor *menuSelColor = [UIColor colorWithRed:92.0f/255.0f green:210.0f/255.0f blue:248.0f/255.0f alpha:1.0f];
         
        
        //添加头像 //位置 9 长度31

       _egoBtnAvatar = [[EGOImageButton alloc] initWithPlaceholderImage:[UIImage imageNamed:LOCAL_DEFAULT_HEADER_IMAGE]];
        CGFloat x = _bgImageView.frame.size.width - _egoBtnAvatar.frame.size.width - 35;
        _egoBtnAvatar.frame = CGRectMake(x, 5 + topdistance, 28, 28);
        _egoBtnAvatar.layer.cornerRadius = _egoBtnAvatar.frame.size.width / 2;
        _egoBtnAvatar.layer.masksToBounds = YES;
        _egoBtnAvatar.layer.borderWidth = AVATAR_BORDER_WIDTH;
        _egoBtnAvatar.layer.borderColor = AVATAR_BORDER_COLOR;
        NSString* userHeadUrl = [UserSessionManager GetInstance].currentUser.head;
        [_egoBtnAvatar addTarget:self action:@selector(doAvatar:) forControlEvents:UIControlEventTouchUpInside];
        if (userHeadUrl && [UserSessionManager GetInstance].isLoggedIn) {
            
            _egoBtnAvatar.imageURL = [NSURL URLWithString:userHeadUrl];
        }
        [self addSubview: _egoBtnAvatar];
        
        

        

        
        //IPHONE4S以上 描述之间的间距加大
        /*CGFloat separation = 0;
        
        if([GlobalDataManager GetInstance].isLongScreen){
            separation = -5;
        }
        NSString* nickname = [NSString alloc];
        if([UserSessionManager GetInstance].isLoggedIn){
            //性别判断
            if([UserSessionManager GetInstance].currentUser.gender==0)
                nickname =  [NSString stringWithFormat:@"%@  ♀",[UserSessionManager GetInstance].currentUser.nickname];
            else
                nickname =  [NSString stringWithFormat:@"%@  ♂",[UserSessionManager GetInstance].currentUser.nickname];
        }else{
            nickname = @"请登录";
        }*/
        
        /*CGFloat tip_x = _egoBtnAvatar.frame.origin.x - _egoBtnAvatar.frame.size.width -20;
        _btnName = [[UIButton alloc] initWithFrame:CGRectMake(tip_x, 0 + topdistance, 50, 42)];
        _btnName.backgroundColor = [UIColor clearColor];
        [_btnName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnName.titleLabel.font = [UIFont fontOfApp:13.0];
        [_btnName.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [_btnName addTarget:self action:@selector(doAvatar:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnName];*/
        
        
        //first
        _btnMenuFirst = [[UIButton alloc] initWithFrame:CGRectMake(10, 0 + topdistance, 80, 42)];
        _btnMenuFirst.tag = 100;
        [_btnMenuFirst setBackgroundImage:menuNorImage forState:UIControlStateNormal];
        //[_btnMenuFirst setBackgroundImage:menuSelImage forState:UIControlStateSelected];
        [_btnMenuFirst setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnMenuFirst setTitleColor:menuSelColor forState:UIControlStateSelected];
        [_btnMenuFirst setTitle:@"音乐基因" forState:UIControlStateNormal];

        //判断用户是否登录以及登录后性别判断
        //[_btnMenuFirst setTitle:nil forState:UIControlStateNormal];
        //_btnMenuFirst.titleLabel.font = [UIFont fontOfApp:13.0f];
        
        [self addSubview:_btnMenuFirst];
        
        //second
        CGFloat second_x =_btnMenuFirst.frame.origin.x + _btnMenuFirst.frame.size.width + 20;
        _btnMenuSecond = [[UIButton alloc] initWithFrame:CGRectMake(second_x, 0 + topdistance, 56, 42)];
        _btnMenuSecond.tag = 101;
        [_btnMenuSecond setBackgroundImage:menuNorImage forState:UIControlStateNormal];
        //[_btnMenuSecond setBackgroundImage:menuSelImage forState:UIControlStateSelected];
        [_btnMenuSecond setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnMenuSecond setTitleColor:menuSelColor forState:UIControlStateSelected];
        [_btnMenuSecond setTitle:@"歌单" forState:UIControlStateNormal];
        _btnMenuSecond.titleLabel.font = [UIFont fontOfApp:17.0f];
        [self addSubview:_btnMenuSecond];
        
        //从右开始偏移计算320 - 56 -10
        //third
        CGFloat third_x =_btnMenuSecond.frame.origin.x + _btnMenuSecond.frame.size.width + 20;
        _btnMenuThird = [[UIButton alloc] initWithFrame:CGRectMake(third_x, 0 + topdistance,56, 42)];
        _btnMenuThird.tag = 102;
        [_btnMenuThird setBackgroundImage:menuNorImage forState:UIControlStateNormal];
        //[_btnMenuThird setBackgroundImage:menuSelImage forState:UIControlStateSelected];
        [_btnMenuThird setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnMenuThird setTitleColor:menuSelColor forState:UIControlStateSelected];
        [_btnMenuThird setTitle:@"歌友" forState:UIControlStateNormal];
        _btnMenuThird.titleLabel.font = [UIFont fontOfApp:17.0f];
        [self addSubview:_btnMenuThird];
    }
    return self;
    
}

#if 0/*
-(id)initRootNavigationMenuView:(CGRect)frame{
    
//    self = [super initWithFrame:CGRectMake(0, 0, 320, 45)];
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *bgImage = [UIImage imageWithName:@"home_navigation_bg" type:@"png"];
        _bgImageView = [[UIImageView alloc] initWithImage:bgImage];
        _bgImageView.frame = CGRectMake(0, 0, 320, 45);
        [self addSubview:_bgImageView];
        
        UIImage *separatorImage = [UIImage imageWithName:@"home_navigation_separator" type:@"png"];
        UIImageView *separatorImageView01 = [[UIImageView alloc] initWithImage:separatorImage];
        separatorImageView01.frame = CGRectMake(106, 0, 1, 43);
        [self addSubview:separatorImageView01];
        
        UIImageView *separatorImageView12 = [[UIImageView alloc] initWithImage:separatorImage];
        separatorImageView12.frame = CGRectMake(213, 0, 1, 43);
        [self addSubview:separatorImageView12];
        
        UIImage *menuSelImage = [UIImage imageWithName:@"home_navigation_menu_sel" type:@"png"];
        UIColor *menuSelColor = [UIColor colorWithRed:92.0f/255.0f green:210.0f/255.0f blue:248.0f/255.0f alpha:1.0f];
        
        //first
        _btnMenuFirst = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 106, 43)];
        _btnMenuFirst.tag = 100;
        [_btnMenuFirst setBackgroundImage:menuSelImage forState:UIControlStateSelected];
        [_btnMenuFirst setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnMenuFirst setTitleColor:menuSelColor forState:UIControlStateSelected];
        [_btnMenuFirst setTitle:@"音乐基因" forState:UIControlStateNormal];
        _btnMenuFirst.titleLabel.font = [UIFont fontOfApp:17.0f];
        [self addSubview:_btnMenuFirst];
        
        //second
        _btnMenuSecond = [[UIButton alloc] initWithFrame:CGRectMake(107, 0, 106, 43)];
        _btnMenuSecond.tag = 101;
        [_btnMenuSecond setBackgroundImage:menuSelImage forState:UIControlStateSelected];
        [_btnMenuSecond setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnMenuSecond setTitleColor:menuSelColor forState:UIControlStateSelected];
        [_btnMenuSecond setTitle:@"歌单" forState:UIControlStateNormal];
        _btnMenuSecond.titleLabel.font = [UIFont fontOfApp:17.0f];
        [self addSubview:_btnMenuSecond];
        
        _btnMenuThird = [[UIButton alloc] initWithFrame:CGRectMake(214, 0,106, 43)];
        _btnMenuThird.tag = 102;
        [_btnMenuThird setBackgroundImage:menuSelImage forState:UIControlStateSelected];
        [_btnMenuThird setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnMenuThird setTitleColor:menuSelColor forState:UIControlStateSelected];
        [_btnMenuThird setTitle:@"歌友" forState:UIControlStateNormal];
        _btnMenuThird.titleLabel.font = [UIFont fontOfApp:17.0f];
        [self addSubview:_btnMenuThird];
        
    }
    return self;
    
}*/
#endif

-(void)setSelectedMenu:(int)aIndex{
    
    [_btnMenuFirst setSelected:NO];
    [_btnMenuSecond setSelected:NO];
    [_btnMenuThird setSelected:NO];
    [_btnMenuFirst setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnMenuSecond setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnMenuThird setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (aIndex == 0) {
        [_btnMenuFirst setSelected:YES];
        [_btnMenuFirst setTitleColor:RGB(63, 198, 241, 2) forState:UIControlStateNormal];
    } else if (aIndex == 1) {
        [_btnMenuSecond setSelected:YES];
        [_btnMenuSecond setTitleColor:RGB(63, 198, 241, 2) forState:UIControlStateNormal];
    } else if (aIndex == 2) {
        [_btnMenuThird setSelected:YES];
        [_btnMenuThird setTitleColor:RGB(63, 198, 241, 2) forState:UIControlStateNormal];
    }
    
}

//头像按钮事件
-(IBAction)doAvatar:(id)sender{
    
    PLog(@"gene doAvatar...");
    
    if ([UserSessionManager GetInstance].isLoggedIn) {
        
        SettingViewController *settingViewController = [[SettingViewController alloc] init];
        [self.topViewcontroller.navigationController pushViewController:settingViewController animated:YES];
        
    } else {
        
        LoginMenuViewController *loginMenuViewController = [[LoginMenuViewController alloc] initWithNibName:@"LoginMenuViewController" bundle:nil];
        [self.topViewcontroller.navigationController pushViewController:loginMenuViewController animated:YES];
        
    }
}

- (void)updateView {
    
    if ([UserSessionManager GetInstance].isLoggedIn) {
        
        _egoBtnAvatar.imageURL = [NSURL URLWithString:[UserSessionManager GetInstance].currentUser.head];
       // [_btnName setHidden:TRUE];
        /*
        NSString *nickname;
        if([UserSessionManager GetInstance].currentUser.gender==0)
            nickname =  [NSString stringWithFormat:@"%@ ♀",[UserSessionManager GetInstance].currentUser.nickname];
        else
            nickname =  [NSString stringWithFormat:@"%@ ♂",[UserSessionManager GetInstance].currentUser.nickname];*/
        
       // _btnName.titleLabel.text = nickname;
    }
    else {
        //[_btnName setHidden:FALSE];
        _egoBtnAvatar.imageURL = nil;
        //_btnName.titleLabel.text = @"请登录";
        
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
