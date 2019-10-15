//
//  MFAudioPlayerController.m
//  Muffin
//
//  Created by JoonHo Kang on 27/06/2019.
//  Copyright © 2019 ESCapeDREAM. All rights reserved.
//

#import "MFAudioPlayerController.h"
#import "STKAudioPlayer.h"
#import "AudioPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioUtil.h"
#import "SampleQueueId.h"
#import "EDSpectrumView.h"
#import "Muffin-Swift.h"
#import "UIView+Toast.h"

@interface MFAudioPlayerController ()
{
    NSTimer * tmrDuration;
    EDSpectrumView * meterView;
    int songIndex;
}

@end

@implementation MFAudioPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    meterView = [[EDSpectrumView alloc] initWithCount:25];

    meterView.frame = _viewMeter.bounds;

    [_viewMeter addSubview:meterView];
    
    _progres1.transform = CGAffineTransformMakeScale(1.0, 2.5);
    _progres2.transform = CGAffineTransformMakeScale(1.0, 2.5);
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onCloseClick:(id)sender {
    [self stopSong];
  
    if(![_songInfo.songWord isEqualToString:_txtLyrics.text])
        [self doSongInfoUpdateWords];

    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onSaveLyricsClick:(id)sender {
    
    
    if (_txtLyrics.editable)
    {
        if(![_songInfo.songWord isEqualToString:_txtLyrics.text])
        {
            
            [self doSongInfoUpdateWords];
            _txtLyrics.editable = NO;
            [_btnSaveLyrics setTitle:@"편집" forState:UIControlStateNormal];
        }
    }
    else
    {
        _txtLyrics.editable = YES;
        [_btnSaveLyrics setTitle:@"저장" forState:UIControlStateNormal];
    }
}

- (void) setSongInfo:(SongInfo *)songInfo
{
    _songInfo = songInfo;
    
    
    _viewType = 1;
    
    if (_songInfo.songType != nil && ([_songInfo.songType intValue] == 2))
        _viewType = 2;
    
    _imgGroup.image = [UIImage imageNamed:@"user_pho_smp_01.png"];
    

    _slider.value = 0;
    _slider.minimumValue = 0;
    _slider.maximumValue = 0;
    
    _lbGroup.text = _songInfo.groupName;
    _lgSongName.text = _songInfo.songName;
    
    
    _progres1.progress = 0.0;
    _progres2.progress = 0.0;
    
//    _btnNext.enabled = NO;
//    _btnPrev.enabled = NO;
//    _btnPlayList.enabled = NO;
    [self updateButtonState];
    
    _txtLyrics.editable = NO;
    _txtLyrics.hidden = YES;
    if (_songInfo.songWord != nil)
        _txtLyrics.text = _songInfo.songWord;
    else
        _txtLyrics.text = @"";
    _btnSaveLyrics.hidden = NO;
    
    if (_viewType == 2) // 가사모드
    {
        _txtLyrics.editable = YES;
        
        _slider.hidden = YES;
        _btnNext.hidden = YES;
        _btnPrev.hidden = YES;
        _btnPlay.hidden = YES;
        _btnPlayList.hidden = YES;
        _btnStop.hidden = YES;
        _progres1.hidden = YES;
        _progres2.hidden = YES;
        
        _txtLyrics.editable = NO;
        _txtLyrics.hidden = NO;
        _txtLyrics.layer.shadowColor = [UIColor whiteColor].CGColor;
        _txtLyrics.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
        _txtLyrics.layer.shadowOpacity = 1.0f;
        _txtLyrics.layer.shadowRadius = 1.0f;
        
        
        CGRect r = _viewImgParent.frame;
        
        r.size.height = 490;
        

        _viewImgParent.frame = r;
        _viewImgMain.frame = _viewImgParent.bounds;
        _imgGroup.frame = _viewImgParent.bounds;
        _txtLyrics.frame = _viewImgParent.bounds;

        if (@available(iOS 10.0, *)) {
            UIView * blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular]];
            blurView.frame = _imgGroup.bounds;
            [_imgGroup addSubview:blurView];
        } else {
            // Fallback on earlier versions
        }

    }
}


