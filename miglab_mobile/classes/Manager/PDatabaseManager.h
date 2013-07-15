//
//  PDatabaseManager.h
//  miglab_mobile
//
//  Created by apple on 13-7-3.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PFileManager.h"
#import "FMDatabase.h"

@interface PDatabaseManager : PFileManager

@property (nonatomic, retain) FMDatabase *db;

+(PDatabaseManager *)GetInstance;

//重制部分数据记录
-(void)initDataInfo;

//设置某个歌曲的总文件大小
-(void)setSongMaxSize:(long long)tlocalkey type:(NSString *)ttype fileMaxSize:(long long)tfilemaxsize;
//判断是否已经记录歌曲的总文件大小
-(BOOL)isExistsSongMaxSize:(long long)tlocalkey type:(NSString *)ttype;
//获取某个歌曲的总文件大小
-(long long)getSongMaxSize:(long long)tlocalkey type:(NSString *)ttype;

@end
