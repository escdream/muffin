//
//  SongTableViewCell.m
//  Muffin
//
//  Created by JoonHo Kang on 26/06/2019.
//  Copyright © 2019 ESCapeDREAM. All rights reserved.
//

#import "SongTableViewCell.h"

@implementation SongTableViewCell
{
    UIButton * btnPlay;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id) initSongWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        
        [self initLayout];

    }
    
    return self;
}



- (void) initLayout
{
    _songInfo = nil;
    //make TextLabel
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.textLabel.font = [UIFont systemFontOfSize:10];
    self.textLabel.textColor = [UIColor purpleColor]; //RGB(33, 33, 33);
    self.detailTextLabel.font = [UIFont systemFontOfSize:12];
    self.detailTextLabel.textColor = [UIColor blackColor]; //RGB(33, 33, 33);
    
    
    //make PlayButton
    btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPlay.frame = CGRectMake(10, 0, 60, 40);
    btnPlay.imageEdgeInsets = UIEdgeInsetsMake(7.5, 40, 7.5, 00);
    
    UIImage *backButtonImage = [UIImage imageNamed:@"btn_s_play.png"];
    [btnPlay setImage:backButtonImage forState:UIControlStateNormal];
//    [btnPlay addTarget:self action:@selector(playMuffin:) forControlEvents:UIControlEventTouchUpInside];//
    btnPlay.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //_btnPlay.tag = [_songInfo.songID intValue];
    
    //        self.accessoryView = btnPlay;
    //self.textLabel.text = song.groupName;
    //self.detailTextLabel.text = song.song
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self addSubview:btnPlay];
}



- (void) setSongInfo:(SongInfo *)songInfo
{
    _songInfo = songInfo;
    
    self.textLabel.text = _songInfo.groupName;
    self.detailTextLabel.text = _songInfo.songName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
