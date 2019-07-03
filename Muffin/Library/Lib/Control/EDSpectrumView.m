//
//  EDSpectrumView.m
//  ExampleApp
//
//  Created by JoonHo Kang on 03/07/2019.
//  Copyright © 2019 Thong Nguyen. All rights reserved.
//

#import "EDSpectrumView.h"

@implementation EDSpectrumView
{
    int nPos;
    CGFloat arrSpectrum[30];
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGFloat gabX = rect.size.width/20, gabY = rect.size.height/20;
    CGFloat gab = 1;
    CGRect rectClient = CGRectInset(rect, gabX, gabY);

    CGFloat w = (rectClient.size.width - (gab*_nCount))/_nCount;
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSaveGState(context);

    CGFloat scale = rectClient.size.height / 100;
    CGFloat sx = rectClient.origin.x;
    
    for (int i=0; i<_nCount; i++)
    {
        
        CGFloat h = arrSpectrum[i] * scale ;
        CGFloat y = rectClient.size.height - h;
        
        CGRect r = CGRectMake(sx, y, w, h);
        
        CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
        CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
        CGContextFillRect(context, r);
        
        sx += (w + gab);
    }
    
    CGContextRestoreGState(context);
}


- (id) initWithCount:(int) nCount;
{
    self = [super init];
    if (self)
    {
         self.opaque = NO;
        _nCount = nCount;
        [self clearData];
    }
    return self;
}

- (void) clearData
{
    for (int i=0; i<30; i++)
        arrSpectrum[i] = 0.0;
}

- (void) appendData:(float) fValue
{
    for (int i=_nCount-2; i>=0; i--)
    {
        CGFloat num = arrSpectrum[i];
        arrSpectrum[i+1] = num;
    }
    
    arrSpectrum[0] =  fValue * 100;

    [self setNeedsDisplay];
}



@end
