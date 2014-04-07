//
//  MainViewController.m
//  miglab_chat
//
//  Created by 180 on 14-3-30.
//  Copyright (c) 2014年 180. All rights reserved.
//

#import "MainViewController.h"
#import "ChatNetService.h"
#import "../ChatViewController/ChatViewController.h"
#import "ChatNotification.h"
#define TOOLBARTAG		200
#define TABLEVIEWTAG	300
@interface MainViewController ()
{

    FaceViewController         *_phraseViewController;
    UITextView                 *u_textView;
    UITextView                 *t_textView;
    
}
@end


@implementation MainViewController
@synthesize phraseViewController = _phraseViewController;
@synthesize customCell, cellNib;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"与10149聊天" forState:UIControlStateNormal];
    [button  setBackgroundImage:[UIImage imageNamed:@"senditem.png"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake((320-200)/2, 100, 200, 40)];
    [button setTag:10149];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton* button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"与10108聊天" forState:UIControlStateNormal];
    [button1 setFrame:CGRectMake((320-200)/2, 150, 200, 40)];
    [button1  setBackgroundImage:[UIImage imageNamed:@"senditem.png"] forState:UIControlStateNormal];
    [button1 setTag:10108];
    [button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    self.cellNib = [UINib nibWithNibName:@"ChatMsgTableViewCell" bundle:nil];


}


- (void) buttonClick:(UIButton *)button;
{
    
    //NSArray * array = [self.cellNib instantiateWithOwner:self options:nil];

    ChatViewController* view = nil;
    
    if ( button.tag == 10149 ) {
        view = [[ChatViewController alloc] init:nil uid:10108 tid:10149];
    }
    else if ( button.tag == 10108 )
    {
         view = [[ChatViewController alloc] init:nil uid:10149 tid:10108];
    }
    //[self presentViewController:view animated:YES completion:nil];
	//[self.navigationController pushViewController:view animated:YES];
    //[self showFace:button];
    [self presentModalViewController:view animated:YES];
    
}

-(void)dealloc
{

}








- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:YES];

	
	//[self.messageTextField setText:self.messageString];
	//[self.chatTableView reloadData];
}


@end
