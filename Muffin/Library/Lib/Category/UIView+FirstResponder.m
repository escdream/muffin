//
//  UIView+FirstResponder.m
//  AddToKeyboard
//
//  Created by Jong Pil Park on 10. 8. 24..
//  Copyright 2010 Lilac Studio. All rights reserved.
//

#import "UIView+FirstResponder.h"


@implementation UIView (FirstResponder)

- (UIView *)findFirstResponder {
	if ([self isFirstResponder]) {
		return self;
	}
	
	for (UIView *subview in [self subviews]) {
		UIView *firstResponder = [subview findFirstResponder];
		if (nil != firstResponder) {
			return firstResponder;
		}
	}
	
	return nil;
}


-(void)scrollToY:(float)y
{
    
    [UIView beginAnimations:@"registerScroll" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];
    self.transform = CGAffineTransformMakeTranslation(0, y);
    [UIView commitAnimations];
    
}

-(void)scrollToView:(UIView *)view
{
    CGRect theFrame = view.frame;
    float y = theFrame.origin.y - 15;
    y -= (y/1.7);
    [self scrollToY:-y];
}


-(void)scrollElement:(UIView *)view toPoint:(float)y
{
    CGRect theFrame = view.frame;
    float orig_y = theFrame.origin.y;
    float diff = y - orig_y;
    if (diff < 0) {
        [self scrollToY:diff];
    }
    else {
        [self scrollToY:0];
    }
    
}

@end
