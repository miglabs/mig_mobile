//
//  GlobalDataManager.h
//  miglab_mobile
//
//  Created by Archer_LJ on 14-5-17.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalDataManager : NSObject

@property (nonatomic, assign) BOOL isMainMenuFirstLaunch;
@property (nonatomic, assign) BOOL isGeneMenuFirstLaunch;
@property (nonatomic, assign) BOOL isFirendMenuFirstLaunch;
@property (nonatomic, assign) BOOL isProgramFirstLaunch;
@property (nonatomic, assign) BOOL isDetailPlayFirstLaunch;
@property (nonatomic, assign) BOOL isIOS7Up;    // ios 7 及以上版本
@property (nonatomic, assign) BOOL isLongScreen; // 长屏幕
@property (nonatomic, assign) BOOL isPad;
@property (nonatomic, assign) BOOL isPadRetina;
@property (nonatomic, assign) BOOL isWifiConnect;
@property (nonatomic, assign) BOOL is3GConnect;
@property (nonatomic, assign) BOOL isNetConnect;
@property (nonatomic, retain) NSString* lastLatitude;
@property (nonatomic, retain) NSString* lastLongitude;
@property (nonatomic, retain) NSString* curSongType;
@property (nonatomic, retain) NSString* curSongTypeName;
@property (nonatomic, assign) int curSongTypeId;
@property (nonatomic, assign) int curSongId;

@property (nonatomic, assign) int nNewArrivalMsg;
@property (nonatomic, assign) int nShareSource; // 1-weibo, 2-weixin

+(GlobalDataManager *)GetInstance;

@end
