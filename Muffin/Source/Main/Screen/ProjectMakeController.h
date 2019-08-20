//
//  ProjectMakeController.h
//  Muffin
//
//  Created by escdream on 2018. 10. 27..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "EDBaseViewController.h"
#import "EDBottomButtonView.h"
#import "EDRoundView.h"
#import "EDRoundButton.h"
#import "ZFTokenField.h"
#import "FileUploadViewController.h"


@interface ProjectMakeController : EDBaseViewController<ZFTokenFieldDelegate, ZFTokenFieldDataSource, FileUploadViewDelegate>
{
    NSMutableArray * tokens;
    UIActivityIndicatorView *activityIndicator;
}
    
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) IBOutlet EDBottomButtonView *bottomView;
@property (strong, nonatomic) IBOutlet UITextField *fldTitle;
@property (strong, nonatomic) IBOutlet UITextView *txtContent;
@property (strong, nonatomic) IBOutlet UIView *viewSteps;
@property (strong, nonatomic) IBOutlet UIScrollView *viewScroll;
@property (strong, nonatomic) IBOutlet EDRoundView *viewClient;
@property (strong, nonatomic) IBOutlet EDRoundView *viewCommand;

@property (strong, nonatomic) IBOutlet UIView *viewStep_1;
@property (strong, nonatomic) IBOutlet UIView *viewStep_2;
@property (strong, nonatomic) IBOutlet UIView *viewStep_3;
@property (strong, nonatomic) IBOutlet UIView *viewGanre;
@property (strong, nonatomic) IBOutlet ZFTokenField *viewTags;
@property (strong, nonatomic) IBOutlet UIView *viewTitleName;
@property (weak, nonatomic) IBOutlet UIView *viewJoin1;
@property (weak, nonatomic) IBOutlet UIView *viewJoin2;

@property (assign, nonatomic) int currentStep;

@property (strong, nonatomic) IBOutlet UIButton *btnStep1;
@property (strong, nonatomic) IBOutlet UIButton *btnStep2;
@property (strong, nonatomic) IBOutlet UIButton *btnStep3;

@property (assign, nonatomic) int currentGanre;
@property (assign, nonatomic) int currentCommand;
@property (strong, nonatomic) IBOutlet UIButton *btnRadio1;
@property (strong, nonatomic) IBOutlet UIButton *btnRadio2;

@property (strong, nonatomic) IBOutlet EDRoundButton *btnJoin1;
@property (strong, nonatomic) IBOutlet EDRoundButton *btnJoin2;
@property (strong, nonatomic) IBOutlet UIButton *btnPlayMuffin;

@property (strong, nonatomic) IBOutlet UITextField *fldPartAskFileName; //파일명
@property (weak, nonatomic) IBOutlet UITextView *fldPartAskSongWord;    //가사

@property (strong, nonatomic) IBOutlet UIImageView *imgAlbum;

@property (strong, nonatomic) IBOutlet UIButton *btnUpload;
@end
