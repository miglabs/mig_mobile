//
//  MyFriendPersonalPageViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-23.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"
#import "PCustomNavigationBarView.h"
#import "FriendMessageUserHead.h"

@interface MyFriendPersonalPageViewController : PlayerViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) PCustomNavigationBarView *navView;
@property (nonatomic, retain) FriendMessageUserHead *userHeadView;

@property (nonatomic, retain) UITableView *bodyTableView;
@property (nonatomic, retain) NSArray *tableTitles;

@property (nonatomic, assign) BOOL isFriend;

-(IBAction)doBack:(id)sender;

-(IBAction)doRecommendMusic:(id)sender; //推荐ta歌曲
-(IBAction)doSendMessage:(id)sender;    //发消息

-(IBAction)doSayHi:(id)sender;      //打招呼
-(IBAction)doAddBlack:(id)sender;   //拉进黑名单

@end
