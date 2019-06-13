//
//  UtilAttr.h
//  SmartVIGS
//
//  Created by itgen on 11. 6. 24..
//  Copyright 2011 itgen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ATTR_USE				(unsigned char)0x80
#define ATTR_MASK				(unsigned char)0x70
#define ATTR_BLACK				(unsigned char)0x10
#define ATTR_BLUE				(unsigned char)0x20
#define ATTR_RED				(unsigned char)0x30
#define ATTR_GREEN				(unsigned char)0x40
#define ATTR_BROWN				(unsigned char)0x50
#define ATTR_CYAN				(unsigned char)0x60
#define ATTR_LIGHTRED			(unsigned char)0x70
#define ATTR_REVERSE			(unsigned char)0x02

#define ATTR_NONE				(unsigned char)0x20
#define ATTR_BC_RED_REVERSE		(unsigned char)0x31
#define ATTR_BC_RED				(unsigned char)0x32
#define ATTR_BC_GREEN			(unsigned char)0x33
#define ATTR_BC_BLUE_REVERSE	(unsigned char)0x34
#define ATTR_BC_BLUE			(unsigned char)0x35

//#define ATTR_TR_NONE            '0'
//#define ATTR_TR_RED				'4'
//#define ATTR_TR_GREEN			'5'
//#define ATTR_TR_BLUE			'1'

#define ATTR_TR_NONE            0x20
#define ATTR_TR_RED				0xB0
#define ATTR_TR_GREEN			0xC0
#define ATTR_TR_BLUE			0xA0


//#define FLUCT_NONE				0
//#define FLUCT_LIMIT_UP			2//1   //상한가
//#define FLUCT_UP				1//2   //상승
//#define FLUCT_STEADY			5//3   //보합
//#define FLUCT_LIMIT_DOWN		4//4   //하한가
//#define FLUCT_DOWN				3//5   //하락
//상승 : 1 상한 : 2 하락 : 3 하한 : 4 보합 : 5
//0보합
//1상승
//2상한
//3기세상승
//4기세상한
//5하락
//6하한
//7기세하락
//8기세하한
//9거래없음
#define FLUCT_NONE				0
#define FLUCT_LIMIT_UP			1   //상한가
#define FLUCT_UP				2   //상승
#define FLUCT_STEADY			3   //보합
#define FLUCT_DOWN				5   //하락
#define FLUCT_LIMIT_DOWN		4   //하한가
#define FLUCT_UP2	  	        6   //하한가
#define FLUCT_DOWN2		        7   //하한가

@interface UtilAttr : NSObject {

}
+ (BOOL) isAttrUse:(unsigned char)ucAttr;
+ (UIColor *) getAttrColor:(unsigned char)ucAttr defColor:(UIColor *)defColor;
+ (NSString *) getAttrColorString:(unsigned char)ucAttr defColor:(NSString *)defColor;
+ (int) getSignTypeString:(NSString *)sign;
+ (int) getSignTypeChar:(unsigned char)sign;
+ (Byte) getAttrByte:(NSInteger)data;
+ (unsigned char) getAttrColorKey:(UIColor*)color;
+ (NSString *) getSignVoiceOverString:(NSInteger)sign;

@end
