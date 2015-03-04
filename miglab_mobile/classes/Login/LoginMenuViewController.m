//
//  LoginMenuViewController.m
//  miglab_mobile
//
//  Created by apple on 13-10-18.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "LoginMenuViewController.h"
#import "LoginMenuCell.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "SVProgressHUD.h"
#import "UserSessionManager.h"
#import "PDatabaseManager.h"
#import "PPlayerManagerCenter.h"
#import "GlobalDataManager.h"

@interface LoginMenuViewController ()

@end

@implementation LoginMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //register
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerFailed:) name:NotificationNameRegisterFailed object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerSuccess:) name:NotificationNameRegisterSuccess object:nil];
        
        //user
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoFailed:) name:NotificationNameGetUserInfoFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoSuccess:) name:NotificationNameGetUserInfoSuccess object:nil];
        
    }
    return self;
}

-(void)dealloc{
    
    //register
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameRegisterFailed object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameRegisterSuccess object:nil];
    
    //user
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetUserInfoFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetUserInfoSuccess object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //nav
    CGRect navViewFrame = self.navView.frame;
    float posy = navViewFrame.origin.y + navViewFrame.size.height;//ios6-45, ios7-65
    
    //nav bar
    self.navView.titleLabel.text = @"请登陆";
    
    //search
#if USE_MIYO_LOGIN
    UIImage *searchImage = [UIImage imageWithName:@"login_choose_register" type:@"png"];
    [self.navView.rightButton setBackgroundImage:searchImage forState:UIControlStateNormal];
    self.navView.rightButton.frame = CGRectMake(262, 7.5 + self.topDistance, 48, 29);
    [self.navView.rightButton setHidden:NO];
    [self.navView.rightButton addTarget:self action:@selector(doGotoRegister:) forControlEvents:UIControlEventTouchUpInside];
#endif
    
    //登陆
    //登陆标示
    UIImageView *loginImageView = [[UIImageView alloc] init];
    loginImageView.frame = CGRectMake(0, posy + 10, 30, 30);
    loginImageView.image = [UIImage imageWithName:@"login_logo.png" type:@"png"];
    [self.view addSubview:loginImageView];
    
    int y = 250;
    _dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, posy + 10+y, 320, kMainScreenHeight + self.topDistance - posy - 10 - 10 - 73 - 10) style:UITableViewStyleGrouped];
    _dataTableView.dataSource = self;
    _dataTableView.delegate = self;
    _dataTableView.backgroundColor = [UIColor clearColor];
    _dataTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _dataTableView.scrollEnabled = NO;
    
    /*UIImageView *bodyBgImageView = [[UIImageView alloc] init];
    bodyBgImageView.frame = CGRectMake(11.5, posy + 10, 297, kMainScreenHeight + self.topDistance - 44 - 10 - 10 - 73 - 10);
    bodyBgImageView.image = [UIImage imageWithName:@"body_bg" type:@"png"];
    _dataTableView.backgroundView = bodyBgImageView;
     */

    
    [self.view addSubview:_dataTableView];
    
    //
    NSMutableDictionary *dicMenu0 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"login_menu_icon_sinaweibo", @"MenuImageName", @"新浪微博登陆", @"MenuText", nil];

    NSMutableDictionary *dicMenu1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"login_menu_icon_qq", @"MenuImageName", @"QQ账号登陆", @"MenuText", nil];
    
    NSMutableDictionary *dicMenu2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"login_menu_icon_douban", @"MenuImageName", @"豆瓣账号登陆", @"MenuText", nil];
    

    NSArray *menulist0 = [NSArray arrayWithObjects:dicMenu0, dicMenu1, dicMenu2, nil];

    
#if USE_MIYO_LOGIN
    NSMutableDictionary *dicMenu10 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"music_source_menu_local", @"MenuImageName", @"用咪哟账号登陆", @"MenuText", nil];
    NSArray *menulist1 = [NSArray arrayWithObjects:dicMenu10, nil];

    _dataList = [NSMutableArray arrayWithObjects:menulist0, menulist1, nil];
#else
    _dataList = [NSMutableArray arrayWithObjects:menulist0, nil];
