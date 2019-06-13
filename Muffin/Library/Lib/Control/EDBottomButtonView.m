//
//  EDBottomButtonView.m
//  Muffin
//
//  Created by escdream on 2018. 10. 22..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "EDBottomButtonView.h"
#import "EDRoundView.h"
#import "ResourceManager.h"

@implementation EDBottomButtonView
{
    EDRoundView *viewBackground;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void) initData
{
    _arrButtons = [[NSMutableArray alloc] init];
    viewBackground = [[EDRoundView alloc] init];
    
    self.backgroundColor = [UIColor whiteColor];
    viewBackground.backgroundColor = RGB(0x3e, 0x3e, 0x3e);
    viewBackground.radius = 10;
    viewBackground.borderColor = viewBackground.backgroundColor;
    viewBackground.borderWidth = 1.0f;
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:viewBackground];
}

- (id) init
{
    self = [super init];
    
    if (self)
    {
        [self initData];
    }
    
    return self;
}


- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self initData];
    }
    
    return self;
}

- (void) setFrame:(CGRect)frame
{
    // Call the parent class to move the view
    [super setFrame:frame];
    
    [self buildLayout];
    
    
}

- (void) clearLayout
{
    for (UIButton * btn in viewBackground.subviews)
    {
        [btn removeFromSuperview];
    }
    
    [_arrButtons removeAllObjects];
}

- (void) alignPosition:(UIView *) parentView
{
    CGRect r = parentView.frame;
    
    
    r.origin.y = r.size.height - 40;
    r.size.height = 80;
    self.frame = r;
    
    [self buildLayout];
}

- (void) buildLayout;
{
    CGRect r = self.frame;
    
    r.origin.x = 10;
    r.origin.y = 0;
    r.size.width = self.frame.size.width - (20);
    r.size.height = (self.frame.size.height ) * 2;
    
    viewBackground.frame = r;
    
    CGFloat bw =  r.size.width / _arrButtons.count;
    
    CGRect br = CGRectMake(0, 0, bw, self.frame.size.height - 2);
    for (int i=0; i<_arrButtons.count; i++)
    {
        UIButton * btn = _arrButtons[i];
        btn.frame = br;
        br.origin.x = (i * bw);
        btn.frame = br;
        
        UIView *vLine = [btn viewWithTag:101];
        
        if (vLine)
        {
            CGRect sr = br;
            
            
            sr.origin.x = sr.size.width - 1;
            sr.origin.y = br.size.height * 0.2;
            sr.size.width = 1;
            sr.size.height = sr.size.height * 0.6 ;
            vLine.frame = sr;
            vLine.backgroundColor = RGB(0x55, 0x55, 0x55);
        }
    }
    
    
    [self.superview bringSubviewToFront:self];
}

- (void) addButtons:(NSString *) sTitle obj:(id) obj withSelector:(SEL)sel tag:(int) ntag;
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setTitle:sTitle forState:UIControlStateNormal];
    btn.tag = ntag;
    btn.backgroundColor = [UIColor clearColor];
    btn.titleLabel.font = [[ResourceManager sharedManager] getFontWithSize:17.0f];

    if (sel && obj)
        [btn addTarget:obj action:sel forControlEvents:UIControlEventTouchUpInside];
    
    [_arrButtons addObject:btn];
    
    int idx = [_arrButtons indexOfObject:btn];
    
    if (_arrButtons.count > 1 && idx <= _arrButtons.count - 1)
    {
        UIView * vLine = [[UIView alloc] init];
        
        vLine.tag = 101;

        idx--;
        if (idx < 0) idx = 0;
        
        UIButton * prevBtn = _arrButtons[idx];
        [prevBtn addSubview:vLine];
    }
    
    [viewBackground addSubview:btn];
    
    [self buildLayout];
}

- (int) getButtonTag:(int)nIdx
{
    UIButton * btn = _arrButtons[nIdx];
    if (btn != nil)
    {
        return btn.tag;
    }
    return 0;
}

- (NSString*) getButtonTitle:(int)nIdx;
{
    UIButton * btn = _arrButtons[nIdx];
    if (btn != nil)
    {
        return btn.titleLabel.text;
    }
    return @"";
}

- (void) setChangeButtonTitle:(int)nIdx sTitle:(NSString*)sTitle tag:(int)nTag;
{
    UIButton * btn = _arrButtons[nIdx];
    if (btn != nil)
    {
        btn.tag = nTag;
        [btn setTitle:sTitle forState:UIControlStateNormal];
//        btn.backgroundColor = [UIColor clearColor];
//        btn.titleLabel.font = [[ResourceManager sharedManager] getFontWithSize:17.0f];
    }
}

-(void)removeButton:(int)nIdx;
{
    [_arrButtons removeObjectAtIndex:nIdx];
}

-(void)removeAllButton;
{
    [_arrButtons removeAllObjects];
}


@end
