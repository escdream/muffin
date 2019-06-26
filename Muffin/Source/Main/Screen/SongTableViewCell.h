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

@interface SongTableViewCell : UITableViewCell

@property (nonatomic, strong) SongInfo * songInfo;
@end

NS_ASSUME_NONNULL_END
