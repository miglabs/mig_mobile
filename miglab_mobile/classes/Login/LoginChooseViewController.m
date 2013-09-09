//
//  LoginChooseViewController.m
//  miglab_mobile
//
//  Created by pig on 13-7-30.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "LoginChooseViewController.h"
#import "MigLabConfig.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "SVProgressHUD.h"
#import "UserSessionManager.h"
#import "PDatabaseManager.h"

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
    
    NSString *requestUrl = [NSString stringWithFormat:@"https://www.douban.com/service/auth2/auth?client_id=%@&redirect_uri=%@&response_type=code", DOUBAN_API_KEY, DOUBAN_REDIRECTURL];
    DoubanAuthorizeView *authorizeView = [[DoubanAuthorizeView alloc] initWithAuthRequestUrl:requestUrl delegate:self];
    authorizeView.kAPIKey = DOUBAN_API_KEY;
    authorizeView.kPrivateKey = DOUBAN_PRIVATE_KEY;
    authorizeView.kRedirectUrl = DOUBAN_REDIRECTURL;
    [authorizeView show];
    
}

-(IBAction)doMiglabLogin:(id)sender{
    
    PLog(@"doMiglabLogin...");
    
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginViewController animated:YES];
    
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
    NSLog(@"registerSuccess...");
    PUser *tempUser = [result objectForKey:@"result"];
    [tempUser log];
    
    PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
    
    if ([UserSessionManager GetInstance].accounttype == SourceTypeSinaWeibo) {
        
        [SVProgressHUD showSuccessWithStatus:@"新浪微博绑定成功:)"];
        
        tempUser.sinaAccount = [UserSessionManager GetInstance].currentUser.sinaAccount;
        tempUser.source = SourceTypeSinaWeibo;
        
        [databaseManager insertUserInfo:tempUser accountId:tempUser.sinaAccount.accountid];
        [databaseManager insertUserAccout:tempUser.sinaAccount.username password:tempUser.sinaAccount.username userid:tempUser.sinaAccount.accountid accessToken:tempUser.sinaAccount.accesstoken accountType:tempUser.sinaAccount.accounttype];
        
        PUser *checkuser = [databaseManager getUserInfoByAccountId:tempUser.sinaAccount.accountid];
        [checkuser log];
        
    } else if ([UserSessionManager GetInstance].accounttype == SourceTypeTencentWeibo) {
        
        [SVProgressHUD showSuccessWithStatus:@"腾讯微博绑定成功:)"];
        
        tempUser.tencentAccount = [UserSessionManager GetInstance].currentUser.tencentAccount;
        tempUser.source = SourceTypeTencentWeibo;
        
        [databaseManager insertUserInfo:tempUser accountId:tempUser.tencentAccount.accountid];
        [databaseManager insertUserAccout:tempUser.tencentAccount.username password:tempUser.tencentAccount.username userid:tempUser.tencentAccount.accountid accessToken:tempUser.tencentAccount.accesstoken accountType:tempUser.tencentAccount.accounttype];
        
    } else if ([UserSessionManager GetInstance].accounttype == SourceTypeDouBan) {
        
        [SVProgressHUD showSuccessWithStatus:@"豆瓣帐号绑定成功:)"];
        
        tempUser.doubanAccount = [UserSessionManager GetInstance].currentUser.doubanAccount;
        tempUser.source = SourceTypeDouBan;
        
        [databaseManager insertUserInfo:tempUser accountId:tempUser.doubanAccount.accountid];
        [databaseManager insertUserAccout:tempUser.doubanAccount.username password:tempUser.doubanAccount.username userid:tempUser.doubanAccount.accountid accessToken:tempUser.doubanAccount.accesstoken accountType:tempUser.doubanAccount.accounttype];
        
    }
    
    [UserSessionManager GetInstance].currentUser = tempUser;
    [UserSessionManager GetInstance].userid = tempUser.userid;
    [UserSessionManager GetInstance].accesstoken = tempUser.token;
    [UserSessionManager GetInstance].isLoggedIn = YES;
    
    //go back
    [self doBack:nil];
    
}

