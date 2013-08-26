//
//  LoginChooseViewController.m
//  miglab_mobile
//
//  Created by pig on 13-7-30.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "LoginChooseViewController.h"
#import "MigLabConfig.h"
#import "AppDelegate.h"
#import "DDMenuController.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "SVProgressHUD.h"
#import "UserSessionManager.h"
#import "PDatabaseManager.h"
#import "MainMenuViewController.h"
#import "WebViewController.h"

@interface NSString (ParseCategory)
- (NSMutableDictionary *)explodeToDictionaryInnerGlue:(NSString *)innerGlue
                                           outterGlue:(NSString *)outterGlue;
@end

@implementation NSString (ParseCategory)

- (NSMutableDictionary *)explodeToDictionaryInnerGlue:(NSString *)innerGlue
                                           outterGlue:(NSString *)outterGlue {
    // Explode based on outter glue
    NSArray *firstExplode = [self componentsSeparatedByString:outterGlue];
    NSArray *secondExplode;
    
    // Explode based on inner glue
    NSInteger count = [firstExplode count];
    NSMutableDictionary* returnDictionary = [NSMutableDictionary dictionaryWithCapacity:count];
    for (NSInteger i = 0; i < count; i++) {
        secondExplode =
        [(NSString*)[firstExplode objectAtIndex:i] componentsSeparatedByString:innerGlue];
        if ([secondExplode count] == 2) {
            [returnDictionary setObject:[secondExplode objectAtIndex:1]
                                 forKey:[secondExplode objectAtIndex:0]];
        }
    }
    return returnDictionary;
}

@end

@interface LoginChooseViewController ()

@end

@implementation LoginChooseViewController

@synthesize bgImageView = _bgImageView;
@synthesize btnTopMenu = _btnTopMenu;
@synthesize btnTopRegister = _btnTopRegister;
@synthesize btnSinaWeibo = _btnSinaWeibo;
@synthesize btnQQ = _btnQQ;
@synthesize btnDouBan = _btnDouBan;
@synthesize btnMiglab = _btnMiglab;

@synthesize popWindow = _popWindow;

@synthesize tencentOAuth = _tencentOAuth;
@synthesize permissions = _permissions;

@synthesize miglabAPI = _miglabAPI;

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
    
    //register
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerFailed:) name:NotificationNameRegisterFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerSuccess:) name:NotificationNameRegisterSuccess object:nil];
    
    //user
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoFailed:) name:NotificationNameGetUserInfoFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoSuccess:) name:NotificationNameGetUserInfoSuccess object:nil];
    
    _bgImageView.frame = kMainScreenFrame;
    
    //sina weibo
    
    //tencent
    _permissions = [NSArray arrayWithObjects:
                     kOPEN_PERMISSION_GET_USER_INFO,
                     kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                     kOPEN_PERMISSION_ADD_ALBUM,
                     kOPEN_PERMISSION_ADD_IDOL,
                     kOPEN_PERMISSION_ADD_ONE_BLOG,
                     kOPEN_PERMISSION_ADD_PIC_T,
                     kOPEN_PERMISSION_ADD_SHARE,
                     kOPEN_PERMISSION_ADD_TOPIC,
                     kOPEN_PERMISSION_CHECK_PAGE_FANS,
                     kOPEN_PERMISSION_DEL_IDOL,
                     kOPEN_PERMISSION_DEL_T,
                     kOPEN_PERMISSION_GET_FANSLIST,
                     kOPEN_PERMISSION_GET_IDOLLIST,
                     kOPEN_PERMISSION_GET_INFO,
                     kOPEN_PERMISSION_GET_OTHER_INFO,
                     kOPEN_PERMISSION_GET_REPOST_LIST,
                     kOPEN_PERMISSION_LIST_ALBUM,
                     kOPEN_PERMISSION_UPLOAD_PIC,
                     kOPEN_PERMISSION_GET_VIP_INFO,
                     kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                     kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
                     kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                     nil];
    
	_tencentOAuth = [[TencentOAuth alloc] initWithAppId:TENCENT_WEIBO_APP_KEY
											andDelegate:self];
    
    //api
    _miglabAPI = [[MigLabAPI alloc] init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)doShowLeftMenu:(id)sender{
    
    PLog(@"doShowLeftMenu...");
    
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController showLeftController:YES];
    
}

