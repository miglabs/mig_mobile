//
//  AccountOf3rdParty.h
//  miglab_mobile
//
//  Created by apple on 13-7-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountOf3rdParty : NSObject

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, assign) int accounttype;
@property (nonatomic, retain) NSString *accountid;
@property (nonatomic, retain) NSString *accesstoken;
@property (nonatomic, retain) NSDate *expirationdate;
@property (nonatomic, retain) NSString *strexpirationdate;

// QQ account part
@property (nonatomic, retain) NSString *qqAccessToken;
@property (nonatomic, retain) NSString *qqOpenId;
@property (nonatomic, retain) NSString *qqLocalAppId;
@property (nonatomic, assign) int qqLongTime;

-(void)log;

@end
