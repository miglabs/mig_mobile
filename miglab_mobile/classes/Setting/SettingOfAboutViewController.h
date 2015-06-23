//
//  SettingOfAboutViewController.h
//  miglab_mobile
//
//  Created by pig on 13-9-25.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingOfAboutViewController : BaseViewController<UIActionSheetDelegate>

@property (nonatomic, retain) UIImageView *iconImageView;
@property (nonatomic, retain) UIButton *btnShare;
@property (nonatomic, retain) UIButton *btnQRCode;
@property (nonatomic, retain) UIButton *btnFAQ;
@property (nonatomic, retain) UILabel *lblRight;

@property (nonatomic, retain) UIImageView *qrImageView;
@property (nonatomic, retain) UIImage *screenCaptureImage;
@property (nonatomic, retain) UIActionSheet *qrAchtionSheet; // 二维码
@property (nonatomic,retain) UIAlertController *qrAlertController; // IO8二维码

- (IBAction)shareToWeixin:(id)sender;
- (IBAction)popQRcode:(id)sender;
- (IBAction)popFAQ:(id)sender;
- (IBAction)dismissQRcode:(id)sender;

@end
