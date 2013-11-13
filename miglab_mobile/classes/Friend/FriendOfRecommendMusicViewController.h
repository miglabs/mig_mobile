//
//  FriendOfRecommendMusicViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-25.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "BaseViewController.h"
#import "SongOfSendEmptyTipsView.h"
#import "SVProgressHUD.h"
#import "FriendOfSendSongListViewController.h"

@interface FriendOfRecommendMusicViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, FriendOfSendSongListViewControllerDelegate>

@property (nonatomic, retain) UITableView* sendsongTableView;
@property (nonatomic, retain) NSMutableArray* sendsongData;

@property (nonatomic, retain) SongOfSendEmptyTipsView *emptyTipsView;

@property (nonatomic, retain) NearbyUser* toUserInfo;
@property (nonatomic, assign) BOOL isSendingSong;
@property (nonatomic, assign) int curEditSong;

@property (nonatomic, retain) MigLabAPI* miglabAPI;

-(void)doUpdateView;
-(void)showOrHideEmptyTips;

-(void)doGetSongList:(id)sender;

-(void)doSendSong:(id)sender;
-(void)SendMusicToUser:(NSString*)songid;
-(void)SendMusicToUserSuccess:(NSNotification*)tNotification;
-(void)SendMusicToUserFailed:(NSNotification*)tNotification;

@end
