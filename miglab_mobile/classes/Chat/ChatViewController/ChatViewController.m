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
    UIActivityIndicatorView *m_indicatorView;
    int64_t                  m_uid;
    int64_t                  m_tid;
    NSString                *m_token;
    ChatNotificationCenter  *m_chatNotification;
    
}

@end

@implementation ChatViewController


- (id)   init:(NSString*) token uid:(int64_t)uid
          tid: (int64_t) tid
{
    self = [super init];
    m_uid = uid;
    m_tid = tid;
    m_token = token;
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
    super.navView.titleLabel.text = @"";
    NSInteger y     = frame.origin.y + frame.size.height;
    NSInteger height = kMainScreenHeight-y - kInputToolBarHeight  + self.topDistance;
    m_msgContentView = [[ChatMsgContentView alloc] initWithFrame:
                     CGRectMake(0, y, kMainScreenWidth,height)];
    [self.view insertSubview:m_msgContentView atIndex:1];
    frame = m_msgContentView.frame;
    y = kMainScreenHeight - kInputToolBarHeight + self.topDistance;
    m_inputToolBar = [[CharInputToolBar alloc] initWithFrame:
                      CGRectMake(0, y, kMainScreenWidth,kInputToolBarHeight)];
    [self.view addSubview:m_inputToolBar];

    m_indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    m_indicatorView.center = self.view.center;
    m_indicatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    [self.view addSubview:m_indicatorView];
    
    //[m_indicatorView startAnimating];
    
    
    [self binds_Notification];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[NSString stringWithFormat:@"%lld",m_uid] forKey:@"uid"];
    [dic setValue:[NSString stringWithFormat:@"%lld",m_tid] forKey:@"tid"];
    [dic setValue:m_token forKey:@"token"];
    [ChatNotificationCenter postNotification:CHATSERVER_CONNENT obj:dic];

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
