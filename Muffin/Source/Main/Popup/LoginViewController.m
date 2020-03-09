//
//  LoginViewController.m
//  Muffin
//
//  Created by escdream on 2018. 8. 24..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "LoginViewController.h"
#import "NavigationController.h"
#import "MainViewController.h"
#import "LGAlertView.h"
#import "UserInfo.h"
#import "StartupPopupView.h"
#import "UserViewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "CommonUtil.h"
#import "SystemUtil.h"

@interface LoginViewController ()
{
    BOOL m_bKeyboardShow;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 노티피케이션 등록.
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] initWithFrame:CGRectMake(80, 600, 214, 30)];
    loginButton.readPermissions = @[@"public_profile", @"email"];
    
    // [self.view addSubview:loginButton];
    
    
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

- (void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [nc removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [nc removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [nc removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void) doUserLoginCheck
{
    [self setEditing:FALSE];
    
 
    
    NSMutableDictionary * dicParam = [[NSMutableDictionary alloc] init];
    dicParam[@"UserId"] = _txtID.text;
    
    [[EDHttpTransManager instance] processUserInfo:@"UserInfo_Select"  dicParam:dicParam withBlack:^(id result, NSError * error)
     {
         if (result != nil)
         {
             
             BOOL isError = NO;
             NSArray * arrData = result;
             
             if (arrData.count == 1)
             {
                 
                 // 사용자가 맞으면...
                 if ([[result[0][@"PPassword"] trim] isEqualToString:_txtPwd.text])
                 {
                     UserInfo * user = [UserInfo instance];
                     
                     user.userID = [_txtID.text copy];
                     user.userPW = [_txtPwd.text copy];
                     user.userName = [result[0][@"UserName"] copy];
                     user.userNickName = [result[0][@"NickName"] copy];
                     user.userSex = [result[0][@"Sex"] copy];
                     user.userImagePath = [result[0][@"ImagePath"] copy];
                     user.userImageID = [result[0][@"ImageId"] copy];
                     user.userEmail = [result[0][@"Email"] copy];
                     user.userLevel = 0;
                     user.userLoginState = UserInfoStateNormal;
                     
                     [self dismissViewControllerAnimated:YES completion:nil];
                 }
                 else{
                     isError = YES;
                 }
             }
             else
             {
                 isError = YES;
                 NSString * sLog = [NSString stringWithFormat:@"%@", result];
             }
             
             if (isError)
             {
                 [[[LGAlertView alloc] initWithTitle:@"안내"
                                             message:@"ID 또는 Password 가 맞지 않습니다."
                                               style:LGAlertViewStyleAlert
                                        buttonTitles:nil
                                   cancelButtonTitle:@"확인"
                              destructiveButtonTitle:nil
                                            delegate:nil] showAnimated:YES completionHandler:nil];

             }
             NSLog(@"result = %@", result);
         }
         
     }];
}
- (IBAction)OnSignUp:(id)sender {
    
    UserViewController * controler = [[UserViewController alloc] initWithNibName:@"UserViewController" bundle:nil];
    controler.modalPresentationStyle = UIModalPresentationFullScreen;// modalPresentationStyle

    [self presentViewController:controler animated:YES  completion:nil];
//    [self.navigationController pushViewController:controler animated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onLoginClick:(id)sender {
//    _txtID.text = _testID.text;
    _txtPwd.text = @"1111";
    
    if ([[_txtID.text trim] isEqualToString:@""] || [[_txtPwd.text trim] isEqualToString:@""])
    {
        [[[LGAlertView alloc] initWithTitle:@"안내"
                                    message:@"ID 또는 Password 를 입력해주세요"
                                      style:LGAlertViewStyleAlert
                               buttonTitles:nil
                          cancelButtonTitle:@"확인"
                     destructiveButtonTitle:nil
                                   delegate:nil] showAnimated:YES completionHandler:nil];
    }
    else
    {
        
        
        [self doUserLoginCheck];
        
        
    }
}

- (IBAction)onCloseClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

+ (void) ShowLoginView:(NSString *) sData animated:(BOOL) animated
{
    LoginViewController * loginView = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    loginView.modalPresentationStyle = UIModalPresentationFullScreen;// modalPresentationStyle

    [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:loginView animated:animated completion:nil];
}





- (void)keyboardWillShow:(NSNotification *)note {
    
    if (m_bKeyboardShow)
    {
        return ;
    }
    m_bKeyboardShow = YES;
    NSDictionary *userInfo = [note userInfo];
    CGRect keyboardRect = [userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    [UIView beginAnimations:@"moveKeyboard" context:nil];
    float height = keyboardRect.size.height-60;
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];

}

- (void)keyboardDidShow:(NSNotification *)note {
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardRect = [userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    [UIView beginAnimations:@"moveKeyboard" context:nil];
    float height = keyboardRect.size.height-60;
    self.view.frame = CGRectMake(self.view.frame.origin.x,         self.view.frame.origin.y + height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    m_bKeyboardShow = NO;
}


- (void)keyboardDidHide:(NSNotification *)notification {
    

    
    //    [[ExceptionManager sharedInstance] removeKeyboardBackgroundView];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    [self onLoginClick:nil];
    
    return YES;
}


-(void)dismissKeyboard:(id)sender
{
     [self.view endEditing:YES];
}

- (IBAction)onFacebookLogin:(id)sender {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login  logInWithReadPermissions: @[@"public_profile"]
            fromViewController:self
            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             
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
             
             [self onLoginClick:nil];
         }
     }];

    
    
//    StartupPopupView * loginView = [[StartupPopupView alloc] initWithNibName:@"StartupPopupView" bundle:nil];
//
//    [self presentViewController:loginView animated:YES  completion:nil];
}



@end
