//
//  EDSpectrumView.h
//  ExampleApp
//
//  Created by JoonHo Kang on 03/07/2019.
//  Copyright © 2019 Thong Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EDSpectrumView : UIView

@property (nonatomic, assign) int nCount;

- (void) appendData:(float) fValue;
- (id) initWithCount:(int) nCount;
@end

NS_ASSUME_NONNULL_END