-(IBAction)doGotoRegister:(id)sender{
    
    PLog(@"doGotoRegister...");
    
    RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:registerViewController animated:YES];
    
}

-(IBAction)doSinaWeiboLogin:(id)sender{
    
    PLog(@"doSinaWeiboLogin...");
    
    [self removeAuthData];
    
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo logIn];
    
}

-(IBAction)doQQLogin:(id)sender{
    
    PLog(@"doQQLogin...");
    
    [_tencentOAuth authorize:_permissions inSafari:NO];
    
}

-(IBAction)doDouBanLogin:(id)sender{
    
    PLog(@"doDouBanLogin...");
    
    NSString *str = [NSString stringWithFormat:@"https://www.douban.com/service/auth2/auth?client_id=%@&redirect_uri=%@&response_type=code", DOUBAN_API_KEY, DOUBAN_REDIRECTURL];
    
    NSString *urlStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    UIViewController *webViewController = [[WebViewController alloc] initWithRequestURL:url];
    [self.navigationController pushViewController:webViewController animated:YES];
    
    
    //pop
    /*
    UIView *tempview = [[UIView alloc] init];
    tempview.frame = CGRectMake(0, 20, kMainScreenWidth, kMainScreenHeight);
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClose.frame = CGRectMake(0, 0, 44, 44);
    [btnClose addTarget:self action:@selector(doCloseDoubanLogin:) forControlEvents:UIControlEventTouchUpInside];
    [tempview addSubview:btnClose];
    
    UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, kMainScreenWidth, kMainScreenHeight - 44)];
    webview.scalesPageToFit = YES;
    webview.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webview loadRequest:request];
    [tempview addSubview:webview];
    
    _popWindow = [[CustomWindow alloc] initWithView:tempview];
    [_popWindow show];
    */
    
//    DOUService *service = [DOUService sharedInstance];
//    
//    NSString *str = [NSString stringWithFormat:@"https://www.douban.com/service/auth2/auth?client_id=%@&redirect_uri=%@&response_type=code", DOUBAN_API_KEY, DOUBAN_REDIRECTURL];
//    DOUQuery *query = [[DOUQuery alloc] initWithSubPath:str parameters:nil];
//    query.apiBaseUrlString = service.apiBaseUrlString;
//    DOUHttpRequest *req = [DOUHttpRequest requestWithQuery:query target:self];
//    
//    [service addRequest:req];
    
    
}

-(IBAction)doCloseDoubanLogin:(id)sender{
    
    PLog(@"doCloseDoubanLogin...");
    [_popWindow setHidden:YES];
    [_popWindow close];
    
}

-(IBAction)doMiglabLogin:(id)sender{
    
    PLog(@"doMiglabLogin...");
    
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginViewController animated:YES];
    
}

-(void)doGotoMainMenuView{
    
    PLog(@"doGotoMainMenuView...");
    
    MainMenuViewController *mainMenuViewController = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainMenuViewController];
    [nav setNavigationBarHidden:YES];
    
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController setRootController:nav animated:YES];
    
}

//register notification
-(void)registerFailed:(NSNotification *)tNotification{
    
    NSDictionary *result = [tNotification userInfo];
    NSLog(@"registerFailed: %@", result);
    
    NSString *msg = [result objectForKey:@"msg"];
    [SVProgressHUD showErrorWithStatus:msg];
    
}

-(void)registerSuccess:(NSNotification *)tNotification{
    
    NSDictionary *result = [tNotification userInfo];
    NSLog(@"registerSuccess: %@", result);
    
    if ([UserSessionManager GetInstance].currentUser.source == SourceTypeSinaWeibo) {
        
        [SVProgressHUD showSuccessWithStatus:@"使用新浪微博注册成功:)"];
        
    }

    
}

