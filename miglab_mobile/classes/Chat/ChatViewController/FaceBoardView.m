//
//  FaceImageView.m
//  miglab_chat
//
//  Created by 180 on 14-4-1.
//  Copyright (c) 2014年 180. All rights reserved.
//

#import "FaceBoardView.h"
#import "ChatDef.h"
#import "ChatNotification.h"
#define FACE_COUNT_ALL  104
#define FACE_COUNT_ROW  4
#define FACE_COUNT_CLU  7

#define FACE_COUNT_PAGE ( FACE_COUNT_ROW * FACE_COUNT_CLU )
#define FACE_PAGE_COUNT ( (FACE_COUNT_ALL - 1 )/FACE_COUNT_PAGE + 1)
#define FACE_ICON_SIZE  44


@interface FaceBoardView ()
{
    UIScrollView    *m_faceView;
    UIPageControl   *m_pageView;
    UIButton        *m_delButton;
    UIButton        *m_sendButton;
}
@end
@implementation FaceBoardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        m_faceView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 40)];
        m_faceView.pagingEnabled = YES;
        m_faceView.contentSize = CGSizeMake(FACE_PAGE_COUNT * 320, frame.size.height - 40);
        m_faceView.showsHorizontalScrollIndicator = NO;
        m_faceView.showsVerticalScrollIndicator = NO;
        m_faceView.delegate = self;
        for (NSInteger i = 0 ; i <= FACE_COUNT_ALL; ++i)
        {
            UIButton *faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [faceButton addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            CGFloat x = ((i % FACE_COUNT_PAGE) % FACE_COUNT_CLU) * FACE_ICON_SIZE + 4 + (i / FACE_COUNT_PAGE * 320);
            CGFloat y = ((i % FACE_COUNT_PAGE) / FACE_COUNT_CLU) * FACE_ICON_SIZE + 4;
            faceButton.frame = CGRectMake( x, y, FACE_ICON_SIZE, FACE_ICON_SIZE);
            [faceButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"chat_face.bundle/%d.png",i]] forState:UIControlStateNormal];
            [faceButton setTag:i];
            [m_faceView addSubview:faceButton];

        }
        m_faceView.backgroundColor = [UIColor clearColor];
        [self addSubview:m_faceView];
        m_pageView = [[UIPageControl alloc] initWithFrame:
                      CGRectMake(0, m_faceView.frame.size.height, frame.size.width, 40)];
        m_pageView.numberOfPages =  FACE_PAGE_COUNT;
        m_pageView.currentPage = 0;
        [m_pageView addTarget:self action:@selector(onPageChange:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:m_pageView];
        
        m_delButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [m_delButton setTitle:@"删除" forState:UIControlStateNormal];
        [m_delButton setImage:[UIImage imageNamed:@"del_emoji_normal.png"] forState:UIControlStateNormal];
        [m_delButton addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        m_delButton.frame = CGRectMake(272, 182, 38, 28);
        
        m_sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [m_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        m_sendButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        [m_sendButton setTintColor:[UIColor blackColor]];
        [m_sendButton  setBackgroundImage:[UIImage imageNamed:@"senditem.png"] forState:UIControlStateNormal];
        [m_sendButton addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        m_sendButton.frame = CGRectMake(272-50-10, 182, 50, 28);
        [self addSubview:m_delButton];
        [self addSubview:m_sendButton];
        
        
        
    }
    return self;
}


-(void)dealloc
{
#if DEBUG
    NSLog(@"%@ dealloc", self);
#endif
}

-(IBAction) onButtonClick:(id)sender
{
    if (sender == m_delButton ) {
        [ChatNotificationCenter postNotification:FACEBOARD_DEL obj:nil];
    }
    else if( sender == m_sendButton )
    {
        [ChatNotificationCenter postNotification:FACEBOARD_SEND obj:nil];
    }
    else
    {
        NSString* msg = [NSString stringWithFormat:@"[/%d]",((UIButton*)sender).tag];
         [ChatNotificationCenter postNotification:FACEBOARD_SELECT obj:msg];
    }
    
}

- (void)onPageChange:(id)sender {
    [m_faceView setContentOffset:CGPointMake(m_pageView.currentPage * 320, 0) animated:YES];
    [m_pageView setCurrentPage:m_pageView.currentPage];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [m_pageView setCurrentPage:m_faceView.contentOffset.x / 320];
    [m_pageView updateCurrentPageDisplay];
}

@end
