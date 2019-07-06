//
//  EDTabstyleView.m
//  Muffin
//
//  Created by escdream on 2018. 9. 4..
//  Copyright © 2018년 ESCapeDREAM. All rights reserved.
//

#import "EDTabstyleView.h"

@interface EDTabstyleView ()
{
    NSString* sTabTitle;
}
@end

@implementation EDTabstyleView

@synthesize tabViewList, marginWidth;

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
    
    [self addTab:@"test1"];
    [self addTab:@"test2"];
    [self addTab:@"test3"];
    [self addTab:@"test3"];
    
    _borderColor = [UIColor blackColor];
    _borderWidth = 2.0f;
    _radius      = 20;
#endif
}

- (void) initLayout
{
    tabButtonList = [[NSMutableArray alloc] init];
    
    tabViewList = [[NSMutableArray alloc] init];
    tabUnderline  = [[UIView alloc] init];
    tabIndicator  = [[UIView alloc] init];
    
    tabParent     = [[UIView alloc] init];
    
    scrollClient  = [[UIScrollView alloc] init];

    pager = [[UIPageControl alloc] init];
    
    scrollClient.delegate = self;
    
    overContentView = 3.0f;
    self.marginBottom = 20.0f;
    
    self.tabHeight = 60.0f;
    
    CGRect r = self.bounds;
    r.size.height = self.tabHeight;
    tabParent.frame = r;
    
    r.origin.y = self.tabHeight;
    r.size.height = self.bounds.size.height - self.tabHeight;
    scrollClient.frame = r;

    scrollClient.pagingEnabled = YES;
    
    [self addSubview:tabParent];
    [self addSubview:scrollClient];
    
    self.noramlTextColor = [UIColor blackColor];
    self.selectTextColor = [UIColor blackColor];
    
    self.underlineColor = [UIColor blackColor];
    self.indicatorColor = [UIColor blackColor];
    self.selectIndex    = 0;

    marginWidth = 8.0f;
    
    _borderColor = [UIColor blackColor];
    _borderWidth = 2.0f;
    _radius      = 20;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    [self calcTabLayouts];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initLayout];
    }
    return self;
}

