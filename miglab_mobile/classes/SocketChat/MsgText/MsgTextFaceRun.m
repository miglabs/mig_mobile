//
//  MsgFace.m
//  miglab_mobile
//
//  Created by yaobanglin on 14-7-16.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import "MsgTextFaceRun.h"
#import "ChatDef.h"
@implementation MsgTextFaceRun



+ (NSArray *)parserAttributedString:(NSMutableAttributedString *)attributedString
{
    NSString *string = attributedString.string;
    NSMutableArray *array = [NSMutableArray array];
    NSError  *error;
    

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:FACE_REGULAR
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0,[string length])];
    NSTextCheckingResult *match;
    while([arrayOfAllMatches count] > 0 )
    {
        match = [arrayOfAllMatches objectAtIndex:0];
        MsgTextFaceRun *msg = [[MsgTextFaceRun alloc] init];
        msg.text     = [string substringWithRange:NSMakeRange(match.range.location,match.range.length)];
        msg.text    = [msg.text substringWithRange:NSMakeRange(1, msg.text.length - 2)];
        
        msg.range    = NSMakeRange(match.range.location, 4);
        msg.isDraw   = YES;
        [array addObject:msg];
        
        [attributedString replaceCharactersInRange:match.range withString:@"    "];
        [msg addAttributedString:attributedString range:msg.range];
        arrayOfAllMatches = [regex matchesInString:attributedString.string options:0 range:NSMakeRange(0,[attributedString.string length])];
    }
    return array;
}



- (void)drawWithRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSString *face = [NSString stringWithFormat:@"chat_face.bundle%@",self.text];
    
    UIImage *image = [UIImage imageNamed:face];
    if (image)
    {
        CGContextDrawImage(context, rect, image.CGImage);
    }
}
@end
