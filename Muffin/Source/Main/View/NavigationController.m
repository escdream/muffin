//
//  NavigationController.m
//  LGSideMenuControllerDemo
//

#import "NavigationController.h"
#import "TONavigationBar.h"
#import "UIViewController+LGSideMenuController.h"

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationBar.translucent = YES;
//    self.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationBar.backgroundColor = [UIColor clearColor];

    UIImage * img = [[UIImage alloc] init];
    
    [self.navigationBar setBackgroundImage:img forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = img;
    
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.modalTransitionStyle   = UIModalTransitionStyleCrossDissolve;
    //catSelection.modalTransitionStyle = .crossDissolve
    
//    UIImageView * imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imageRoot"]];
//
//    imgView.contentMode = UIViewContentModeScaleAspectFill;
//    imgView.clipsToBounds = YES;
//
//    imgView.frame = self.navigationBar.frame;
//    [self.navigationBar addSubview:imgView];
////    [self.navigationBar sendSubviewToBack:imgView];
//
//    UIVisualEffect *blurEffect;
//    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *visualEffectView;
//    visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
//    visualEffectView.frame = imgView.frame;
//    [imgView addSubview:visualEffectView];

}

- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return self.sideMenuController.isRightViewVisible ? UIStatusBarAnimationSlide : UIStatusBarAnimationFade;
}

@end
