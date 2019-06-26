//
//  SongTableViewCell.h
//  Muffin
//
//  Created by JoonHo Kang on 26/06/2019.
//  Copyright © 2019 ESCapeDREAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongInfo.h"


NS_ASSUME_NONNULL_BEGIN


@class SongTableViewCell;

@protocol SongTableViewCellDelegate <NSObject>

@optional
- (void) onSongPlayInfo:(SongTableViewCell *)cell songInfo:(SongInfo *) songInfo isPlaying:(BOOL) isPlaying;

@end

@interface SongTableViewCell : UITableViewCell
@property (nonatomic, weak) id<SongTableViewCellDelegate> delegate;
@property (nonatomic, strong) SongInfo * songInfo;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL showFavorite;

- (void) playSong;
- (void) stopSong;
@end

NS_ASSUME_NONNULL_END
