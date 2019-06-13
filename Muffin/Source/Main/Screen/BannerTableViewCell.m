//
//  BannerTableViewCell.m
//  Muffin
//
//  Created by escdream on 2018. 11. 10..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "BannerTableViewCell.h"
#import "ResourceManager.h"

@implementation BannerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    UIView * bg = [[UIView alloc] initWithFrame:_viewBottom.bounds];
    bg.backgroundColor = [UIColor blackColor];
    bg.alpha = 0.5;
    bg.tag = 1000;
    
    [_viewBottom addSubview:bg];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setBannerImage:(NSString *) imageName
{
    _imgBanner.image = [UIImage imageNamed:imageName];
}

- (void) setPoint:(int) nPoint
{
    _lbPoint.text = [NSString stringWithFormat:@"+%d", nPoint];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    CGRect r= self.bounds;
    
    r.size.height -= 15;
    _imgBanner.frame = r;
    _viewClient.frame = r;
    
    r.origin.y = r.size.height - _viewBottom.frame.size.height;
    r.size.height = _viewBottom.frame.size.height;
    _viewBottom.frame = r;
    
    UIView * bg = [_viewBottom viewWithTag:1000];
    bg.frame = _viewBottom.bounds;
    [_viewBottom sendSubviewToBack:bg];
    
    
}

@end
