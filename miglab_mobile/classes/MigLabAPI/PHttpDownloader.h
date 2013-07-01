//
//  PHttpDownloader.h
//  miglab_mobile
//
//  Created by apple on 13-7-1.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHttpDownloader : NSObject

-(BOOL)initDownloadInfo;
-(void)doStart;
-(void)doPause;
-(void)doResume;

@end
