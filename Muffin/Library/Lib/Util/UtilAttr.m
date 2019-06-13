//
//  UtilAttr.m
//  SmartVIGS
//
//  Created by itgen on 11. 6. 24..
//  Copyright 2011 itgen. All rights reserved.
//

#import "UtilAttr.h"
#import "DataAttr.h"
#import "ResourceManager.h"


@implementation UtilAttr


+ (UIColor *) getAttrColor:(unsigned char)ucAttr defColor:(UIColor *)defColor
{
	if( ucAttr == ATTR_NONE )
		return defColor;

	if(ucAttr == ATTR_TR_NONE)
		return [[ResourceManager sharedManager] getBasicTextColor];
	else if	(ucAttr == ATTR_TR_BLUE)
		return [[ResourceManager sharedManager] getDownColor];
	else if	(ucAttr == ATTR_TR_RED)
		return [[ResourceManager sharedManager] getUpColor];
	else if	(ucAttr == ATTR_TR_GREEN)
		return [[ResourceManager sharedManager] getSteadyColor];

	return defColor;
}

+ (unsigned char) getAttrColorKey:(UIColor*)color
{
	if ([[ResourceManager sharedManager] getBasicTextColor] == color)
		return ATTR_TR_NONE;
	else if ([[ResourceManager sharedManager] getDownColor] == color)
		return ATTR_TR_BLUE;
	else if ([[ResourceManager sharedManager] getUpColor] == color)
		return ATTR_TR_RED;
	else if ([[ResourceManager sharedManager] getSteadyColor] == color)
		return ATTR_TR_GREEN;
	return ATTR_TR_NONE;
}


+ (NSString *) getAttrColorString:(unsigned char)ucAttr defColor:(NSString *)defColor
{
	if( ucAttr == ATTR_NONE )
		return defColor;
	
	if(ucAttr == ATTR_TR_NONE)
		return defColor;
	else if	(ucAttr == ATTR_TR_BLUE)
		return @"002:000000255";
	else if	(ucAttr == ATTR_TR_RED)
		return @"001:255000000";
	else if	(ucAttr == ATTR_TR_GREEN)
		return @"003:025025025";
	
	return defColor;
}


+ (BOOL) isAttrUse:(unsigned char)ucAttr
{
	if( ucAttr == ATTR_NONE ) return FALSE;
	
	int nAttr = ucAttr & 0xff;
	
	if( (nAttr & 0x80) != 0 )
	{
		if( (nAttr & ATTR_MASK) != 0 ) return TRUE;
	}
	else
	{
		if( ucAttr >= 0x31) return TRUE;
	}
	
	return FALSE;
}

+ (int) getSignTypeString:(NSString *)sign
{
	const char *sSignValue = [sign cStringUsingEncoding:NSUTF8StringEncoding];
	if( sSignValue == nil ) return 0;
	
	return [self getSignTypeChar:(unsigned char)sSignValue[0]];
}

+ (int) getSignTypeChar:(unsigned char)sign
{
	switch( sign )
	{		
		// 가격변화구분(0:보합,1:상승,2:상한,3:기세상승,4:기세상한,5:하락,6:하한,7:시세하락,8:기세하한,9:거래없음)
		case (unsigned char)0x32:
		case (unsigned char)0x34:
			return FLUCT_LIMIT_UP;
			break;
		case (unsigned char)0x31:
		case (unsigned char)0x33:
			return FLUCT_UP;
			break;
		case (unsigned char)0x30:
		case (unsigned char)0x39:
			return FLUCT_STEADY;
			break;
		case (unsigned char)0x36:
		case (unsigned char)0x38:
			return FLUCT_LIMIT_DOWN;
			break;
		case (unsigned char)0x35:
		case (unsigned char)0x37:
			return FLUCT_DOWN;
			break;
	}
	return FLUCT_NONE;
}

+(Byte) getAttrByte :(NSInteger) data
{
    unsigned char retVal = (Byte)((data) & 0xFF);
    return (Byte)retVal;
}

+ (NSString *) getSignVoiceOverString:(NSInteger)sign
{
	switch( sign )
	{
			// 가격변화구분(0:보합,1:상승,2:상한,3:기세상승,4:기세상한,5:하락,6:하한,7:시세하락,8:기세하한,9:거래없음)
		case FLUCT_LIMIT_UP:
			return @"상한";
			break;
		case FLUCT_UP:
			return @"상승";
			break;
		case FLUCT_STEADY:
			return @"보합";
			break;
		case FLUCT_LIMIT_DOWN:
			return @"하한";
			break;
		case FLUCT_DOWN:
			return @"하락";
			break;
	}
	return @"";
}


@end
