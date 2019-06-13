//
//  HangulUtils.m
//  SmartVIGS
//
//  Created by juyoung Kim on 11. 4. 22..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HangulUtils.h"
#import "CommonUtil.h"

#define HANGUL_BEGIN_UNICODE	44032 // 가
#define HANGUL_END_UNICODE		55203 // 힣
#define HANGUL_BASE_UNIT		588

// 참고 유니코드값 = 44032 + 초성번호*21*28 + 중성번호*28 +종성번호
@implementation HangulUtils

+ (HangulUtils *) GetInstance:(BOOL)isrelease
{
    static HangulUtils *hangulUtils = nil;
    if (hangulUtils == nil) hangulUtils = [[HangulUtils alloc] init];
    
    if (isrelease)
    {
        hangulUtils = nil;
        
        return nil;
    }
    
    return hangulUtils;
}

- (id) init
{
	self = [super init];
	if( self )
	{
		[self initInitialSound];
        resultBuffer = [[NSMutableString alloc] init];
	}
	return self;
}

- (void) initInitialSound
{
	arrayChosung  = [[NSArray alloc] initWithObjects:@"ㄱ",@"ㄲ",@"ㄴ",@"ㄷ",@"ㄸ",@"ㄹ",@"ㅁ",@"ㅂ",@"ㅃ",@"ㅅ",@"ㅆ",@"ㅇ",@"ㅈ",@"ㅉ",@"ㅊ",@"ㅋ",@"ㅌ",@"ㅍ",@"ㅎ",nil];
	arrayJungSung = [[NSArray alloc] initWithObjects:@"ㅏ",@"ㅐ",@"ㅑ",@"ㅒ",@"ㅓ",@"ㅔ",@"ㅕ",@"ㅖ",@"ㅗ",@"ㅘ",@"ㅙ",@"ㅚ",@"ㅛ",@"ㅜ",@"ㅝ",@"ㅞ",@"ㅟ",@"ㅠ",@"ㅡ",@"ㅢ",@"ㅣ",nil];
	arrayJongSung = [[NSArray alloc] initWithObjects:@""  ,@"ㄱ",@"ㄲ",@"ㄳ",@"ㄴ",@"ㄵ",@"ㄶ",@"ㄷ",@"ㄹ",@"ㄺ",@"ㄻ",@" ㄼ",@"ㄽ",@"ㄾ",@"ㄿ",@"ㅀ",@"ㅁ",@"ㅂ",@"ㅄ",@"ㅅ",@"ㅆ",@"ㅇ",@"ㅈ",@"ㅊ",@"ㅋ",@" ㅌ",@"ㅍ",@"ㅎ",nil];
}

-(NSString *) getHangulInitialSound : (NSString *)value ChoList:(BOOL)isChoList
{
	[resultBuffer setString:@""];
    
	value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	for( int i = 0 ; i < [value length] ; i++ ) 
	{
		NSInteger code = [value characterAtIndex:i];
		if( (code >= HANGUL_BEGIN_UNICODE) && (code <= HANGUL_END_UNICODE) ) 
		{				
			NSInteger uniCode	   = code - HANGUL_BEGIN_UNICODE;				
			NSInteger chosungIndex = uniCode / HANGUL_BASE_UNIT;
			
            [resultBuffer appendString:[arrayChosung objectAtIndex:chosungIndex]];
		}
		else 
		{
            [resultBuffer appendFormat:@"%C", [value characterAtIndex:i]];
		}
	}

	return resultBuffer;
}

- (NSString *) makeChosungFromString:(NSString *)text
{
    if (text == nil) return @"";
    if ([text length] <= 0) return @"";

    NSMutableString *result = [[NSMutableString alloc] init];
    for (NSInteger i = 0; i < [text length]; i++)
    {
        unichar code = [text characterAtIndex:i];
        if((code >= HANGUL_BEGIN_UNICODE) && (code <= HANGUL_END_UNICODE)) 
        {
            NSUInteger hangeulcode = code - HANGUL_BEGIN_UNICODE;
            NSInteger chosungindex = hangeulcode / HANGUL_BASE_UNIT;
            
            [result appendString:[arrayChosung objectAtIndex:chosungindex]];
        }
        else
        {
            [result appendString:[[NSString stringWithFormat:@"%C", code] capitalizedString]];
        }
    }
    
    return result;
}