#endif
    
    //api
    _miglabAPI = [[MigLabAPI alloc] init];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //register
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerFailed:) name:NotificationNameRegisterFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerSuccess:) name:NotificationNameRegisterSuccess object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerFailed:) name:NotificationThirdLoginFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerSuccess:) name:NotificationThirdLoginSuccess object:nil];
    
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //register
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameRegisterFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameRegisterSuccess object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didFinishLogin {
    
    // 保存登录状态到本地, 1表示已登陆，0表示未登陆或退出登陆，如果退出登陆，下次启动时会检查该值，以免再重新登陆一次
    [[PDatabaseManager GetInstance] setLoginStatusInfo:1];
    
    // 发送登陆成功消息
    //[[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameLoginSuccessByUser object:nil userInfo:nil];
    
    // 发送设备号到服务端
    [self SendBDPushToken];
    //[self SendDeviceToken];
    
    // 如果当前没有播放，获取一次歌曲
#if USE_NEW_AUDIO_PLAY
    PAudioStreamerPlayer *asMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AudioStreamerPlayer];
    
    if (![asMusicPlayer isMusicPlaying]) {
#else //USE_NEW_AUDIO_PLAY
    PAAMusicPlayer* aaMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
    if (![aaMusicPlayer isMusicPlaying]) {
#endif //USE_NEW_AUDIO_PLAY
        
        [[PPlayerManagerCenter GetInstance] doNext];
    }
    
    // 开启登陆后引导
    if ([GlobalDataManager GetInstance].isProgramFirstLaunch) {
        
        [GlobalDataManager GetInstance].isGeneMenuFirstLaunch = YES;
    }
}

-(void)didFinishLogout {
    
}

-(void) SendBDPushToken{
    MigLabAPI *miglabApi = [[MigLabAPI alloc] init];
    NSString* userid = [UserSessionManager GetInstance].userid;
    NSString* accesstoken = [UserSessionManager GetInstance].accesstoken;
    NSString *channelid = [[UserSessionManager GetInstance].bdBindPush valueForKey:BPushRequestChannelIdKey];
    NSString *appid = [[UserSessionManager GetInstance].bdBindPush valueForKey:BPushRequestAppIdKey];
    NSString *bduserid = [[UserSessionManager GetInstance].bdBindPush valueForKey:BPushRequestUserIdKey];
    NSString *requestid = [[UserSessionManager GetInstance].bdBindPush valueForKey:BPushRequestRequestIdKey];
    NSString *ttag = @"miyo";
    NSString *machine = @"1";
    [miglabApi doSendBPushInfo:userid token:accesstoken channelid:channelid userid:bduserid tag:ttag
                           pkg: [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey] machine: machine appid: appid requestid:requestid];
    
    
    
}
    
-(void)SendDeviceToken {
        
    MigLabAPI* miglab = [[MigLabAPI alloc] init];
    
    NSString* userid = [UserSessionManager GetInstance].userid;
    NSString* accesstoken = [UserSessionManager GetInstance].accesstoken;
    NSString* device_token = [UserSessionManager GetInstance].devicetoken;
    
    [miglab doConfigPush:userid token:accesstoken devicetoken:device_token isreceive:@"1" begintime:@"08:00" endtime:@"23:55"];
}
    


-(IBAction)doGotoRegister:(id)sender{
    
    PLog(@"doGotoRegister...");
    
    RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:registerViewController animated:YES];
    
}

-(IBAction)doSinaWeiboLogin:(id)sender{
    
    PLog(@"doSinaWeiboLogin...");
    
    SinaWeiboHelper *sinaWeiboHelper = [SinaWeiboHelper sharedInstance];
    sinaWeiboHelper.delegate = self;
    [sinaWeiboHelper doSinaWeiboLogin];
    
}