//getUserInfo notification
-(void)getUserInfoFailed:(NSNotification *)tNotification{
    
    NSDictionary *result = [tNotification userInfo];
    NSLog(@"getUserInfoFailed: %@", result);
    [SVProgressHUD showErrorWithStatus:@"用户信息获取失败:("];
    
    NSString *username = [UserSessionManager GetInstance].currentUser.username;
    NSString *nickname = [UserSessionManager GetInstance].currentUser.nickname;
    
    [_miglabAPI doRegister:username password:username nickname:nickname source:SourceTypeSinaWeibo];
    
}

-(void)getUserInfoSuccess:(NSNotification *)tNotification{
    
    NSDictionary* result = [tNotification userInfo];
    NSLog(@"getUserInfoSuccess...%@", result);
    
    PUser* user = [result objectForKey:@"result"];
    [user log];
    
    [SVProgressHUD showSuccessWithStatus:@"用户信息获取成功:)"];
    
    user.password = [UserSessionManager GetInstance].currentUser.password;
    [UserSessionManager GetInstance].currentUser = user;
    
    NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
    NSString *username = [UserSessionManager GetInstance].currentUser.username;
    NSString *password = [UserSessionManager GetInstance].currentUser.password;
    NSString *userid = [UserSessionManager GetInstance].currentUser.userid;
    int accounttype = [UserSessionManager GetInstance].currentUser.source;
    
    PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
    [databaseManager insertUserAccout:username password:password userid:userid accessToken:accesstoken accountType:accounttype];
    
    //go back
    [self doBack:nil];
    
}

//sina weibo
-(SinaWeibo *)sinaweibo{
    
    //sina weibo
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.sinaweibo) {
        appDelegate.sinaweibo.delegate = self;
        return appDelegate.sinaweibo;
    }
    appDelegate.sinaweibo = [[SinaWeibo alloc] initWithAppKey:SINA_WEIBO_APP_KEY appSecret:SINA_WEIBO_APP_SECRET appRedirectURI:SINA_WEIBO_APP_REDIRECTURI andDelegate:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        appDelegate.sinaweibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        appDelegate.sinaweibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        appDelegate.sinaweibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    }
    return appDelegate.sinaweibo;
}

- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
}

- (void)storeAuthData
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)getUserInfoFromSinaWeibo
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"users/show.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
}

#pragma mark - SinaWeibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    
    [UserSessionManager GetInstance].currentUser.source = SourceTypeSinaWeibo;
    [UserSessionManager GetInstance].currentUser.userid = sinaweibo.userID;
    [UserSessionManager GetInstance].accesstoken = sinaweibo.accessToken;
    
    [self storeAuthData];
    [self getUserInfoFromSinaWeibo];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
    [self removeAuthData];
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
    [self removeAuthData];
}

#pragma mark - SinaWeiboRequest Delegate

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    if ([request.url hasSuffix:@"users/show.json"])
    {
        PLog(@"didFailWithError...%@", request.url);
        
        NSString *userid = [UserSessionManager GetInstance].currentUser.userid;
        
        PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
        [databaseManager deleteUserAccountByUserName:userid];
        
    }
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:@"users/show.json"])
    {
        PLog(@"didFinishLoadingWithResult: %@", result);
        
        if (result && [result isKindOfClass:[NSDictionary class]]) {
            
            NSString *name = [result objectForKey:@"name"];
            NSString *screenName = [result objectForKey:@"screen_name"];
            
            //写入缓存
            [UserSessionManager GetInstance].currentUser.username = name;
            [UserSessionManager GetInstance].currentUser.nickname = screenName;
            [UserSessionManager GetInstance].isLoggedIn = YES;
            
            NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
            NSString *userid = [UserSessionManager GetInstance].currentUser.userid;
            int accounttype = [UserSessionManager GetInstance].currentUser.source;
            
            PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
            [databaseManager insertUserAccout:name password:name userid:userid accessToken:accesstoken accountType:accounttype];
            
            //检查服务端是否已经记录该帐号
            [_miglabAPI doGetUserInfo:name accessToken:[UserSessionManager GetInstance].accesstoken];
            
            [self doBack:nil];
            
        }//if
        
    }
}

//end sina weibo

//tencent weibo

/**
 * Called when the user successfully logged in.
 */
