//
//  MainHotSongPopupViewController.m
//  Muffin
//
//  Created by escdream on 2020/12/09.
//  Copyright © 2020 ESCapeDREAM. All rights reserved.
//

#import "MainHotSongPopupViewController.h"
#import "CommonUtil.h"
#import "ProjectInfo.h"
#import "SongInfo.h"
#import "LoginViewController.h"

#define MAX_IMAGE  3


@interface UIImgView : UIView
@property (nonatomic, strong) UIImageView * imageView;
@end

@implementation UIImgView

- (id) init
{
    self = [super init];
    if (self)
    {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = TRUE;
        
        [self addSubview:_imageView];
    }
    return self;
}

- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGRect r = frame;
    r.size.height += 10;
    _imageView.frame =  self.bounds;
}

@end


@interface MainHotSongPopupViewController ()
{
    NSMutableArray * arrData;
    
    UIImgView * bgImageView[MAX_IMAGE];
    
    int timerIndex;
    NSTimer *timer;
    
    UILabel * lbUser;
    UILabel * lbPoint;
    UIImage *imgPj[MAX_IMAGE];

    UIImageView *imgPjIcon;
    UILabel * lbPrjUser;
    UILabel * lbPrjName;
}


@end

@implementation MainHotSongPopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    arrData = [[NSMutableArray alloc] init];
    timerIndex = 0;
    
    [self InitLayout];
    [self doSearchMuffinProject:@"3" muffinKind:@"99"];
}


- (void) updateUserInfo:(NSMutableDictionary *) dic
{
    self->lbUser.text = dic[@"user"];
    NSString * str = [NSString stringWithFormat:@"Muffin Point : %@", dic[@"point"]];
    NSMutableAttributedString *labelText = [[NSMutableAttributedString alloc] initWithString: str ];
    [labelText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(15,  str.length - 15)];
    self->lbPoint.attributedText = labelText;
    
}

- (void) updateMethod:(NSTimer *)incomingTimer {
    NSLog(@"Inside update method");

    [UIView animateWithDuration:1.0f
        animations:^(void) {
        
        for (int i=0; i<MAX_IMAGE; i++)
        {
            CGRect r = self->bgImageView[i].frame;

            r.origin.x -= r.size.width;
            
            
            if (r.origin.x < -(r.size.width * 1))
            {
                r.origin.x = r.size.width;
                self->bgImageView[i].frame = r;
                self->bgImageView[i].hidden = YES;
            }
            else
                self->bgImageView[i].hidden = NO;

            self->bgImageView[i].frame = r;
            
            
            self->lbUser.alpha = 0;
            self->lbPoint.alpha = 0;
            
            self->imgPjIcon.alpha = 0;
            self->lbPrjName.alpha = 0;
            self->lbPrjUser.alpha = 0;
            
            
        }
        self->timerIndex ++;
        if (self->timerIndex >= MAX_IMAGE)
            self->timerIndex = 0;
        }
     
        completion:^(BOOL finished) {
            
            [self updateUserInfo:self->arrData[self->timerIndex]];
        
            [UIView animateWithDuration:0.3 animations:^(void) {
                self->lbUser.alpha = 1.0f;
                self->lbPoint.alpha = 1.0f;
                
                self->imgPjIcon.alpha = 1.0;
                self->lbPrjName.alpha = 1.0;
                self->lbPrjUser.alpha = 1.0;

            } completion:^(BOOL finished) {
            }];
    }];
}

- (void) setShadowView:(UIView *) view
{
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowRadius = 3.0f;
    view.layer.shadowOffset = CGSizeMake(2, 2);
    view.layer.shadowOpacity = 0.6;
}

