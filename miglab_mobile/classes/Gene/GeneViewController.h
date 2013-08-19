//
//  GeneViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-16.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"
#import "CurrentGeneView.h"
#import "ModifyGeneView.h"

@interface GeneViewController : PlayerViewController

//当前基因信息
@property (nonatomic, retain) CurrentGeneView *currentGeneView;

//音乐基因
@property (nonatomic, retain) ModifyGeneView *modifyGeneView;

-(IBAction)doAvatar:(id)sender;

-(IBAction)doGotoGene:(id)sender;
-(IBAction)doBackFromGene:(id)sender;

//解析音乐基因数据
-(void)initGeneDataFromFile;

@end
