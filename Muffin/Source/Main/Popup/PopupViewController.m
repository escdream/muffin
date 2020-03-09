//
//  PopupViewController.m
//  Muffin
//
//  Created by escdream on 2018. 8. 24..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "PopupViewController.h"
#import "SystemUtil.h"
#import "CommonUtil.h"

@interface PopupViewController ()

@end

@implementation PopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self adjustSizeLayout];
    
    
    // 클릭시 키보드를 내리게 한다.
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(handleTap:)];
    [singleTapRecognizer setDelegate:self];
    singleTapRecognizer.numberOfTapsRequired = 1;
    singleTapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleTapRecognizer];
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
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
@end