- (NSString *) makeOnlyNamesChosungFromString:(NSString *)text
{
    if (text == nil) return @"";
    if ([text length] <= 0) return @"";
    
    unichar code = [text characterAtIndex:0];
    unichar shapcode = [@"#" characterAtIndex:0];
    unichar astcode = [@"*" characterAtIndex:0];
    
    // escdream 추가 예외처러 감리/주의 종목 2017.12.12
    if (code == shapcode || code == astcode)
    {
        code = [text characterAtIndex:1];
    }
    
    if (code == shapcode || code == astcode)
    {
        code = [text characterAtIndex:2];
    }
    
    
    if((code >= HANGUL_BEGIN_UNICODE) && (code <= HANGUL_END_UNICODE))
    {
        NSUInteger hangeulcode = code - HANGUL_BEGIN_UNICODE;
        NSInteger chosungindex = hangeulcode / HANGUL_BASE_UNIT;
        
        if (chosungindex == 1) chosungindex = 0;
        return [arrayChosung objectAtIndex:chosungindex];
    }
    else
    {
        
        // escdream 추가 예외처러 감리/주의 종목 2017.12.12
        unichar zero = [@"0" characterAtIndex:0];
        unichar nine = [@"9" characterAtIndex:0];
        
        if (code >= zero && code <= nine)
        {
            return @"0-9";
        }
        else
        {
            unichar zero = [@"A" characterAtIndex:0];
            unichar nine = [@"z" characterAtIndex:0];
            if (code >= zero && code <= nine)
            {
                return @"A-Z";
            }
        }
    }
    return [[NSString stringWithFormat:@"%C", code] capitalizedString];
}


- (NSString *) makeOneChosungFromString:(NSString *)text
{
    if (text == nil) return @"";
    if ([text length] <= 0) return @"";
    
    unichar code = [text characterAtIndex:0];
    
    
    if((code >= HANGUL_BEGIN_UNICODE) && (code <= HANGUL_END_UNICODE)) 
    {
        NSUInteger hangeulcode = code - HANGUL_BEGIN_UNICODE;
        NSInteger chosungindex = hangeulcode / HANGUL_BASE_UNIT;
        
        if (chosungindex == 1) chosungindex = 0;
        return [arrayChosung objectAtIndex:chosungindex];
    }
    else
    {
        return [[NSString stringWithFormat:@"%C", code] capitalizedString];
    }
}

/*
 * 주어진 캑릭터 코드가 문자열에 있는지 검사.
 * searchchar: 찾고자하는 코드
 * source: 소스 데이터.
 */
- (BOOL) hasCharacter:(NSString *)source searchchar:(unichar)searchchar
{
    for (int i = 0; i < [source length]; i++)
    {
        unichar code = [source characterAtIndex:i];
        if (code >= HANGUL_BEGIN_UNICODE && code <= HANGUL_END_UNICODE)
        {
            NSUInteger startcode = code - HANGUL_BEGIN_UNICODE;
            NSInteger chosungIndex = startcode / HANGUL_BASE_UNIT;
            code = [[arrayChosung objectAtIndex:chosungIndex] characterAtIndex:0];
        }
        
        if (searchchar == code) return YES;
    }

    return NO;
}

- (BOOL) isChosung:(NSUInteger)searchchar
{
    switch (searchchar)
    {
        case 0x3131 : // 'ㄱ'
        case 0x3132 : // 'ㄲ'
        case 0x3134 : // 'ㄴ'
        case 0x3137 : // 'ㄷ'
        case 0x3138 : // 'ㄸ'
        case 0x3139 : // 'ㄹ'
        case 0x3141 : // 'ㅁ'
        case 0x3142 : // 'ㅂ'
        case 0x3143 : // 'ㅃ'
        case 0x3145 : // 'ㅅ'
        case 0x3146 : // 'ㅆ'
        case 0x3147 : // 'ㅇ'
        case 0x3148 : // 'ㅈ'
        case 0x3149 : // 'ㅉ'
        case 0x314a : // 'ㅊ'
        case 0x314b : // 'ㅋ'
        case 0x314c : // 'ㅌ'
        case 0x314d : // 'ㅍ'
        case 0x314e : // 'ㅎ'
            return YES;
    }

    return NO;
}