- (void) InitLayout {
    
    CGRect r = [[UIScreen mainScreen] bounds];
    CGRect or = [[UIScreen mainScreen] bounds];
    
    r.origin.y -= 50;
    r.size.height += 50;

    for (int i=0; i<MAX_IMAGE; i++)
    {
        bgImageView[i] = [[UIImgView alloc] init];
        [self.view addSubview:bgImageView[i]];
        
        imgPj[i] = [UIImage imageNamed: [NSString stringWithFormat:@"pj_ion_0%d", i+1]];
        
        r.origin.x = (r.size.width * i);
        bgImageView[i].frame = r;
    }
    
    
    CGFloat sy = [[UIScreen mainScreen] bounds].size.height - (180 + 40 + 60); //(or.size.height / 3) * 2
    
    UIImageView * imgLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_copy_01"]];
    r = CGRectMake(or.size.width - 200, sy, 170, 46);
    imgLogo.frame = r;


    [self.view addSubview:imgLogo];
    
    UILabel * lbTitle = [[UILabel alloc] init];
    r.origin.y += r.size.height + 10;
    r.origin.x  = -30;
    r.size.width = or.size.width;
    r.size.height = 25;
    lbTitle.frame = r;

    lbTitle.textAlignment = NSTextAlignmentRight;
    lbTitle.text = @"머핀에서 제일 핫한 방송";
    lbTitle.font = [UIFont boldSystemFontOfSize:20];
    [lbTitle setTextColor:[UIColor whiteColor]];
    

    [self.view addSubview:lbTitle];
    
    lbUser = [[UILabel alloc] init];
    r.origin.y += (25 + 5 + 10);
    r.size.height = 20;
    lbUser.frame = r;

    lbUser.textAlignment = NSTextAlignmentRight;
    lbUser.text = @"facebookID : nununana";
    lbUser.font = [UIFont systemFontOfSize:10];
    [lbUser setTextColor:[UIColor whiteColor]];
    
    [self.view addSubview:lbUser];

    lbPoint = [[UILabel alloc] init];
    r.origin.y += (20);
    r.size.height = 20;
    lbPoint.frame = r;

    lbPoint.textAlignment = NSTextAlignmentRight;
    lbPoint.text = @"Muffin Point : 1,237";
    lbPoint.font = [UIFont systemFontOfSize:10];
    [lbPoint setTextColor:[UIColor whiteColor]];
    

    NSMutableAttributedString *labelText = [[NSMutableAttributedString alloc] initWithString : @"Muffin Point : 1,237"];
    [labelText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(15,5)];
    
    
    lbPoint.attributedText = labelText;
    
    [self.view addSubview:lbPoint];

    UIButton * btnHome = [UIButton buttonWithType:UIButtonTypeCustom];
    r = CGRectMake([[UIScreen mainScreen] bounds].size.width - 42, [[UIScreen mainScreen] bounds].size.height - 120, 42, 100);
    btnHome.frame = r;
    
    [btnHome setBackgroundImage:[UIImage imageNamed:@"home_btn"] forState:UIControlStateNormal];
    [btnHome addTarget:self action:@selector(OnLoginClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnHome];

    
    imgPjIcon = [[UIImageView alloc] init];
    

    imgPjIcon.frame = CGRectMake(20, r.origin.y + ((r.size.height - 27) / 2),  27, 27);
    imgPjIcon.image = imgPj[0];

    [self.view addSubview:imgPjIcon];
    
    
    lbPrjUser = [[UILabel alloc] init];
    
    lbPrjUser.text = @"Bruno Mas";
    lbPrjUser.font = [UIFont boldSystemFontOfSize:16];
    [lbPrjUser sizeToFit];
    
    CGRect tr = lbPrjUser.frame;
    
    r = imgPjIcon.frame;
    r.origin.x += r.size.width + 3;
//    r.origin.y += (r.size.height - tr.size.height) / 2;
    r.size.width = tr.size.width;
    
    lbPrjUser.frame = r;
    [lbPrjUser setTextColor:[UIColor whiteColor]];

    [self.view addSubview:lbPrjUser];
    
    
    
    lbPrjName = [[UILabel alloc] init];
    lbPrjName.text = @"nunnunanna";
    lbPrjName.textColor = [UIColor whiteColor];
    lbPrjName.font = [UIFont systemFontOfSize:11];
    [lbPrjName sizeToFit];
    
    tr = lbPrjName.frame;
    r = lbPrjUser.frame;
    
    r.origin.x += r.size.width + 3;
//    r.origin.y += (r.size.height - tr.size.height) / 2;
    r.size.width = tr.size.width;
    lbPrjName.frame = r;
    [self.view addSubview:lbPrjName];
    
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString * build = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
    UILabel *lbVersion = [[UILabel alloc] init];
    lbVersion.text = [NSString stringWithFormat:@"%@ (%@)", version, build];
    lbVersion.textAlignment = NSTextAlignmentRight;
    lbVersion.font = [UIFont systemFontOfSize:10];
    lbVersion.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].origin.y + 50, [[UIScreen mainScreen] bounds].size.width- 20, 25);
    lbVersion.textColor = [UIColor whiteColor];

    [self.view addSubview:lbVersion];
    
    [self setShadowView:imgLogo];
    [self setShadowView:lbTitle];
    [self setShadowView:lbUser];
    [self setShadowView:lbPoint];
    [self setShadowView:imgPjIcon];
    [self setShadowView:lbPrjName];
    [self setShadowView:lbPrjUser];
    [self setShadowView:lbVersion];

}

- (void) OnLoginClick
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)doSearchMuffinProject:(NSString *)sType  muffinKind:(NSString*)sKind{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    dic[@"Function"] = @"SongInfo_SelectWhere";
    dic[@"Type"] = sType;
    dic[@"Kind"] = sKind;
    
    [[EDHttpTransManager instance] callMuffinInfo:dic withBlack:^(id result, NSError * error)
     {
         if (result != nil)
         {
             NSArray * arr = result;
             
             [self->arrData removeAllObjects];
             self->timerIndex = 0;
             
             int i = 0;
             for (NSDictionary * dic in arr)
             {
                 SongInfo * p = [[SongInfo alloc] initWithData:dic];
                 
                 NSMutableDictionary * sDic = [[NSMutableDictionary alloc] init];
                 
                 sDic[@"bg_name"] = [NSString stringWithFormat:@"sam_bg_0%d", i+1];
                 sDic[@"song"] = p;
                 sDic[@"image"] = [UIImage imageNamed:[NSString stringWithFormat:@"sam_bg_0%d", i+1]];
                 sDic[@"user"] =  p.songName;
                 sDic[@"point"] = @"8,246";
                 [self->arrData addObject:sDic];
                 self->bgImageView[i].imageView.image = sDic[@"image"];
                 i++;
                 if (i>=MAX_IMAGE) break;
                 
             }

             if (arr != nil && arr.count > 0)
             {
                 [self updateUserInfo:self->arrData[0]];
                 self->timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(updateMethod:) userInfo:nil repeats:YES];
             }
         }
     }];
}


+ (void) ShowHotSongView:(NSString *) sData animated:(BOOL) animated
{
    MainHotSongPopupViewController * loginView = [[MainHotSongPopupViewController alloc] initWithNibName:@"MainHotSongPopupViewController" bundle:nil];
    loginView.modalPresentationStyle = UIModalPresentationFullScreen;// modalPresentationStyle

    [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:loginView animated:animated completion:nil];
}


- (void) viewDidDisappear:(BOOL)animated
{
    [timer invalidate];
    
    [LoginViewController ShowLoginView:@"" animated:NO];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
