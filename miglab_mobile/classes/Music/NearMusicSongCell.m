//
//  MusicSongCell.m
//  miglab_mobile
//
//  Created by pig on 13-8-20.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "NearMusicSongCell.h"
#import "MyFriendPersonalPageViewController.h"

@implementation NearMusicSongCell

@synthesize btnIcon = _btnIcon;
@synthesize lblSongName = _lblSongName;
@synthesize lblSongArtistAndDesc = _lblSongArtistAndDesc;
@synthesize btnAvatar = _btnAvatar;
@synthesize imgMsgTips = _imgMsgTips;
@synthesize lblDistance = _lblDistance;
@synthesize lblFrom = _lblFrom;
@synthesize msginfo = _msginfo;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateNearMusicSongCellData:(MessageInfo*)message{
    _msginfo = message;
    Song *tempsong =_msginfo.song;
    PoiInfo * temppoi = _msginfo.poi;
    _btnIcon.tag = tempsong.songid;
    _lblSongName.text = tempsong.songname;
    _lblSongName.font = [UIFont fontOfApp:15.0f];
    
    long distance = _msginfo.poi.distance;
    int favornum = tempsong.commentnum>999?999:tempsong.commentnum;
    NSString* imageurl = _msginfo.userInfo.headurl;
    NSString* szFavor = [NSString stringWithFormat:@"%d", favornum];
    
    if(temppoi!=nil)
        _lblDistance.text = distance<1000?[NSString stringWithFormat:@"%@ | %ldm内", szFavor, distance]:[NSString stringWithFormat:@"%@ |    %ldkm", szFavor, distance / 1000];
    else
        _lblDistance.text = [NSString stringWithFormat:@"%@ | %@", szFavor, MIGTIP_UNKOWN_DISTANCE];
;
    
    _lblDistance.textAlignment = UITextAlignmentRight;
    
    CGSize distancesize = [_lblDistance.text sizeWithFont:_lblDistance.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    CGRect distanceRect = _lblDistance.frame;
    CGRect tipRect = _imgMsgTips.frame;
    tipRect.origin.x = distanceRect.origin.x + distanceRect.size.width - distancesize.width - 5 -tipRect.size.width;
    _imgMsgTips.frame = tipRect;
    _btnAvatar.placeholderImage = [UIImage imageNamed:LOCAL_DEFAULT_HEADER_IMAGE];
    [_btnAvatar setImageURL:[NSURL URLWithString:imageurl]];
    _btnAvatar.layer.cornerRadius = _btnAvatar.frame.size.width / 2;
    _btnAvatar.layer.masksToBounds = YES;
    _btnAvatar.layer.borderWidth = AVATAR_BORDER_WIDTH;
    _btnAvatar.layer.borderColor = AVATAR_BORDER_COLOR;

    [_btnAvatar addTarget:self action:@selector(checkNearMusicUserInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSString *tempartist = tempsong.artist ? tempsong.artist : @"未知演唱者";
    //取消缓存机制暂时填充专辑名
    //NSString *songDesc = @"未缓存";
    NSString *songDesc = tempsong.album ? tempsong.album : @"未知专辑";
    /*long long filesize = [[SongDownloadManager GetInstance] getSongLocalSize:tempsong];
    if (filesize > 0) {
        songDesc = [NSString stringWithFormat:@"%.2fMB", (float)filesize / 1000000];
    }*/
    _lblSongArtistAndDesc.text = [NSString stringWithFormat:@"%@ | %@", tempartist, songDesc];
    _lblSongArtistAndDesc.font = [UIFont fontOfApp:10.0f];
    
}

-(IBAction)checkNearMusicUserInfo:(id)sender{
    if (sender == _btnAvatar) {
        NearbyUser* user = _msginfo.userInfo;
        user.distance = _msginfo.poi.distance;
        //MessageInfo* msg = _msginfo;
        if (user) {
            MyFriendPersonalPageViewController *personalPageViewController = [[MyFriendPersonalPageViewController alloc] initWithNibName:@"MyFriendPersonalPageViewController" bundle:nil];
            personalPageViewController.userinfo = user;
            personalPageViewController.isFriend = NO;
            [self.topViewcontroller.navigationController pushViewController:personalPageViewController animated:YES];
        }
    }
}

@end
