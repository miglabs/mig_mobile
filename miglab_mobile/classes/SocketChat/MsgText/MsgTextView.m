//
//  MsgView.m
//  miglab_mobile
//
//  Created by yaobanglin on 14-7-16.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import "MsgTextView.h"
#import "MsgTextURLRun.h"
#import "MsgTextFaceRun.h"
#import <CoreText/CoreText.h>
@interface MsgTextView ()

@property (nonatomic,strong) NSMutableArray *msgs;
@property (nonatomic,strong) NSMutableDictionary *msgRectDic;
@property (nonatomic,strong) MsgTextRun *touchMsg;

@end

@implementation MsgTextView

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void) initialize
{
    //public
    self.text        = nil;
    self.font        = [UIFont systemFontOfSize:16.0f];
    self.textColor   = [UIColor whiteColor];
    self.lineSpace   = 2.0f;
    self.msgs        = [NSMutableArray array];
    self.msgRectDic = [NSMutableDictionary dictionary];
    self.touchMsg = nil;
}


-(void) drawTexts:(CTLineRef) lineRef lineOrigin:(CGPoint) lineOrigin
{
    CGFloat lineAscent;
    CGFloat lineDescent;
    CGFloat lineLeading;
    CTLineGetTypographicBounds(lineRef, &lineAscent, &lineDescent, &lineLeading);
    CFArrayRef runs = CTLineGetGlyphRuns(lineRef);
    
    for (int j = 0; j < CFArrayGetCount(runs); j++)
    {
        CTRunRef runRef = CFArrayGetValueAtIndex(runs, j);
        CGFloat runAscent;
        CGFloat runDescent;
        CGRect runRect;
        
        runRect.size.width = CTRunGetTypographicBounds(runRef, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
        runRect = CGRectMake(lineOrigin.x + CTLineGetOffsetForStringIndex(lineRef, CTRunGetStringRange(runRef).location, NULL),
                             lineOrigin.y ,
                             runRect.size.width,
                             runAscent + runDescent);
        
        NSDictionary * attributes = (__bridge NSDictionary *)CTRunGetAttributes(runRef);
        MsgTextRun *msgText = [attributes objectForKey:kMsgTextRunAttributedName];
        if (msgText != nil && msgText.isDraw)
        {
            CGFloat runAscent,runDescent;
            CGFloat runWidth  = CTRunGetTypographicBounds(runRef, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
            CGFloat runHeight = (lineAscent + lineDescent );
            CGFloat runPointX = runRect.origin.x + lineOrigin.x;
            CGFloat runPointY = lineOrigin.y - 4;
            
            CGRect runRectDraw = CGRectMake(runPointX, runPointY, runWidth, runHeight);
            
            [msgText drawWithRect:runRectDraw];
            
            [self.msgRectDic setObject:msgText forKey:[NSValue valueWithCGRect:runRectDraw]];
        }
        else
        {
            if (msgText)
            {
                [self.msgRectDic setObject:msgText forKey:[NSValue valueWithCGRect:runRect]];
            }
        }
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (self.text == nil){
        return;
    }
    if( self.msgs == nil)
    {
        self.msgs        = [NSMutableArray array];
        self.msgRectDic = [NSMutableDictionary dictionary];
    }
    
    [self.msgs removeAllObjects];
    [self.msgRectDic removeAllObjects];

    CGRect viewRect = self.bounds;
    NSMutableAttributedString *attString = [[self class] getAttributedStringWithText:self.text font:self.font color:self.textColor lineSpace:self.lineSpace];
    
    [self.msgs addObjectsFromArray:[[self class] getMsgTextsWithAttString:attString]];
    
    [[UIColor whiteColor] set];
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGAffineTransform affineTransform = CGAffineTransformIdentity;
    affineTransform = CGAffineTransformMakeTranslation(0.0, viewRect.size.height);
    affineTransform = CGAffineTransformScale(affineTransform, 1.0, -1.0);
    CGContextConcatCTM(contextRef, affineTransform);
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathAddRect(pathRef, NULL, viewRect);
    CTFramesetterRef framesetterRef = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attString);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetterRef, CFRangeMake(0, 0), pathRef, nil);
    CFArrayRef lines = CTFrameGetLines(frameRef);
    CGPoint lineOrigins[CFArrayGetCount(lines)];
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), lineOrigins);
    for (int i = 0; i < CFArrayGetCount(lines); i++)
    {
        [self drawTexts:CFArrayGetValueAtIndex(lines, i) lineOrigin:lineOrigins[i]];
    }
    CTFrameDraw(frameRef, contextRef);
    CFRelease(pathRef);
    CFRelease(frameRef);
    CFRelease(framesetterRef);
}

+ (NSMutableAttributedString *) getAttributedStringWithText:(NSString *)text font:(UIFont *)font color:(UIColor*)color lineSpace:(CGFloat)lineSpace
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    
    
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    [attString addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0,attString.length)];
    CFRelease(fontRef);
    
    if( color != nil )
    {
        [attString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)color.CGColor range:NSMakeRange(0,attString.length)];
    }
    
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByCharWrapping;
    lineBreakMode.spec        = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value       = &lineBreak;
    lineBreakMode.valueSize   = sizeof(lineBreak);
    
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacing;
    lineSpaceStyle.valueSize = sizeof(lineSpace);
    lineSpaceStyle.value =&lineSpace;
    
    CTParagraphStyleSetting settings[] = {lineSpaceStyle,lineBreakMode};
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, sizeof(settings));
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(__bridge id)style forKey:(id)kCTParagraphStyleAttributeName ];
    CFRelease(style);
    
    [attString addAttributes:attributes range:NSMakeRange(0, [attString length])];
    
    return attString;

}

