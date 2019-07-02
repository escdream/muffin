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
    
    UIImageView * thumbImage;
    NSString * imageName;
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

    self.textLabel.font = [UIFont systemFontOfSize:10];
    self.textLabel.textColor = [UIColor purpleColor]; //RGB(33, 33, 33);
    self.detailTextLabel.font = [UIFont systemFontOfSize:12];
    self.detailTextLabel.textColor = [UIColor blackColor]; //RGB(33, 33, 33);
    
    
    _groupName = [[EDAlignableLabel alloc] init];
    _songName = [[EDAlignableLabel alloc] init];

    _groupName.contentMode = UIViewContentModeBottom;
    _songName.contentMode = UIViewContentModeTop;

    _groupName.font = [UIFont systemFontOfSize:10];
    _groupName.textColor = [UIColor purpleColor]; //RGB(33, 33, 33);
    _songName.font = [UIFont systemFontOfSize:14];
    _songName.textColor = [UIColor blackColor]; //RGB(33, 33, 33);

    thumbImage = [[UIImageView alloc] init];

    
    [self addSubview:_groupName];
    [self addSubview:_songName];
    [self addSubview:thumbImage];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    //make PlayButton
    btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect r = self.bounds;
    r.origin.x = r.size.width - 50;
    r.origin.y = 2;
    r.size.width = 60;
    r.size.height = 40;
    
    btnPlay.frame = r;
    
    btnPlay.imageEdgeInsets = UIEdgeInsetsMake(10, 5, 10, 5);
    
    UIImage *backButtonImage = [UIImage imageNamed:@"btn_s_play.png"];
    [btnPlay setImage:backButtonImage forState:UIControlStateNormal];
    [btnPlay addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];//
    btnPlay.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btnPlay.tag = 0;

    
    [self addSubview:btnPlay];
    
    
    //make PlayButton
//    btnFavorite = [UIButton buttonWithType:UIButtonTypeCustom];
    btnFavorite = [UIButton buttonWithType:UIButtonTypeContactAdd];
    
    r.origin.x -= 60;
    r.origin.y = 2;
    r.size.width = 60;
    r.size.height = 40;
    
    btnFavorite.frame = r;
    
    btnFavorite.imageEdgeInsets = UIEdgeInsetsMake(7.5, 0, 7.5, 00);
    
//    backButtonImage = [UIImage imageNamed:@"btn_star_o.png"];
//    [btnFavorite setImage:backButtonImage forState:UIControlStateNormal];
    [btnFavorite addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];//
    btnFavorite.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btnFavorite.tag = 0;
    
    
    [self addSubview:btnFavorite];

    ;
}

- (void) layoutSubviews
{
    CGRect rect = self.bounds;
    
    CGRect lr = rect;
    
    lr.size.height = rect.size.height / 2;
    lr.origin.x = rect.size.height + 20;
    lr.size.width -= 10;
    _groupName.frame = lr;
    
    
    lr.origin.y = lr.size.height;
    _songName.frame = lr;
    
    
    lr = self.bounds;
    lr.origin.x = 10;
    lr.size.width = lr.size.height;
    
    thumbImage.frame = lr;
    
    CGRect r = self.bounds;
    r.origin.x = r.size.width - 60;
    r.origin.y = 2;
    r.size.width = 60;
    r.size.height = 40;
    
    btnPlay.frame = r;
    
    r.origin.x -= 60;
    r.origin.y = 2;
    r.size.width = 60;
    r.size.height = 40;
    
    btnFavorite.frame = r;
    
}


-(void) getGroupImage//:(UIImageView *) imageView groupID:(NSString *) groupID
{
    if (_songInfo.groupImage != nil)
    {
//        thumbImage.image = _songInfo.groupImage;

        return;
    }
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    
    dic[@"Function"] = @"GroupInfo_Select";
    dic[@"GroupId"] = _songInfo.groupID;
    //    dic[@"UserId"] = [UserInfo instance].userID;
    [[EDHttpTransManager instance] callProjectInfo:dic withBlack:^(id result, NSError * error)
     {
         if (result != nil)
         {
             NSArray * arr = result;
             NSDictionary * dic = arr[0];
             if (dic != nil)
             {
                 // 이미지를 읽어올 주소
                 NSString *imgPath = dic[@"ImagePath"];
                 NSString *imgName = dic[@"ImageId"];
                 
                 NSString * iName = [NSString stringWithFormat:@"%@%@", imgPath, imgName];
                 
                     NSURL *urlImage = [NSURL URLWithString:iName];
                     NSData *dataImage = [NSData dataWithContentsOfURL:urlImage];
                     // 데이터가 정상적으로 읽혔는지 확인한다. 네트워크가 연결되지 않았다면 nil이다.
                     if(dataImage)
                     {
                         thumbImage.image = [UIImage imageWithData:dataImage];
                         _songInfo.groupImage = dataImage;
                     }

             }
         }
     }];
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
    
    _groupName.text = _songInfo.groupName;
    _songName.text = _songInfo.songName;
    
    [self getGroupImage];
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