- (void) playSong
{
    SongInfo * muffinInfo = _songInfo;
    if(muffinInfo != nil)
    {
//        STKAudioPlayerStatePlaying = (1 << 1) | STKAudioPlayerStateRunning,
//        STKAudioPlayerStateBuffering = (1 << 2) | STKAudioPlayerStateRunning,
//        STKAudioPlayerStatePaused = (1 << 3) | STKAudioPlayerStateRunning,
//        STKAudioPlayerStateStopped = (1 << 4),

        
        if ([AudioUtil player].state == STKAudioPlayerStatePlaying)
        {
            UIImage *backButtonImage = [UIImage imageNamed:@"Play.png"];
            [_btnPlay setImage:backButtonImage forState:UIControlStateNormal];
            
            [[AudioUtil player] pause];
        }
        else if ([AudioUtil player].state == STKAudioPlayerStatePaused)
        {
            UIImage *backButtonImage = [UIImage imageNamed:@"Pause.png"];
            [_btnPlay setImage:backButtonImage forState:UIControlStateNormal];
            [[AudioUtil player] resume];
        }
        else if ([AudioUtil player].state == STKAudioPlayerStateStopped)
        {
            NSString* strFilePath = muffinInfo.musicPath;
            NSString* strFileID = muffinInfo.musicFileID;
            NSString* strMuffinURL = [strFilePath stringByAppendingString:strFileID];
            NSURL* url = [NSURL URLWithString:strMuffinURL];
            
            if (url != nil) {
                UIImage *backButtonImage = [UIImage imageNamed:@"Pause.png"];
                [_btnPlay setImage:backButtonImage forState:UIControlStateNormal];
                
                STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
                [AudioUtil player].meteringEnabled = YES;
                [[AudioUtil player] setDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
                
                _isPlaying = YES;
                
                if  (tmrDuration != nil)
                {
                    [tmrDuration invalidate];
                    tmrDuration = nil;
                }
                
                tmrDuration = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                               target:self
                                                             selector:@selector(onSongDuration)
                                                             userInfo:nil
                                                              repeats:YES]; //10초
            }
            


        }
        [self updateButtonState];
    }
}
- (IBAction)onSlideChange:(id)sender {
    NSLog(@"Slider Changed: %f", _slider.value);
    [[AudioUtil player] seekToTime:_slider.value];
}

-(NSString*) formatTimeFromSeconds:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}


- (void) onSongDuration
{
//    _lbTimer.text = [[AudioUtil player].duration ]
    
    
    if ([AudioUtil player].currentlyPlayingQueueItemId == nil)
    {
        _slider.value = 0;
        _slider.minimumValue = 0;
        _slider.maximumValue = 0;
        _progres1.progress = 0.0;
        _progres2.progress = 0.0;

        _lbTimer.text = @"";
        
        
        if (songIndex < arrPlayList.count-1)
            [self btnNextClick:nil];
        else
            [self stopSong];
        return;
    }
    
    if ([AudioUtil player].duration != 0)
    {
        _slider.minimumValue = 0;
        _slider.maximumValue = [AudioUtil player].duration;
        _slider.value = [AudioUtil player].progress;
        
        _lbTimer.text = [NSString stringWithFormat:@"%@ - %@", [self formatTimeFromSeconds:[AudioUtil player].progress], [self formatTimeFromSeconds:[AudioUtil player].duration]];
        
        
        
        CGFloat f0 = [[AudioUtil player] peakPowerInDecibelsForChannel:0];
        
        /// Reads the average power in decibals for the given channel (0 or 1)
        /// Return values are between -60 (low) and 0 (
        CGFloat f1 = [[AudioUtil player] peakPowerInDecibelsForChannel:1];

        
        _progres1.progress = (f0+60) / 60;
        _progres2.progress = (f1+60) / 60;

        [meterView appendData:(f1+60) / 60];
        
//        _lbTimer.text = [NSString stringWithFormat:@"%@ - %@ (%f-%f)", [self formatTimeFromSeconds:[AudioUtil player].progress], [self formatTimeFromSeconds:[AudioUtil player].duration], f0+60, f1+60];
    }
    else
    {
        _slider.value = 0;
        _slider.minimumValue = 0;
        _slider.maximumValue = 0;
        _progres1.progress = 0.0;
        _progres2.progress = 0.0;

        _lbTimer.text =  [NSString stringWithFormat:@"Live stream %@", [self formatTimeFromSeconds:[AudioUtil player].progress]];
    }
}

