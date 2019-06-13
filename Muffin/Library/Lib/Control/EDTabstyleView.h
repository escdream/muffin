//
//  EDTabstyleView.h
//  Muffin
//
//  Created by escdream on 2018. 9. 4..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE

@interface EDTabstyleView : UIView
{
    NSMutableArray * tabButtonList;
    UIView         * tabParent;
    UIScrollView   * scrollClient;
    UIPageControl  * pager;
    UIView * tabIndicator;
    UIView * tabUnderline;
    
    CGFloat buttonWidth;
    CGFloat frameWidth;
    CGFloat frameHeight;
    CGFloat overContentView;
}

@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) NSMutableArray * tabViewList;

@property (nonatomic, strong) IBInspectable UIColor * noramlTextColor;
@property (nonatomic, strong) IBInspectable UIColor * selectTextColor;
@property (nonatomic, strong) IBInspectable UIColor * underlineColor;
@property (nonatomic, strong) IBInspectable UIColor * indicatorColor;
@property (nonatomic, assign) IBInspectable CGFloat tabHeight;
@property (nonatomic, assign) IBInspectable CGFloat marginWidth;
@property (nonatomic, assign) IBInspectable CGFloat marginBottom;



@property (nonatomic, assign) IBInspectable CGFloat radius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign) IBInspectable UIColor * borderColor;
@property (nonatomic, assign) IBInspectable BOOL    useShadow;


- (CGRect) getClientRect;
- (void) addTab:(NSString *) sTitle;
- (void) addTab:(NSString *) sTitle subView:(UIView *) subView;
- (void) removeTab:(int) nIndex;
- (void) changeTab:(NSString *) sTitle nIndex:(int) nIndex;
- (void) calcTabLayouts;
- (NSString*) currentTabTitle;
@end
