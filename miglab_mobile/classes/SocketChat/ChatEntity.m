//
//  ChatMsg.m
//  miglab_chat
//
//  Created by 180 on 14-4-1.
//  Copyright (c) 2014年 180. All rights reserved.
//

#import "ChatEntity.h"

@interface ChatMsg ()
{
    NSMutableArray* m_msgArray;
    CGSize          m_viewsize;
}
@end
@implementation ChatMsg

-(id) init
{
    self = [super init];
    m_msgArray = NULL;
    self.send_user_info = NULL;
    m_viewsize.height = m_viewsize.width = 0;
    return self;
}

-(id) init:(NSDictionary *)dic
{
    self = [super init];
    if( dic != nil)
    {
        self.send_user_id = [[dic valueForKey:@"fid"] longLongValue];
        self.recv_user_id = [[dic valueForKey:@"tid"] longLongValue];
        self.msg_id = [[dic valueForKey:@"id"] longLongValue];
        self.msg_content = [dic valueForKey:@"msg"];
        self.msg_time =  [dic valueForKey:@"time"];
        self.send_nickname = [dic valueForKey:@"nickname"];
    }
    return self;
}

-(id) init:(NSString*) msg send_id:(int64_t) send_id recv_id:(int64_t) recv_id msg_id:(int64_t) msg_id
{
    self = [super init];
    self.send_user_id = send_id;
    self.recv_user_id = recv_id;
    self.msg_id = msg_id;
    self.msg_content = msg;
    NSDate *nowTime = [NSDate date];
    NSDateFormatter  *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.msg_time = [formatter stringFromDate:nowTime];
    return self;
}

-(id) init:(NSString*) msg send_nickname:(NSString*) nickname send_id:(int64_t) send_id recv_id:(int64_t) recv_id msg_id:(int64_t) msg_id{
    self = [super init];
    self.send_user_id = send_id;
    self.recv_user_id = recv_id;
    self.msg_id = msg_id;
    self.msg_content = msg;
    self.send_nickname = nickname;
    NSDate *nowTime = [NSDate date];
    NSDateFormatter  *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.msg_time = [formatter stringFromDate:nowTime];
    return self;
}

-(void)dealloc
{
#if DEBUG
    NSLog(@"%@ dealloc", self);
#endif
}
#ifndef NEW_MSGVIEW
-(NSArray*) getMsg
{
    if( m_msgArray == nil )
    {
        m_msgArray = [[NSMutableArray alloc] init];
        NSError  *error;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:FACE_REGULAR
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
        NSArray *arrayOfAllMatches = [regex matchesInString:self.msg_content options:0 range:NSMakeRange(0,[self.msg_content length])];
        if( arrayOfAllMatches != nil && [arrayOfAllMatches count] > 0 )
        {
            NSRange         range = NSMakeRange(0,0);
            for(NSTextCheckingResult *match in arrayOfAllMatches)
            {
                if( match.range.location != range.location )
                {
                    range.length = match.range.location - range.location;
                    [m_msgArray addObject: [self.msg_content substringWithRange:range] ];
                }
                range.location = match.range.location + match.range.length;
                if (  match.range.length > 0 )
                {
                    [m_msgArray addObject: [self.msg_content substringWithRange:NSMakeRange(match.range.location,match.range.length)] ];
                }
            }
            if ( range.location != [self.msg_content length] ) {
                range.length = [self.msg_content length] - range.location;
                [m_msgArray addObject: [self.msg_content substringWithRange:range] ];
            }
        }
        else
            [m_msgArray addObject:[self msg_content]];
    }
    return m_msgArray;
}

-(CGSize) getViewSize
{
    if ( m_viewsize.height == 0 ) {
        CGFloat upX;
        
        CGFloat upY;
        
        CGFloat lastPlusSize;
        
        CGFloat viewWidth;
        
        CGFloat viewHeight;
        
        BOOL isLineReturn;
        
        NSArray *messageRange = [self getMsg];
        
        
        UIFont *font = [UIFont systemFontOfSize:16.0f];
        
        isLineReturn = NO;
        
        upX = VIEW_LEFT;
        upY = VIEW_TOP;
        
        for (int index = 0; index < [messageRange count]; index++) {
            
            NSString *str = [messageRange objectAtIndex:index];
            if ( [str hasPrefix:FACE_NAME_HEAD] && [str hasSuffix:FACE_NAME_END]) {
                NSString *imagePath = nil;
                NSString *imageName = [str substringWithRange:NSMakeRange(1, str.length - 2)];
                imageName = [NSString stringWithFormat:@"chat_face.bundle%@",imageName];
                imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
                
                if ( imagePath ) {
                    
                    if ( upX > ( VIEW_WIDTH_MAX - KFacialSizeWidth ) ) {
                        
                        isLineReturn = YES;
                        
                        upX = VIEW_LEFT;
                        //if (  index + 1 < [messageRange count] )
                        {
                            upY += VIEW_LINE_HEIGHT;
                        }
                        
                    }
                    
                    upX += KFacialSizeWidth;
                    
                    lastPlusSize = KFacialSizeWidth;
                }
                else {
                    
                    for ( int index = 0; index < str.length; index++) {
                        
                        NSString *character = [str substringWithRange:NSMakeRange( index, 1 )];
                        
                        CGSize size = [character sizeWithFont:font
                                            constrainedToSize:CGSizeMake(VIEW_WIDTH_MAX, VIEW_LINE_HEIGHT * 1.5)];
                        
                        if ( upX > ( VIEW_WIDTH_MAX - KCharacterWidth ) ) {
                            
                            isLineReturn = YES;
                            
                            upX = VIEW_LEFT;
                            //upY += VIEW_LINE_HEIGHT;
                            //if (  index + 1 < [messageRange count] )
                            {
                                upY += VIEW_LINE_HEIGHT;
                            }
                        }
                        
                        upX += size.width;
                        
                        lastPlusSize = size.width;
                    }
                }
            }
            else {
                
                for ( int index = 0; index < str.length; index++) {
                    
                    NSString *character = [str substringWithRange:NSMakeRange( index, 1 )];
                    
                    CGSize size = [character sizeWithFont:font
                                        constrainedToSize:CGSizeMake(VIEW_WIDTH_MAX, VIEW_LINE_HEIGHT * 1.5)];
                    
                    if ( upX > ( VIEW_WIDTH_MAX - KCharacterWidth ) ) {
                        
                        isLineReturn = YES;
                        
                        upX = VIEW_LEFT;
                        //if (  index + 1 < [messageRange count] )
                        {
                            upY += VIEW_LINE_HEIGHT;
                        }
                    }
                    
                    upX += size.width;
                    
                    lastPlusSize = size.width;
                }
            }
        }
        
        if ( isLineReturn ) {
            
            viewWidth = VIEW_WIDTH_MAX + VIEW_LEFT * 2;
        }
        else {
            
            viewWidth = upX + VIEW_LEFT;
        }
        
        viewHeight = upY + VIEW_LINE_HEIGHT + VIEW_TOP;
        m_viewsize.width =  viewWidth;
        m_viewsize.height   = viewHeight;
    }
    return m_viewsize;
}
#endif
@end

@implementation ChatUserInfo

- (void) dealloc
{
#if DEBUG
    NSLog(@"%@ dealloc", self);
#endif
}
@end

@implementation NotifiOppinfo

- (void) dealloc
{
#if DEBUG
    NSLog(@"%@ dealloc", self);
#endif
}
@end
