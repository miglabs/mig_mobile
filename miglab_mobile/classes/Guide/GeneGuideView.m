//
//  GeneGuideView.m
//  miglab_mobile
//
//  Created by pig on 14-5-18.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import "GeneGuideView.h"

@implementation GeneGuideView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor colorWithRed:37/255 green:37/255 blue:37/255 alpha:0.7];
        
        _loginIconImageView = [[UIImageView alloc] init];
        _loginIconImageView.frame = CGRectMake(102, 105, 60, 59);
        _loginIconImageView.image = [UIImage imageNamed:@"login_icon.png"];
        [self addSubview:_loginIconImageView];
        
        _loginTextImageView = [[UIImageView alloc] init];
        _loginTextImageView.frame = CGRectMake(162, 137, 132, 38);
        _loginTextImageView.image = [UIImage imageNamed:@"login_text.png"];
        [self addSubview:_loginTextImageView];
        
        _gene1ImageView = [[UIImageView alloc] init];
        _gene1ImageView.frame = CGRectMake(21, 163, 54, 54);
        _gene1ImageView.image = [UIImage imageNamed:@"gene1.png"];
        [self addSubview:_gene1ImageView];
        
        _gene2ImageView = [[UIImageView alloc] init];
        _gene2ImageView.frame = CGRectMake(250, 234, 54, 54);
        _gene2ImageView.image = [UIImage imageNamed:@"gene2.png"];
        [self addSubview:_gene2ImageView];
        
        _gene3ImageView = [[UIImageView alloc] init];
        _gene3ImageView.frame = CGRectMake(21, 305, 54, 54);
        _gene3ImageView.image = [UIImage imageNamed:@"gene3.png"];
        [self addSubview:_gene3ImageView];
        
        _geneTextImageView = [[UIImageView alloc] init];
        _geneTextImageView.frame = CGRectMake(35, 220, 210, 82);
        _geneTextImageView.image = [UIImage imageNamed:@"gene_text.png"];
        [self addSubview:_geneTextImageView];
        
    }
    return self;
}

@end
