//
//  SongTableViewCell.m
//  Muffin
//
//  Created by JoonHo Kang on 26/06/2019.
//  Copyright © 2019 ESCapeDREAM. All rights reserved.
//

#import "SongTableViewCell.h"
#import "STKAudioPlayer.h"
#import "AudioPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioUtil.h"
#import "SampleQueueId.h"

@implementation SongTableViewCell
{
    UIButton * btnPlay;
    UIButton * btnFavorite;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
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
//    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.textLabel.font = [UIFont systemFontOfSize:10];
    self.textLabel.textColor = [UIColor purpleColor]; //RGB(33, 33, 33);
    self.detailTextLabel.font = [UIFont systemFontOfSize:12];
    self.detailTextLabel.textColor = [UIColor blackColor]; //RGB(33, 33, 33);
    
    
    //make PlayButton
    btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect r = self.bounds;
    r.origin.x = r.size.width - 40;
    r.origin.y = 2;
    r.size.width = 60;
    r.size.height = 40;
    
    btnPlay.frame = r;
    
    btnPlay.imageEdgeInsets = UIEdgeInsetsMake(7.5, 40, 7.5, 00);
    
    UIImage *backButtonImage = [UIImage imageNamed:@"btn_s_play.png"];
    [btnPlay setImage:backButtonImage forState:UIControlStateNormal];
    [btnPlay addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];//
    btnPlay.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btnPlay.tag = 0;
    
    //        self.accessoryView = btnPlay;
    //self.textLabel.text = song.groupName;
    //self.detailTextLabel.text = song.song
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self addSubview:btnPlay];
    
    
    //make PlayButton
    btnFavorite = [UIButton buttonWithType:UIButtonTypeCustom];
    
    r.origin.x -= 70;
    r.origin.y = 2;
    r.size.width = 60;
    r.size.height = 40;
    
    btnFavorite.frame = r;
    
    btnFavorite.imageEdgeInsets = UIEdgeInsetsMake(7.5, 40, 7.5, 00);
    
    backButtonImage = [UIImage imageNamed:@"btn_s_play.png"];
    [btnFavorite setImage:backButtonImage forState:UIControlStateNormal];
    [btnFavorite addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];//
    btnFavorite.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btnFavorite.tag = 0;
    
    
    [self addSubview:btnFavorite];

    ;
}


- (void) playSong
{
    SongInfo * muffinInfo = _songInfo;
    if(muffinInfo != nil)
    {
        
        NSString* strFilePath = muffinInfo.musicPath;
        NSString* strFileID = muffinInfo.musicFileID;
        NSString* strMuffinURL = [strFilePath stringByAppendingString:strFileID];
        NSURL* url = [NSURL URLWithString:strMuffinURL];
        
        if (url != nil) {
            UIImage *backButtonImage = [UIImage imageNamed:@"btn_on.png"];
            [btnPlay setImage:backButtonImage forState:UIControlStateNormal];
           
            STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
            [[AudioUtil player] setDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
            
            _isPlaying = YES;
            
        }
    }
}

- (void) stopSong
{
    UIImage *backButtonImage = [UIImage imageNamed:@"btn_s_play.png"];
    [btnPlay setImage:backButtonImage forState:UIControlStateNormal];
    
    [[AudioUtil player] stop];
    _isPlaying = NO;

}

- (void) play
{
    if (_isPlaying == NO)
    {
        SongInfo * muffinInfo = _songInfo;
        if(muffinInfo != nil)
        {
            NSString* strFilePath = muffinInfo.musicPath;
            NSString* strFileID = muffinInfo.musicFileID;
            NSString* strMuffinURL = [strFilePath stringByAppendingString:strFileID];
            NSURL* url = [NSURL URLWithString:strMuffinURL];
            
            if (url != nil) {
                UIImage *backButtonImage = [UIImage imageNamed:@"btn_on.png"];
                [btnPlay setImage:backButtonImage forState:UIControlStateNormal];
                if (_delegate)
                {
                    if ([_delegate respondsToSelector:@selector(onSongPlayInfo:songInfo:isPlaying:)])
                    {
                        [_delegate onSongPlayInfo:self songInfo:self.songInfo isPlaying:YES];
                    }
                }
            }
        }
    }
    else
    {
        [self stop];
    }
}

- (void) stop
{
    if (_delegate)
    {
        if ([_delegate respondsToSelector:@selector(onSongPlayInfo:songInfo:isPlaying:)])
        {
            [_delegate onSongPlayInfo:self songInfo:self.songInfo isPlaying:NO];
        }
    }
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

- (void) setShowFavorite:(BOOL)showFavorite
{
    _showFavorite = showFavorite;
    
    if (showFavorite)
    {
        btnFavorite.hidden = NO;
    }
    else
    {
        btnFavorite.hidden = YES;
    }
}

@end
