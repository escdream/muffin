//
//  ZFTokenField.h
//  ZFTokenField
//
//  Created by Amornchai Kanokpullwad on 10/11/2014.
//  Copyright (c) 2014 Amornchai Kanokpullwad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDRoundView.h"

@class ZFTokenField;

@interface ZFTokenTextField : UITextField
@end

@protocol ZFTokenFieldDataSource <NSObject>
@required
- (CGFloat)lineHeightForTokenInField:(ZFTokenField *)tokenField;
- (NSUInteger)numberOfTokenInField:(ZFTokenField *)tokenField;
- (UIView *)tokenField:(ZFTokenField *)tokenField viewForTokenAtIndex:(NSUInteger)index;
@end

@protocol ZFTokenFieldDelegate <NSObject>
@optional
- (void) autoSizeChangeInField:(ZFTokenField *)tokenField frame:(CGRect)frame;
- (CGFloat)tokenMarginInTokenInField:(ZFTokenField *)tokenField;
- (void)tokenField:(ZFTokenField *)tokenField didRemoveTokenAtIndex:(NSUInteger)index;
- (void)tokenField:(ZFTokenField *)tokenField didReturnWithText:(NSString *)text;
- (void)tokenField:(ZFTokenField *)tokenField didTextChanged:(NSString *)text;
- (void)tokenFieldDidBeginEditing:(ZFTokenField *)tokenField;
- (BOOL)tokenFieldShouldEndEditing:(ZFTokenField *)textField;
- (void)tokenFieldDidEndEditing:(ZFTokenField *)tokenField;
@end

@interface ZFTokenField : EDRoundView

@property (nonatomic, weak) IBOutlet id<ZFTokenFieldDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id<ZFTokenFieldDelegate> delegate;

@property (nonatomic, strong, readonly) ZFTokenTextField *textField;

@property (nonatomic, assign) BOOL autoHeight;
@property (nonatomic, assign) BOOL showTitleText;
@property (nonatomic, assign) BOOL readOnly;

@property (nonatomic, assign) CGFloat marginTop;
@property (nonatomic, assign) CGFloat marginBottom;
@property (nonatomic, assign) CGFloat marginLeft;
@property (nonatomic, assign) CGFloat marginRight;
@property (nonatomic, strong) UILabel * titleText;
@property (nonatomic, assign) BOOL viewOnly;


- (void)reloadData;
- (NSUInteger)numberOfToken;
- (NSUInteger)indexOfTokenView:(UIView *)view;


@end
