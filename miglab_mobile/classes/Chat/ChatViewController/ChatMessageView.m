//
//  ChatMessageView.m
//  miglab_chat
//
//  Created by 180 on 14-4-2.
//  Copyright (c) 2014年 180. All rights reserved.
//

#import "ChatMessageView.h"
#import "ChatDef.h"


@interface ChatMessageView ()
{
    CGFloat         m_upX;
    
    CGFloat         m_upY;
    
    CGFloat         m_lastPlusSize;
    
    CGFloat         m_viewWidth;
    
    CGFloat         m_viewHeight;
    
    BOOL            m_isLineReturn;
    NSMutableArray *m_message;
}

@end
@implementation ChatMessageView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)showMessage:(NSArray *)message {
    
    m_message = (NSMutableArray *)message;
    
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    
	if ( m_message ) {
        
        //NSDictionary *faceMap = [[NSUserDefaults standardUserDefaults] objectForKey:@"FaceMap"];
        
        UIFont *font = [UIFont systemFontOfSize:16.0f];
        [[UIColor whiteColor] set];
        m_isLineReturn = NO;
        
        m_upX = VIEW_LEFT;
        m_upY = VIEW_TOP;
        
		for (int index = 0; index < [m_message count]; index++) {
            
			NSString *str = [m_message objectAtIndex:index];
			if ( [str hasPrefix:FACE_NAME_HEAD] && [str hasSuffix:FACE_NAME_END])
            {
                
				NSString *imageName = [str substringWithRange:NSMakeRange(1, str.length - 2)];
                imageName = [NSString stringWithFormat:@"chat_face.bundle%@",imageName];

                
                UIImage *image = [UIImage imageNamed:imageName];
                
                if ( image ) {
                    
                    //                    if ( upX > ( VIEW_WIDTH_MAX - KFacialSizeWidth ) ) {
                    if ( m_upX > ( VIEW_WIDTH_MAX ) ) {
                        
                        m_isLineReturn = YES;
                        
                        m_upX = VIEW_LEFT;
                        m_upY += VIEW_LINE_HEIGHT;
                    }
                    
                    [image drawInRect:CGRectMake(m_upX, m_upY, KFacialSizeWidth, KFacialSizeHeight)];
                    
                    m_upX += KFacialSizeWidth;
                    
                    m_lastPlusSize = KFacialSizeWidth;
                }
                else {
                    
                    [self drawText:str withFont:font];
                }
			}
            else {
                
                [self drawText:str withFont:font];
			}
        }
	}
}

- (void)drawText:(NSString *)string withFont:(UIFont *)font{
    
    for ( int index = 0; index < string.length; index++) {
        
        NSString *character = [string substringWithRange:NSMakeRange( index, 1 )];
        
        CGSize size = [character sizeWithFont:font
                            constrainedToSize:CGSizeMake(VIEW_WIDTH_MAX, VIEW_LINE_HEIGHT * 1.5)];
        
        if ( m_upX > ( VIEW_WIDTH_MAX - KCharacterWidth ) ) {
            
            m_isLineReturn = YES;
            
            m_upX = VIEW_LEFT;
            m_upY += VIEW_LINE_HEIGHT;
        }
        
        [character drawInRect:CGRectMake(m_upX, m_upY, size.width, self.bounds.size.height) withFont:font];
        
        m_upX += size.width;
        
        m_lastPlusSize = size.width;
    }
}

/**
 * 判断字符串是否有效
 */
- (BOOL)isStrValid:(NSString *)srcStr forRule:(NSString *)ruleStr {
    
    NSRegularExpression *regularExpression = [[NSRegularExpression alloc] initWithPattern:ruleStr
                                                                                  options:NSRegularExpressionCaseInsensitive
                                                                                    error:nil];
    
    NSUInteger numberOfMatch = [regularExpression numberOfMatchesInString:srcStr
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, srcStr.length)];
    
    return ( numberOfMatch > 0 );
}

- (void)dealloc {
    
#if DEBUG
    NSLog(@"%@ dealloc", self);
#endif
}


@end
