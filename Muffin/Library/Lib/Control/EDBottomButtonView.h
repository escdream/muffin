//
//  EDBottomButtonView.h
//  Muffin
//
//  Created by escdream on 2018. 10. 22..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EDBottomButtonView : UIView

@property (nonatomic, strong) NSMutableArray * arrButtons;
- (void) alignPosition:(UIView *) parentView;

- (void) buildLayout;
- (void) addButtons:(NSString *) sTitle obj:(id) obj withSelector:(SEL)sel tag:(int) ntag;
- (void) clearLayout;
- (NSString*) getButtonTitle:(int)nIdx;
- (int) getButtonTag:(int)nIdx;
- (void) setChangeButtonTitle:(int)nIdx sTitle:(NSString*)sTitle tag:(int)nTag;
- (void) removeButton:(int)nIdx;
- (void )removeAllButton;
@end

NS_ASSUME_NONNULL_END
