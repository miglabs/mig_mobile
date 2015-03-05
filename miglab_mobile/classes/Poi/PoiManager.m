//
//  Poi.m
//  miglab_mobile
//
//  Created by kerry on 14/12/20.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoiManager.h"


@interface MigPoiManager ()

@end

@implementation  MigPoiManager

@synthesize locationManager = _locationManager;
@synthesize miglabAPI = _miglabAPI;
@synthesize isUpdateLocation = _isUpdateLocation;
@synthesize viewType =_viewType;

+(MigPoiManager *)GetInstance{
    
    static MigPoiManager *instance = nil;
    @synchronized(self){
        if (nil == instance) {
            instance = [[self alloc] init];
        }
    }
    return instance;
}


- (instancetype)init{
     self = [super init];
    [self GPSInit];
     _miglabAPI = [[MigLabAPI alloc] init];
    _isUpdateLocation = false;
    _lastViewType = INIT_VIEW_TYPE;
    return  self;
}

-(void) GPSInit{
    //初始化GPS
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        
        _locationManager = [[CLLocationManager alloc] init];
        if ([CLLocationManager locationServicesEnabled]) {
            
            [_locationManager setDelegate:self];
            [_locationManager setDistanceFilter:kCLDistanceFilterNone];
            [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            [_locationManager startUpdatingLocation];
            //IOS8问题
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
                [_locationManager requestWhenInUseAuthorization];
        }
    }
    else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:MIGTIP_LOCATION_CLOSE delegate:nil cancelButtonTitle:MIGTIP_OK otherButtonTitles:nil, nil];
        [alert show];
    }

}


-(void) startUpdatingLocation{
    [_locationManager startUpdatingLocation];
}

-(void) ViewPoi:(NSInteger) view_type{
    _viewType = view_type;
}



-(void) RequestServer{
    NSString* userid = [UserSessionManager GetInstance].currentUser.userid;
    NSString* accesstoken = [UserSessionManager GetInstance].accesstoken;
    NSString* strLocation = [UserSessionManager GetInstance].currentUser.location;
    NSString* strlatitude = [UserSessionManager GetInstance].currentUser.latitude;
    NSString* strlongtitude = [UserSessionManager GetInstance].currentUser.longitude;
    switch (_viewType) {
        case ROOT_VIEW_TYPE:
            [self RootLocation:userid accesstoken:accesstoken location:strLocation latitude:strlatitude longtitude:strlongtitude];
            break;
        case MUSICT_VIEW_TYPE:
            [self MusicLocation:userid accesstoken:accesstoken location:strLocation latitude:strlatitude longtitude:strlongtitude];
            break;
        case FRINED_VIEW_TYPE:
            [self FriendLocation:userid accesstoken:accesstoken location:strLocation latitude:strlatitude longtitude:strlongtitude];
            break;
        case SAMEMUSCI_VIEW_TYPE:
            [self SameMusicLocation:userid accesstoken:accesstoken location:strLocation latitude:strlatitude longtitude:strlongtitude];
            break;
        case NEARFRI_VIEW_TYPE:
            [self NearFriendLocation:userid accesstoken:accesstoken location:strLocation latitude:strlatitude longtitude:strlongtitude];
            break;
        case NEARRMUSIC_VIEW_TYPE:
            [self NearMusciLocation:userid accesstoken:accesstoken location:strLocation latitude:strlatitude longtitude:strlongtitude];
            break;
        default:
            break;
    }
    
    _lastViewType = _viewType;
}

//注册地理位置及获取天气及登陆日志
-(void) RootLocation:(NSString*) uid accesstoken:(NSString*) accesstoken
            location:(NSString*) location latitude:(NSString*) latitude
          longtitude:(NSString*) longtitude{
    
    [_miglabAPI doSetUserPos:uid token:accesstoken location:location];
    //登陆日志
    [_miglabAPI doLoginRecord:uid ttoken:accesstoken latitude:latitude longitude:longtitude];
    //获取地理信息
    [_miglabAPI doGetLocation:uid ttoken:accesstoken tlatitude:latitude
                   tlongitude:longtitude];
}

//歌友界面
-(void) FriendLocation:(NSString*) uid accesstoken:(NSString*) accesstoken
              location:(NSString*) location latitude:(NSString*) latitude
            longtitude:(NSString*) longtitude{
    
    [SVProgressHUD showWithStatus:MIGTIP_LOADING maskType:SVProgressHUDMaskTypeNone];
    [_miglabAPI doGetMyNearMusicMsgNumber:uid token:accesstoken radius:[NSString stringWithFormat:@"%d", SEARCH_DISTANCE] location:location];
}

