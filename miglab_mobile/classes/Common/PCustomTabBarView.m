//
//  PCustomTabBarView.m
//  itime
//
//  Created by pig on 13-1-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PCustomTabBarView.h"
#import "NSString+PStringCategory.h"
#import "UIImage+PImageCategory.h"
#import "PCustomTabBarItemView.h"

#define VIEW_WIDTH 320.0f
#define VIEW_HEIGHT 50.0f

@implementation PCustomTabBarView

@synthesize delegate;
@synthesize currentSelectedIndex;
@synthesize slideBg;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithTitleList:(NSArray *)tTitleList normalIconList:(NSArray *)tNormalIconList selectedIconList:(NSArray *)tSelectedIconList{
    
    if(self = [super initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT)]){
        [self setBackgroundColor:[UIColor colorWithWhite:0.1f alpha:1.0]];
        
        int width = VIEW_WIDTH / 3;
        int defaultSelectedIndex = 1;
        for (int i=0; i<3; i++) {
            NSString *tempTitle = [tTitleList objectAtIndex:i];
            NSString *tempNormalImageName = [tNormalIconList objectAtIndex:i];
            NSString *tempSelectedImageName = [tSelectedIconList objectAtIndex:i];
            UIImage *tempNormalImage = [UIImage imageWithName:[tempNormalImageName getImageName] type:[tempNormalImageName getImageType]];
            UIImage *tempSelectedImage = [UIImage imageWithName:[tempSelectedImageName getImageName] type:[tempSelectedImageName getImageType]];
            
            PCustomTabBarItemView *pCustomTabBarItemView = nil;
            if (1 == i) {
                pCustomTabBarItemView = [[PCustomTabBarItemView alloc] initWithFrame:CGRectMake(i*width, -16, width, VIEW_HEIGHT+16) normalIconImage:tempNormalImage selectedIconImage:tempSelectedImage];
            }else{
                pCustomTabBarItemView = [[PCustomTabBarItemView alloc] initWithFrame:CGRectMake(i*width, 0, width, VIEW_HEIGHT) title:tempTitle normalIconImage:tempNormalImage selectedIconImage:tempSelectedImage];
            }
            
            [pCustomTabBarItemView setTag:i + 100];
            [pCustomTabBarItemView addTarget:self action:@selector(selectedCustomTabBarItemView:) forControlEvents:UIControlEventTouchUpInside];
            
            //默认选中的TabBarItemView
            if (defaultSelectedIndex == i) {
                //设置TabBarItemView的选择状态
                [pCustomTabBarItemView setSelected:YES];
                //保存当前选择索引
                [self setCurrentSelectedIndex:i];
            }else{
                [pCustomTabBarItemView setSelected:NO];
            }
            
            [self addSubview:pCustomTabBarItemView];
            [pCustomTabBarItemView release];
            
        }//for
        
        //
        UIImage *slideImage = [UIImage imageWithName:@"tab_glow.png"];
        UIImageView *tempSlideBg = [[UIImageView alloc] initWithImage:slideImage];
        [self setSlideBg:tempSlideBg];
        [self addSubview:tempSlideBg];
        [tempSlideBg release];
        self.slideBg.frame = CGRectMake(-30, self.frame.origin.y, slideBg.image.size.width, slideBg.image.size.height);
        
    }
    
    return self;
}

-(void)dealloc{
    
    [self setDelegate:nil];
    [super dealloc];
    
}

/*
 * 按钮选中事件
 */
-(void)selectedCustomTabBarItemView:(id)sender{
    
    PCustomTabBarItemView *pCustomTabBarItemView = sender;
    NSLog(@"pCustomTabBarItemView.tag: %d", pCustomTabBarItemView.tag);
    if ([delegate respondsToSelector:@selector(selectedCustomTabBarItemViewIndex:)]) {
        BOOL isSelected = [delegate selectedCustomTabBarItemViewIndex:pCustomTabBarItemView.tag - 100];
        if (isSelected) {
            [self updateSelectedCustomTabBarItemView:pCustomTabBarItemView.tag - 100];
        }
    }
}

-(void)updateSelectedCustomTabBarItemView:(int)tIndex{
    //修改当前状态
    PCustomTabBarItemView *curCustomTabBarItemView = (PCustomTabBarItemView *)[self viewWithTag:self.currentSelectedIndex + 100];
    [curCustomTabBarItemView setSelected:NO];
    
    //选中新的item
    PCustomTabBarItemView *newCustomTabBarItemView = (PCustomTabBarItemView *)[self viewWithTag:tIndex + 100];
    [newCustomTabBarItemView setSelected:YES];
    
    //记录新的选中索引
    [self setCurrentSelectedIndex:tIndex];
    
    //
    [self performSelector:@selector(slideTabBy:) withObject:newCustomTabBarItemView];
    
}

-(void)slideTabBy:(PCustomTabBarItemView *)pCustomTabBarItemView{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.20];
    [UIView setAnimationDelegate:self];
    self.slideBg.frame = CGRectMake(pCustomTabBarItemView.frame.origin.x - 30, pCustomTabBarItemView.frame.origin.y, slideBg.image.size.width, slideBg.image.size.height);
    [UIView commitAnimations];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
