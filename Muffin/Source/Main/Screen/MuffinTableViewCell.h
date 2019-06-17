//
//  MuffinTableViewCell.h
//  Muffin
//
//  Created by escdream on 17/06/2019.
//  Copyright © 2019 ESCapeDREAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface MuffinTableViewCell : UITableViewCell

@property (nonatomic, strong) SongInfo * songInfo;
@property (nonatomic, strong) UIButton * btnPlay;

@end

NS_ASSUME_NONNULL_END
