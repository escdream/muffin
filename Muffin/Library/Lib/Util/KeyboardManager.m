
//
//  KeyboardManager.m
//  SmartVIGS
//
//  Created by W JW on 11. 11. 15..
//  Copyright 2011 itgen. All rights reserved.
//

#import "KeyboardManager.h"

#import "ResourceManager.h"
#import "UIView+FirstResponder.h"
#import "SystemUtil.h"
#import "CommonUtil.h"

#define TRANSKEYBOARD_TEXT_HEIGHT   368+20
#define TRANSKEYBOARD_NUM_HEIGHT    295+20

static KeyboardManager* instance;

@interface KeyboardManager()

- (void)createSubView;

@end

@implementation KeyboardManager

//@synthesize m_curTransKey;

- (id)init
{
    self = [super init];
    if (self) 
    {
        instance = self;
        
        // 노티피케이션 등록.
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [nc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [nc addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [nc addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
        
        [nc addObserver:self selector:@selector(editEndEditing:)   name:NSLocalizedString(@"EDIT_CHANGE_END" , @"") object:nil];      
        [nc addObserver:self selector:@selector(editBeginEditing:) name:NSLocalizedString(@"EDIT_CHANGE_BEGIN" , @"") object:nil];

        m_isKeyboardMinus = NO;
        m_isKeyboardPoint = NO;
        m_isShow = FALSE;
        
    }
    
    
    return self;
}

- (void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [nc removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [nc removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [nc removeObserver:self name:UIKeyboardDidHideNotification object:nil];    

    [nc removeObserver:self name:NSLocalizedString(@"EDIT_CHANGE_END" , @"")   object:nil];
    [nc removeObserver:self name:NSLocalizedString(@"EDIT_CHANGE_BEGIN" , @"") object:nil];    
}


- (void)scrollKeyWindow:(UIView *)textField
{
    int animatedDistance = 0;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    UIView *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect windowRect = keyWindow.frame;
    CGRect textFieldRect = [textField convertRect:textField.bounds toView:keyWindow];
    
    int nTextFieldEndPos = textFieldRect.origin.y + textFieldRect.size.height + windowRect.origin.y + 5;
    
    // 가로/세로 모드에 따라 위치 계산을 해야 한다.
    switch (orientation) { 
        case UIInterfaceOrientationPortraitUpsideDown:
            nTextFieldEndPos = windowRect.size.height - windowRect.origin.y - textFieldRect.origin.y + 5;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            nTextFieldEndPos = textFieldRect.origin.x + textFieldRect.size.width + windowRect.origin.x + 5;
            break;
        case UIInterfaceOrientationLandscapeRight:
            // escdream 2017.12.22 - 가로 모드시 입력창 표시 스크롤 오류 수정
            if (windowRect.size.width > windowRect.size.height)
                nTextFieldEndPos = windowRect.size.height - windowRect.origin.x - textFieldRect.origin.x + 5;
            else
                nTextFieldEndPos = windowRect.size.width - windowRect.origin.x - textFieldRect.origin.x + 5;
            break;
        default: // as UIInterfaceOrientationPortrait
            break;
    }
    
    
    int nKeyboardHeight = PORTRAIT_KEYBOARD_HEIGHT ;
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        nKeyboardHeight = PORTRAIT_KEYBOARD_HEIGHT ; // + KEYBOARD_TITLE_HEIGHT;

        if ([[SystemUtil instance] isIPhoneX] )
        {
            nKeyboardHeight += 70;
        }

    }
    else
    {
       nKeyboardHeight = LANDSCAPE_KEYBOARD_HEIGHT; // + KEYBOARD_TITLE_HEIGHT;

        if ([[SystemUtil instance] isIPhoneX] )
        {
            nKeyboardHeight += 70;
        }

        // 가로모드일 경우는 키윈도우의 크기를 뒤집어 주어야 함. (키윈도우는 항상 포트레이트 기준)
        int nTmp = windowRect.size.width;
        windowRect.size.width = windowRect.size.height;
        windowRect.size.height = nTmp;
    }
    if( (windowRect.size.height - nKeyboardHeight) < nTextFieldEndPos )
        animatedDistance = nKeyboardHeight - (windowRect.size.height - nTextFieldEndPos) ;
    
    
    if( animatedDistance > 0 )
    {
        CGRect viewFrame = keyWindow.frame;
        
        // 가로/세로 모드에 따라 위치 계산을 해야 한다.
        switch (orientation) { 
            case UIInterfaceOrientationPortraitUpsideDown:
                viewFrame.origin.y += animatedDistance;
                break;
            case UIInterfaceOrientationLandscapeLeft:
                viewFrame.origin.x -= animatedDistance;
                break;
            case UIInterfaceOrientationLandscapeRight:
//                viewFrame.origin.x += animatedDistance;
                viewFrame.origin.y -= animatedDistance;
                
                break;
            default: // as UIInterfaceOrientationPortrait
                viewFrame.origin.y -= animatedDistance;
                break;
        }
        
       
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
        
        [keyWindow setFrame:viewFrame];
        
        [UIView commitAnimations];
    }    
}

-(void)WindowDidBecomeKey:(NSNotification *) note{
//     TRACE(@"WindowDidBecomeKey\n");    
}

- (void)keyboardWillShow:(NSNotification *)note {
//     TRACE(@"keyboardWillShow\n");   
//    m_isShow = TRUE;
    

    
    if( m_textField != nil )
        [self scrollKeyWindow:m_textField];
}

- (void)keyboardDidShow:(NSNotification *)note {

    m_isShow = TRUE;
    m_keyWindow = [[UIApplication sharedApplication] keyWindow];
//    if( m_textField != nil )
//        [self addButtonToKeyboard:note];
}

- (void)keyboardWillHide:(NSNotification *)notification {

    [self dismissingKeyboard:nil];
    m_textField = nil; // escdream 2018.04.06 
    
    
    m_isShow = FALSE;
}





- (void)keyboardDidHide:(NSNotification *)notification {

    m_isShow = FALSE;
    m_isKeyboardMinus = NO;
    m_isKeyboardPoint = NO;
    m_keyboardtype    = 0;
    
    
//    [[ExceptionManager sharedInstance] removeKeyboardBackgroundView];
    
}

- (void)editBeginEditing:(NSNotification *)notification {

    m_isKeyboardMinus = NO;
    m_isKeyboardPoint = NO;
    m_keyboardtype    = 0;
    
    id item = [notification object];
    if (([item class] == [UITextField class]) || ([item class] == [UITextView class])) {
        UITextField *edit = (UITextField*)item;
        m_textField = edit;
    }else if ([[item class] isSubclassOfClass:[UITextField class]])
    {
        m_keyboardtype = [item keyboardType];
        m_isKeyboardMinus = NO;
    }
}

- (void)editEndEditing:(NSNotification *)notification{

    m_textField = nil;

}

- (void)removeKeyboradtitle{
    if (m_keyboardTitle != nil)
    {
        [m_keyboardTitle removeFromSuperview];
        m_keyboardTitle = nil;
    }
}

- (void)removeDotButton{
    if (m_dotbutton != nil) {
        [m_dotbutton removeFromSuperview];
        m_dotbutton = nil;
    }
}

- (void)removeDoneButton{
    if (m_donebutton != nil) {
        [m_donebutton removeFromSuperview];
        m_donebutton = nil;
    }
}

- (void)addButtonToKeyboard:(NSNotification *)noti {
    [self createSubView];

}

- (void)createSubView
{
    NSArray *window = [[UIApplication sharedApplication] windows];
    if ([window count] < 2 )
        return;        
    
    if (m_keyboardtype != UIKeyboardTypeNumberPad) {
        [self removeKeyboradtitle];
        return;
    }
    
    // 숫자 키패드... 하단에 완료버튼으로 변경 - Gon
    // 점(.),마이너스(-) 고려 안하고..... 우선 바꿔놓음;;;
	// 고려하기로 함 -_-; - cory
	else if (m_isKeyboardPoint)
    {
        CGSize screenSize = [CommonUtil GetScreenSize];
        
		
        // 높이가 크면 가로 , 넓이가 크면 세로
        if (screenSize.width < screenSize.height) {
            m_dotbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 163, 105, 53)];
			m_donebutton =  [[UIButton alloc] initWithFrame:CGRectMake(215, 163, 105, 53)];
        }else{
            m_dotbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 122, 158, 40)];
            m_donebutton = [[UIButton alloc] initWithFrame:CGRectMake(322, 125, 158, 40)];
        }
        
		
		[m_donebutton addTarget:self action:@selector(dismissKeyboard:) forControlEvents:UIControlEventTouchUpInside];
		UIImage* imgBack = [CommonUtil getImage:@"numpad_bg.9" size:m_dotbutton.frame.size];
		[m_donebutton setBackgroundImage:imgBack forState:UIControlStateNormal];
        [m_donebutton setTitleColor:[UIColor colorWithRed:77.0f/255.0f green:84.0f/255.0f blue:98.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
        [m_donebutton setTitleColor:                 [UIColor whiteColor] forState:UIControlStateHighlighted];
        [m_donebutton setTitle:@"완료" forState:UIControlStateNormal];
        [m_donebutton setTitle:@"완료" forState:UIControlStateHighlighted];
        [m_donebutton setTag:1];
		
		
        [m_dotbutton addTarget:self action:@selector(keyboardButton:) forControlEvents:UIControlEventTouchUpInside];
        [m_dotbutton setBackgroundImage:[[ResourceManager sharedManager] getUIImage:@"keyboardbackground" imageOfSize:m_dotbutton.frame.size] forState:UIControlStateHighlighted];
        [m_dotbutton setBackgroundColor:[UIColor clearColor]];
		
        [m_dotbutton setTitleColor:[UIColor colorWithRed:77.0f/255.0f green:84.0f/255.0f blue:98.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
        [m_dotbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [m_dotbutton setTitle:@"." forState:UIControlStateNormal];
        [m_dotbutton setTitle:@"." forState:UIControlStateHighlighted];
        [m_dotbutton setTag:0];
		
		
		UIWindow* tempWindow = [window objectAtIndex:1];
		
		
		for(UIView* keyboard in tempWindow.subviews) {
			// keyboard found, add the button
			if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
				if([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES){
					if( m_dotbutton != nil )[keyboard addSubview:m_dotbutton];
					if( m_donebutton != nil)[keyboard addSubview:m_donebutton];
					if( m_keyboardTitle != nil )[keyboard addSubview:m_keyboardTitle];
					break;
				}
			} else {
				if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES){
					if( m_dotbutton != nil )[keyboard addSubview:m_dotbutton];
					if( m_donebutton != nil)[keyboard addSubview:m_donebutton];
					if( m_keyboardTitle != nil )[keyboard addSubview:m_keyboardTitle];
					break;
				}
			}
		}
		return;
    }
    else if (!m_isKeyboardPoint)
    {
        CGSize screenSize = [CommonUtil GetScreenSize];
        
        // 높이가 크면 가로 , 넓이가 크면 세로
        if (screenSize.width < screenSize.height) {
            m_dotbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 163, 105, 53)];
        }else{
            m_dotbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 122, 158, 40)];
        }
        
        [m_dotbutton addTarget:self action:@selector(dismissKeyboard:) forControlEvents:UIControlEventTouchUpInside];
        [m_dotbutton setBackgroundImage:[[ResourceManager sharedManager] getUIImage:@"keyboardbackground" imageOfSize:m_dotbutton.frame.size] forState:UIControlStateHighlighted];
        [m_dotbutton setBackgroundColor:[UIColor clearColor]];
        
        [m_dotbutton setTitleColor:[UIColor colorWithRed:77.0f/255.0f green:84.0f/255.0f blue:98.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
        [m_dotbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [m_dotbutton setTitle:@"완료" forState:UIControlStateNormal];
        [m_dotbutton setTitle:@"완료" forState:UIControlStateHighlighted];
        [m_dotbutton setTag:0];
        
        UIWindow* tempWindow = [window objectAtIndex:1];
        
        
        for(UIView* keyboard in tempWindow.subviews) {
            // keyboard found, add the button
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
                if([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES){
                    if( m_dotbutton != nil )[keyboard addSubview:m_dotbutton];
                    if( m_keyboardTitle != nil )[keyboard addSubview:m_keyboardTitle];
                    break;
                }
            } else {
                if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES){
                    if( m_dotbutton != nil )[keyboard addSubview:m_dotbutton];
                    if( m_keyboardTitle != nil )[keyboard addSubview:m_keyboardTitle];
                    break;
                }
            }
        }
        
        return;
    }
    
    
    
    [self removeKeyboradtitle];
    [self removeDotButton];
	[self removeDoneButton];
    
    
    m_keyboardTitle = [[UIToolbar alloc] initWithFrame:CGRectMake(0, -44, [CommonUtil GetScreenSize].width, 44)];
    m_keyboardTitle.barStyle = UIBarStyleBlackTranslucent;
    m_keyboardTitle.tintColor = [UIColor darkGrayColor];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"완료" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissKeyboard:)];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSMutableArray *item = [[NSMutableArray alloc] init];
//    if (m_isKeyboardPoint)
//    {
//        CGSize screenSize = [CommonUtil GetScreenSize];
//        
//        // 높이가 크면 가로 , 넓이가 크면 세로
//        if (screenSize.width < screenSize.height) {
//            m_dotbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 163, 105, 53)];
//        }else{
//            m_dotbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 122, 158, 40)];
//        }
//        
//        [m_dotbutton addTarget:self action:@selector(keyboardButton:) forControlEvents:UIControlEventTouchUpInside];
//        [m_dotbutton setBackgroundImage:[[ResourceManager sharedManager] getUIImage:@"keyboardbackground" imageOfSize:m_dotbutton.frame.size] forState:UIControlStateHighlighted];
//        [m_dotbutton setBackgroundColor:[UIColor clearColor]];
//
//        [m_dotbutton setTitleColor:[UIColor colorWithRed:77.0f/255.0f green:84.0f/255.0f blue:98.0f/255.0f alpha:1.0] forState:UIControlStateNormal];	
//        [m_dotbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//        [m_dotbutton setTitle:@"." forState:UIControlStateNormal];
//        [m_dotbutton setTitle:@"." forState:UIControlStateHighlighted];                
//        [m_dotbutton setTag:0];
//    }
    if (m_isKeyboardMinus) {
        UIBarButtonItem *minusbtn = [[UIBarButtonItem alloc] initWithTitle:@"-" style:UIBarButtonItemStyleBordered target:self action:@selector(minusButton:)];
        minusbtn.title = @"-";
        minusbtn.width = 40;
        
        [item addObject:minusbtn];
    }
    
    [item addObject:space];
    [item addObject:doneButton];
    
    [m_keyboardTitle setItems:item];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [m_keyboardTitle addSubview:btn];
    
    UIWindow* tempWindow = [window objectAtIndex:1];
    
    for(UIView* keyboard in tempWindow.subviews) {
        // keyboard found, add the button
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
            if([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES){
                if( m_dotbutton != nil )[keyboard addSubview:m_dotbutton];
                if( m_keyboardTitle != nil )[keyboard addSubview:m_keyboardTitle];                                
                break;
            }
        } else {
            if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES){
                if( m_dotbutton != nil )[keyboard addSubview:m_dotbutton];
                if( m_keyboardTitle != nil )[keyboard addSubview:m_keyboardTitle];                                
                break;
            }
        }
    }
}


