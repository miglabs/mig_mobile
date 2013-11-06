//
//  FriendMessageUserHead.h
//  miglab_mobile
//
//  Created by pig on 13-8-23.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"

@interface FriendMessageUserHead : UIView

@property (nonatomic, assign) NearbyUser* userinfo;

@property (nonatomic, retain) IBOutlet UILabel *lblListening;
@property (nonatomic, retain) IBOutlet EGOImageButton *btnAvatar;
@property (nonatomic, retain) IBOutlet UILabel *lblNickName;
@property (nonatomic, retain) IBOutlet UILabel *lblUserInfo;
@property (nonatomic, retain) IBOutlet UIButton *btnSayHi;
@property (nonatomic, retain) IBOutlet UIButton *btnAddBlack;
@property (nonatomic, assign) BOOL isFriend;

-(void)updateFriendMessageUserHead:(NearbyUser*)user;

@end
