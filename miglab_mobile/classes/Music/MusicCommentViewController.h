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

@property (nonatomic, retain) PCustomNavigationBarView *navView;
@property (nonatomic, retain) MusicCommentPlayerView *commentPlayerView;

@property (nonatomic, retain) UITableView *commentTableView;
@property (nonatomic, retain) NSMutableArray *commentList;

@property (nonatomic, retain) MusicCommentInputView *commentInputView;

@property (nonatomic, retain) Song *song;

@property (nonatomic, retain) MigLabAPI *miglabAPI;

-(IBAction)doPlayOrPause:(id)sender;
-(IBAction)doCollectedOrCancel:(id)sender;
-(IBAction)doHate:(id)sender;
-(IBAction)doShare:(id)sender;

-(IBAction)doHideKeyboard:(id)sender;

@end
