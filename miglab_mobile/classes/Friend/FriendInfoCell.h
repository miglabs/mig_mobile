//
//  FriendInfoCell.h
//  miglab_mobile
//
//  Created by pig on 13-8-23.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"

@interface FriendInfoCell : UITableViewCell

@property (nonatomic, retain) IBOutlet EGOImageButton *btnAvatar;
@property (nonatomic, retain) IBOutlet UILabel *lblNickName;
@property (nonatomic, retain) IBOutlet UILabel *lblUserInfo;
@property (nonatomic, retain) IBOutlet UIImageView *genderImageView;
@property (nonatomic, retain) IBOutlet UIImageView *userSourceImageView;
@property (nonatomic, retain) NearbyUser* userinfo;
@property (nonatomic, retain) Song*       song;
@property (nonatomic, retain) PoiInfo*    poi;

-(void)updateFriendInfoCellData:(MessageInfo*)user;

@end
