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

+(GlobalDataManager *)GetInstance;

@end
