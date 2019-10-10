//
//  MFAudioPlayerController.h
//  Muffin
//
//  Created by JoonHo Kang on 27/06/2019.
//  Copyright © 2019 ESCapeDREAM. All rights reserved.
//

#import "PopupViewController.h"
#import "SongInfo.h"
#import "EDRoundView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFAudioPlayerController : PopupViewController
{
    NSMutableArray * arrPlayList;
}

@property (weak, nonatomic) IBOutlet UILabel *lbGroup;
@property (weak, nonatomic) IBOutlet UILabel *lgSongName;
@property (weak, nonatomic) IBOutlet UIImageView *imgGroup;
@property (nonatomic, strong) SongInfo * songInfo;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) int viewType; // 1: song 2 : 가사
@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (weak, nonatomic) IBOutlet UIView *viewMeter;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIButton *btnStop;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnPrev;
@property (weak, nonatomic) IBOutlet UIButton *btnPlayList;
@property (weak, nonatomic) IBOutlet UILabel *lbTimer;
@property (weak, nonatomic) IBOutlet UIProgressView *progres1;
@property (weak, nonatomic) IBOutlet UIProgressView *progres2;
@property (weak, nonatomic) IBOutlet UITextView *txtLyrics;
@property (weak, nonatomic) IBOutlet EDRoundView *viewImgParent;
@property (weak, nonatomic) IBOutlet EDRoundView *viewImgMain;
@property (weak, nonatomic) IBOutlet EDRoundView *viewControlParent;
@property (nonatomic, assign) BOOL isEditable;
@property (weak, nonatomic) IBOutlet UIButton *btnSaveLyrics;

- (void) setPlayList:(id) object;




@end

NS_ASSUME_NONNULL_END