+ (NSMutableAttributedString *) getAttributedStringWithText:(NSString *)text font:(UIFont *)font lineSpace:(CGFloat)lineSpace
{
    
    return [self getAttributedStringWithText:text font:font color:nil lineSpace:lineSpace];
}

+ (NSArray *)getMsgTextsWithAttString:(NSMutableAttributedString *)attString
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObjectsFromArray:[MsgTextFaceRun parserAttributedString:attString]];
    [array addObjectsFromArray:[MsgTextURLRun parserAttributedString:attString]];
    return  array;
}

+ (CGRect)getRectWithSize:(CGSize)size font:(UIFont *)font AttString:(NSMutableAttributedString *)attString
{
    [[self class] getMsgTextsWithAttString:attString];
    
    NSDictionary *dic = [attString attributesAtIndex:0 effectiveRange:nil];
    CTParagraphStyleRef paragraphStyle = (__bridge CTParagraphStyleRef)[dic objectForKey:(id)kCTParagraphStyleAttributeName];
    CGFloat linespace = 0;
    
    CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierLineSpacing, sizeof(linespace), &linespace);
    
    CGFloat height = 0;
    CGFloat width = 0;
    CFIndex lineIndex = 0;
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathAddRect(pathRef, NULL, CGRectMake(0, 0, size.width, size.height));
    CTFramesetterRef framesetterRef = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attString);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetterRef, CFRangeMake(0, 0), pathRef, nil);
    CFArrayRef lines = CTFrameGetLines(frameRef);
    
    lineIndex = CFArrayGetCount(lines);
    
    if (lineIndex > 1)
    {
        for (int i = 0; i <lineIndex ; i++)
        {
            CTLineRef lineRef= CFArrayGetValueAtIndex(lines, i);
            CGFloat lineAscent;
            CGFloat lineDescent;
            CGFloat lineLeading;
            CTLineGetTypographicBounds(lineRef, &lineAscent, &lineDescent, &lineLeading);
            
            if (i == lineIndex - 1)
            {
                height += (lineAscent + lineDescent );
            }
            else
            {
                height += (lineAscent + lineDescent + linespace);
            }
        }
        
        width = size.width;
    }
    else
    {
        for (int i = 0; i <lineIndex ; i++)
        {
            CTLineRef lineRef= CFArrayGetValueAtIndex(lines, i);
            CGRect rect = CTLineGetBoundsWithOptions(lineRef,kCTLineBoundsExcludeTypographicShifts);
            width = rect.size.width;
            
            CGFloat lineAscent;
            CGFloat lineDescent;
            CGFloat lineLeading;
            CTLineGetTypographicBounds(lineRef, &lineAscent, &lineDescent, &lineLeading);
            
            height += (lineAscent + lineDescent + lineLeading + linespace);
        }
        
        height = height;
    }
    
    CFRelease(pathRef);
    CFRelease(frameRef);
    CFRelease(framesetterRef);
    
    CGRect rect = CGRectMake(0,0,width,height);
    
    return rect;
}

+ (CGRect)getRectWithSize:(CGSize)size font:(UIFont *)font string:(NSString *)string lineSpace:(CGFloat )lineSpace
{
    NSMutableAttributedString *attributedString = [[self class] getAttributedStringWithText:string font:font lineSpace:lineSpace];
    
    return [self getRectWithSize:size font:font AttString:attributedString];
}


#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    CGPoint location = [(UITouch *)[touches anyObject] locationInView:self];
    CGPoint runLocation = CGPointMake(location.x, self.frame.size.height - location.y);
    
    if (self.delegage && [self.delegage respondsToSelector:@selector(msgTextView: touchesBegan:)])
    {
        __weak MsgTextView *weakSelf = self;
        
        [self.msgRectDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
            
            CGRect rect = [((NSValue *)key) CGRectValue];
            if(CGRectContainsPoint(rect, runLocation))
            {
                self.touchMsg = obj;
                [weakSelf.delegage msgTextView:weakSelf touchesBegan:obj];
            }
        }];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    CGPoint location = [(UITouch *)[touches anyObject] locationInView:self];
    CGPoint runLocation = CGPointMake(location.x, self.frame.size.height - location.y);
    
    if (self.delegage && [self.delegage respondsToSelector:@selector(msgTextView: touchesEnded:)])
    {
        __weak MsgTextView *weakSelf = self;
        
        [self.msgRectDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
            
            CGRect rect = [((NSValue *)key) CGRectValue];
            if(CGRectContainsPoint(rect, runLocation))
            {
                self.touchMsg = obj;
                [weakSelf.delegage msgTextView:weakSelf touchesEnded:obj];
            }
        }];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    CGPoint location = [(UITouch *)[touches anyObject] locationInView:self];
    CGPoint runLocation = CGPointMake(location.x, self.frame.size.height - location.y);
    
    if (self.delegage && [self.delegage respondsToSelector:@selector(msgTextView: touchesCancelled:)])
    {
        __weak MsgTextView *weakSelf = self;
        
        [self.msgRectDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
            
            CGRect rect = [((NSValue *)key) CGRectValue];
            if(CGRectContainsPoint(rect, runLocation))
            {
                self.touchMsg = obj;
                [weakSelf.delegage msgTextView:weakSelf touchesCancelled:obj];
            }
        }];
    }
}

- (UIResponder*)nextResponder
{
    [super nextResponder];
    
    return self.touchMsg;
}

#pragma mark -


- (void)setText:(NSString *)text
{
    _text = text;
    [self setNeedsDisplay];
    
}

@end
