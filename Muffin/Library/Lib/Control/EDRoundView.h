//
//  EDRoundView.h
//  Muffin
//
//  Created by escdream on 2018. 8. 24..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface EDRoundView : UIControl


@property (nonatomic, assign) IBInspectable CGFloat radius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign) IBInspectable UIColor * borderColor;
@property (nonatomic, assign) IBInspectable BOOL    useShadow;


@end
