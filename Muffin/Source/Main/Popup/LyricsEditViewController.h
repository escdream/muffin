//
//  LyricsEditViewController.h
//  Muffin
//
//  Created by escdream on 13/10/2019.
//  Copyright © 2019 ESCapeDREAM. All rights reserved.
//

#import "PopupViewController.h"
#import "SongInfo.h"
#import "EDRoundView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LyricsEditViewController : PopupViewController
@property (weak, nonatomic) IBOutlet EDRoundView *viewImgParent;
@property (weak, nonatomic) IBOutlet EDRoundView *viewImgMain;
@property (weak, nonatomic) IBOutlet UITextView *txtLyrics;
@property (weak, nonatomic) IBOutlet UILabel *lbGroup;
@property (weak, nonatomic) IBOutlet UILabel *lgSongName;
@property (weak, nonatomic) IBOutlet UIImageView *imgGroup;
@property (nonatomic, strong) SongInfo * songInfo;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) int viewType; // 1: song 2 : 가사
@end

NS_ASSUME_NONNULL_END
