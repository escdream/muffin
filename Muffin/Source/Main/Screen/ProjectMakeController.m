//
//  ProjectMakeController.m
//  Muffin
//
//  Created by escdream on 2018. 10. 27..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "ProjectMakeController.h"
#import "ResourceManager.h"
#import "CommonUtil.h"
#import "SystemUtil.h"
#import "UserInfo.h"
#import "UIView+Toast.h"
#import "ProjectInfo.h"
#import "ProjectViewController.h"
#import "FileUploadViewController.h"
#import "CommonFileUtil.h"
#import "CommonUtil.h"

#import "FTPFileUploder.h"

@interface ProjectMakeController ()
{
    NSMutableArray * arrCommand;
    NSMutableArray * arrGanre;
    NSMutableArray * arrCommand2;
    NSMutableArray * arrSelect;
    NSMutableArray * arrRadio;
    
    NSMutableArray * arrFiles;
    FTPFileUploder * uploader;
    
    NSMutableArray * arrTags;

    NSString * sUploadType;
    
    int nSelTagCount;
}

@end

@implementation ProjectMakeController

@synthesize activityIndicator;


- (void) initIndicator
{
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    //    activityIndicator = [[UIActivityIndicatorView alloc]
    //                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

    [activityIndicator setCenter:self.view.center];
    [self.view addSubview : activityIndicator];
}


- (void)viewDidLoad {
    
    CGRect ar = [CommonUtil getWindowArea];
    
    self.view.frame = ar;

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    tokens = [[NSMutableArray alloc] init];
    _viewTags.delegate = self;
    _viewTags.dataSource = self;
    
    [tokens addObject:@"#락"];
    [tokens addObject:@"#발라드"];
    [tokens addObject:@"#레게"];
    [tokens addObject:@"#아무거나"];
    [tokens addObject:@"#이런"];
    [tokens addObject:@"#사랑"];    [tokens addObject:@"#소울"];
    [tokens addObject:@"#트로트"];
    [tokens addObject:@"#힙합"];
    [tokens addObject:@"#보컬"];
    [tokens addObject:@"#싱어송"];
    [tokens addObject:@"#버스킹"];    [tokens addObject:@"#이별"];
    [tokens addObject:@"#댄스"];
    [tokens addObject:@"#외로움"];
    [tokens addObject:@"#그리움"];
    [tokens addObject:@"#첫사랑"];
    [tokens addObject:@"#친구"];

    [_viewTags setViewOnly:YES];
    _viewTags.textField.hidden = YES;
    _viewTags.titleText.text = @"태그선택";
    _viewTags.showTitleText = YES;
//    [_viewTags reloadData];
    
    
    
    [self.bottomView addButtons:@"다음으로" obj:self withSelector:@selector(onNextClick) tag:0];
//    [self.bottomView alignPosition:self.view];
    [self.bottomView buildLayout];
    
    
    if ([[SystemUtil instance] isIPhoneX] )
    {
        CGRect r = ar;
        
        r.origin.y = r.size.height - 10;
        r.size.height = 40;
        
        self.bottomView.frame = r;
        
        
        r = ar;
        r.size.height -= 10;
        
        self.viewScroll.frame = r;
    }
    
    self.currentStep = 1;
    _currentStep = 1;
    
    
    [_btnStep1 setImage:[UIImage imageNamed:@"st_01_off.png"]  forState:UIControlStateNormal];
    [_btnStep1 setImage:[UIImage imageNamed:@"st_01_on.png"]  forState:UIControlStateSelected];
    [_btnStep2 setImage:[UIImage imageNamed:@"st_02_off.png"]  forState:UIControlStateNormal];
    [_btnStep2 setImage:[UIImage imageNamed:@"st_02_on.png"]  forState:UIControlStateSelected];
    [_btnStep3 setImage:[UIImage imageNamed:@"st_03_off.png"]  forState:UIControlStateNormal];
    [_btnStep3 setImage:[UIImage imageNamed:@"st_03_on.png"]  forState:UIControlStateSelected];

    _btnStep1.tag = 1;
    _btnStep2.tag = 2;
    _btnStep3.tag = 3;
    
    
    arrCommand = [[NSMutableArray alloc] init];
    
    [arrCommand addObject:[_viewCommand viewWithTag:101]];
    [arrCommand addObject:[_viewCommand viewWithTag:102]];
    [arrCommand addObject:[_viewCommand viewWithTag:103]];
    [arrCommand addObject:[_viewCommand viewWithTag:104]];

    arrGanre = [[NSMutableArray alloc] init];
    [arrGanre addObject:[_viewGanre viewWithTag:201]];
    [arrGanre addObject:[_viewGanre viewWithTag:202]];
    [arrGanre addObject:[_viewGanre viewWithTag:203]];
    [arrGanre addObject:[_viewGanre viewWithTag:204]];
    [arrGanre addObject:[_viewGanre viewWithTag:205]];
    [arrGanre addObject:[_viewGanre viewWithTag:206]];

    arrCommand2 = [[NSMutableArray alloc] init];
    [arrCommand2 addObject:[_viewStep_3 viewWithTag:301]];
    [arrCommand2 addObject:[_viewStep_3 viewWithTag:302]];

    arrSelect = [[NSMutableArray alloc] init];
    [arrSelect addObject:[_viewStep_3 viewWithTag:3401]];
    [arrSelect addObject:[_viewStep_3 viewWithTag:3402]];
    
    
    arrRadio =  [[NSMutableArray alloc] init];
    [arrRadio addObject:_btnRadio1];
    [arrRadio addObject:_btnRadio2];

    arrTags = [[NSMutableArray alloc] init];
    [arrTags addObject: @""];
    [arrTags addObject: @""];
    [arrTags addObject: @""];
    [arrTags addObject: @""];
    [arrTags addObject: @""];

    CGSize sz = CGSizeMake(30, 30);
    
    

    
    UIImage * onImage = [CommonUtil getLocalImageWithSize:sz  filename:@"btn_on.png"] ;
    UIImage * offImage = [CommonUtil getLocalImageWithSize:sz filename:@"btn_off.png" ] ;

    [_btnRadio1 setImage:offImage forState:UIControlStateNormal];
    [_btnRadio1 setImage:onImage  forState:UIControlStateSelected];

    _btnRadio1.selected = YES;

    [_btnRadio2 setImage:offImage forState:UIControlStateNormal];
    [_btnRadio2 setImage:onImage  forState:UIControlStateSelected];

    _btnJoin1.selected = YES;
    
    sUploadType = @"";
    
    [self setCommendTarget];

    [self setCurrentCommand:1];
    [self setCurrentGanre:1];
    [self setCurrentCommand:1 arrData:arrSelect];
    [self setCurrentGanre:1 arrData:arrCommand2];
    
    [self initIndicator];
    [self setFTP];
}


