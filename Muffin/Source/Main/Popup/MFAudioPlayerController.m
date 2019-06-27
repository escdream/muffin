//
//  MFAudioPlayerController.m
//  Muffin
//
//  Created by JoonHo Kang on 27/06/2019.
//  Copyright © 2019 ESCapeDREAM. All rights reserved.
//

#import "MFAudioPlayerController.h"

@interface MFAudioPlayerController ()

@end

@implementation MFAudioPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onCloseClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
