//
//  SettingOfAboutViewController.m
//  miglab_mobile
//
//  Created by pig on 13-9-25.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "SettingOfAboutViewController.h"
#import "GlobalDataManager.h"
#import "WXApi.h"
#import "SVProgressHUD.h"

@interface SettingOfAboutViewController ()

@end

@implementation SettingOfAboutViewController

@synthesize iconImageView = _iconImageView;
@synthesize btnFAQ = _btnFAQ;
@synthesize btnQRCode = _btnQRCode;
@synthesize btnShare = _btnShare;
@synthesize lblRight = _lblRight;
@synthesize qrImageView = _qrImageView;
@synthesize screenCaptureImage = _screenCaptureImage;
@synthesize qrAchtionSheet = _qrAchtionSheet;
@synthesize qrAlertController = _qrAlertController;

UIView *gobackgroundView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:241.0f/255.0f blue:237.0f/255.0f alpha:1.0f];
    
    //nav
    CGRect navViewFrame = self.navView.frame;
    float posy = navViewFrame.origin.y + navViewFrame.size.height;//ios6-45, ios7-65
    
    //nav bar
    self.navView.titleLabel.text = @"关于咪哟";
    self.bgImageView.hidden = YES;
    
    //icon
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kMainScreenWidth - 261) / 2, posy + 55, 261, 204)];
    _iconImageView.image = [UIImage imageNamed:@"logo_about.png"];
    [self.view addSubview:_iconImageView];
    
    float remainHeight = kMainScreenHeight - (posy + 55 + 261);
    posy = kMainScreenHeight - remainHeight / 2 - 40;
    
    float hunit = 261 / 15.0f;
    float hstart = (kMainScreenWidth - 261) / 2;
    float btnheight = 25;
    _btnShare = [[UIButton alloc] initWithFrame:CGRectMake(hstart, posy, 4 * hunit, btnheight)];
    [_btnShare setTitle:@"分享微信" forState:UIControlStateNormal];
    [_btnShare setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_btnShare.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [_btnShare addTarget:self action:@selector(shareToWeixin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnShare];
    
    hstart += 4 * hunit;
    UIImageView *sep1 = [[UIImageView alloc] initWithFrame:CGRectMake(hstart + hunit - 5, posy + 10, 5, 5)];
    [sep1 setImage:[UIImage imageNamed:@"point.png"]];
    [self.view addSubview:sep1];
    
    hstart += 2 * hunit;
    _btnQRCode = [[UIButton alloc] initWithFrame:CGRectMake(hstart, posy, 3 * hunit, btnheight)];
    [_btnQRCode setTitle:@"二维码" forState:UIControlStateNormal];
    [_btnQRCode setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_btnQRCode.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [_btnQRCode addTarget:self action:@selector(popQRcode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnQRCode];
    
    hstart += 3 * hunit;
    UIImageView *sep2 = [[UIImageView alloc] initWithFrame:CGRectMake(hstart + hunit, posy + 10, 5, 5)];
    [sep2 setImage:[UIImage imageNamed:@"point.png"]];
    [self.view addSubview:sep2];
    
    hstart += 2 * hunit;
    _btnFAQ = [[UIButton alloc] initWithFrame:CGRectMake(hstart, posy, 4 * hunit, btnheight)];
    [_btnFAQ setTitle:@"常见问题" forState:UIControlStateNormal];
    [_btnFAQ setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_btnFAQ.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [_btnFAQ addTarget:self action:@selector(popFAQ:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnFAQ];
    
    NSString *szRight = @"Copyright2013-2015 Miglab Team 版权所有";
    _lblRight = [[UILabel alloc] initWithFrame:CGRectMake(10, kMainScreenHeight - 30, kMainScreenWidth - 20, 15)];
    [_lblRight setFont:[UIFont systemFontOfSize:12]];
    [_lblRight setText:szRight];
    [_lblRight setTextColor:[UIColor lightGrayColor]];
    [_lblRight setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_lblRight];
    
    _qrImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [_qrImageView setImage:[UIImage imageNamed:@"睡觉.jpg"]];
}

- (IBAction)shareToWeixin:(id)sender
{
    
    PLog(@"doShare2WeiXin...");
    
    //分享到微信朋友圈
    if (![WXApi isWXAppInstalled]) {
        
        [SVProgressHUD showErrorWithStatus:MIGTIP_NOT_FOUND_WEIXIN];
        
        return;
    }
    
    if (![WXApi isWXAppSupportApi]) {
        
        [SVProgressHUD showErrorWithStatus:MIGTIP_WEIXIN_OUT_OF_DATE];
        
        return;
    }
    
    UIImage *shareImage = [UIImage imageNamed:@"about_icon.png"];
    //
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"咪哟 - FIR.im";
    [message setThumbImage:shareImage];
    
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"http://fir.im/imiyo/";
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    [WXApi sendReq:req];
}

- (IBAction)popQRcode:(id)sender
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    gobackgroundView = [[UIView alloc] initWithFrame:kApplicationFrame];
    gobackgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    _qrImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth/2, kMainScreenHeight/2, 1, 1)];
    [_qrImageView setImage:[UIImage imageNamed:@"code.png"]];
    [gobackgroundView addSubview:_qrImageView];
    
    UITapGestureRecognizer *singletab = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissQRcode:)];
    singletab.numberOfTapsRequired = 1;
    [gobackgroundView addGestureRecognizer:singletab];
    
    [window addSubview:gobackgroundView];
    
    [UIView animateWithDuration:0.4 animations:^{
        _qrImageView.frame = CGRectMake((kMainScreenWidth - 100) / 2, (kMainScreenHeight - 100) / 2, 100, 100);
    } completion:^(BOOL finished) {
    }];
}

- (IBAction)popFAQ:(id)sender
{
    NSString *str = @"http://www.zhihu.com/question/31771410";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (IBAction)dismissQRcode:(id)sender
{
    [UIView animateWithDuration:0.4 animations:^{
        _qrImageView.frame = CGRectMake(kMainScreenWidth/2, kMainScreenHeight/2, 1, 1);
    } completion:^(BOOL finished) {
        
    }];
    [gobackgroundView removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
