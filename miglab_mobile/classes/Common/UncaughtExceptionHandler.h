//
//  UncaughtExceptionHandler.h
//  itime
//
//  Created by Ming Jianhua on 13-2-27.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UncaughtExceptionHandler : NSObject{
    BOOL dismissed;
}

@end

void InstallUncaughtExceptionHandler();