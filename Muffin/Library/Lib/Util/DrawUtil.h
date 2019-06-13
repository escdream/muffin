//
//  DrawUtil.h
//  SmartVIGS
//
//  Created by juyoung Kim on 11. 6. 27..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DrawUtil : NSObject {
    
}

+(NSString *)   drawShapeText:(NSInteger)nIndex;
+(void)         drawText:(CGContextRef)context text:(NSString*)drawtext textcolor:(UIColor*)tColor Rect:(CGRect)rect HAlign:(NSInteger)HAlign VAlign:(NSInteger)VAlign font:(UIFont *)font;
+(void)         drawSign:(CGContextRef)context DrawType:(NSInteger)type Rect:(CGRect)rect HAlign:(NSInteger)HAlign VAlign:(NSInteger)VAlign font:(UIFont*)font;
+(void)         drawTriangle:(CGContextRef)context Rect:(CGRect)rect Reverse:(BOOL)Type;
+(void)         drawArr:(CGContextRef)context Rect:(CGRect)rect Reverse:(BOOL)Type;
+(NSInteger)    getTextVAlignPos:(NSInteger)nTextAlign Height:(NSInteger)height TextHeight:(NSInteger)textHeight;
+(int)			getRealUpDown:(int) nUpDown;
@end
