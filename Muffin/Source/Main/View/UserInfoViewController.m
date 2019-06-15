//
//  UserInfoViewController.m
//  Muffin
//
//  Created by escdream on 2018. 8. 24..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UIViewController+LGSideMenuController.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "UserInfo.h"
#import "SearchViewController.h"
#import "ProjectViewController.h"
#import "AudioPlayerViewController.h"
#import "ProjectMakeController.h"
#import "BannerViewController.h"
#import "NavigationController.h"
#import "TONavigationBar.h"
#import "MyMuffinViewController.h"
#import "SystemUtil.h"
#import "CommonUtil.h"


@interface UserInfoViewController ()
{
    UIImageView * backgroundImage;
    
    UINavigationController * mainNavi;
    
    MainViewController *mainViewController;
}

@end

@implementation UserInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton * btn;

    for (int i=401; i<404; i++)
    {
        btn = [self.view viewWithTag:i];
        btn.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0 );
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    
    if ([[SystemUtil instance] isIPhoneX] )
    {
        CGRect ar = [CommonUtil getWindowArea];
        
        ar.size.height += ar.origin.y + 90 + 60;
        ar.size.width = _imgBackground.frame.size.width;
        ar.origin.y = 0;
        _imgBackground.bounds = ar;
    }
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    self.lbUserName.text  = [UserInfo instance].userID;
    self.lbUserEmail.text = [UserInfo instance].userEmail;
    // User 이미지를 읽어올 주소
    NSURL *urlImage = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",
                                                                    [UserInfo instance].userImagePath,
                                                                    [UserInfo instance].userImageID]];
    NSData *dataImage = [NSData dataWithContentsOfURL:urlImage];
    // 데이터가 정상적으로 읽혔는지 확인한다. 네트워크가 연결되지 않았다면 nil이다.
    if(dataImage)
    {
        self.imgUser.image = [UIImage imageWithData:dataImage];
    }
    
    
    backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"m_bg.png"]];
    
    backgroundImage.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    backgroundImage.contentMode = UIViewContentModeScaleAspectFit;
    
//    [self.view addSubview:backgroundImage];
//    [self.view sendSubviewToBack:backgroundImage];
    
    mainViewController = (MainViewController *)self.sideMenuController;
    mainNavi = (UINavigationController *)(mainViewController.rootViewController);

    
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
- (IBAction)onClick:(id)sender {
    [self hideMenus];
//
//    [[EDHttpTransManager instance] callLoginInfo:@"" withBlack:^(id result, NSError * error)
//     {
//         if (result != nil)
//         {
//             NSLog(@"result = %@", result);
//         }
//
//     }];
}


- (void) hideMenus
{
    [mainViewController hideLeftViewAnimated];
    [mainViewController hideRightViewAnimated];
//    [mainNavi  popToRootViewControllerAnimated:NO];
}

- (void) openController:(UIViewController *) controller
{
    [mainNavi  popToRootViewControllerAnimated:NO];
    [mainNavi pushViewController:controller animated:YES];

}

- (void) goHome
{
    [self hideMenus];
    [mainNavi  popToRootViewControllerAnimated:NO];
}

- (void) goSearchView
{
    [self hideMenus];

    SearchViewController * controler = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    controler.viewType = @"SearchMuffin";

    [self openController:controler];
}


- (void) goProjectView
{
    [self hideMenus];
    
//    ProjectViewController * controler = [[ProjectViewController alloc] initWithNibName:@"ProjectViewController" bundle:nil];
    SearchViewController * controler = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    controler.viewType = @"MuffinProject";
    
    [self openController:controler];
}

- (void) goPlayMuffin
{
    [self hideMenus];

    AudioPlayerViewController * controler = [[AudioPlayerViewController alloc] initWithNibName:@"AudioPlayerViewController" bundle:nil];
    
    [self openController:controler];
}

- (void) goProjectMake
{
    [self hideMenus];

    ProjectMakeController * viewController =  [[ProjectMakeController alloc] initWithNibName:@"ProjectMakeController" bundle:nil];
    
//    NavigationController *navigationController = [[NavigationController alloc]  initWithNavigationBarClass:[TONavigationBar class] toolbarClass:nil];
//
//    [navigationController pushViewController:viewController animated:NO];

    [self openController:viewController];

    
}

- (void) goBannerView
{
    [self hideMenus];
    
    BannerViewController * controler = [[BannerViewController alloc] initWithNibName:@"BannerViewController" bundle:nil];
    
    [self openController:controler];
}

- (void) goMyMuffin
{
    [self hideMenus];
    
    
    MyMuffinViewController * controler = [[MyMuffinViewController alloc] initWithNibName:@"MyMuffinViewController" bundle:nil];
    
    [self openController:controler];
}

- (IBAction)onMenuClick:(id)sender {
    
    UIButton * btn = sender;
    
    switch (btn.tag) {
        case 100: [self goHome];
            break;
        case 101:
            break;

        case 201: [self goPlayMuffin];
            break;
        case 202: [self goSearchView];
            break;

        case 301: [self goProjectView];
            break;
        case 302: [self goProjectMake];
            break;

        case 401: [self goMyMuffin];
            break;
        case 402:
            break;
        case 403:
            break;

        case 501: [self goBannerView];
            break;

        default:
            break;
    }
    
    
    if (btn.tag == 100) // home
    {
        
        
        
        
    }
}

@end
