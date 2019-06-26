//
//  EDBaseViewController.m
//  Muffin
//
//  Created by escdream on 2018. 8. 25..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "EDBaseViewController.h"
#import "SystemUtil.h"
#import "CommonUtil.h"
#import "MainViewController.h"
#import "MainScreenViewController.h"

@interface EDBaseViewController ()
{
    UIButton * mainMenu;
    UIButton * goBack;
    
    UINavigationController * mainNavi;
    MainViewController *mainViewController;
}

@end

@implementation EDBaseViewController



- (void) adjustSizeLayout
{
    
    CGRect ar = [CommonUtil getWindowArea];
    
    
    for (UIView * view in self.view.subviews)
    {
        if (view.tag >= 990000)
        {
            CGRect r = view.frame;
            r.origin.y += (ar.origin.y );
            if ([[SystemUtil instance] isIPhoneX] && view.tag == 999000)
                r.size.height += 90;
            view.frame = r;
            
        }
    }
    [CommonUtil  iosChangeScaleView:self.view  fontSizeFix:1.0];

    
}

- (void) setTitleText:(NSString *) sTitle;
{
    self.title = sTitle;
    UILabel * lb = [[UILabel alloc] init];
    lb.text = sTitle;
    lb.frame = CGRectMake(0, 0, 200, 70);
    lb.textColor =  [UIColor whiteColor];
    self.navigationItem.titleView = lb;
}


- (void) setShowTitleLogo:(BOOL)showLogo
{
    if (showLogo)
    {
        UIImage * logoImage = [UIImage imageNamed:@"muffin_logo_s.png"];
        UIButton * btnLogo = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btnLogo setImage:logoImage forState:UIControlStateNormal];
        
        btnLogo.imageEdgeInsets = UIEdgeInsetsMake(10, 17, 00, 17);
        self.navigationItem.titleView = btnLogo;
    }
    else
    {
        UILabel * lb = [[UILabel alloc] init];
        lb.text = self.title;
        lb.frame = CGRectMake(0, 5, 300, 70);
        lb.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = lb;
        
        

    }
}

- (void) gotoMyMuffin
{

    
    MainScreenViewController * viewController =  [[MainScreenViewController alloc] initWithNibName:@"MainScreenViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    
}


- (void) setShowMyMenu:(BOOL)showMyMenu
{
    if (showMyMenu)
    {

        UIButton * mainMenu = [UIButton buttonWithType:UIButtonTypeCustom];
        mainMenu.frame = CGRectMake(10, 0, 60, 40);
        mainMenu.imageEdgeInsets = UIEdgeInsetsMake(7.5, 40, 7.5, 00);
        UIImage *backButtonImage = [UIImage imageNamed:@"util_icon_login.png"];
        UIImage *backButtonImage_B = [UIImage imageNamed:@"util_icon_login_b.png"];
        [mainMenu setImage:backButtonImage forState:UIControlStateNormal];
        [mainMenu setImage:backButtonImage_B forState:UIControlStateSelected];

        [mainMenu addTarget:self action:@selector(gotoMyMuffin) forControlEvents:UIControlEventTouchUpInside];//

        mainMenu.imageView.contentMode = UIViewContentModeScaleAspectFit;

        UIBarButtonItem * customItem = [[UIBarButtonItem alloc] initWithCustomView:mainMenu];
        
        self.navigationItem.rightBarButtonItem = customItem;

    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void) setShowBack:(BOOL)showBack
{
    goBack.hidden = !showBack;
}


- (void) viewDidAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault]; //UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.shadowImage = [UIImage new];////UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.translucent = YES;
    //self.navigationController.navigationBar.tintColor = [UIColor clearColor];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    self.view.backgroundColor = RGB(242, 242, 242);
    
    
    self.bacgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nor_bg_img.png"]];
    self.bacgroundImage.contentMode = UIViewContentModeScaleToFill;
    self.bacgroundImage.clipsToBounds = YES;
    
    self.bacgroundImage.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.7);
    
    [self.view addSubview:self.bacgroundImage];
    
    [self adjustSizeLayout];

    
    mainMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    mainMenu.frame = CGRectMake(0, 0, 35, 35);
