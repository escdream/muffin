//
//  UserInfoViewController.h
//  Muffin
//
//  Created by escdream on 2018. 8. 24..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lbUserName;
@property (weak, nonatomic) IBOutlet UILabel *lbUserEmail;
@property (strong, nonatomic) IBOutlet UIImageView *imgBackground;
@property (strong, nonatomic) IBOutlet UIImageView *imgUser;

@end



