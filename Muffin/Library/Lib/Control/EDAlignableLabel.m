//
//  EDAlignableLabel.m
//
//  Created by JoonHo Kang on 12/03/2019.
//  Copyright © 2019 ESCapeDREAM. All rights reserved.
//

#import "EDAlignableLabel.h"

@implementation EDAlignableLabel


- (id) init
{
    self = [super init];
    {
        self.contentMode = UIViewContentModeCenter;
        self.backgroundColor = [UIColor clearColor];
        self.minimumScaleFactor = 0.6f;
        self.isAutoLineCount = YES;
        self.opaque = NO;
    };
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//
//
//    [super drawRect:rect];
//
//
//}

- (CGSize) calcTextWidth:(NSString *) sText :(UIFont *)aFont;
{
    NSDictionary *userAttributes = @{NSFontAttributeName: aFont,
                                     NSForegroundColorAttributeName: [UIColor blackColor]};
    return [sText sizeWithAttributes: userAttributes];
}


- (void) calcAutoFontSize
{
    UIFont * tmpFont = [UIFont systemFontOfSize:self.font.pointSize * self.minimumScaleFactor];
    
    CGSize sz = [self calcTextWidth:self.text :tmpFont ];
    
    if (!CGRectIsEmpty(self.bounds) && (sz.width > (self.bounds.size.width)) && _isAutoLineCount )
    {
        self.font = tmpFont;
        self.numberOfLines = 2;
    }
    else
        self.numberOfLines = 1;
    
}

- (void)setText:(NSString *)text
{
    [super setText:text];

    [self calcAutoFontSize];
}

- (void) setIsAutoLineCount:(BOOL)isAutoLineCount
{
    _isAutoLineCount = isAutoLineCount;
    
    [self calcAutoFontSize];
}



- (void)drawTextInRect:(CGRect) rect{


    CGSize sizeThatFits = [self sizeThatFits:rect.size];
    
    
    if (self.contentMode == UIViewContentModeTop) {
        rect.size.height = MIN(rect.size.height, sizeThatFits.height);
    }
    else if (self.contentMode == UIViewContentModeBottom) {
        rect.origin.y = MAX(0, rect.size.height - sizeThatFits.height);
        rect.size.height = MIN(rect.size.height, sizeThatFits.height);
    }
    
    [super drawTextInRect:rect];
}


@end
