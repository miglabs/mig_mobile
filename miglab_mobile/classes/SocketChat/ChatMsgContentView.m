//
//  ChatContentView.m
//  miglab_chat
//
//  Created by 180 on 14-4-1.
//  Copyright (c) 2014年 180. All rights reserved.
//

#import "ChatMsgContentView.h"
#import "ChatNetService.h"
#import "ChatDef.h"
#import "ChatMessageView.h"
#import "MsgTextView.h"

@interface ChatMsgContentView ()
{
    UITableView                 *m_chatTableView;
    ChatNetService              *m_charNet;
    NSMutableArray              *m_chatMsgArray;
    UITapGestureRecognizer      *m_tapGestureRecognizer;
    ChatNotificationCenter      *m_chatNotification;
    EGORefreshTableHeaderView   *m_refreshHeaderView;
	BOOL                         m_reloading;
    NSInteger                    m_lastdatacount;
    
}
@end

@implementation ChatMsgContentView

@synthesize customCell, cellNib;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        frame.origin.y = 0;
        m_chatTableView = [[UITableView alloc] initWithFrame:frame];
        m_chatTableView.backgroundColor = [UIColor clearColor];
        m_chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:m_chatTableView];
        [m_chatTableView setDelegate: self];
        [m_chatTableView setDataSource:self];
        [m_chatTableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        
        
        if (m_refreshHeaderView == nil) {
            
            EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - m_chatTableView.bounds.size.height, self.frame.size.width, m_chatTableView.bounds.size.height)];
            view.delegate = self;
            [self->m_chatTableView addSubview:view];
            m_refreshHeaderView = view;
            
        }
        
        m_chatMsgArray = [[NSMutableArray alloc] init];
        
        self.cellNib = [UINib nibWithNibName:@"ChatMsgTableViewCell" bundle:nil];
        
               
//        m_tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
//        [m_tapGestureRecognizer addTarget:self action:@selector(handleSingleFingerEvent:)];
//        [m_tapGestureRecognizer setNumberOfTapsRequired:1];
//        [self addGestureRecognizer:m_tapGestureRecognizer];
//
//        UISwipeGestureRecognizer *recognizer  = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handelPan:)];
//        recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
//        //[self addGestureRecognizer:recognizer];
//        
//        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handelPan:)];
//        recognizer.direction = UISwipeGestureRecognizerDirectionRight;
//        //[self addGestureRecognizer:recognizer];
//        
//        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handelPan:)];
//        recognizer.direction = UISwipeGestureRecognizerDirectionUp;
//        //[self addGestureRecognizer:recognizer];
//        
//        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handelPan:)];
//        recognizer.direction = UISwipeGestureRecognizerDirectionDown;
//        //[self addGestureRecognizer:recognizer];
        m_chatNotification = [[ChatNotificationCenter alloc] init:self];
        m_lastdatacount = 0;
        
    }
    return self;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
     [ChatNotificationCenter postNotification:INPUTBOARD_CLOSE obj:nil];
}


-(void)dealloc
{
    m_chatNotification = nil;
    m_charNet = nil;
    
#if DEBUG
    NSLog(@"%@ dealloc", self);
#endif
    [SVProgressHUD dismiss];
}
#pragma mark Notification

-(void) onChatNotification:(ChatNotification *)notification
{
    if ( notification != nil )
    {
        switch (notification.type) {
            case CHATMESSAGE_SEND:
            {
                NSString* msg = (NSString*)notification.object;
                if( msg != nil && m_charNet != nil )
                    [m_charNet sendChatMsg:msg];
                
            }
                break;
            case CHATMESSAGE_RELOAD:
            {
                [self onReLoadTableView:TRUE];
            }
                break;
            case CHATSERVER_CONNENT:
            {
                
                NSMutableDictionary* dic = (NSMutableDictionary*)notification.object;
                m_charNet = [[ChatNetService alloc] init:[dic valueForKey:@"token"]
                                                     uid:[[dic valueForKey:@"uid"] longLongValue]
                                                     tid:[[dic valueForKey:@"tid"] longLongValue]];
                [m_charNet setDelegate:self];
                m_reloading = YES;
            }
                break;
            default:
                break;
        }

    }
}