//    mainMenu.imageEdgeInsets = UIEdgeInsetsMake(7.5, 0, 7.5, 40);
    UIImage *backButtonImage = [UIImage imageNamed:@"util_open_menu.png"];
    [mainMenu setImage:backButtonImage forState:UIControlStateNormal];
    
    [mainMenu addTarget:self action:@selector(showLeftView) forControlEvents:UIControlEventTouchUpInside];//
    

    
    goBack = [UIButton buttonWithType:UIButtonTypeCustom];
    goBack.frame = CGRectMake(40, 0, 35, 35);
//    goBack.imageEdgeInsets = UIEdgeInsetsMake(7.5, 0, 7.5, 40);
    UIImage *backImage = [UIImage imageNamed:@"ico_tit_back_n.png"];
    [goBack setImage:backImage forState:UIControlStateNormal];
    
    [goBack addTarget:self action:@selector(goBackClick:) forControlEvents:UIControlEventTouchUpInside];//
    goBack.hidden = YES;
    
    UIView * viewLeft = [[UIView alloc] init];
    viewLeft.frame = CGRectMake(0, 0, 80, 40);
    
    [viewLeft addSubview:mainMenu];
    [viewLeft addSubview:goBack];

    
    UIBarButtonItem * customItem = [[UIBarButtonItem alloc] initWithCustomView:viewLeft];
    self.navigationItem.leftBarButtonItem = customItem;

    
    
    
    //[[UIBarButtonItem alloc] initWithTitle:@""
     //                                                                        style:UIBarButtonItemStylePlain
     //                                                                       target:self
      //                                                                      action:@selector(showLeftView)];
    
    
    
    
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Right"
//                                                                              style:UIBarButtonItemStyleDone
//                                                                             target:self
//                                                                             action:@selector(showRightView)];
    
    UIImage * logoImage = [UIImage imageNamed:@"muffin_logo_s.png"];
    UIButton * btnLogo = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnLogo setImage:logoImage forState:UIControlStateNormal];

    btnLogo.imageEdgeInsets = UIEdgeInsetsMake(5, 17, 5, 17);
    self.navigationItem.titleView = btnLogo;
    
    
    // escdream 2019.06.16 added
    self.showMyMenu = YES;
    mainViewController = (MainViewController *)self.sideMenuController;
    mainNavi = (UINavigationController *)(mainViewController.rootViewController);
    
    [btnLogo addTarget:self action:@selector(goHome:) forControlEvents:UIControlEventTouchUpInside];
    
    self.title = @"";
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onScreenTap:)];
    tap.enabled = YES;
    tap.cancelsTouchesInView = FALSE;
    [self.view addGestureRecognizer:tap];
    
}


- (void) onScreenTap:(UITapGestureRecognizer *) gesture
{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
//    self.bacgroundImage.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.6);//CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
//
//    UIVisualEffect *blurEffect;
//    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *visualEffectView;
//    visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
//    visualEffectView.frame = self.bacgroundImage.frame;
//    [self.bacgroundImage addSubview:visualEffectView];
//
    [self.view sendSubviewToBack:self.bacgroundImage];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint location = [touch locationInView:self.view];
    
    [self.view endEditing:YES];

}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSLog(@"textViewShouldBeginEditing:");
    [[NSNotificationCenter defaultCenter] postNotificationName:NSLocalizedString(@"EDIT_CHANGE_BEGIN" , @"") object:textView];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView;
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:NSLocalizedString(@"EDIT_CHANGE_BEGIN" , @"") object:textView];
}
- (void)textViewDidEndEditing:(UITextView *)textView;
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NSLocalizedString(@"EDIT_CHANGE_END" , @"") object:textView];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NSLocalizedString(@"EDIT_CHANGE_BEGIN" , @"") object:textField];
}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NSLocalizedString(@"EDIT_CHANGE_END" , @"") object:textField];
}



#pragma mark -

- (UIViewController*)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}


- (void)showLeftView {
    [self.sideMenuController showLeftViewAnimated:YES completionHandler:nil];
}

- (void)showRightView {
    [self.sideMenuController showRightViewAnimated:YES completionHandler:nil];
}

- (void) goBackClick:(UIButton *) btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) goHome:(UIButton *) btn
{
    [mainNavi  popToRootViewControllerAnimated:YES];
    
    UIViewController * vc = mainNavi.topViewController;
    
    if ([vc isKindOfClass:[EDBaseViewController class]])
    {
        [(EDBaseViewController*)vc onRefresh];
    }
}

- (void) onRefresh;
{
}


@end
