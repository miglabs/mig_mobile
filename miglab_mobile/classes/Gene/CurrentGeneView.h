//
//  CurrentGeneView.h
//  miglab_mobile
//
//  Created by pig on 13-8-19.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"

@interface CurrentGeneView : UIView

@property (nonatomic, retain) IBOutlet UILabel *lblYear;
@property (nonatomic, retain) IBOutlet UILabel *lblMonthAndDay;
@property (nonatomic, retain) IBOutlet EGOImageButton *egoBtnAvatar;
@property (nonatomic, retain) IBOutlet UILabel *lblTypeDesc;
@property (nonatomic, retain) IBOutlet UILabel *lblMoodDesc;
@property (nonatomic, retain) IBOutlet UILabel *lblSceneDesc;

@end