//getUserInfo notification
-(void)getUserInfoFailed:(NSNotification *)tNotification{
    
    NSDictionary *result = [tNotification userInfo];
    NSLog(@"getUserInfoFailed: %@", result);
    [SVProgressHUD showErrorWithStatus:@"用户信息获取失败:("];
    
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
    
    AccountOf3rdParty *sinaAccount = [[AccountOf3rdParty alloc] init];
    sinaAccount.accountid = sinaweibo.userID;
    sinaAccount.accesstoken = sinaweibo.accessToken;
    sinaAccount.expirationdate = sinaweibo.expirationDate;
    sinaAccount.accounttype = SourceTypeSinaWeibo;
    
    [UserSessionManager GetInstance].accounttype = SourceTypeSinaWeibo;
    [UserSessionManager GetInstance].currentUser.sinaAccount = sinaAccount;
    [UserSessionManager GetInstance].currentUser.source = SourceTypeSinaWeibo;
    
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
            NSString *gender = [result objectForKey:@"gender"];
            
            //写入缓存
            [UserSessionManager GetInstance].currentUser.sinaAccount.username = name;
            if ([gender isEqualToString:@"m"]) {
                gender = [NSString stringWithFormat:@"%d", 1];
            } else {
                gender = [NSString stringWithFormat:@"%d", 0];
            }
            
            //
            NSString *userid = [UserSessionManager GetInstance].currentUser.sinaAccount.accountid;
            SourceType accounttype = [UserSessionManager GetInstance].accounttype;
            
            //注册和登录合并，第三方平台直接使用注册接口登录
            [_miglabAPI doRegister:name password:name nickname:screenName source:accounttype session:userid sex:gender];
            
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
        
        AccountOf3rdParty *tencentAccount = [[AccountOf3rdParty alloc] init];
        tencentAccount.accountid = _tencentOAuth.openId;
        tencentAccount.accesstoken = _tencentOAuth.accessToken;
        tencentAccount.expirationdate = _tencentOAuth.expirationDate;
        tencentAccount.accounttype = SourceTypeTencentWeibo;
        
        [UserSessionManager GetInstance].accounttype = SourceTypeTencentWeibo;
        [UserSessionManager GetInstance].currentUser.tencentAccount = tencentAccount;
        [UserSessionManager GetInstance].currentUser.source = SourceTypeTencentWeibo;
        
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
        
        NSDictionary *result = response.jsonResponse;
        NSString *name = [result objectForKey:@"nickname"];
        NSString *screenName = [result objectForKey:@"nickname"];
        NSString *gender = [result objectForKey:@"gender"];
        
        //写入缓存
        [UserSessionManager GetInstance].currentUser.tencentAccount.username = name;
        if ([gender isEqualToString:@"男"]) {
            gender = [NSString stringWithFormat:@"%d", 1];
        } else {
            gender = [NSString stringWithFormat:@"%d", 0];
        }
        
        //
        NSString *userid = [UserSessionManager GetInstance].currentUser.tencentAccount.accountid;
        SourceType accounttype = [UserSessionManager GetInstance].accounttype;
        
        //注册和登录合并，第三方平台直接使用注册接口登录
        [_miglabAPI doRegister:name password:name nickname:screenName source:accounttype session:userid sex:gender];
        
        /*
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[NSString stringWithFormat:@"%@",str]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
        */
	}
	else
    {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"%@", response.errorMsg]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
	}
    
}

//end tencent weibo

#pragma mark - DoubanAuthorizeViewDelegate

- (void)authorizeView:(DoubanAuthorizeView *)authView didRecieveAuthorizationResult:(NSDictionary *)result{
    
    NSString *douban_user_id = [result objectForKey:@"douban_user_id"];
    NSString *access_token = [result objectForKey:@"access_token"];
    NSString *douban_user_name = [result objectForKey:@"douban_user_name"];
    NSString *expires_in = [result objectForKey:@"expires_in"];
    NSString *gender = @"0";
    
    AccountOf3rdParty *doubanAccount = [[AccountOf3rdParty alloc] init];
    doubanAccount.accountid = douban_user_id;
    doubanAccount.accesstoken = access_token;
    doubanAccount.expirationdate = [NSDate dateWithTimeIntervalSince1970:[expires_in longLongValue]];
    doubanAccount.accounttype = SourceTypeDouBan;
    
    [UserSessionManager GetInstance].accounttype = SourceTypeSinaWeibo;
    [UserSessionManager GetInstance].currentUser.doubanAccount = doubanAccount;
    [UserSessionManager GetInstance].currentUser.source = SourceTypeSinaWeibo;
    
    //
    SourceType accounttype = [UserSessionManager GetInstance].accounttype;
    
    //注册和登录合并，第三方平台直接使用注册接口登录
    [_miglabAPI doRegister:douban_user_name password:douban_user_name nickname:douban_user_name source:accounttype session:douban_user_id sex:gender];
    
}

- (void)authorizeView:(DoubanAuthorizeView *)authView didFailWithErrorInfo:(NSDictionary *)errorInfo{
    
    //
    PLog(@"authorizeView didFailWithErrorInfo...");
    
}

- (void)authorizeViewDidCancel:(DoubanAuthorizeView *)authView{
    //
    PLog(@"authorizeViewDidCancel...");
    
}

@end