-(IBAction)doQQLogin:(id)sender{
    
    PLog(@"doQQLogin...");
    
    TencentHelper *tencentHelper = [TencentHelper sharedInstance];
    tencentHelper.delegate = self;
    [tencentHelper doTencentLogin];
    
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
    
    NSDictionary *dic = [tNotification userInfo];
    NSLog(@"registerSuccess...");
    
    if (dic) {
        NSDictionary* result = [dic objectForKey:@"result"];
        
        
        PUser *tempUser = [PUser initWithNSDictionary:[result objectForKey:@"userinfo"]];
        [tempUser log];
        
        PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
        
        if ([UserSessionManager GetInstance].accounttype == SourceTypeSinaWeibo) {
            
           // [SVProgressHUD showSuccessWithStatus:@"新浪微博绑定成功:)"];
            
            tempUser.sinaAccount = [UserSessionManager GetInstance].currentUser.sinaAccount;
            tempUser.source = SourceTypeSinaWeibo;
            
            [databaseManager insertUserInfo:tempUser accountId:tempUser.sinaAccount.accountid];
            [databaseManager insertUserAccout:tempUser.sinaAccount.username password:tempUser.sinaAccount.username userid:tempUser.sinaAccount.accountid accessToken:tempUser.sinaAccount.accesstoken accountType:tempUser.sinaAccount.accounttype];
            
            PUser *checkuser = [databaseManager getUserInfoByAccountId:tempUser.sinaAccount.accountid];
            [checkuser log];
            
        } else if ([UserSessionManager GetInstance].accounttype == SourceTypeTencentWeibo) {
            
            //[SVProgressHUD showSuccessWithStatus:@"腾讯微博绑定成功:)"];
            
            tempUser.tencentAccount = [UserSessionManager GetInstance].currentUser.tencentAccount;
            tempUser.source = SourceTypeTencentWeibo;
            
            [databaseManager insertUserInfo:tempUser accountId:tempUser.tencentAccount.accountid];
            [databaseManager insertUserAccout:tempUser.tencentAccount.username password:tempUser.tencentAccount.username userid:tempUser.tencentAccount.accountid accessToken:tempUser.tencentAccount.accesstoken accountType:tempUser.tencentAccount.accounttype];
            
        } else if ([UserSessionManager GetInstance].accounttype == SourceTypeDouBan) {
            
            //[SVProgressHUD showSuccessWithStatus:@"豆瓣帐号绑定成功:)"];
            
            tempUser.doubanAccount = [UserSessionManager GetInstance].currentUser.doubanAccount;
            tempUser.source = SourceTypeDouBan;
            
            [databaseManager insertUserInfo:tempUser accountId:tempUser.doubanAccount.accountid];
            [databaseManager insertUserAccout:tempUser.doubanAccount.username password:tempUser.doubanAccount.username userid:tempUser.doubanAccount.accountid accessToken:tempUser.doubanAccount.accesstoken accountType:tempUser.doubanAccount.accounttype];
            
        }
        
        [UserSessionManager GetInstance].currentUser = tempUser;
        [UserSessionManager GetInstance].userid = tempUser.userid;
        [UserSessionManager GetInstance].accesstoken = tempUser.token;
        [UserSessionManager GetInstance].isLoggedIn = YES;
        
        [self didFinishLogin];
        
        //go back
        [self doBack:nil];
    }
    else {
        
        [self didFinishLogin];
        
        RootViewController *rootViewController = [RootViewController sharedInstance];
        [self.navigationController popToViewController:rootViewController animated:YES];
        
    }
    
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
    
    //[SVProgressHUD showSuccessWithStatus:@"用户信息获取成功:)"];
    
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

#pragma mark SinaWeiboHelperDelegate method

- (void)sinaWeiboLoginHelper:(SinaWeiboHelper *)sinaWeiboHelper didFailWithError:(NSError *)error
{
    NSString *userid = [UserSessionManager GetInstance].currentUser.userid;
    
    PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
    [databaseManager deleteUserAccountByUserName:userid];
    
    [SVProgressHUD showErrorWithStatus:@"sorry, 登录失败啦～"];
}

- (void)sinaWeiboLoginHelper:(SinaWeiboHelper *)sinaWeiboHelper didFinishLoadingWithResult:(NSDictionary *)result
{
    NSString *name = [result objectForKey:@"name"];
    NSString *screenName = [result objectForKey:@"screen_name"];
    NSString *gender = [result objectForKey:@"gender"];
    NSString *head = [result objectForKey:@"avatar_large"];
    NSString *location = [result objectForKey:@"location"];//地区 做URLCODE
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
    //[_miglabAPI doRegister:name password:name nickname:screenName source:accounttype session:userid sex:gender];
    [_miglabAPI doThirdLogin:1 nickname:screenName source:accounttype session:userid imei:@"888888" sex:gender birthday:DEFAULT_BIRTHDAY location:location head:head latitude:nil longitude:nil];
}

//update
- (void)sinaWeiboUpdateHelper:(SinaWeiboHelper *)sinaWeiboHelper didFailWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"新浪微博分享失败～"];
}

- (void)sinaWeiboUpdateHelper:(SinaWeiboHelper *)sinaWeiboHelper didFinishLoadingWithResult:(NSDictionary *)result
{
    [SVProgressHUD showSuccessWithStatus:@"新浪微博分享成功～"];
}

//end sina weibo

//tencent

#pragma mark TencentHelperDelegate method

- (void)tencentLoginHelper:(TencentHelper *)tencentHelper didFailWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"sorry, 登录失败啦～"];
}

