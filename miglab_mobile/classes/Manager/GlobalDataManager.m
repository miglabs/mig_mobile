//
//  GlobalDataManager.m
//  miglab_mobile
//
//  Created by Archer_LJ on 14-5-17.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import "GlobalDataManager.h"

@implementation GlobalDataManager

@synthesize isMainMenuFirstLaunch = _isMainMenuFirstLaunch;
@synthesize isGeneMenuFirstLaunch = _isGeneMenuFirstLaunch;
@synthesize isFirendMenuFirstLaunch = _isFirendMenuFirstLaunch;
@synthesize isProgramFirstLaunch = _isProgramFirstLaunch;
@synthesize isDetailPlayFirstLaunch = _isDetailPlayFirstLaunch;
@synthesize nNewArrivalMsg = _nNewArrivalMsg;
@synthesize isIOS7Up = _isIOS7Up;
@synthesize isIOS8 = _isIOS8;
@synthesize isLongScreen = _isLongScreen;
@synthesize isPad = _isPad;
@synthesize isPadRetina = _isPadRetina;
@synthesize isWifiConnect = _isWifiConnect;
@synthesize is3GConnect = _is3GConnect;
@synthesize isNetConnect = _isNetConnect;
@synthesize lastLatitude = _lastLatitude;
@synthesize lastLongitude = _lastLongitude;
@synthesize nShareSource = _nShareSource;
@synthesize curSongType = _curSongType;
@synthesize curSongTypeName = _curSongTypeName;
@synthesize curSongTypeId = _curSongTypeId;
@synthesize curSongId = _curSongId;

+(GlobalDataManager *)GetInstance{
    
    static GlobalDataManager *instance = nil;
    @synchronized(self){
        if (nil == instance) {
            instance = [[self alloc] init];
        }
    }
    return instance;
}

@end
