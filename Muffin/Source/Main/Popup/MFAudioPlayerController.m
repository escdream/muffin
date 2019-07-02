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

@interface MFAudioPlayerController ()
{
    NSTimer * tmrDuration;
}

@end

@implementation MFAudioPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) setSongInfo:(SongInfo *)songInfo
{
    _songInfo = songInfo;
    
    
    
    _imgGroup.image = [UIImage imageNamed:@"user_pho_smp_01.png"];
    _slider.value = 0;
    _slider.minimumValue = 0;
    _slider.maximumValue = 0;
    
    _lbGroup.text = _songInfo.groupName;
    _lgSongName.text = _songInfo.songName;
    
    
    _progres1.progress = 0.0;
    _progres2.progress = 0.0;
    
    _btnNext.enabled = NO;
    _btnPrev.enabled = NO;
    _btnPlayList.enabled = NO;
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

- (IBAction)onPlayClick:(id)sender {
    [self playSong];
}
- (IBAction)onStopClick:(id)sender {
    [self stopSong];
}


- (void) setPlayList:(id) object;
{
    if (arrPlayList != nil)
    {
        [arrPlayList removeAllObjects];
        arrPlayList = nil;
    }
    
    
    
}


@end
