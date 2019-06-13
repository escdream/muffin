//
//  EDRoundView.m
//  Muffin
//
//  Created by escdream on 2018. 8. 24..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "EDRoundView.h"

@implementation EDRoundView

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
    
    
#if !TARGET_INTERFACE_BUILDER

    
#else
    _borderColor = [UIColor blackColor];
    _borderWidth = 2.0f;
    _radius      = 20;
#endif
    
    
/*
    self.layer.borderColor = _borderColor.CGColor;
    self.layer.cornerRadius = _radius;
    self.layer.borderWidth = _borderWidth;
*/
    [self setNeedsDisplay];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _borderColor = [UIColor blackColor];
        _borderWidth = 2.0f;
        _radius      = 20;

    }
    return self;
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


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    
//    CGPoint location = [touch locationInView:self.view];
    
    [self endEditing:YES];
    
}

@end
