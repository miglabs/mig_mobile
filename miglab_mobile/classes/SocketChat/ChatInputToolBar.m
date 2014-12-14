//
//  CharInputToolBar.m
//  miglab_chat
//
//  Created by 180 on 14-4-1.
//  Copyright (c) 2014年 180. All rights reserved.
//

#import "ChatInputToolBar.h"
#define kFaceBoardBarHeight 216
#import "FaceBoardView.h"
#import "ChatDef.h"
#import "ChatNotification.h"
@interface CharInputToolBar ()
{
    UITextView                  *m_textView;
    UIButton                    *m_faceButton;
    UIButton                    *m_keyButton;
    FaceBoardView               *m_faceBoard;
    ChatNotificationCenter      *m_chatNotification;
    
}
@end

@implementation CharInputToolBar
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isFaceBoardShow = false;
        // Initialization code
        UIImageView* bg = [[UIImageView alloc] initWithImage:
                           [UIImage imageNamed:@"chat_toolbar_bg.png"]];
        bg.frame = CGRectMake(0, 0, frame.size.width, frame.size.height+2);
        [self addSubview:bg];
        
        UIImage* faceImage  = [UIImage imageNamed:@"face_but_img.png"];
        UIImage* keyImage   = [UIImage imageNamed:@"key_but_img.png"];
        
        NSInteger textViewWidth = 0;
        NSInteger height = frame.size.height - 30;
        
        m_faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        m_keyButton = [UIButton buttonWithType:UIButtonTypeCustom];
       
        NSInteger width  = keyImage.size.width * height/ keyImage.size.height;
        NSInteger x = 0;
        
        textViewWidth = frame.size.width -30 - width;
        x= textViewWidth + 20;
        
        m_keyButton.frame = CGRectMake(x, 15, width,height);
        [m_keyButton setImage:keyImage forState:UIControlStateNormal];
        
        width  = faceImage.size.width * height/ faceImage.size.height;
        x = textViewWidth + 20 + ( m_keyButton.frame.size.width - width)/2;
        m_faceButton.frame = CGRectMake(x, 15, width,height);
        [m_faceButton setImage:faceImage forState:UIControlStateNormal];

        [m_keyButton setHidden:true];
        
        height = frame.size.height - 12;
        CGRect imageViewFrame = CGRectMake(10, 6,textViewWidth , height);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
        imageView.image = [UIImage imageNamed:@"chat_textfield_bg.png"];
        imageView.userInteractionEnabled = YES;
        
        m_textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0,textViewWidth , height)];
        
        [m_textView setTextColor:[UIColor whiteColor]];
        [m_textView setReturnKeyType:UIReturnKeySend];
        [m_textView setBackgroundColor:[UIColor clearColor]];
        [m_textView setDelegate:self];
        [m_textView setFont:[UIFont boldSystemFontOfSize:14]];
        
        [imageView addSubview:m_textView];
        [self addSubview:imageView];
        
        [self addSubview:m_faceButton];
        [self addSubview:m_keyButton];
        
        m_faceBoard = [[FaceBoardView alloc] initWithFrame:CGRectMake(0, 0, 320,kFaceBoardBarHeight)];
        
        [m_keyButton addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [m_faceButton addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        m_chatNotification = [[ChatNotificationCenter alloc] init:self ];
    }
    return self;
}

-(void)dealloc
{
    m_chatNotification = nil;
#if DEBUG
    NSLog(@"%@ dealloc", self);
#endif
}

