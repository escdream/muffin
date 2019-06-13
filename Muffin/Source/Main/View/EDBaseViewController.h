//
//  EDBaseViewController.h
//  Muffin
//
//  Created by escdream on 2018. 8. 25..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+LGSideMenuController.h"

@interface EDBaseViewController : UIViewController
@property (strong, nonatomic) UIImageView *bacgroundImage;
- (void) adjustSizeLayout;

@property (nonatomic, assign) BOOL showTitleLogo;
@property (nonatomic, assign) BOOL showPlayer;
@property (nonatomic, assign) BOOL showBack;



- (void) setTitleText:(NSString *) sTitle;



@end
