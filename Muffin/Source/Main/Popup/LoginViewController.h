//
//  LoginViewController.h
//  Muffin
//
//  Created by escdream on 2018. 8. 24..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "PopupViewController.h"

@interface LoginViewController : PopupViewController
@property (weak, nonatomic) IBOutlet UITextField *txtID;
@property (weak, nonatomic) IBOutlet UITextField *testID;
@property (weak, nonatomic) IBOutlet UITextField *txtPwd;
@property (strong, nonatomic) IBOutlet UIImageView *imgBackground;


+ (void) ShowLoginView:(NSString *) sData animated:(BOOL) animated;
@end