-(void)dismissingKeyboard:(id)sender
{    
    [self removeDotButton];
	[self removeDoneButton];
    [self removeKeyboradtitle];
    
    // 키보드 사라질때 얼럿창이 뜨거나 하면 키윈도우가 다른것이 얻어지는 경우가 있어 키보다 뜰때 얻은 키윈도우를 사용한다.
    if( m_keyWindow != nil )
    {
        CGRect keyFrame = m_keyWindow.frame;
        [m_keyWindow setFrame:CGRectMake(0, 0, keyFrame.size.width, keyFrame.size.height)];
        m_keyWindow = nil;
    }
}

-(void)dismissKeyboard:(id)sender
{
/*
    id <IMessageDelegate> MainViewController = [[SharedDelegate instance] getTargetWithType:kMainViewController];
    UIViewController *viewContoller = (UIViewController*)[MainViewController receiveObejctMessage:RECV_MAINVIEWCON_TOPCON];
    [viewContoller.view endEditing:YES];

    
    [[ExceptionManager sharedInstance] removeKeyboardBackgroundView];
*/
//    if( m_curTransKey != nil )
//    {
//        [m_curTransKey TranskeyResignFirstResponder];
//        m_curTransKey = nil;
//    }
}

//-(void)dismissTransKey
//{
//    if( m_curTransKey != nil )
//    {
//        [m_curTransKey TranskeyResignFirstResponder];
//        m_curTransKey = nil;
//    }
//}



- (void)setFramefromOrientation
{
    [self createSubView];
}

+ (void)dismissKeyboard:(id)sender
{
    if( instance == nil ) return;
    [instance dismissKeyboard:sender];
}

//+ (void)dismissTransKey
//{
//    if( instance == nil ) return;
//    [instance dismissTransKey];
//}

//+ (void)setResponderTransKey:(TransKey *)transKey
//{
//    if( instance == nil ) return;
//    [instance setTransKey:transKey];
//}


@end
