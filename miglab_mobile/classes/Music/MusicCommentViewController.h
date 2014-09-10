//
//  MusicCommentViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-21.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"
#import "PCustomNavigationBarView.h"
#import "MusicCommentPlayerView.h"
#import "MusicCommentInputView.h"
#import "Song.h"
#import "MigLabAPI.h"

//歌曲评论页面
@interface MusicCommentViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, retain) UIView *bodyView;

@property (nonatomic, retain) MusicCommentPlayerView *commentPlayerView;

@property (nonatomic, retain) UITableView *dataTableView;
@property (nonatomic, retain) NSMutableArray *dataList;

@property (nonatomic, retain) MusicCommentInputView *commentInputView;

// 当前页面显示的歌曲
@property (nonatomic, retain) Song *song;

// 当前正在播放的歌曲
@property (nonatomic, retain) Song* curPlayingSong;

@property (nonatomic, retain) MigLabAPI *miglabAPI;

@property (nonatomic, assign) int pageIndex;
@property (nonatomic, assign) int pageSize;
@property (nonatomic, assign) BOOL isLoadMore;
@property (nonatomic, assign) int isCurrentLike;

-(void)loadData;
-(void)loadCommentListFromServer;

-(void)updateSongInfo;

-(void)getCommentListFailed:(NSNotification *)tNotification;
-(void)getCommentListSuccess:(NSNotification *)tNotification;

-(void)doCollectSuccess:(NSNotification*)tNotification;
-(void)doCollectFailed:(NSNotification *)tNotification;

-(void)doDeleteCollectSuccess:(NSNotification*)tNotification;
-(void)doDeleteCollectFailed:(NSNotification *)tNotification;

-(void)doCommentSongSuccess:(NSNotification*)tNotification;
-(void)doCommentSongFailed:(NSNotification *)tNotification;

-(void)playerStart:(NSNotification *)tNotification;
-(void)playerStop:(NSNotification *)tNotification;

-(IBAction)doPlayOrPause:(id)sender;
-(IBAction)doNext:(id)sender;
-(IBAction)doCollect:(id)sender;
-(IBAction)doHate:(id)sender;
-(IBAction)doShare:(id)sender;

-(IBAction)doCommentSong:(id)sender;
-(IBAction)doHideKeyboard:(id)sender;



@end
