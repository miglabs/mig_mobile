//
//  MessageInfoCell.h
//  miglab_mobile
//
//  Created by pig on 13-8-25.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"

@interface MessageInfoCell : UITableViewCell

@property (nonatomic, retain) IBOutlet EGOImageButton *btnAvatar;
@property (nonatomic, retain) IBOutlet UILabel *lblMessageType;
@property (nonatomic, retain) IBOutlet UILabel *lblContent;

@end