- (void) addTab:(NSString *) sTitle
{
    UIButton * btn = [[UIButton alloc] init];
    
    [btn setTitle:sTitle forState:UIControlStateNormal];
    [btn setTitleColor:self.noramlTextColor forState:UIControlStateNormal];
    [btn setTitleColor:self.selectTextColor forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(onTabClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [tabButtonList addObject:btn];
    
    [tabParent addSubview:btn];

    UIScrollView * sv = [[UIScrollView alloc] init];
    sv.backgroundColor = [UIColor clearColor];// RGB(random()%255, random()%255, random()%255);
    [tabViewList addObject:sv];
    [scrollClient addSubview:sv];
    
    [self calcTabLayouts];
}

- (void) addTab:(NSString *) sTitle subView:(UIView *) subView;
{
    UIButton * btn = [[UIButton alloc] init];
    
    [btn setTitle:sTitle forState:UIControlStateNormal];
    [btn setTitleColor:self.noramlTextColor forState:UIControlStateNormal];
    [btn setTitleColor:self.selectTextColor forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(onTabClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [tabButtonList addObject:btn];
    
    [tabParent addSubview:btn];

    UIScrollView * sv = [[UIScrollView alloc] init];
    sv.backgroundColor = [UIColor clearColor];// RGB(random()%255, random()%255, random()%255);
    [tabViewList addObject:sv];
    [scrollClient addSubview:sv];

    [sv addSubview:subView];
    [sv willRemoveSubview:subView];
    [self calcTabLayouts];

}

- (NSString*) currentTabTitle
{
    return sTabTitle;
}

- (void) removeSubViewFromTab:(int) nIndex superView:(UIView *) superView;
{
    UIScrollView * sv = tabViewList[nIndex];

    for (UIView * v in superView.subviews)
    {
        if (v == sv)
        {
            [sv removeFromSuperview];
        }
    }
}

- (void) removeTab:(int) nIndex
{
    UIButton * b = tabButtonList[nIndex];
    UIScrollView * sv = tabViewList[nIndex];
    
    for (UIView * v in tabParent.subviews)
    {
        if (v == b)
        {
            [v removeFromSuperview];
        }
        if (v == sv)
        {
            [sv removeFromSuperview];
        }
    }
    [tabButtonList removeObjectAtIndex:nIndex];
    [tabViewList removeObjectAtIndex:nIndex];
    
    [self calcTabLayouts];
}

- (void) doTabClick:(int) nIndex {
    [self onTabClick:tabButtonList[nIndex]];
}

- (NSString*) getTabTitle:(int) nIndex {
    UIButton * btn = tabButtonList[nIndex];
    return btn.titleLabel.text;
}

- (void) changeTab:(NSString *) sTitle nIndex:(int) nIndex
{
    UIButton * btn = tabButtonList[nIndex];
    [btn setTitle:sTitle forState:UIControlStateNormal];

    [self calcTabLayouts];
}

- (CGRect) getClientRect
{
    CGRect r = CGRectMake(0, 0, frameWidth, frameHeight);
    r.size.height = r.size.height;
    
    return r;
}

- (void) calcTabLayouts
{

    CGRect r = self.bounds;
    
    r.origin.x = marginWidth;
    r.size.width -= (marginWidth * 2);
    
    r.size.height = self.tabHeight;
    tabParent.frame = r;
    
    r.origin.y = self.tabHeight + overContentView;
    r.size.height = self.bounds.size.height - self.tabHeight - overContentView;
    
    scrollClient.frame = r;
    scrollClient.contentSize = CGSizeMake(self.bounds.size.width * tabButtonList.count, 0);
    
    buttonWidth = (tabParent.frame.size.width / tabButtonList.count);

    frameWidth = self.bounds.size.width - (marginWidth * 2);
    frameHeight = scrollClient.frame.size.height - _marginBottom;
    
    for (int i=0; i<tabButtonList.count; i++)
    {
        UIButton * btn = tabButtonList[i];

        r = CGRectMake(buttonWidth*i, 0, buttonWidth, self.tabHeight);

        btn.frame = r;
        btn.tag = i;

        // view
        UIScrollView * v = tabViewList[i];
        r = CGRectMake(frameWidth*i, 0, frameWidth, frameHeight);
        v.frame = r;
        v.tag = i;
    };
    
    r = self.bounds;
    r.origin.x = marginWidth;
    r.size.width -= (marginWidth * 2);
    r.origin.y = self.tabHeight-1;
    r.size.height = 1;
    tabUnderline.frame = r;
    tabUnderline.backgroundColor = _underlineColor;
    [self addSubview:tabUnderline];
    [self bringSubviewToFront:tabUnderline];
    
    
    r = scrollClient.frame;
    r.origin.y = self.tabHeight;
    r.size.height = self.bounds.size.height - self.tabHeight;
    scrollClient.frame = r;

    
    r = tabParent.bounds;

    r.size.width = buttonWidth;
    r.size.height = 3;

    r.origin.x  = marginWidth + (buttonWidth * self.selectIndex) ;
    r.origin.y  = self.tabHeight - 2;
    
    tabIndicator.frame = r;
    tabIndicator.backgroundColor = self.indicatorColor;
    
    [self addSubview:tabIndicator];
}

- (void) onTabClick:(UIButton *) btn
{
    self.selectIndex = btn.tag;
    btn = tabButtonList[self.selectIndex];
    sTabTitle = btn.titleLabel.text;
    
    [self.superview endEditing:YES];
    [UIView animateWithDuration:0.3f animations:^(void)
     {
         
         CGRect r = self->tabIndicator.frame;
         r.origin.x = self.marginWidth + (self->buttonWidth * self.selectIndex);
         
         self->scrollClient.contentOffset = CGPointMake(self.selectIndex * self->frameWidth, 0);
         
         self->tabIndicator.frame = r;
     }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    NSInteger currentOffset = offset.x;
    NSInteger nWidth = frameWidth;
//    CGRect bounds = scrollView.bounds;
//    CGSize size = scrollView.contentSize;
//    UIEdgeInsets inset = scrollView.contentInset;
//    float y = offset.y + bounds.size.height - inset.bottom;
//    float h = size.height;
//
//
    NSLog(@"x = %f Index = %d", offset.x, self.selectIndex);
    self.selectIndex = (currentOffset / nWidth);
    if (currentOffset % nWidth  == 0)
    {
        [self onTabClick:tabButtonList[self.selectIndex]];
    }

//
//    if (self.selectIndex != nSelect)
//    {
//        //self.selectIndex = select;
//        [self onTabClick:tabButtonList[nSelect]];
//    }
//
}

-(void) tabChange:(int)nIndex;
{
    self.selectIndex = nIndex;
    [self onTabClick:tabButtonList[self.selectIndex]];
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


@end