/*-(void) onChatNotification:(NSNotification *)notification
{
    if( notification != nil)
    {
        ChatNotification* not = notification.object;
        if( not != nil)
        {
        }
    }
}*/

-(CGSize) getMsgRect:(NSString*) msg
{
    CGRect rect = [MsgTextView getRectWithSize:CGSizeMake(VIEW_WIDTH_MAX-VIEW_LEFT-VIEW_RIGHT, 900) font:[UIFont systemFontOfSize:16.0f] string:msg lineSpace:2.0f];
    rect.size.height += VIEW_TOP+ VIEW_TOP;
      return rect.size;
}

#pragma mark TableView


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return m_chatMsgArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    ChatMsg * msg = [m_chatMsgArray objectAtIndex:indexPath.row];
    CGFloat span =  0;
#ifdef NEW_MSGVIEW
    span =  [self getMsgRect:msg.msg_content].height- MSG_VIEW_MIN_HEIGHT;
#else
    span =  msg.getViewSize.height- MSG_VIEW_MIN_HEIGHT;
#endif
    CGFloat height = MSG_CELL_MIN_HEIGHT + span;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"ChatMsgTableViewCell";
    ChatMsgTableViewCell *cell = (ChatMsgTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( cell == nil ) {
        NSArray * array = [self.cellNib instantiateWithOwner:self options:nil];
        //[self.cellNib instantiateWithOwner:self options:nil];
		//cell = [[[UINib nibWithNibName:@"ChatMsgTableViewCell" bundle:nil] instantiateWithOwner:nil options:nil] objectAtIndex:0];;
		//self.customCell = nil;
        cell = [array objectAtIndex:0];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ChatMsg* msg =  [m_chatMsgArray objectAtIndex:indexPath.row];
    if( msg.send_user_info == nil)
       [m_charNet bindSendUserInfo:msg];
#ifdef NEW_MSGVIEW
    [cell refreshMsg:msg withSize:[self getMsgRect:msg.msg_content]];
#else
    [cell refreshMsg:msg withSize:msg.getViewSize];
#endif
    return cell;
}

-(void)  onReLoadTableView:(BOOL) bForRow
{
    @synchronized(self)
    {
        if ( [m_chatMsgArray count] > 0 ) {
            NSIndexPath* indexPath = nil;
            [m_chatTableView reloadData];
            if ( bForRow ) {
                indexPath = [NSIndexPath indexPathForRow:[m_chatMsgArray count]-1 inSection:0];
                
            }
            else
            {
                indexPath = [NSIndexPath indexPathForRow:[m_chatMsgArray count]-m_lastdatacount inSection:0];
            }
            m_lastdatacount = [m_chatMsgArray count];
            [m_chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
        }
       
    }
}

#pragma mark ChatNetServiceDelegate
- (void) onHiscChatMsg:(NSArray*) data
{
    [self doneLoadingTableViewData];
    if( data != nil && data.count > 0 )
    {
        BOOL bForRow = [m_chatMsgArray count] == 0 ;
        @synchronized(self)
        {
            NSRange range = NSMakeRange(0, [data count]);
            [m_chatMsgArray insertObjects:data atIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        }
        [self onReLoadTableView:bForRow];
    }
     //[m_indicatorView stopAnimating];
}


- (void) onChatMsg:(id) data
{
    
    if( data != nil )
    {
        @synchronized(self)
        {
            [m_chatMsgArray addObject:data];
        }
        [self onReLoadTableView:TRUE ];
    }
}

- (void) onError:(NSString*) error
{
    [self doneLoadingTableViewData];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    NSLog(@"onError %@",error);
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	m_reloading = YES;
	if ( m_charNet != nil ) {
        int64_t minmsgid = 0;
        if ( m_chatMsgArray != nil && [m_chatMsgArray count] > 0 ) {
            minmsgid = ((ChatMsg* )[m_chatMsgArray objectAtIndex:0]).msg_id;
            
        }
        [m_charNet reloadHiscChat:minmsgid];
    }
}

- (void)doneLoadingTableViewData{
	m_reloading = NO;
	[m_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:m_chatTableView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[m_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[m_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return m_reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}


@end