-(void) onSend
{
    NSString *inputString = m_textView.text;
    if ( inputString != nil && inputString.length > 0 )
    {
         inputString = [inputString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ( inputString.length > 0 ) {
            //[m_textView resignFirstResponder];
            [ChatNotificationCenter postNotification:CHATMESSAGE_SEND obj:inputString];
            [m_textView setText:@""];
        }
       
    }
}

#define TIME  0.2
-(IBAction) onButtonClick:(id)sender
{
    if ( sender == m_keyButton ) {
        [UIView animateWithDuration:TIME
                         animations:^{
                             [m_textView resignFirstResponder];
         }];
        [m_keyButton setHidden:true];
        [m_faceButton setHidden:false];
        [m_textView setInputView: nil];
        self.isFaceBoardShow = false;
        [UIView animateWithDuration:TIME
                         animations:^{
                             [m_textView becomeFirstResponder];
                         }
         ];
        
       
    }
    else if( sender == m_faceButton)
    {
        self.isFaceBoardShow = true;
        [m_keyButton setHidden:false];
        [m_faceButton setHidden:true];
        [UIView animateWithDuration:TIME
                         animations:^{
                             [m_textView resignFirstResponder];
                         }];

        
        [UIView animateWithDuration:TIME
                         animations:^{
                             [m_textView setInputView: m_faceBoard];
                             [m_textView becomeFirstResponder];
                         }];
    }
}

-(void) onChatNotification:(ChatNotification *)notification
{
    if( notification != nil)
    {
        switch (notification.type) {
            case FACEBOARD_SEND:
                //self.isFaceBoardShow = false;
                [self onSend];
                //[m_keyButton setHidden:true];
                //[m_faceButton setHidden:false];
                //[m_textView setInputView: nil];
                break;
            case FACEBOARD_SELECT:
            {
                if ( notification.object != nil ) {
                    [self onInputString:(NSString*)notification.object];
                }
            }
                break;
            case FACEBOARD_DEL:
                [self onDelInputString];
                break;
            case INPUTBOARD_CLOSE:
            {
                self.isFaceBoardShow = false;
                [m_textView resignFirstResponder];
                [m_keyButton setHidden:true];
                [m_faceButton setHidden:false];
                [m_textView setInputView: nil];
            }
                break;
            default:
                break;
        }
    }
}


#define MAX_FACE_LENGTH 5
#define MIN_FACE_LENGHT 3

-(NSRange) getCorrectRange:(NSString*) textString range:(NSRange)range  isInput:(BOOL) isInput
{
    NSRange rangeNew;
    rangeNew.location = 0;
    if (  range.location > MAX_FACE_LENGTH ) {
        rangeNew.location  = range.location - MAX_FACE_LENGTH;
    }
    rangeNew.length = textString.length - rangeNew.location;
    if ( textString.length > range.location + range.length + MAX_FACE_LENGTH ) {
        rangeNew.length = range.length + MAX_FACE_LENGTH + (range.location-rangeNew.location);
    }
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:FACE_REGULAR
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:textString options:0 range:rangeNew];
    if( arrayOfAllMatches != nil && [arrayOfAllMatches count] > 0 )
    {
        
        NSTextCheckingResult    *match      = nil;
        NSInteger i = 0;
        for (;  i < [arrayOfAllMatches count]; ++i)
        {
                match = (NSTextCheckingResult*)[arrayOfAllMatches objectAtIndex:i];
                rangeNew.location = match.range.location + match.range.length;
                if (  rangeNew.location  > range.location )
                {
                    if ( range.length == 0 && isInput ) {
                        rangeNew.location  = match.range.location + match.range.length;
                    }
                    else
                        rangeNew.location = match.range.location;
                    
                    break;
                }
                else if( rangeNew.location  ==  range.location )
                {
                    if (isInput) {
                        rangeNew.location  = range.location;
                    }
                    else
                        rangeNew.location  = match.range.location;
                    
                    break;
                }
        }
        i = [arrayOfAllMatches count] - 1;
        for (;  i >= 0  ; --i)
        {
            match = (NSTextCheckingResult*)[arrayOfAllMatches objectAtIndex:i];
            if (  match.range.location  < (range.location + range.length) )
            {
                rangeNew.length = match.range.location - rangeNew.location + match.range.length;
                break;
            }
            else if(  match.range.location  < (range.location + range.length) )
            {
                rangeNew.length = range.location + range.length - rangeNew.location;
                break;
            }
        }
        range = rangeNew;
    }
    return  range;
}

-(void) onInputString:(NSString*) face
{
    NSString* inputString = m_textView.text;
    if( inputString.length == 0 )
    {
         [m_textView setText:face];
    }
    else {
        NSRange range = m_textView.selectedRange;
        if ( range.location == inputString.length ) {
            inputString = [NSString stringWithFormat:@"%@%@",inputString,face];
        }
        else{

            range = [self getCorrectRange:inputString range:range isInput:TRUE];
            inputString = [inputString stringByReplacingCharactersInRange:range withString:face];
        }
        
        [m_textView setText:inputString];
    }
}



-(void) onDelInputString
{
    NSRange range = m_textView.selectedRange;
    NSString* inputString = m_textView.text;
    if( inputString.length > 0 )
    {
        if ( range.location > 0 && inputString.length > MIN_FACE_LENGHT)
        {
            range = [self getCorrectRange:inputString range:range isInput:FALSE];
       
        }
        if ( range.length == 0 ) {
            range.location -= 1;
            range.length = 1;
        }
        inputString = [inputString stringByReplacingCharactersInRange:range withString:@""];
        [m_textView setText:inputString];
    }
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if( [text length] == 0 ) {
        NSRange range1 = m_textView.selectedRange;
        if ( range1.length == 0 && range.length != 0 ) {
            return YES;
        }
        [self onDelInputString];
        return NO;
    }
    else if ([text isEqualToString:@"\n"]) {
         [self onSend];
        return false;
    }
    else {
        NSString* inputString = m_textView.text;
        if( inputString.length >  0 )
        {
            //NSRange range = m_textView.selectedRange;
            if ( range.location != inputString.length )
            {
                range = [self getCorrectRange:inputString range:range isInput:TRUE];
                m_textView.selectedRange = range;
            }
        }

        return true;
    }
    return true;
}


@end
