//
//  DoubanAuthorizeView.h
//  miglab_mobile
//
//  Created by pig on 13-8-28.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <libDoubanApiEngine/DOUAPIEngine.h>

@class DoubanAuthorizeView;

@protocol DoubanAuthorizeViewDelegate <NSObject>

- (void)authorizeView:(DoubanAuthorizeView *)authView didRecieveAuthorizationResult:(NSDictionary *)result;
- (void)authorizeView:(DoubanAuthorizeView *)authView didFailWithErrorInfo:(NSDictionary *)errorInfo;
- (void)authorizeViewDidCancel:(DoubanAuthorizeView *)authView;

@end

@interface DoubanAuthorizeView : UIView<UIWebViewDelegate, DOUOAuthServiceDelegate>

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIButton *closeButton;
@property (nonatomic, retain) UIView *modalBackgroundView;
@property (nonatomic, retain) UIActivityIndicatorView *indicatorView;
@property (nonatomic, assign) UIInterfaceOrientation previousOrientation;

@property (nonatomic, assign) id<DoubanAuthorizeViewDelegate> delegate;
@property (nonatomic, retain) NSString *requestUrl;

@property (nonatomic, retain) NSString *kAPIKey;
@property (nonatomic, retain) NSString *kPrivateKey;
@property (nonatomic, retain) NSString *kRedirectUrl;

- (id)initWithAuthRequestUrl:(NSString *)requestUrl delegate:(id<DoubanAuthorizeViewDelegate>)delegate;

- (void)load;
- (void)show;
- (void)hide;

@end
