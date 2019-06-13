//
//  TagCollectonViewController.h
//  Muffin
//
//  Created by escdream on 2018. 11. 11..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "EDBaseViewController.h"
#import "ZFTokenField.h"
#import "EDRoundButton.h"

@interface TagCollectonViewController : EDBaseViewController<ZFTokenFieldDelegate, ZFTokenFieldDataSource>
@property (strong, nonatomic) IBOutlet UIScrollView *viewScroll;
@property (strong, nonatomic) IBOutlet ZFTokenField *viewJanre;
@property (strong, nonatomic) IBOutlet ZFTokenField *viewAkgi;
@property (strong, nonatomic) IBOutlet ZFTokenField *viewTag;
@property (strong, nonatomic) IBOutlet UIView *viewSongType;
@property (strong, nonatomic) IBOutlet UIButton *btnRadio1;
@property (strong, nonatomic) IBOutlet UIButton *btnRadio2;
@property (strong, nonatomic) IBOutlet EDRoundButton *btnSelect1;
@property (strong, nonatomic) IBOutlet EDRoundButton *btnSelect2;
@property (strong, nonatomic) IBOutlet EDRoundButton *btnSelect3;


@end
