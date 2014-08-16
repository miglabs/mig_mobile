//
//  SinaWeiboHelper.h
//  miglab_mobile
//
//  Created by pig on 14-5-18.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
#import "Song.h"
#import "LyricShare.h"

typedef enum {
    SinaWeiboHelperStatusLogin = 1,
    SinaWeiboHelperStatusUpdate
} SinaWeiboHelperStatus;

@class SinaWeiboHelper;

@protocol SinaWeiboHelperDelegate <NSObject>

@optional;

//login
- (void)sinaWeiboLoginHelper:(SinaWeiboHelper *)sinaWeiboHelper didFailWithError:(NSError *)error;
- (void)sinaWeiboLoginHelper:(SinaWeiboHelper *)sinaWeiboHelper didFinishLoadingWithResult:(NSDictionary *)result;

//update
- (void)sinaWeiboUpdateHelper:(SinaWeiboHelper *)sinaWeiboHelper didFailWithError:(NSError *)error;
- (void)sinaWeiboUpdateHelper:(SinaWeiboHelper *)sinaWeiboHelper didFinishLoadingWithResult:(NSDictionary *)result;

@end

@interface SinaWeiboHelper : NSObject<SinaWeiboDelegate, SinaWeiboRequestDelegate>

@property (nonatomic, assign) id<SinaWeiboHelperDelegate> delegate;
@property (nonatomic, assign) SinaWeiboHelperStatus sinaWeiboHelperStatus;
@property (nonatomic, retain) Song *shareSong;

+ (id)sharedInstance;

- (void)doSinaWeiboLogin;
- (void)updateSinaWeibo:(Song *)tSong;

-(void)doShareToSinaWeibo:(LyricShare *)lyric;

-(void)getLyricInfoSucceed:(NSNotification *)tNotification;
-(void)getLyricInfoFailed:(NSNotification *)tNotification;

@end
