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


@interface MainHotSongPopupViewController ()
{
    NSMutableArray * arrData;
    UIImageView * bgImageView[MAX_IMAGE];
    
    int timerIndex;
    NSTimer *timer;
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
        }
        self->timerIndex ++;
        if (self->timerIndex >= MAX_IMAGE)
            self->timerIndex = 0;
        }
        completion:^(BOOL finished) {
    }];
}



- (void) InitLayout {
    
    CGRect r = [[UIScreen mainScreen] bounds];
    CGRect or = [[UIScreen mainScreen] bounds];
    
    r.origin.y -= 50;
    r.size.height += 50;

    for (int i=0; i<MAX_IMAGE; i++)
    {
        bgImageView[i] = [[UIImageView alloc] init];
        [self.view addSubview:bgImageView[i]];
        
        r.origin.x = (r.size.width * i);
        bgImageView[i].frame = r;
    }
    
    
    UIImageView * imgLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_copy_01"]];
    r = CGRectMake(or.size.width - 200, (or.size.height / 3) * 2, 170, 46);
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
    
    UILabel * lbUser = [[UILabel alloc] init];
    r.origin.y += (25 + 5);
    r.size.height = 20;
    lbUser.frame = r;

    lbUser.textAlignment = NSTextAlignmentRight;
    lbUser.text = @"facebookID : nununana";
    lbUser.font = [UIFont systemFontOfSize:10];
    [lbUser setTextColor:[UIColor whiteColor]];
    
    [self.view addSubview:lbUser];

    UILabel * lbPoint = [[UILabel alloc] init];
    r.origin.y += (20 + 5);
    r.size.height = 20;
    lbPoint.frame = r;

    lbPoint.textAlignment = NSTextAlignmentRight;
    lbPoint.text = @"Muffin Point : 1,985";
    lbPoint.font = [UIFont systemFontOfSize:10];
    [lbPoint setTextColor:[UIColor whiteColor]];
    
    [self.view addSubview:lbPoint];


    
    UIButton * btnHome = [UIButton buttonWithType:UIButtonTypeCustom];
    r = CGRectMake([[UIScreen mainScreen] bounds].size.width - 42, [[UIScreen mainScreen] bounds].size.height - 160, 42, 100);
    btnHome.frame = r;
    
    [btnHome setBackgroundImage:[UIImage imageNamed:@"home_btn"] forState:UIControlStateNormal];
    [btnHome addTarget:self action:@selector(OnLoginClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnHome];
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
                 [self->arrData addObject:sDic];
                 self->bgImageView[i].image = sDic[@"image"];
                 i++;
                 if (i>=MAX_IMAGE) break;
             }

             if (arr != nil && arr.count > 0)
             {
                 timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(updateMethod:) userInfo:nil repeats:YES];
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