//相同音乐的人
-(void) SameMusicLocation:(NSString*) uid accesstoken:(NSString*) accesstoken
                 location:(NSString*) location latitude:(NSString*) latitude
               longtitude:(NSString*) longtitude{
    [SVProgressHUD showWithStatus:MIGTIP_LOADING maskType:SVProgressHUDMaskTypeNone];
    [_miglabAPI doGetSameMusic:uid token:accesstoken radius:[NSString stringWithFormat:@"%d", SEARCH_DISTANCE] location:location];
}

//附近歌友
-(void) NearFriendLocation:(NSString*) uid accesstoken:(NSString*) accesstoken
                  location:(NSString*) location latitude:(NSString*) latitude
                longtitude:(NSString*) longtitude{
    [SVProgressHUD showWithStatus:MIGTIP_LOADING maskType:SVProgressHUDMaskTypeNone];
    [_miglabAPI doGetNearUser:uid token:accesstoken radius:[NSString stringWithFormat:@"%d", SEARCH_DISTANCE] location:location];
}
//音乐界面
-(void) MusicLocation:(NSString*) uid accesstoken:(NSString*) accesstoken
             location:(NSString*) location latitude:(NSString*) latitude
           longtitude:(NSString*) longtitude{
    [SVProgressHUD showWithStatus:MIGTIP_LOADING maskType:SVProgressHUDMaskTypeNone];
    [_miglabAPI doCollectAndNearNum:uid token:accesstoken taruid:uid radius:@"1000" pageindex:@"0" pagesize:@"10" location:location];
}

//附近音乐
-(void) NearMusciLocation:(NSString*) uid accesstoken:(NSString*) accesstoken
                 location:(NSString*) location latitude:(NSString*) latitude
               longtitude:(NSString*) longtitude{
     [SVProgressHUD showWithStatus:MIGTIP_LOADING maskType:SVProgressHUDMaskTypeNone];
    [self.miglabAPI doGetNearMusic:uid token:accesstoken radius:@"1000" pageindex:0 pagesize:@"10" location:location];
}



-(double)  CalcGEODistance:(double)latitude1 longitude1:(double) longitude1
            latitude2:(double) latitude2  longitude2:(double) longitude2{
    if ((latitude1==latitude2)&&(longitude1==longitude2))
        return 0;

    double dd = M_PI/180;
    double x1 = longitude1 * dd;
    double y1 = latitude1 * dd;
    
    double x2 = longitude2 * dd;
    double y2 = latitude2 * dd;
    
    double R = 6378137;
    
    double runDistance = (2*R*asin(sqrt(2-2*cos(x1)*cos(x2)*cos(y1-y2) - 2*sin(x1)*sin(x2))/2));
    runDistance = (runDistance < 0) ? (-runDistance) : runDistance;
    return runDistance;
}

#pragma mark - Location delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    PLog(@"old %@,%@",[NSString stringWithFormat:@"%g", newLocation.coordinate.latitude],[NSString stringWithFormat:@"%g", newLocation.coordinate.longitude]);
    PLog(@"new %@,%@",[NSString stringWithFormat:@"%g", oldLocation.coordinate.latitude],[NSString stringWithFormat:@"%g", oldLocation.coordinate.longitude]);
    
    //停止更新
    [_locationManager stopUpdatingLocation];
    
    CLLocationCoordinate2D newcoordinate = newLocation.coordinate;
    CLLocationDegrees newLatitude = newcoordinate.latitude;
    CLLocationDegrees newLongitude = newcoordinate.longitude;
    
    CLLocationCoordinate2D oldcoordinate = oldLocation.coordinate;
    CLLocationDegrees oldLatitude = oldcoordinate.latitude;
    CLLocationDegrees oldLongitude = oldcoordinate.longitude;

    double distance = [self CalcGEODistance:newLatitude longitude1:newLongitude latitude2:oldLatitude longitude2:oldLongitude];
    
    if (distance>RANGE)
        _isUpdateLocation = false;
    
    if (!_isUpdateLocation) {
        

        NSString* strlatitude = [NSString stringWithFormat:@"%g", newLatitude];
        NSString* strlongtitude = [NSString stringWithFormat:@"%g", newLongitude];
        
        
        NSString* location = [NSString stringWithFormat:@"%@,%@", strlatitude, strlongtitude];
        
        PLog(@"%@",location);
        _isUpdateLocation = YES;
        
        [UserSessionManager GetInstance].currentUser.location = location;
        [UserSessionManager GetInstance].currentUser.latitude = strlatitude;
        [UserSessionManager GetInstance].currentUser.longitude = strlongtitude;
    }
    
    //如果类型不同则请求
    //如果距离大于RANGE则请求
    if (_lastViewType!=_viewType||distance>RANGE)
         [self RequestServer];
   
    //[self loadNumbersFromServer:location];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    if (_isUpdateLocation) {
        
        return;
    }
    else {
        
        NSString *location = @"0,0";
        //[self loadNumbersFromServer:location];
        _isUpdateLocation = YES;
    }
    
    PLog(@"update location failed");
}

@end