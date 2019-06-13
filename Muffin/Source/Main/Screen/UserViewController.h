//
//  UserViewController.h
//  Muffin
//
//  Created by escdream on 2018. 8. 25..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "EDBaseViewController.h"
#import "EDRoundView.h"

@interface UserViewController : EDBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *txtID;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtNick;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtImageId;
@property (weak, nonatomic) IBOutlet EDRoundView *viewLog;
@property (weak, nonatomic) IBOutlet UITextView *txtLog;
@end
