//
//  ShareGuideView.m
//  miglab_mobile
//
//  Created by pig on 14-5-18.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import "ShareGuideView.h"

@implementation ShareGuideView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor colorWithRed:37/255 green:37/255 blue:37/255 alpha:0.8f];
        
        _shareIconImageView = [[UIImageView alloc] init];
        _shareIconImageView.frame = CGRectMake(260, 20, 57, 57);
        _shareIconImageView.image = [UIImage imageNamed:@"share1.png"];
        [self addSubview:_shareIconImageView];
        
        _shareTextImageView = [[UIImageView alloc] init];
        _shareTextImageView.frame = CGRectMake(80, 70, 217, 41);
        _shareTextImageView.image = [UIImage imageNamed:@"share_text.png"];
        [self addSubview:_shareTextImageView];
        
    }
    return self;
}

@end
