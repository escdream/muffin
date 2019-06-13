//
//  UserViewController.m
//  Muffin
//
//  Created by escdream on 2018. 8. 25..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "UserViewController.h"
#import "UserListViewController.h"
#import "TOHeaderImageView.h"

@interface UserViewController ()

@property (nonatomic, strong) TOHeaderImageView *headerView;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.leftBarButtonItem = nil;//[[UIBarButtonItem alloc] initWithTitle:@"Left"
                                                //                             style:UIBarButtonItemStylePlain
                                                //                            target:self
                                                //                            action:@selector(showLeftView)];
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    // Set up the header view
    self.headerView = [[TOHeaderImageView alloc] initWithImage:[UIImage imageNamed:@"imageRoot.png"] height:200.0f];
    self.headerView.shadowHidden = NO;
//    self.tableView.tableHeaderView = self.headerView;
    
//    self.bacgroundImage = self.headerView;
    
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
- (IBAction)onButtonClick:(id)sender {
    
    UserViewController * control = [[UserViewController alloc] initWithNibName:@"UserViewController" bundle:nil];
    
    [self.navigationController pushViewController:control animated:YES];
    
    
    
}
- (IBAction)onUserinfoClick:(id)sender {
    
    [self setEditing:FALSE];
    
    NSMutableDictionary * dicParam = [[NSMutableDictionary alloc] init];
    dicParam[@"UserId"] = _txtID.text;
    
    [[EDHttpTransManager instance] processUserInfo:@"UserInfo_Select"  dicParam:dicParam withBlack:^(id result, NSError * error)
     {
         if (result != nil)
         {
             
             NSArray * arrData = result;
             
             if (arrData.count == 1)
             {
                 _txtName.text = result[0][@"UserName"];
                 _txtNick.text = result[0][@"NickName"];
                 _txtImageId.text = result[0][@"ImageId"];
                 _txtPassword.text = result[0][@"PPassword"];
             }
             else
             {
                 NSString * sLog = [NSString stringWithFormat:@"%@", result];
                 _viewLog.hidden = NO;
                 _txtLog.text = sLog;
             }
             NSLog(@"result = %@", result);
         }
         
     }];
}
- (IBAction)logviewClose:(id)sender {
    _viewLog.hidden = YES;
}
- (IBAction)onUserListClick:(id)sender {
    
    UserListViewController * control = [[UserListViewController alloc] initWithNibName:@"UserListViewController" bundle:nil];
    
    [self.navigationController pushViewController:control animated:YES];
    
//    retrun 0;
//    
//    [[EDHttpTransManager instance] callLoginInfo:@"" withBlack:^(id result, NSError * error)
//     {
//         if (result != nil)
//         {
//             NSString * sLog = [NSString stringWithFormat:@"%@", result];
//             
//             _viewLog.hidden = NO;
//             _txtLog.text = sLog;
//             
//             NSLog(@"result = %@", result);
//         }
//         
//     }];
}
- (IBAction)onUserUpdateClick:(id)sender {
    [self setEditing:FALSE];
    
    NSMutableDictionary * dicParam = [[NSMutableDictionary alloc] init];
    dicParam[@"UserId"]     = _txtID.text;
    dicParam[@"UserName"]   = _txtName.text;
    dicParam[@"NickName"]   = _txtNick.text;
    dicParam[@"ImageId"]    = _txtImageId.text;
    dicParam[@"PPassword"]  = _txtPassword.text;
    
    [[EDHttpTransManager instance] processUserInfo:@"UserInfo_Update"  dicParam:dicParam withBlack:^(id result, NSError * error)
     {
         if (result != nil)
         {
             
             NSArray * arrData = result;
             
             if (arrData.count == 1)
             {

             }
             else
             {
                 NSString * sLog = [NSString stringWithFormat:@"%@", result];
                 _viewLog.hidden = NO;
                 _txtLog.text = sLog;
             }
             NSLog(@"result = %@", result);
         }
         
     }];
}

- (IBAction)onCloseClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onUserInsertClick:(id)sender {
    [self setEditing:FALSE];
    
    NSMutableDictionary * dicParam = [[NSMutableDictionary alloc] init];
    dicParam[@"UserId"]     = _txtID.text;
    dicParam[@"UserName"]   = _txtName.text;
    dicParam[@"NickName"]   = _txtNick.text;
    dicParam[@"ImageId"]    = _txtImageId.text;
    dicParam[@"PPassword"]  = _txtPassword.text;
    
    [[EDHttpTransManager instance] processUserInfo:@"UserInfo_Insert"  dicParam:dicParam withBlack:^(id result, NSError * error)
     {
         if (result != nil)
         {
             NSArray * arrData = result;
             
             if (arrData.count == 1)
             {
                 
             }
             else
             {
                 NSString * sLog = [NSString stringWithFormat:@"%@", result];
                 _viewLog.hidden = NO;
                 _txtLog.text = sLog;
             }
             NSLog(@"result = %@", result);
         }
         
     }];
}
- (IBAction)onUserDeleteClick:(id)sender {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:url];
}

@end
