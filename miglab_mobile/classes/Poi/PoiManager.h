//
// Poi.h
// miglab_mobile
//
// Created by kerry on 14/12/20.
// Copyright (c) 2014年 pig. All rights reserved.
//
#ifndef miglab_mobile_Poi_h
#define miglab_mobile_Poi_h
#import "UserSessionManager.h"
#import "SVProgressHUD.h"
#import "MigLabAPI.h"
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
enum ViewTypes{
    INIT_VIEW_TYPE = 0,
    ROOT_VIEW_TYPE = 1,
    MUSICT_VIEW_TYPE,
    NEARRMUSIC_VIEW_TYPE,
    FRINED_VIEW_TYPE,
    SAMEMUSCI_VIEW_TYPE,
    NEARFRI_VIEW_TYPE,
};
#define RANGE 5
//单件模型
@interface MigPoiManager:NSObject<CLLocationManagerDelegate>
//gps定位
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL isUpdateLocation;
//接口api
@property (nonatomic, retain) MigLabAPI *miglabAPI;
@property NSInteger viewType;
@property NSInteger lastViewType;
//启动定位
-(void) startUpdatingLocation;
//设置界面定位相关
-(void) ViewPoi:(NSInteger) view_type;
//计算距离
-(double) CalcGEODistance:(double)latitude1 longitude1:(double) longitude1
                latitude2:(double) latitude2 longitude2:(double) longitude2;
//通知服务端
-(void) RequestServer;
+(MigPoiManager *)GetInstance;
@end
#endif