- (void)tencentLoginHelper:(TencentHelper *)tencentHelper didFinishLoadingWithResult:(NSDictionary *)result
{
    NSString *name = [result objectForKey:@"nickname"];
    NSString *screenName = [result objectForKey:@"nickname"];
    NSString *gender = [result objectForKey:@"gender"];
    NSString *head = [result objectForKey:@"figureurl_2"];
    NSString *location = [result objectForKey:@"city"];
    
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
    //[_miglabAPI doRegister:name password:name nickname:screenName source:accounttype session:userid sex:gender];
    [_miglabAPI doThirdLogin:1 nickname:screenName source:accounttype session:userid  imei:@"8888" sex:gender birthday:DEFAULT_BIRTHDAY location:location head:head latitude:nil longitude:nil];
    
}

//end tencent

//douban

#pragma mark - DoubanAuthorizeViewDelegate

- (void)authorizeView:(DoubanAuthorizeView *)authView didRecieveAuthorizationResult:(NSDictionary *)result{
    
    NSString *douban_user_id = [result objectForKey:@"douban_user_id"];
    NSString *access_token = [result objectForKey:@"access_token"];
    NSString *douban_user_name = [result objectForKey:@"douban_user_name"];
    NSString *expires_in = [result objectForKey:@"expires_in"];
    NSString *gender = @"0";
    NSString *password = @"";
    
    AccountOf3rdParty *doubanAccount = [[AccountOf3rdParty alloc] init];
    doubanAccount.accountid = douban_user_id;
    doubanAccount.accesstoken = access_token;
    doubanAccount.expirationdate = [NSDate dateWithTimeIntervalSince1970:[expires_in longLongValue]];
    doubanAccount.accounttype = SourceTypeDouBan;
    doubanAccount.username = douban_user_name;
    doubanAccount.password = password;
    
    [UserSessionManager GetInstance].accounttype = SourceTypeDouBan;
    [UserSessionManager GetInstance].currentUser.doubanAccount = doubanAccount;
    [UserSessionManager GetInstance].currentUser.source = SourceTypeDouBan;
    
    //
    SourceType accounttype = [UserSessionManager GetInstance].accounttype;
    
    //注册和登录合并，第三方平台直接使用注册接口登录
    //[_miglabAPI doRegister:douban_user_name password:douban_user_name nickname:douban_user_name source:accounttype session:douban_user_id sex:gender];
    [_miglabAPI doThirdLogin:1 nickname:douban_user_name  source:accounttype session:douban_user_id imei:@"8888" sex:gender birthday:DEFAULT_BIRTHDAY location:DEFAULT_LOCATION head:DEFAULT_HEAD_MALE latitude:nil longitude:nil];
    
    [self didFinishLogin];
    
}

- (void)authorizeView:(DoubanAuthorizeView *)authView didFailWithErrorInfo:(NSDictionary *)errorInfo{
    
    //
    PLog(@"authorizeView didFailWithErrorInfo...");
    
}

- (void)authorizeViewDidCancel:(DoubanAuthorizeView *)authView{
    //
    PLog(@"authorizeViewDidCancel...");
    
}

//end douban

#pragma mark - UITableView delegate

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // ...
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            [self doSinaWeiboLogin:nil];
        } else if (indexPath.row == 1) {
#if USE_QQ_LOGIN
            [self doQQLogin:nil];
#else
            [self doDouBanLogin:nil];
#endif
        } else if (indexPath.row == 2) {
            [self doDouBanLogin:nil];
        }
        
    }
#if USE_MIYO_LOGIN
    else if (indexPath.section == 1) {
        [self doMiglabLogin:nil];
    }
#endif
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#if USE_MIYO_LOGIN
    return 2;
#else
    return 1;
#endif
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    PLog(@"section: %d", section);
    NSArray *sectionMenu = [_dataList objectAtIndex:section];
    return sectionMenu.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"LoginMenuCell";
	LoginMenuCell *cell = (LoginMenuCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"LoginMenuCell" owner:self options:nil];
        cell = (LoginMenuCell *)[nibContents objectAtIndex:0];
        cell.backgroundColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:0.5];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
    
    NSArray *sectionMenu = [_dataList objectAtIndex:indexPath.section];
    NSMutableDictionary *dicMenu = [sectionMenu objectAtIndex:indexPath.row];
    
    NSString* imgName = [dicMenu objectForKey:@"MenuImageName"];
    cell.iconImageView.image = [UIImage imageWithName:imgName];
    cell.iconImageView.frame = CGRectMake(60, 12, 31, 25);
    
    cell.lblDesc.font = [UIFont fontOfApp:17.0f];
    cell.lblDesc.textColor = [UIColor whiteColor];
    cell.lblDesc.text = [dicMenu objectForKey:@"MenuText"];
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
}

@end
