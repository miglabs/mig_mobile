//
//  ChatViewController.m
//  miglab_chat
//
//  Created by 180 on 14-4-1.
//  Copyright (c) 2014年 180. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatMsgContentView.h"
#import "ChatInputToolBar.h"
#import "ChatJoinToolBar.h"
#import "ChatNotification.h"
#import "ChatEntity.h"
#define kMainScreenFrame [[UIScreen mainScreen] bounds]
#define kMainScreenWidth kMainScreenFrame.size.width
#define kMainScreenHeight kMainScreenFrame.size.height-20
#define kApplicationFrame [[UIScreen mainScreen] applicationFrame]
#define kInputToolBarHeight 50
@interface ChatViewController ()
{
    ChatMsgContentView      *m_msgContentView;
    CharInputToolBar        *m_inputToolBar;
    CharJoinToolBar         *m_joinToolBar;
    UIActivityIndicatorView *m_indicatorView;
    int64_t                  m_uid;
    int64_t                  m_tid;
    NSString                *m_token;
    ChatNotificationCenter  *m_chatNotification;
    int32_t                  m_type;  //1 单聊 2 群聊 3，临时组
    int64_t                  m_groupid;
    NSString                *m_name;
    
}

@end

@implementation ChatViewController

- (id)  init:(NSString*) token uid:(int64_t) uid  name:(NSString*) name
    tid: (int64_t) tid{
    
    self = [super init];
    m_uid = uid;
    m_tid = tid;
    m_token = token;
    m_name = name;
    m_type = ALONE_CHAT;
    [SVProgressHUD showWithStatus:MIGTIP_HIS_CHAT maskType:SVProgressHUDMaskTypeNone];
    return  self;
}






- (id)   init:(NSString*) token uid:(int64_t)uid
          tid: (int64_t) tid
{
    self = [super init];
    m_uid = uid;
    m_tid = tid;
    m_token = token;
    m_type = ALONE_CHAT;
    
    [SVProgressHUD showWithStatus:MIGTIP_HIS_CHAT maskType:SVProgressHUDMaskTypeNone];
    
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)dealloc
{
    m_msgContentView = nil;
    m_inputToolBar = nil;
#if DEBUG
    NSLog(@"%@ dealloc", self);
#endif
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.view = nil;
}

-(IBAction)doBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = super.navView.frame;
    super.navView.titleLabel.font = [UIFont fontOfApp:14.0];
    super.navView.titleLabel.text = @"";
    
    [self.bgImageView setImage:[UIImage imageNamed:@"华语流行.jpg"]];
    
    NSInteger y     = frame.origin.y + frame.size.height;
    NSInteger height = kMainScreenHeight-y - kInputToolBarHeight  + self.topDistance;
    m_msgContentView = [[ChatMsgContentView alloc] initWithFrame:
                     CGRectMake(0, y, kMainScreenWidth,height)];
    [self.view insertSubview:m_msgContentView atIndex:1];
    frame = m_msgContentView.frame;
    
    
    y = kMainScreenHeight - kInputToolBarHeight + self.topDistance;
    m_inputToolBar = [[CharInputToolBar alloc] initWithFrame:
                      CGRectMake(0, y, kMainScreenWidth,kInputToolBarHeight)];
    [m_inputToolBar setHidden:true];
    [self.view addSubview:m_inputToolBar];
    
    m_joinToolBar = [[CharJoinToolBar alloc] initWithFrame:
                     CGRectMake(0, y, kMainScreenWidth,kInputToolBarHeight)];
    [m_joinToolBar setHidden:false];
    [self.view addSubview:m_joinToolBar];

    m_indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    m_indicatorView.center = self.view.center;
    m_indicatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    [self.view addSubview:m_indicatorView];
    
    //[m_indicatorView startAnimating];
    
    
    [self binds_Notification];
    
    //单聊和群聊区分绑定
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    if (m_type==ALONE_CHAT) {
        [dic setValue:[NSString stringWithFormat:@"%lld",m_uid] forKey:@"uid"];
        [dic setValue:[NSString stringWithFormat:@"%lld",m_tid] forKey:@"tid"];
        [dic setValue:[NSString stringWithFormat:@"%@",m_name] forKey:@"name"];
        [dic setValue:m_token forKey:@"token"];
    }else{
        [dic setValue:[NSString stringWithFormat:@"%lld",m_uid] forKey:@"uid"];
        [dic setValue:[NSString stringWithFormat:@"%lld",m_groupid] forKey:@"gid"];
        //[dic setValue:[NSString stringWithFormat:@"%@",m_] forKey:@"name"];
        [dic setValue:m_token forKey:@"token"];
    }

    //[ChatNotificationCenter postNotification:CHATSERVER_CONNENT obj:dic];
    [ChatNotificationCenter postNotification:CHATSERVER_LOAD obj:dic];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) binds_Notification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyBoard_Notification:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyBoard_Notification:) name:UIKeyboardWillShowNotification object:nil];
    m_chatNotification = [[ChatNotificationCenter alloc] init:self];

}

-(void) onChatNotification:(ChatNotification *)notification
{
    if ( notification != nil )
    {
        switch (notification.type) {
            case CHATSERVER_ONTUSERINFO:
            {
                
                if ( notification.object) {
                    ChatUserInfo* pInfo = (ChatUserInfo*)notification.object;
                    super.navView.titleLabel.text = [NSString stringWithFormat:@"与 %@ 聊天中...",pInfo.nickname];
                }
            }
                break;
            case CHATSERVER_OPPINFO:
                if ( notification.object) {
                    ChatUserInfo* pInfo = (ChatUserInfo*)notification.object;
                    super.navView.titleLabel.text = [NSString stringWithFormat:@"与 %@ 聊天中...",pInfo.nickname];
                }
                break;
            case CHATSERVER_JOIN:
                [m_inputToolBar setHidden:false];
                [m_joinToolBar setHidden:true];
                //通知登陆聊天服务器
                [ChatNotificationCenter postNotification:CHATSERVER_LOGIN obj:nil];
                break;
            default:
                break;
        }
    }
}


-(void) removes_Notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    m_chatNotification = nil;
}

-(void) onKeyBoard_Notification:(NSNotification *)notification
{
    
    NSString *name = notification.name;
    if( [name isEqualToString:UIKeyboardWillHideNotification] )
    {
        if (  ! [m_inputToolBar isFaceBoardShow] )
        {
            [self moveViews:0];
        }
            
    }
    else if(  [name isEqualToString:UIKeyboardWillShowNotification] )
    {
        NSDictionary* userInfo = [notification userInfo];
        NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        [self moveViews:keyboardRect.size.height];
    }
}
-(void) moveViews: (float) h{
    
    CGRect frame = super.navView.frame;
    /*int y = frame.origin.y + frame.size.height - h;
    m_msgContentView.frame = CGRectMake(0, y, kMainScreenWidth, kMainScreenFrame.size.height-kInputToolBarHeight-frame.origin.y - frame.size.height);*/

    NSInteger y = frame.origin.y + frame.size.height;
    m_msgContentView.frame = CGRectMake(0, y, kMainScreenWidth, kMainScreenHeight-kInputToolBarHeight-y-h + self.topDistance);
    y = kMainScreenHeight-kInputToolBarHeight- h + self.topDistance;
    m_inputToolBar.frame = CGRectMake(0.0f, y, kMainScreenWidth,kInputToolBarHeight);
    [ChatNotificationCenter postNotification:CHATMESSAGE_RELOAD obj:nil];
}


@end