- (void)tencentDidLogin {
    
	// 登录成功
    
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        PLog(@"_tencentOAuth.openId: %@", _tencentOAuth.openId);
        PLog(@"_tencentOAuth.accessToken: %@", _tencentOAuth.accessToken);
        PLog(@"_tencentOAuth.expirationDate: %@", _tencentOAuth.expirationDate);
        
        [UserSessionManager GetInstance].currentUser.source = SourceTypeTencentWeibo;
        [UserSessionManager GetInstance].currentUser.userid = _tencentOAuth.openId;
        [UserSessionManager GetInstance].accesstoken = _tencentOAuth.accessToken;
        
        if(![_tencentOAuth getUserInfo]){
            [self showInvalidTokenOrOpenIDMessage];
        }
        
    }
    else
    {
        PLog(@"登录不成功 没有获取accesstoken");
    }
    
}


/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
	if (cancelled){
        NSLog(@"用户取消登录");
    }
	else {
        NSLog(@"登录失败");
	}
	
}

/**
 * Called when the notNewWork.
 */
-(void)tencentDidNotNetWork
{
    NSLog(@"无网络连接，请设置网络");
}

- (void)showInvalidTokenOrOpenIDMessage{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"api调用失败" message:@"可能授权已过期，请重新获取" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

/**
 * Called when the get_user_info has response.
 */
- (void)getUserInfoResponse:(APIResponse*) response {
	if (response.retCode == URLREQUEST_SUCCEED)
	{
        PLog(@"response.jsonResponse: %@", response.jsonResponse);
        
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[NSString stringWithFormat:@"%@",str]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
	}
	else
    {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"%@", response.errorMsg]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
	}
//	_labelTitle.text=@"获取个人信息完成";
    
}

//end tencent weibo

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *urlObj =  [request URL];
    NSString *url = [urlObj absoluteString];
    
    
    if ([url hasPrefix:DOUBAN_REDIRECTURL]) {
        
        NSString *query = [urlObj query];
        NSMutableDictionary *parsedQuery = [query explodeToDictionaryInnerGlue:@"="
                                                                    outterGlue:@"&"];
        
        //access_denied
        NSString *error = [parsedQuery objectForKey:@"error"];
        if (error) {
            return NO;
        }
        
        //access_accept
        NSString *code = [parsedQuery objectForKey:@"code"];
        DOUOAuthService *service = [DOUOAuthService sharedInstance];
        service.authorizationURL = kTokenUrl;
        service.delegate = self;
        service.clientId = DOUBAN_API_KEY;
        service.clientSecret = DOUBAN_PRIVATE_KEY;
        service.callbackURL = DOUBAN_REDIRECTURL;
        service.authorizationCode = code;
        
        [service validateAuthorizationCode];
        
        return NO;
    }
    
    return YES;
}


- (void)OAuthClient:(DOUOAuthService *)client didAcquireSuccessDictionary:(NSDictionary *)dic {
    
    NSLog(@"success!");
    NSLog(@"dic: %@", dic);
    
    NSString *userid = [dic objectForKey:@"douban_user_id"];
    NSString *accesstoken = [dic objectForKey:@"access_token"];
    NSString *username = [dic objectForKey:@"douban_user_name"];
    NSString *password = username;
    int accounttype = SourceTypeDouBan;
    
    [UserSessionManager GetInstance].userid = userid;
    [UserSessionManager GetInstance].accesstoken = accesstoken;
    [UserSessionManager GetInstance].currentUser.userid = userid;
    [UserSessionManager GetInstance].currentUser.username = username;
    [UserSessionManager GetInstance].currentUser.source = SourceTypeDouBan;
    [UserSessionManager GetInstance].isLoggedIn = YES;
    
    PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
    [databaseManager insertUserAccout:username password:password userid:userid accessToken:accesstoken accountType:accounttype];
    
    //检查服务端是否已经记录该帐号
    [_miglabAPI doGetUserInfo:username accessToken:[UserSessionManager GetInstance].accesstoken];
    
    //
    [self doBack:nil];
    
}

- (void)OAuthClient:(DOUOAuthService *)client didFailWithError:(NSError *)error {
    NSLog(@"Fail!");
}

@end
