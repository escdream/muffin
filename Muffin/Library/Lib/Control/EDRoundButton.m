//
//  EDRoundButton.m
//  Muffin
//
//  Created by escdream on 2018. 8. 25..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "EDRoundButton.h"

@implementation EDRoundButton
{
    UIColor * saveBackground;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    
    _selectedBackgroundColor = RGB(0x36, 0x1f, 0x69);
    _selectedBorderColor     = RGB(0x36, 0x1f, 0x69);
    
    _borderColor             = RGB(0x36, 0x1f, 0x69);

    saveBackground          = _selectedBorderColor;
    
#if !TARGET_INTERFACE_BUILDER
    
    
#else
    _borderColor = [UIColor blackColor];
    _borderWidth = 2.0f;
    _radius      = 20;
    
    _selectedBackgroundColor = [UIColor blackColor];
    _selectedBorderColor = [UIColor blackColor];
#endif
    
}


- (void) setRadius:(CGFloat)radius
{
    self.layer.cornerRadius = radius;
}
- (void) setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}
- (void) setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}


- (void) setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    if (!enabled)
    {
        self.alpha = 0.3;
    }
    else
    {
        self.alpha = 1.0;
    }
}

- (void) setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    @try {
        if (!self.enabled)
        {
            self.alpha = 0.3;
        }
        else
        {
            self.alpha = 1.0;
            if (selected)
            {
                
                if (self.enabled)
                {
                    saveBackground = self.backgroundColor;
                    self.backgroundColor = self.selectedBackgroundColor;
                    self.layer.borderColor = self.selectedBorderColor.CGColor;
                }
            }
            else
            {
                self.backgroundColor = saveBackground;
                //self.layer.borderColor = self.borderColor.CGColor;
            }
        }
    } @catch (NSException *exception) {
    } @finally {
    }
}

- (void) setUseShadow:(BOOL)useShadow
{
    if (useShadow)
    {
        [self.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.layer setShadowOpacity:0.8];
        [self.layer setShadowRadius:3.0];
        [self.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    }
    else
    {
        [self.layer setShadowRadius:0];
    }
}


- (UIViewController*)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    
    UIViewController * vc = [self topViewController];
    if (vc != nil)
    {
        [vc.view endEditing:YES];
    }
}

@end
