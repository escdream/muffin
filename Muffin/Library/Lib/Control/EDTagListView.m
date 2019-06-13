//
//  EDTagListView.m
//  Muffin
//
//  Created by escdream on 2018. 10. 28..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "EDTagListView.h"
#import "ResourceManager.h"

@implementation EDTagListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) init
{
    self = [super init];
    if (self)
    {
        dicTag = [[NSMutableDictionary alloc] init];
        _buttonHeight = 20;
        _buttonMinWidth = 20;
        
        _normalTextColor = RGB(0, 0, 0);
        _selectTextColor = RGB(255, 255, 255);

        _normalColor = RGB(255, 255, 255);
        _selectColor = RGB(0, 0, 0);
        
        _buttonFont = [[ResourceManager sharedManager] getFontBoldWithSize:12];
        
        self.radius = _buttonHeight / 2;
    }
    
    return self;
}

- (void) addTag:(NSString *) sTagString sData:(NSString *)sData;
{
    dicTag[sTagString] = sData;
}

- (void) removeTag:(NSString *) sTagString;
{
    [dicTag removeObjectForKey:sTagString];
}

- (void) clearTags
{
    for (EDRoundButton * btn in self.subviews)
    {
        [btn removeFromSuperview];
    }

    [dicTag removeAllObjects];
}

- (void) buildLayout
{
    for (EDRoundButton * btn in self.subviews)
    {
        [btn removeFromSuperview];
    }
    
    NSArray * arrTags = [dicTag allKeys];
    
    CGRect r = CGRectZero;
    CGPoint pt = CGPointZero;
    
    CGFloat gap = 4.0f;
    CGFloat margin = 3.0f;
    
    for (NSString * sKey in arrTags)
    {
        EDRoundButton * btn = [EDRoundButton buttonWithType:UIButtonTypeCustom];
        [btn.titleLabel setFont:self.buttonFont];
        
        CGSize sz = [sKey sizeWithFont:btn.titleLabel.font];
        
        sz.width += margin * 2;
        
        if (sz.width < _buttonMinWidth)
            sz.width = _buttonMinWidth;
        
        
        CGRect btnRect = CGRectMake(pt.x, pt.y, sz.width, sz.height);
        

        pt.x += sz.width + margin;
    }
    
}



@end