- (void) setFTP;
{
    arrFiles = [[NSMutableArray alloc] init];
    uploader = [[FTPFileUploder alloc] init];
    uploader.ftpUrl = @"ftp://ourworld3.cafe24.com//tomcat/webapps/dataM/attach/image_g";
    uploader.ftpUserName = @"ourworld3";
    uploader.ftpUserPassword = @"ourworld6249!";
    uploader.delegate = self;
    
//    [self openFileExplorer];
}


- (void) openFileExplorer
{
    NSString *sLocalPath =  [NSString stringWithFormat:@"%@/Main/image", [[NSBundle mainBundle] resourcePath] ];// [CommonFileUtil getDocumentPath] ;//[NSString stringWithFormat:@"%@/
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/images"];
    
    NSArray *arrContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dataPath error:nil];
    
    [arrFiles removeAllObjects];
    arrFiles = [[NSMutableArray alloc] initWithArray:arrContents];
}


- (void) setCommendTarget;
{
    for (UIButton * btn in arrCommand)
    {
        [btn addTarget:self action:@selector(clickButtonWork:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [[ResourceManager sharedManager]  getFontBoldWithSize:12];
    }

    for (UIButton * btn in arrCommand2)
    {
        [btn addTarget:self action:@selector(clickButtonWork:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [[ResourceManager sharedManager]  getFontBoldWithSize:12];
    }

    for (UIButton * btn in arrRadio)
    {
        [btn addTarget:self action:@selector(clickButtonWork:) forControlEvents:UIControlEventTouchUpInside];
    //    btn.titleLabel.font = [[ResourceManager sharedManager]  getFontBoldWithSize:12];
    }

    
    for (UIButton * btn in arrGanre)
    {
        [btn addTarget:self action:@selector(clickButtonWork:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setTitleColor:RGB(0x36, 0x1f, 0x69) forState:UIControlStateNormal];
        [btn setTitleColor:RGB(255, 255, 255) forState:UIControlStateSelected];
    }
    
    for (UIButton * btn in arrSelect)
    {
        [btn addTarget:self action:@selector(clickButtonWork:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setTitleColor:RGB(0x36, 0x1f, 0x69) forState:UIControlStateNormal];
        [btn setTitleColor:RGB(255, 255, 255) forState:UIControlStateSelected];
    }

}

- (void) setCurrentCommand:(long) currentCommand arrData:(NSMutableArray *) arrData
{
    for (int i=0; i<arrData.count; i++)
    {
        UIButton * btn = arrData[i];
        btn.selected = ((currentCommand-1) == i);
    }
}

- (NSString*) getCurrentCommand:(NSMutableArray *) arrData
{
    for (int i=0; i<arrData.count; i++)
    {
        UIButton * btn = arrData[i];
        if (btn.selected)
        {
            switch (btn.tag) {
                case 101:
                    return @"01";
                case 102:
                    return @"02";
                case 103:
                    return @"03";
                case 104:
                    return @"04";
                default:
                    break;
            }
        }
    }
    return @"01";
}


- (NSString*) getCurrentGanre:(NSMutableArray *) arrData
{
    for (int i=0; i<arrData.count; i++)
    {
        UIButton * btn = arrData[i];
        if (btn.selected)
        {
            switch (btn.tag) {
                case 201:
                    return @"01";
                case 202:
                    return @"02";
                case 203:
                    return @"03";
                case 204:
                    return @"04";
                case 205:
                    return @"05";
                case 206:
                    return @"06";
                default:
                    break;
            }
        }
    }
    return @"01";
}
- (void) setCurrentGanre:(long) currentGanre arrData:(NSMutableArray *) arrData
{
    for (int i=0; i<arrData.count; i++)
    {
        UIButton * btn = arrData[i];
        btn.selected = ((currentGanre-1) == i);
        
        if (btn.selected)
            btn.backgroundColor = RGB(0x36, 0x1f, 0x69);
        else
            btn.backgroundColor = RGB(242, 242, 242);
    }
}


- (void) clickButtonWork:(UIButton *) button
{
    
    switch (button.tag) {
        case 101:
        case 102:
        case 103:
        case 104:
            [self setCurrentCommand:button.tag-100 arrData:arrCommand];
            break;
        case 201:
        case 202:
        case 203:
        case 204:
        case 205:
        case 206:
            [self setCurrentGanre:button.tag-200 arrData:arrGanre];
            break;
        case 301:
        case 302:
            [self setCurrentGanre:button.tag-300 arrData:arrCommand2];
            break;
        case 3401:
        case 3402:
            [self setCurrentCommand:button.tag-3400 arrData:arrSelect];
            break;
        case 3601:
        case 3602:
            [self setCurrentCommand:button.tag-3600 arrData:arrRadio];
            break;
        default:
            break;
    }
}

- (CGFloat) setParentCenterX:(UIView *) parent view:(UIView *) view
{
    return (parent.frame.size.width - view.frame.size.width) / 2;
}

- (void) updateLayoutStep1
{
    CGRect r = _viewClient.frame;
    
    r.size.height = _viewTitleName.frame.size.height + _viewSteps.frame.size.height + 10;
    _viewClient.frame = r;
    
    
    r = _viewTitleName.frame;
    r.origin.y = _viewSteps.frame.size.height + 10;
    r.origin.x = (_viewClient.frame.size.width - _viewTitleName.frame.size.width)/2;
    
    _viewTitleName.frame = r;
    [_viewClient addSubview:_viewTitleName];
    
    r = _viewGanre.frame;
    
    r.origin.x = [self setParentCenterX:_viewScroll view:_viewGanre];
    r.origin.y = _viewClient.frame.origin.y + _viewClient.frame.size.height + 10;
    _viewGanre.frame = r;
    
    [_viewScroll addSubview:_viewGanre];
    
    r = _viewTags.frame;
    r.origin.x = [self setParentCenterX:_viewScroll view:_viewTags];
    r.origin.y = _viewGanre.frame.origin.y + _viewGanre.frame.size.height + 10;
    _viewTags.frame = r;
    
    [_viewScroll addSubview:_viewTags];

    
    CGSize size = CGSizeMake(0, 0);
    size.height = _viewTags.frame.origin.y + _viewTags.frame.size.height + 10;
    
    _viewScroll.contentSize = size;

    [_viewStep_2 removeFromSuperview];
    [_viewStep_3 removeFromSuperview];
    
    [self.bottomView clearLayout];
    [self.bottomView addButtons:@"다음으로" obj:self withSelector:@selector(onNextClick) tag:0];
    [self.bottomView buildLayout];
}

- (void) updateLayoutStep2
{
 
    CGRect r = _viewClient.frame;
    
    r.size.height = _viewSteps.frame.size.height + _viewStep_2.frame.size.height + 20;
    _viewClient.frame = r;

    r = _viewStep_2.frame;
    
    r.origin.y = _viewSteps.frame.size.height + 10;

    _viewStep_2.frame = r;
    
    [_viewClient addSubview:_viewStep_2];
    
    [self.viewTags removeFromSuperview];
    [self.viewGanre removeFromSuperview];
    [_viewTitleName removeFromSuperview];
    [_viewStep_3 removeFromSuperview];
    
    _viewScroll.contentSize = CGSizeZero;
    
    [self.bottomView clearLayout];
    [self.bottomView addButtons:@"이전" obj:self withSelector:@selector(onPrevClick) tag:0];
    [self.bottomView addButtons:@"다음으로" obj:self withSelector:@selector(onNextClick) tag:0];
    [self.bottomView buildLayout];
}

- (void) updateLayoutStep3
{
  
    CGRect r = _viewClient.frame;
    
    r.size.height = _viewSteps.frame.size.height + _viewStep_3.frame.size.height + 20;
    _viewClient.frame = r;
    
    r = _viewStep_3.frame;
    
    r.origin.y = _viewSteps.frame.size.height + 10;
    
    _viewStep_3.frame = r;

    [_viewClient addSubview:_viewStep_3];
    
    [self.viewTags removeFromSuperview];
    [self.viewGanre removeFromSuperview];
    [_viewTitleName removeFromSuperview];
    [_viewStep_2 removeFromSuperview];
    
    _viewScroll.contentSize = CGSizeZero;

    [self.bottomView clearLayout];
    [self.bottomView addButtons:@"이전" obj:self withSelector:@selector(onPrevClick) tag:0];
    [self.bottomView addButtons:@"프로젝트등록" obj:self withSelector:@selector(onProjectMakeClick) tag:1];
    [self.bottomView buildLayout];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) onNextClick
{
    int nStep = _currentStep;

    if (nStep == 1)
    {
        if ( [self.fldTitle.text length] < 1 && [self.fldTitle.text isEqualToString:@""] )
        {
            NSString *sMsg = @"곡의 제목을 입력하십시오.";
            UIWindow *window = UIApplication.sharedApplication.delegate.window;
            [window.rootViewController.view makeToast:sMsg];

            return;
        }
    }
    else if (nStep == 2)
    {
//        if ( _imgAlbum.image == nil )
//        {
//            NSString *sMsg = @"이미지를 선택하십시오.";
//            UIWindow *window = UIApplication.sharedApplication.delegate.window;
//            [window.rootViewController.view makeToast:sMsg];
//
//            return;
//        }
    }
    else
    {
        
    }
 

    nStep++;
    if (nStep > 3) nStep = 3;
    
    _currentStep = nStep;
    [self setCurrentStep:nStep];
}

- (void) onPrevClick
{
    int nStep = _currentStep;
    
    nStep--;
    if (nStep < 0) nStep = 1;
    
    _currentStep = nStep;
    [self setCurrentStep:nStep];

}
- (void) onProjectMakeClick
{
    if ( [self.fldPartAskFileName.text length] < 1 && [self.fldPartAskFileName.text isEqualToString:@""] )
    {
        NSString *sMsg = @"음원 또는 가사 파일을 선택하십시오.";
        UIWindow *window = UIApplication.sharedApplication.delegate.window;
        [window.rootViewController.view makeToast:sMsg];
        
        return;
    }
    
    //이미지 업로드 -> 파일 업로드 수행..
    if (_imgAlbum.image != nil)
    {
        sUploadType = @"Image";
        [self doImageUpload];
    }
    else
    {
        sUploadType = @"File";
    
        if (self.btnJoin1.selected)
            [self doFilesUpload: @"mp3"];
        else if (self.btnJoin2.selected)
            [self doFilesUpload: @"txt"];
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) setCurrentStep:(int)currentStep
{
    _btnStep1.selected = NO;
    _btnStep2.selected = NO;
    _btnStep3.selected = NO;

    if (currentStep == 1)
    {
        _btnStep1.selected = YES;
        [self updateLayoutStep1];
    }
    else if (currentStep == 2)
    {
        _btnStep2.selected = YES;
        [self updateLayoutStep2];
    }
    else if (currentStep == 3)
    {
        _btnStep3.selected = YES;
        [self updateLayoutStep3];
    }
}


- (void)tokenDeleteButtonPressed:(UIButton *)tokenButton
{
//    NSUInteger index = [self.tokenField indexOfTokenView:tokenButton.superview];
//    if (index != NSNotFound) {
//        [self.tokens removeObjectAtIndex:index];
//        [self.tokenField reloadData];
//    }
}

#pragma mark - ZFTokenField DataSource

- (CGFloat)lineHeightForTokenInField:(ZFTokenField *)tokenField
{
    return 20;
}

- (NSUInteger)numberOfTokenInField:(ZFTokenField *)tokenField
{
    return tokens.count;
}

- (UIView *)tokenField:(ZFTokenField *)tokenField viewForTokenAtIndex:(NSUInteger)index
{
//    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"TokenView" owner:nil options:nil];
//    UIView *view = nibContents[0];
//    UILabel *label = (UILabel *)[view viewWithTag:2];
//    UIButton *button = (UIButton *)[view viewWithTag:3];
//
////    [button addTarget:self action:@selector(tokenDeleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
////
//    label.text = tokens[index];
//    CGSize size = [label sizeThatFits:CGSizeMake(1000, 30)];
//    view.frame = CGRectMake(0, 0, size.width + 97, 30);
    
    EDRoundView * view = [[EDRoundView alloc] init];
    view.radius = 10;
    view.borderColor = RGB(0x3e, 0x3e, 0x3e);
    view.borderWidth = 1.0f;
    
    UILabel * lb = [[UILabel alloc] init];
    lb.text = tokens[index];
    CGSize size = [lb sizeThatFits:CGSizeMake(1000, 20)];
    lb.textAlignment = NSTextAlignmentCenter;
    view.frame = CGRectMake(0, 0, size.width , 20);

    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = view.frame;
    btn.tag = index;
    [btn setTitleColor:RGB(0x3e, 0x3e, 0x3e) forState:UIControlStateNormal];
    [btn setTitleColor:RGB(255, 255, 255) forState:UIControlStateSelected];
    [btn setTitle:tokens[index] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnTagClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = RGB(242, 242, 242);
    btn.titleLabel.font = [[ResourceManager sharedManager] getFontWithSize:9];

    [view addSubview:btn];
    view.clipsToBounds = YES;
    lb.frame = view.bounds;
    
    return view;
}

-(NSString *)saveImageToDocumentDirectoryWithImage: (UIImage *)capturedImage {
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = documentsDirectory;//[documentsDirectory stringByAppendingPathComponent:@"/images"];
    
    //Create a folder inside Document Directory
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    
    NSString *imageName = [NSString stringWithFormat:@"%@/img_%@.png", dataPath, [self getRandomNumber]] ;
    // save the file
    if ([[NSFileManager defaultManager] fileExistsAtPath:imageName]) {
        // delete if exist
        [[NSFileManager defaultManager] removeItemAtPath:imageName error:nil];
    }
    
    NSData *imageDate = [NSData dataWithData:UIImagePNGRepresentation(capturedImage)];
    [imageDate writeToFile: imageName atomically: YES];
    
    return imageName;
}

-(NSString *)getFileToDocumentDirectoryWithFiles: (NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = documentsDirectory;// [documentsDirectory stringByAppendingPathComponent:@"/images"];
    
    fileName = [NSString stringWithFormat:@"%@/%@", dataPath, fileName];
    return fileName;
}


- (void)doImageUpload{
    UIImage * image = self.imgAlbum.image;
    NSString * fullPath = [self saveImageToDocumentDirectoryWithImage:image];
    
    uploader.ftpUrl = @"ftp://ourworld3.cafe24.com//tomcat/webapps/dataM/attach/image_g";
    
    [uploader upload:fullPath];
}

- (void)doFilesUpload:(NSString *)sFileType {
    NSString * fileName = self.fldPartAskFileName.text;
    NSString * fullPath = [self getFileToDocumentDirectoryWithFiles:fileName];
    
    if ([sFileType isEqualToString: @"mp3"])
        uploader.ftpUrl = @"ftp://ourworld3.cafe24.com//tomcat/webapps/dataM/attach/muffin";
    else if ([sFileType isEqualToString: @"txt"])
        uploader.ftpUrl = @"ftp://ourworld3.cafe24.com//tomcat/webapps/dataM/attach/muffin";
    
    [uploader upload:fullPath];
}

- (IBAction)onImageUpload:(id)sender {
    [self doImageUpload];
}


- (IBAction)onOpenAlbumImage:(id)sender {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

- (IBAction)onBtnPlayMuffinClick:(id)sender
{
    FileUploadViewController * controler = [[FileUploadViewController alloc] initWithNibName:@"FileUploadViewController" bundle:nil];
    controler.delegate = self;
    
    if (_btnJoin1.selected)
        controler.sBrowserType = @"mp3";
    else if (_btnJoin2.selected)
        controler.sBrowserType = @"txt";    
    
    [self presentViewController:controler animated:YES completion:nil];
}

-(void) getData:(NSString *)data
{
    _fldPartAskFileName.text = data;
}
#pragma mark
#pragma mark == Generate Random Number
-(NSString *)getRandomNumber{
    NSTimeInterval time = ([[NSDate date] timeIntervalSince1970]); // returned as a double
    long digits = (long)time; // this is the first 10 digits
    int decimalDigits = (int)(fmod(time, 1) * 1000); // this will get the 3 missing digits
    //long timestamp = (digits * 1000) + decimalDigits;
    NSString *timestampString = [NSString stringWithFormat:@"%ld%d",digits ,decimalDigits];
    return timestampString;
}

#pragma mark - ZFTokenField Delegate

- (void) btnTagClick:(UIButton *) btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        btn.backgroundColor = RGB(0x3e, 0x3e, 0x3e);
//        [arrTags removeObject:@""];
        for (int i=0; i<arrTags.count; i++)
        {
            if ( [[arrTags objectAtIndex:i] isEqualToString:@""] )
            {
                [arrTags removeObjectAtIndex:i];
                [arrTags addObject: btn.titleLabel.text];
                nSelTagCount++;
                return;
            }
            
//            if ( [[arrTags objectAtIndex:i] isEqualToString:btn.titleLabel.text] )
//            {
//                UIWindow *window = UIApplication.sharedApplication.delegate.window;
//                [window.rootViewController.view makeToast:@"이미 선택된 태그입니다."];
//                return;
//            }
        }
    }
    else {
        btn.backgroundColor = RGB(242, 242, 242);
        
        for (int i=0; i<arrTags.count; i++)
        {
            if ( [[arrTags objectAtIndex:i] isEqualToString:btn.titleLabel.text] )
            {
                [arrTags removeObjectAtIndex:i];
                [arrTags addObject:@""];
                nSelTagCount--;
            }
        }
    }

    if (nSelTagCount > 5) {
        UIWindow *window = UIApplication.sharedApplication.delegate.window;
        [window.rootViewController.view makeToast:@"태그는 최대 5개까지만 선택가능합니다."];

        btn.selected = !btn.selected;
        btn.backgroundColor = RGB(242, 242, 242);
        nSelTagCount--;
    }
}

- (CGFloat)tokenMarginInTokenInField:(ZFTokenField *)tokenField
{
    return 5;
}

- (void)tokenField:(ZFTokenField *)tokenField didReturnWithText:(NSString *)text
{
    [tokens addObject:text];
    [tokenField reloadData];
}

- (void)tokenField:(ZFTokenField *)tokenField didRemoveTokenAtIndex:(NSUInteger)index
{
    [tokens removeObjectAtIndex:index];
}

- (BOOL)tokenFieldShouldEndEditing:(ZFTokenField *)textField
{
    return NO;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //You can retrieve the actual UIImage
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //Or you can get the image url from AssetsLibrary
    NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];

    _imgAlbum.image = image;
    [_imgAlbum setNeedsLayout];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint location = [touch locationInView:self.view];
    
    [self.view endEditing:YES];
    
}

- (IBAction)onBtnJoinClick:(id)sender {
    UIButton * btn = sender;
    if (btn.tag == 301)
    {
        _btnJoin1.selected = YES;
        _btnJoin2.selected = NO;
    }
    else if (btn.tag == 302)
    {
        _btnJoin1.selected = NO;
        _btnJoin2.selected = YES;
    }
}

- (void) UploadProcess:(FTPFileUploder *) FileUploader nState:(int)nState sMessage:(NSString *) sMessage;
{
    NSLog(@"ftp log : %@[%d]", sMessage, nState);
    
    if (nState < 0)
    {
        [activityIndicator stopAnimating];
        activityIndicator.hidden= TRUE;
        UIWindow *window = UIApplication.sharedApplication.delegate.window;
        [window.rootViewController.view makeToast:@"업로드 실패"];
    }
    //업로드 중..
    else if ( nState == 20000)
    {
        activityIndicator.hidden= FALSE;
        [activityIndicator startAnimating];
    }
    //업로드 완료
    else if ( nState == 99999)
    {
        [activityIndicator stopAnimating];
        activityIndicator.hidden= TRUE;
        
        //이미지 업로드 완료되면 -> 파일업로드
        if ([sUploadType isEqualToString:@"Image"])
        {
            sUploadType = @"File";
            if (self.btnJoin1.selected)
                [self doFilesUpload: @"mp3"];
            else if (self.btnJoin2.selected)
                [self doFilesUpload: @"txt"];
        }
        else
        {
            [self doGroupInsert];
            UIWindow *window = UIApplication.sharedApplication.delegate.window;
            [window.rootViewController.view makeToast:@"프로젝트 등록이 완료되었습니다."];
        }
    }
}

-(void) setTagList{
//    arrTags add
}

-(void) doGroupInsert
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    
    dic[@"UserId"] = [UserInfo instance].userID;
    dic[@"GroupName"] = self.fldTitle.text;
    dic[@"GroupKind"] = [self getCurrentGanre:self->arrGanre];//01:발라드 02:댄스 03:클래식 04:알앤비 05:락 06레개
    dic[@"ImageId"] = @"";
    dic[@"SystemId"] = @"";
    dic[@"GroupDesc"] = self.txtContent.text;
    dic[@"Tag1"] = [arrTags objectAtIndex:0];
    dic[@"Tag2"] = [arrTags objectAtIndex:1];
    dic[@"Tag3"] = [arrTags objectAtIndex:2];
    dic[@"Tag4"] = [arrTags objectAtIndex:3];
    dic[@"Tag5"] = [arrTags objectAtIndex:4];
    
    
    dic[@"Function"] = @"GroupInfo_Insert";
    
    [[EDHttpTransManager instance] callProjectCommand:dic withBlack:^(id result, NSError * error)
     {
         if (result != nil)
         {
             
         }
         else //프로젝트 등록완료 -> 그룹ID조회 -> 관리지등록 -> 상세화면으로 전환..
         {
             //그룹ID조회 - GroupInfo_LastSelect( String GroupName ,String GroupKind ,String ImageId  )
             dic[@"Function"] = @"GroupInfo_LastSelect";
             [[EDHttpTransManager instance] callProjectCommand:dic withBlack:^(id result, NSError * error)
              {
                  if (result != nil)
                  {
                      NSArray * arrData = result;
                      if (arrData.count == 1)
                      {
                          NSString * strGroupId = [result[0][@"GroupId"] copy];
                          
                          //관리자 등록 - GroupItem_InsertAdmin(String sGroupId,String sUserId,String sPosition)
                          dic[@"GroupId"] = strGroupId;
                          dic[@"Position"] = [self getCurrentCommand:self->arrCommand]; //@"01"; //작사
                          dic[@"Function"] = @"GroupItem_InsertAdmin";
                          [[EDHttpTransManager instance] callGroupItemInfo:dic withBlack:^(id result, NSError * error)
                           {
                               if (result != nil)
                               {
                                   
                               }
                               else
                               {
                                   //관리자 등록 완료 후 화면전환
                                   ProjectInfo * projectInfo = [[ProjectInfo alloc] initWithData:dic];
                                   ProjectViewController * controler = [[ProjectViewController alloc] initWithProject:projectInfo];
                                   
                                   //네이게이션바 뒤로가기 버튼 숨기기 하면 좋을듯......
                                   [self.navigationController pushViewController:controler animated:YES];
                               }
                           }];
                      }
                  }
                  else
                  {
                      
                  }
              }];
         }
     }];
}

@end