- (void) stopSong
{
    UIImage *backButtonImage = [UIImage imageNamed:@"Play.png"];
    [_btnPlay setImage:backButtonImage forState:UIControlStateNormal];
    
    [[AudioUtil player] stop];
    _isPlaying = NO;
    
    _slider.value = 0;
    _slider.minimumValue = 0;
    _slider.maximumValue = 0;
        
    _lbTimer.text = @"";

    _progres1.progress = 0.0;
    _progres2.progress = 0.0;

    [tmrDuration invalidate];
    tmrDuration = nil;
}

- (int) updateSongIndex
{
    songIndex = -1;
    int i = 0;
    for (SongInfo * song in arrPlayList)
    {
        if (song == _songInfo)
        {
            songIndex = i;
            break;
        }
    }
    
    return songIndex;
}




- (IBAction)onPlayClick:(id)sender {
    [self playSong];
}
- (IBAction)onStopClick:(id)sender {
    [self stopSong];
}



- (void) setPlayList:(id) object;
{
    arrPlayList =(NSMutableArray *)object;
    
    [self updateSongIndex];
}

- (IBAction)onPlaylistClick:(id)sender {
    
    
    PlaylistView * sys = [[PlaylistView alloc] init];
    
    sys.delegate = (id)self;
    sys.arrList = arrPlayList;
    sys.currentSong = _songInfo;
    [sys showList:self.view];
    
}

- (void) getPlaylstWithArrList:(NSArray *) arrList nIndex:(int)nIndex
{
    
    [self stopSong];
    SongInfo * song = arrList[nIndex];
    
    self.songInfo = song;
    
    [self performSelector:@selector(playSong) withObject:nil afterDelay:0.3f];

}
- (IBAction)btnPrevClick:(id)sender {
    
    [self stopSong];
    
    songIndex--;
    if (songIndex < 0)
        songIndex = 0;
    
    self.songInfo = arrPlayList[songIndex];
    
    [self performSelector:@selector(playSong) withObject:nil afterDelay:0.3f];
    
}

- (IBAction)btnNextClick:(id)sender {
    [self stopSong];
    
    songIndex++;
    if (arrPlayList.count <= songIndex)
        songIndex = arrPlayList.count-1;
    self.songInfo = arrPlayList[songIndex];
    [self performSelector:@selector(playSong) withObject:nil afterDelay:0.3f];

}


- (void) updateButtonState
{
    _btnPrev.enabled = (songIndex > 0) && (arrPlayList.count > 0);
    _btnNext.enabled = (songIndex < arrPlayList.count-1) && (arrPlayList.count > 0);
}

-(void) doSongInfoUpdateWords
{
    //가사 저장(업데이트)
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    dic[@"Function"] = @"SongInfo_UpdateWords";
    dic[@"SongId"] = _songInfo.songID;
    dic[@"SongWords"] = _txtLyrics.text;
    
    [[EDHttpTransManager instance] callMuffinInfo:dic withBlack:^(id result, NSError * error)
     {
         if (result != nil)
         {
             
         }
         else
         {
             UIWindow *window = UIApplication.sharedApplication.delegate.window;
             [window.rootViewController.view makeToast:@"가사가 저장되었습니다."];
         }
         
     }
     ];
}
@end
