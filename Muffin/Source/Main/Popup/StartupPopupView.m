//
//  StartupPopupView.m
//  Muffin
//
//  Created by escdream on 2018. 10. 2..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "StartupPopupView.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "UserInfo.h"
#import "CommonUtil.h"
#import "SystemUtil.h"

@interface StartupPopupView ()

@end

@implementation StartupPopupView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] initWithFrame:CGRectMake(80, 600, 214, 30)];
    loginButton.readPermissions = @[@"public_profile", @"email"];
    
    [self.view addSubview:loginButton];
    
    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    [[NSNotificationCenter defaultCenter] addObserverForName:FBSDKProfileDidChangeNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:
     ^(NSNotification *notification) {
         if ([FBSDKProfile currentProfile]) {
             
             FBSDKProfilePictureView *profilePictureView = [[FBSDKProfilePictureView alloc] init];
             profilePictureView.frame = CGRectMake(0,0,100,100);
             profilePictureView.profileID = [[FBSDKAccessToken currentAccessToken] userID];
             //             [self.view addSubview:profilePictureView];
             
             
             
             UIImage *image = nil;
             
             for (NSObject *obj in [profilePictureView subviews]) {
                 if ([obj isMemberOfClass:[UIImageView class]]) {
                     UIImageView *objImg = (UIImageView *)obj;
                     image = objImg.image;
                     break;
                 }
             }
             
             [UserInfo instance].faceBookImage = [image copy];
             [UserInfo instance].userImage = [image copy];
             [UserInfo instance].userEmail = [profilePictureView.profileID copy];
             [UserInfo instance].faceBookEmail = [profilePictureView.profileID copy];
             
             // Update for new user profile
         }
     }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:FBSDKAccessTokenDidChangeNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:
     ^(NSNotification *notification) {
         if (notification.userInfo[FBSDKAccessTokenDidChangeUserID]) {
             // Handle user change
         }
     }];
    
    
    if ([[SystemUtil instance] isIPhoneX] )
    {
        CGRect ar = [CommonUtil getWindowArea];
        
        ar.size.height += ar.origin.y + 90 + 60;
        ar.origin.y = 0;
        _imgBackground.bounds = ar;
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onFacebookSign:(id)sender {

}
- (IBAction)onCloseClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
