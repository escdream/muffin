//
//  DrawUtil.m
//  SmartVIGS
//
//  Created by juyoung Kim on 11. 6. 27..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DrawUtil.h"
#import "ResourceManager.h"
#import "UtilAttr.h"
#import "CommonUtil.h"

@implementation DrawUtil

+(void)drawTriangle:(CGContextRef)context Rect:(CGRect)rect Reverse:(BOOL)Type
{    
    NSInteger x = rect.origin.x;
    NSInteger y = rect.origin.y;
    NSInteger w = rect.size.width;
    NSInteger h = rect.size.height;
    
    NSInteger dx = 0;
    NSInteger dy = 0;
    
    //삼각형을 정삼각형으로 만들고 센터에 위치시키기 위한 로직
    if( w < h )
    {
        dy = (h-w)>>1; 
        h = w;
    }
    else if( w > h)
    {
        dx = (w-h)>>1;
        w = h;
    }
    
    NSInteger _w1 = w>>1;
    NSInteger _w2 = w>>2;
//    NSInteger _h1 = h>>1;
    NSInteger _h2 = h>>2;
    
    //삼각형 그리기
    UIColor *color = nil;

    if (Type) {
        color = [[ResourceManager sharedManager] getDownColor];
        CGContextTranslateCTM(context, 0.0, rect.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
    }
    else
    {
        color = [[ResourceManager sharedManager] getUpColor];    
    }
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 1);    
    
    CGContextMoveToPoint(context, x+_w1+dx , y+_h2+dy ) ;
    CGContextAddLineToPoint(context,x + _w2+dx , y+h-_h2+dy);
    CGContextAddLineToPoint(context,x+(w-_w2)+dx ,  y+h-_h2+dy);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
//        CGContextMoveToPoint(context, x+_w1+dx , y+h-_h2+dy );
//        CGContextAddLineToPoint(context,x + _w2+dx , y+_h2+dy);
//        CGContextAddLineToPoint(context,x+(w-_w2)+dx , y+_h2+dy);
}

+(void)drawArr:(CGContextRef)context Rect:(CGRect)rect Reverse:(BOOL)Type
{
    NSInteger x = rect.origin.x;
    NSInteger y = rect.origin.y;
    NSInteger w = rect.size.width;
    NSInteger h = rect.size.height;
    
    NSInteger dx = 0;
    NSInteger dy = 0;
    
    //삼각형을 정삼각형으로 만들고 센터에 위치시키기 위한 로직
    if(w<h) {
        dy = (h-w)/2; 
        h = w;
    }
    else if(w>h) {
        dx = (w-h)/2;
        w = h;
    }
    
    NSInteger _w1 = w>>1;
    NSInteger _w2 = w>>2;
    NSInteger _h1 = h>>1;
    NSInteger _h2 = h>>2;
    
    UIColor *color = nil;
    
    if (Type) {
        color = [[ResourceManager sharedManager] getDownColor];
        CGContextTranslateCTM(context, 0.0, rect.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
    }
    else
    {
        color = [[ResourceManager sharedManager] getUpColor];    
    }
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 1);    

    CGContextAddRect(context, CGRectMake(x+dx+w*2/5, y+_h1+dy+_h2/2, w*1/5, _h2 ));
    
    CGContextMoveToPoint(context, x+_w1+dx , y+_h2/2+dy );
    CGContextAddLineToPoint(context, x + _w2+dx , (y+_h1+dy+_h2/2));
    CGContextAddLineToPoint(context,x+(w-_w2)+dx , (y+_h1+dy+_h2/2));

    CGContextClosePath(context);
    CGContextFillPath(context);
    
}

