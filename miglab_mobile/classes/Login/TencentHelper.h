//
//  TencentHelper.h
//  miglab_mobile
//
//  Created by pig on 14-5-18.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentMessageObject.h>
#import <TencentOpenAPI/WeiBoAPI.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "Song.h"

typedef enum {
    TencentHelperStatusLogin = 1,
    TencentHelperStatusAddTopic,
    TencentHelperStatusAddWeibo
} TencentHelperStatus;


@interface QQAPIHandler : NSObject

@end

@class TencentHelper;

@protocol TencentHelperDelegate <NSObject, TencentLoginDelegate>

@optional;

//login
- (void)tencentLoginHelper:(TencentHelper *)tencentHelper didFailWithError:(NSError *)error;
- (void)tencentLoginHelper:(TencentHelper *)tencentHelper didFinishLoadingWithResult:(NSDictionary *)result;

//add topic
- (void)tencentAddTopicHelper:(TencentHelper *)tencentHelper didFailWithError:(NSError *)error;
- (void)tencentAddTopicHelper:(TencentHelper *)tencentHelper didFinishLoadingWithResult:(NSDictionary *)result;

//weibo add
- (void)tencentAddWeiboHelper:(TencentHelper *)tencentHelper didFailWithError:(NSError *)error;
- (void)tencentAddWeiboHelper:(TencentHelper *)tencentHelper didFinishLoadingWithResult:(NSDictionary *)result;

@end

@interface TencentHelper : NSObject<TencentSessionDelegate, TCAPIRequestDelegate>

@property (nonatomic, retain) TencentOAuth *tencentOAuth;
@property (nonatomic, retain) NSArray *permissions;

@property (nonatomic, assign) id<TencentHelperDelegate> delegate;
@property (nonatomic, assign) TencentHelperStatus tencentHelperStatus;
@property (nonatomic, strong) Song *shareSong;

+ (id)sharedInstance;

- (void)doTencentLogin;
- (void)addTopic:(Song *)tSong;
- (void)addWeibo:(Song *)tSong;
- (void)addQQZoneWithLyricImage:(Song *)tSong;

-(void)initTencentOAuth:(AccountOf3rdParty *)tmpauth;

@end
