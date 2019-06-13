//
//  iToast.m
//  iToast
//
//  Created by Diallo Mamadou Bobo on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
// Added By shpark on 2011/11/03

#import "iToast.h"
#import <QuartzCore/QuartzCore.h>
//#import "ResourceManager.h"
//#import "CommonUtil.h"

static iToast *sharedInstance = nil;

@interface iToast(private)
@end

@implementation iToast

- (void) dealloc
{
    [arrViews removeAllObjects];
    arrViews = nil;
}

- (id)init
{
    if (self = [super init])
    {
        arrViews = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (iToast*)sharedToast
{
    if (sharedInstance == nil)
    {
        sharedInstance = [[iToast alloc] init];
    }
    
    return sharedInstance;
}

- (void) layoutCenter:(UIView *)ctlView frameRect:(CGRect)frameRect
{
    CGRect formRect = ctlView.frame;
    frameRect.origin.x = (int)((frameRect.size.width - formRect.size.width) / 2);
    frameRect.origin.y = (int)((frameRect.size.height - formRect.size.height) / 2);
    ctlView.frame = CGRectMake(frameRect.origin.x, frameRect.origin.y, formRect.size.width, formRect.size.height);   
}

- (void) showWithObject:(iToastData*)dataToast{
	
	UIFont *font = [[ResourceManager sharedManager] getFontWithUnit:FTU_TOAST];
	CGSize textSize = [dataToast.sToastText sizeWithFont:font constrainedToSize:CGSizeMake(280, 60)];
    
    int nHeightCount = 1;
    if (textSize.width + 30 > [CommonUtil GetScreenSize].width) {
        nHeightCount = textSize.width / [CommonUtil GetScreenSize].width + 1;
    }
    
    CGFloat btnWidth = textSize.width + 30;
    if (btnWidth > [CommonUtil GetScreenSize].width) {
        btnWidth = [CommonUtil GetScreenSize].width - 20;
    }
    
    
	UIButton *v = [UIButton buttonWithType:UIButtonTypeCustom];
	v.frame = CGRectMake(0, 0, btnWidth, textSize.height * nHeightCount + 10);
    [v addTarget:self action:@selector(hitToast:) forControlEvents:UIControlEventTouchDown];
    v.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    v.layer.borderWidth = 1;
    v.layer.borderColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.7].CGColor;
	v.layer.cornerRadius = 5;
    [v.titleLabel setFont:font];
    [v.titleLabel setNumberOfLines:0];
    [v.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [CommonUtil setButtonTitleColor:v normal:[UIColor whiteColor] highlited:[UIColor whiteColor] selected:[UIColor whiteColor] disabled:[UIColor whiteColor]];
    [CommonUtil setButtonTitle:v normal:dataToast.sToastText highlited:dataToast.sToastText selected:dataToast.sToastText disabled:dataToast.sToastText];
    
	UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	
    // 가로/세로 모드에 따라 위치 계산을 해야 한다.
    CGPoint point = CGPointZero;
    CGFloat angle = 0.0;
    switch (orientation) { 
        case UIInterfaceOrientationPortraitUpsideDown:
            angle = M_PI; 
            point = CGPointMake(window.frame.size.width/2, window.frame.size.height/5);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            angle = - M_PI / 2.0f;
            point = CGPointMake(window.frame.size.width/5*4, window.frame.size.height/2);
            break;
            //2017.04.17 by 한국금융IT >> 가로차트 툴팁이 90도 회전하여 그려지는 현상 수정
//        case UIInterfaceOrientationLandscapeRight:
//            angle = M_PI / 2.0f;
//            point = CGPointMake(window.frame.size.width/5, window.frame.size.height/2);
//            break;
            //2017.04.17 by 한국금융IT << 가로차트 툴팁이 90도 회전하여 그려지는 현상 수정 end
        default: // as UIInterfaceOrientationPortrait
            angle = 0.0;
            point = CGPointMake(window.frame.size.width/2, window.frame.size.height/5*4);
            break;
    } 
	
    CGRect rect = v.frame;
	v.frame = CGRectMake((int)(point.x - rect.size.width/2), (int)(point.y - rect.size.height/2), rect.size.width, rect.size.height);
    v.frame = [CommonUtil makeEventRect:v.frame];
   
    v.transform = CGAffineTransformMakeRotation(angle);
    
	dataToast.toastTimer = [NSTimer timerWithTimeInterval:dataToast.toastDuration/1000.0f
                                                   target:self selector:@selector(hideToast:)
                                                 userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:dataToast.toastTimer forMode:NSDefaultRunLoopMode];
	
    dataToast.toastView = v;
	[window addSubview:v];
}
//
- (void) hideToast:(NSTimer*)theTimer{   
    // 관리할 뷰가 없으면 시작
    
    iToastData *dataToast = nil;
    for (iToastData *subToast in arrViews) {
        if ([subToast.toastTimer isEqual:theTimer])
        {
            dataToast = subToast;
            break;
        }
    }
    
    [self removeToastData:dataToast];
}

- (void)hitToast:(UIButton*)button
{
    iToastData *findDataToast = nil;
    for (iToastData *subToast in arrViews) {
        if ([subToast.toastView isEqual:button])
        {
            findDataToast = subToast;
            break;
        }
    }
    [self removeToastData:findDataToast];
}

- (void)removeToastData:(iToastData*)dataToast
{
    if (dataToast == nil) return;
    
    [UIView animateWithDuration:0.3
                     animations:^(void)
     {
         dataToast.toastView.alpha = 0;
     }
                     completion:^(BOOL finished){
                         [dataToast.toastView removeFromSuperview];
                         [arrViews removeObject:dataToast];
                     }
     ];
}

//
//- (void) removeToast:(NSTimer*)theTimer
//{
//    if (view != nil)
//        view = nil;
//}
//
//// autorelease 추가 주영
//+ (iToast *) makeText:(NSString *) _text{
//	iToast *toast = [[iToast alloc] initWithText:_text];
//	
//	return toast;
//}

- (iToastData *) showText:(NSString *)text duration:(iToastDuration)duration gravity:(iToastGravity)gravity
{
    iToastData *dataToast = [[iToastData alloc] initWithText:text duration:duration gravity:gravity];
    [arrViews addObject:dataToast];
    [self showWithObject:dataToast];
    
    return dataToast;
}

@end


@implementation iToastData

@synthesize toastView;
@synthesize sToastText;
@synthesize toastDuration;
@synthesize toastTimer;

- (id)initWithText:(NSString*)sText duration:(iToastDuration)duration gravity:(iToastGravity)gravity
{
    if (self = [super init])
    {
        sToastText = sText;
        toastDuration = duration;
    }
    
    return self;
}

@end


