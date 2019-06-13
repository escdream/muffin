//
//  BannerTableViewCell.h
//  Muffin
//
//  Created by escdream on 2018. 11. 10..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDRoundView.h"

@interface BannerTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgBanner;
@property (strong, nonatomic) IBOutlet UILabel *lbTitle;
@property (strong, nonatomic) IBOutlet EDRoundView *viewClient;
@property (strong, nonatomic) IBOutlet UILabel *lbPoint;
@property (strong, nonatomic) IBOutlet UIView *viewBottom;
- (void) setBannerImage:(NSString *) imageName;
- (void) setPoint:(int) nPoint;

@end