+(NSString *)drawShapeText:(NSInteger)nIndex
{
    unichar arccode = 0x00;
//    unichar eee = 0xE405;   // 두품한 상한가  화살표 
//    unichar ccc = 0xE406;   // 두툼한 하한가 화살표      
//    0xE2C7; break;    // 상한가 화살표
//    0x25B2; break;         // 상승 화살표
//    0xE2C8; break;         // 하한가 화살표
//    0x25bC; break;         // 하락 화살표
	
	
	// 윤고딕 777
	// 상승		: 25B2 (1)
	// 상한		: E000 (2)
	// 기세상승	: 25B3
	// 기세상한	: E002
	// 하락		: 25BC (3)
	// 하한		: E001 (4)
	// 기세하락	: 25BD
	// 기세하한	: E003
	// 보합		: (5)
	//상승 : 1 상한 : 2 하락 : 3 하한 : 4 보합 : 5
    
//    switch (nIndex) {
//        case FLUCT_LIMIT_UP:        arccode = 0xE000; break;    // 상한가 화살표
//        case FLUCT_UP:              arccode = 0x25B2; break;         // 상승 화살표
//        case FLUCT_LIMIT_DOWN:      arccode = 0xE001; break;         // 하한가 화살표
//        case FLUCT_DOWN:            arccode = 0x25bC; break;         // 하락 화살표
    
    switch (nIndex) {
        case FLUCT_LIMIT_UP:        return @"⬆"; break;    // 상한가 화살표
        case FLUCT_UP:              return @"▲"; break;         // 상승 화살표
        case FLUCT_NONE:            return @" "; break; // 보합
        case FLUCT_LIMIT_DOWN:      return @"▼"; break;         // 하한가 화살표
        case FLUCT_DOWN:            return @"⬇"; break;         // 하락 화살표
			
//#define STOCK_SYMBOL_MAXUP	 @"⬆"
//#define STOCK_SYMBOL_UP	 @"▲"
//#define STOCK_SYMBOL_ZERO	 @" "
//#define STOCK_SYMBOL_DOWN	 @"▼"
//#define STOCK_SYMBOL_MAXDOWN	@"⬇"
    }
    return [NSString stringWithCharacters:&arccode length:sizeof(arccode) - 1];
}
+(void)drawText:(CGContextRef)context text:(NSString*)drawtext textcolor:(UIColor*)tColor Rect:(CGRect)rect HAlign:(NSInteger)HAlign VAlign:(NSInteger)VAlign font:(UIFont *)font
{
    CGContextSetStrokeColorWithColor(context, tColor.CGColor);
    CGContextSetFillColorWithColor(context, tColor.CGColor);
    CGSize shapeSize = [drawtext sizeWithFont:font constrainedToSize:rect.size lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat fontsize = font.pointSize;
//    CGSize shapeSize = [drawtext sizeWithFont:font minFontSize:6 actualFontSize:&(fontsize) forWidth:rect.size.width  lineBreakMode:NSLineBreakByWordWrapping];
    CGPoint shapePoint = CGPointMake(rect.origin.x, rect.origin.y);
    switch (VAlign) {
        case 0:
        {
            shapePoint.y = shapePoint.y + 0; // 2 보정값
            break;
        }
        case 1:
        {
            shapePoint.y = rect.origin.y+ (rect.size.height - shapeSize.height) / 2;
            break;
        }
        case 2:
        {
            shapePoint.y = rect.origin.y + rect.size.height - shapeSize.height - 2;   // 2 보정값
            break;
        }
            
        default:
            break;
    }
    
    switch (HAlign) {
        case 0:
        {
            shapePoint.x = rect.origin.x + 2;
            break;
        }
        case 1:
        {
            shapePoint.x = rect.origin.x + (rect.size.width - shapeSize.width) / 2;
            break;
        }
        case 2:
        {
            shapePoint.x = rect.origin.x + rect.size.width - shapeSize.width - 2;
            break;
        }
        default:
            break;
    }
    CGFloat actual = font.xHeight;
    [drawtext drawAtPoint:shapePoint forWidth:rect.size.width withFont:font minFontSize:6 actualFontSize:&actual lineBreakMode:NSLineBreakByClipping baselineAdjustment:UIBaselineAdjustmentAlignCenters];
    
}

+(void)drawSign:(CGContextRef)context DrawType:(NSInteger)type Rect:(CGRect)rect HAlign:(NSInteger)HAlign VAlign:(NSInteger)VAlign font:(UIFont *)font
{
//    if (type < 0 && type > 6 ) return;
    ResourceManager *ResMngr = [ResourceManager sharedManager];
//    UIColor *color = nil;
//    switch (type) {
//        case FLUCT_LIMIT_UP:    { color = [ResMngr getUpColor]; break; }
//        case FLUCT_UP:          { color = [ResMngr getUpColor]; break; }
//        case FLUCT_STEADY:      { break; }
//        case FLUCT_LIMIT_DOWN:  { color = [ResMngr getDownColor]; break; }
//        case FLUCT_DOWN:        { color = [ResMngr getDownColor]; break; }
//        default: break;
//    }
//    
    NSString *shapetext = [self drawShapeText:type];
    CGSize shapeSize = [shapetext sizeWithFont:font];
    
    //이미지모드 추가
    shapeSize.width = shapeSize.height;
    
    CGRect shapeRect = rect;
    //이미지모드 추가
    UIImage *signImg = nil;
    switch (type) {
        case FLUCT_LIMIT_UP:
		{ signImg = [ResMngr getUICacheImage:@"ico_arrow_02_up_blank.png" imageOfSize:rect.size]; break; }
        case FLUCT_UP:
		{ signImg = [ResMngr getUICacheImage:@"ico_arrow_01_up.png" imageOfSize:rect.size]; break; }
        case FLUCT_STEADY:
//        { signImg = [ResMngr getUICacheImage:@"ico_arrow_01_zero.png" imageOfSize:rect.size]; break; }
            break;
        case FLUCT_LIMIT_DOWN:
		{ signImg = [ResMngr getUICacheImage:@"ico_arrow_02_down_blank.png" imageOfSize:rect.size]; break; }
        case FLUCT_DOWN:
		{ signImg = [ResMngr getUICacheImage:@"ico_arrow_01_down.png" imageOfSize:rect.size]; break; }
        case FLUCT_UP2:
        { signImg = [ResMngr getUICacheImage:@"ic_bullet_up3.png" imageOfSize:rect.size]; break; }
        case FLUCT_DOWN2:
        { signImg = [ResMngr getUICacheImage:@"ic_bullet_down3.png" imageOfSize:rect.size]; break; }
        default: break;
    }
	
    CGFloat nImgWidth = CALCUTIL_VERT_WIDTH(signImg.size.width / 2);	// shapeSize.width;
    int nImgHeight = CALCUTIL_VERT_WIDTH(signImg.size.height / 2); 	// shapeSize.height;
	
    switch (VAlign) {
        case 0:
        {
            shapeRect.origin.y += 2;
            break;
        }
        case 1:
        {
            shapeRect.origin.y = ((shapeRect.size.height - nImgHeight) /2);
            break;
        }
        case 2:
        {
            shapeRect.origin.y = shapeRect.size.height - nImgHeight - 2;
            break;
        }
            
        default:
            break;
    }
    
    switch (HAlign) {
        case 0:
        {
            shapeRect.origin.x += 2;
            break;
        }
        case 1:
        {
            shapeRect.origin.x += (CGRectGetWidth(rect) - nImgWidth) / 2;
            break;
        }
        case 2:
        {
            shapeRect.origin.x += CGRectGetWidth(rect) - nImgWidth - 2;
            break;
        }
        case 3:
        {
            shapeRect.origin.x = rect.origin.x;
            break;
        }
        default:
            break;
    }
    
    
    shapeRect.size.width  = nImgWidth;
    shapeRect.size.height = nImgHeight;
	
    if (signImg != nil) {
        CGContextTranslateCTM(context, 0, rect.origin.y + rect.size.height);
        CGContextScaleCTM(context, 1.f, -1.f);
        CGContextDrawImage(context, shapeRect, signImg.CGImage);
        CGContextTranslateCTM(context, 0, rect.origin.y + rect.size.height);
        CGContextScaleCTM(context, 1.f, -1.f);
    }
}


+(NSInteger)getTextVAlignPos:(NSInteger)nTextAlign Height:(NSInteger)height TextHeight:(NSInteger)textHeight
{
    NSInteger yPos = - 1;
    switch (nTextAlign) {
        case 0:
        {
            yPos = 2;    // 마진
            break;            
        }
        case 1:
        {
            yPos = (height - textHeight) / 2;
            break;
        }
        case 2:
        {
            yPos = height - textHeight;
            break;
        }
        default:
            break;
    }
    return yPos;
}

+ (int) getRealUpDown:(int) nUpDown
{
	if(nUpDown == 1 || nUpDown == 3) return 1;
	if(nUpDown == 5 || nUpDown == 7) return 2;
	if(nUpDown == 0 || nUpDown == 9) return 5;
	if(nUpDown == 2 || nUpDown == 4) return 3;
	if(nUpDown == 6 || nUpDown == 8) return 4;
	return 5;
}

@end
