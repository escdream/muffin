//
//  LyricsEditViewController.m
//  Muffin
//
//  Created by escdream on 13/10/2019.
//  Copyright © 2019 ESCapeDREAM. All rights reserved.
//

#import "LyricsEditViewController.h"

@interface LyricsEditViewController ()

@end

@implementation LyricsEditViewController

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



- (void) setSongInfo:(SongInfo *)songInfo
{
    _songInfo = songInfo;
    
    
    _viewType = 1;
    
    if (_songInfo.songType != nil && ([_songInfo.songType intValue] == 2))
        _viewType = 2;
    
    _imgGroup.image = [UIImage imageNamed:@"user_pho_smp_01.png"];
    
    
    if (_songInfo.songWord != nil)
        _txtLyrics.text = _songInfo.songWord;
    else
        _txtLyrics.text = @"";
    
    if (_viewType == 2) // 가사모드
    {
        _txtLyrics.editable = YES;
        
        _txtLyrics.hidden = NO;
        _txtLyrics.layer.shadowColor = [UIColor whiteColor].CGColor;
        _txtLyrics.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
        _txtLyrics.layer.shadowOpacity = 1.0f;
        _txtLyrics.layer.shadowRadius = 1.0f;
        
        
        CGRect r = _viewImgParent.frame;
        
        r.size.height = 490;
        
        
        _viewImgParent.frame = r;
        _viewImgMain.frame = _viewImgParent.bounds;
        _imgGroup.frame = _viewImgParent.bounds;
        _txtLyrics.frame = _viewImgParent.bounds;
        
        if (@available(iOS 10.0, *)) {
            UIView * blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular]];
            blurView.frame = _imgGroup.bounds;
            [_imgGroup addSubview:blurView];
        } else {
            // Fallback on earlier versions
        }
        
    }
}


@end
