//
//  MuffinTableViewCell.m
//  Muffin
//
//  Created by escdream on 17/06/2019.
//  Copyright © 2019 ESCapeDREAM. All rights reserved.
//

#import "MuffinTableViewCell.h"

@implementation MuffinTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id) initSongWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        
        _songInfo = nil;
        //make TextLabel
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.textLabel.font = [UIFont systemFontOfSize:10];
        self.textLabel.textColor = [UIColor purpleColor]; //RGB(33, 33, 33);
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
        self.detailTextLabel.textColor = [UIColor blackColor]; //RGB(33, 33, 33);
        
        //make PlayButton
        _btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnPlay.frame = CGRectMake(10, 0, 60, 40);
        _btnPlay.imageEdgeInsets = UIEdgeInsetsMake(7.5, 40, 7.5, 00);
        
        UIImage *backButtonImage = [UIImage imageNamed:@"btn_s_play.png"];
        [_btnPlay setImage:backButtonImage forState:UIControlStateNormal];
        [_btnPlay addTarget:self action:@selector(playMuffin:) forControlEvents:UIControlEventTouchUpInside];//
        _btnPlay.imageView.contentMode = UIViewContentModeScaleAspectFit;
        //_btnPlay.tag = [_songInfo.songID intValue];
        
        self.accessoryView = _btnPlay;
        //self.textLabel.text = song.groupName;
        //self.detailTextLabel.text = song.songName;
    }
    
    return self;
}


- (void) setSongInfo:(SongInfo *)songInfo
{
    _songInfo = songInfo;
    
    _btnPlay.tag = [_songInfo.songID intValue];
    
    self.accessoryView = _btnPlay;
    self.textLabel.text = _songInfo.groupName;
    self.detailTextLabel.text = _songInfo.songName;

    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
