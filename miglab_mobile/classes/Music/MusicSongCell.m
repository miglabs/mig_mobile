//
//  MusicSongCell.m
//  miglab_mobile
//
//  Created by pig on 13-8-20.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "MusicSongCell.h"

@implementation MusicSongCell

@synthesize btnIcon = _btnIcon;
@synthesize lblSongName = _lblSongName;
@synthesize lblSongArtistAndDesc = _lblSongArtistAndDesc;
@synthesize btnCover = _btnCover;

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

-(void)updateMusicSongCellData:(Song*)song{
    _btnIcon.tag = song.songid;
    _lblSongName.text = song.songname;
    _lblSongName.font = [UIFont fontOfApp:15.0f];
    
    NSString *tempartist = song.artist ? song.artist : @"未知演唱者";
    //取消缓存机制暂时填充专辑名
    //NSString *songDesc = @"未缓存";
    NSString *songDesc = song.album ? song.album : @"未知专辑";
    /*long long filesize = [[SongDownloadManager GetInstance] getSongLocalSize:tempsong];
    if (filesize > 0) {
        songDesc = [NSString stringWithFormat:@"%.2fMB", (float)filesize / 1000000];
    }*/
    _btnCover.placeholderImage = [UIImage imageNamed:LOCAL_DEFAULT_HEADER_IMAGE];
    [_btnCover setImageURL:[NSURL URLWithString:song.coverurl]];
    _btnCover.layer.cornerRadius = _btnCover.frame.size.width / 2;
    _btnCover.layer.masksToBounds = YES;
    _btnCover.layer.borderWidth = AVATAR_BORDER_WIDTH;
    _btnCover.layer.borderColor = AVATAR_BORDER_COLOR;
    
    _lblSongArtistAndDesc.text = [NSString stringWithFormat:@"%@ | %@", tempartist, songDesc];
    _lblSongArtistAndDesc.font = [UIFont fontOfApp:10.0f];

}

@end
