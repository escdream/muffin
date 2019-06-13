//
//  UIView+FirstResponder.h
//  AddToKeyboard
//
//  Created by Jong Pil Park on 10. 8. 24..
//  Copyright 2010 Lilac Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (FirstResponder) 

- (UIView *)findFirstResponder;

-(void)scrollToY:(float)y;
-(void)scrollToView:(UIView *)view;
-(void)scrollElement:(UIView *)view toPoint:(float)y;
\
@end
