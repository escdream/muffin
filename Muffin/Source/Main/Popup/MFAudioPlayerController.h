//
//  MFAudioPlayerController.h
//  Muffin
//
//  Created by JoonHo Kang on 27/06/2019.
//  Copyright © 2019 ESCapeDREAM. All rights reserved.
//

#import "PopupViewController.h"
#import "SongInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFAudioPlayerController : PopupViewController

@property (nonatomic, strong) SongInfo * songInfo;
@end

NS_ASSUME_NONNULL_END
