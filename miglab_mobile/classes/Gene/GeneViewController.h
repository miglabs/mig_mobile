//
//  GeneViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-16.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"

@interface GeneViewController : PlayerViewController

@property (nonatomic, retain) EGOImageButton *btnAvatar;

@property (nonatomic, retain) UIButton *btnGotoGene;        //显示音乐基因

//音乐基因
@property (nonatomic, retain) IBOutlet UIView *geneView;
@property (nonatomic, retain) IBOutlet UIButton *btnBackFromGene;

-(IBAction)doAvatar:(id)sender;

-(IBAction)doGotoGene:(id)sender;
-(IBAction)doBackFromGene:(id)sender;

//解析音乐基因数据
-(void)initGeneDataFromFile;

@end