- (NSUInteger) getChosung:(NSUInteger)source
{
    if (source >= HANGUL_BEGIN_UNICODE && source <= HANGUL_END_UNICODE)
    {
        NSUInteger startcode = source - HANGUL_BEGIN_UNICODE;
        NSInteger chosungIndex = startcode / HANGUL_BASE_UNIT;
        source = [[arrayChosung objectAtIndex:chosungIndex] characterAtIndex:0];
    }
    
    return source;
}

-(BOOL) getIsChoSungList:(NSString *)name
{
//	if (name == @"" || name == nil) return nil;
	return NO;
}

-(NSString *) getHangulInitialSoundImpl:(NSString *)value keyword:(NSString *)searchKeyword
{
	[resultBuffer setString:@""];
    
    NSInteger nCount = MIN([value length], [searchKeyword length]);
	for( int i = 0 ; i < nCount; i++ ) 
	{
		NSInteger code = [value characterAtIndex:i];
		NSInteger key = [searchKeyword characterAtIndex:i];
        
        if( [self isChosung:key] )
        {
            if( (code >= HANGUL_BEGIN_UNICODE) && (code <= HANGUL_END_UNICODE) ) 
            {				
                NSInteger uniCode	   = code - HANGUL_BEGIN_UNICODE;				
                NSInteger chosungIndex = uniCode / HANGUL_BASE_UNIT;
                
                [resultBuffer appendString:[arrayChosung objectAtIndex:chosungIndex]];
            }
            else 
            {
                [resultBuffer appendFormat:@"%C", [value characterAtIndex:i]];
            }
        }
        else
        {
            [resultBuffer appendFormat:@"%C", [value characterAtIndex:i]];
        }
	}
    
	return resultBuffer;
}

-(NSString*) getHangulInitialSound : (NSString *)value keyword:(NSString *)searchKeyword
{
    unichar firstChar = [value characterAtIndex:0];
    if( ![CommonUtil isAlphaNum:firstChar] || [CommonUtil isAlphaNum:[searchKeyword characterAtIndex:0]] )
    {
        return [self getHangulInitialSoundImpl:value  keyword:searchKeyword];			
    }
    else
    {
        NSInteger nCompartStart = -1;
        NSInteger nValueLen = [value length];
        for (int i = 1; i < nValueLen; i++)
        {
            if( ![CommonUtil isAlphaNum:[value characterAtIndex:i]] )
            {
                nCompartStart = i;
                break;
            }
        }
        if( nCompartStart < 0 ) return @"";
         return [self getHangulInitialSoundImpl:[value substringFromIndex:nCompartStart] keyword:searchKeyword];			
    }
}

- (NSString *)doubleChosungReplace:(NSString *)chosung{
    
    chosung = [chosung stringByReplacingOccurrencesOfString:@"ㅃ" withString:@"ㅂㅂ"];
    chosung = [chosung stringByReplacingOccurrencesOfString:@"ㅉ" withString:@"ㅈㅈ"];
    chosung = [chosung stringByReplacingOccurrencesOfString:@"ㄸ" withString:@"ㄷㄷ"];
    chosung = [chosung stringByReplacingOccurrencesOfString:@"ㄲ" withString:@"ㄱㄱ"];
    chosung = [chosung stringByReplacingOccurrencesOfString:@"ㅆ" withString:@"ㅅㅅ"];
    
    return chosung;
    
}


- (NSString *)getChosungs:(NSString *)name{
    NSMutableString *chosung = [NSMutableString string];
    for(int i = 0 ; i < [name length]; i++){
        unichar c = [name characterAtIndex:i];
        if (c >= 0xAC00) {
            int c_subCode = (c - 0xAC00) / (21 * 28);
            [chosung appendFormat:@"%@", [arrayChosung objectAtIndex:c_subCode] ] ;
        }else{
            [chosung appendFormat:@"%c", c];
        }
    }
    return chosung;
}


-(void)dealloc
{
    arrayChosung = nil;
    arrayJungSung = nil;
    arrayJongSung = nil;
	
}

@end
