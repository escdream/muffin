//
//  BannerItem.h
//  Muffin
//
//  Created by escdream on 2018. 11. 10..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerItem : NSObject
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * contents;
@property (nonatomic, assign) int point;
@property (nonatomic, strong) NSString * imageName;
@end

@interface BannerItemManager : NSObject
@property (nonatomic, strong) NSMutableArray * bannerList;
@end
