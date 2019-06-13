//
//  KeyboardManager.h
//  SmartVIGS
//
//  Created by W JW on 11. 11. 15..
//  Copyright 2011 itgen. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class TransKey;


static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;

static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
static const CGFloat KEYBOARD_TITLE_HEIGHT = 44;

typedef enum {
    Edit_KeybordType_Normal  = 0,
    Edit_KeybordType_Number = 1,
    Edit_KeybordType_Search = 2,
    Edit_KeybordType_None   = 3,
}Edit_KeybordType;

typedef enum {
    Edit_Password_Mode_None = 0,
    Edit_Password_Mode_Normal = 1,
    Edit_Password_Mode_Account = 2,
    Edit_Password_Mode_NoEncrypt = 3, // 공인인증서 비밀번호 입력
    
}Edit_Password_Mode;

typedef enum {
    Edit_Number_ToolBar_Mode_Done = 0,
    Edit_Number_ToolBar_Mode_MinusPoint = 1,
    Edit_Number_ToolBar_Mode_Minus = 2,
    Edit_Number_ToolBar_Mode_Point = 3,
}Edit_Number_ToolBar_Mode;

@interface KeyboardManager : NSObject
{
    NSInteger       m_keyboardtype;
    UIToolbar       *m_keyboardTitle;
    UIButton        *m_dotbutton;
	UIButton        *m_donebutton;
    BOOL            m_isKeyboardMinus;
    BOOL            m_isKeyboardPoint;    
    UIWindow        *m_keyWindow;
    UIView          *m_textField;
//    __weak TransKey        *m_curTransKey;
    BOOL            m_isShow;
}

//@property (nonatomic , weak , setter = setTransKey:       , getter = getTransKey       )   TransKey *    m_curTransKey;


// 키보드에 버튼 추가 하기
- (void)addButtonToKeyboard:(NSNotification *)noti;
// 키보드에 타이틀 삭제
- (void) removeKeyboradtitle;
- (void) removeDotButton;
- (void) dismissKeyboard:(id)sender;
- (UIView *) findFirstResponder;
- (void)setFramefromOrientation;
- (void)dismissingKeyboard:(id)sender;

+ (void)dismissKeyboard:(id)sender;
//+ (void)setResponderTransKey:(TransKey *)transKey;
//+ (void)dismissTransKey;
+ (void)scrollForTransKey:(UIView *)textField show:(BOOL)isShow type:(int)type;

@end
