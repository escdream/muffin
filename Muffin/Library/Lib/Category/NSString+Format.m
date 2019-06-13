/////////////////////////////////////////////////////////////////////////////////////////////////////
// Class Name  : NSString+Format.m / ItgenStdDev
// Description : 특정 포맷값을 만드는 함수
////////////////////////////////////////////////////////////////////////////////////////////////////

#import "NSString+Format.h"
#define ELLIPSIS @"..."

@implementation NSString(Format)


-(NSString *) dateStringFromString:(NSString *)format targetFormat:(NSString *)targetFormat
{
	NSString *returnValue = nil;
    
    if ([self isEqualToString:@""]) return @"";
	
	// Convert string to date object
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:format];
	NSDate *date = [dateFormat dateFromString:self];  
	
	// Convert date object to desired output format
	[dateFormat setDateFormat:targetFormat];
	returnValue = [dateFormat stringFromDate:date];  
	
	return returnValue;
}

-(NSString *) dateStringFromString:(NSString *)format targetFormat:(NSString *)targetFormat intervalTime:(NSTimeInterval)intervalTime
{
	
	NSString *returnValue = nil;
	
	// Convert string to date object
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:format];
	NSDate *date = [dateFormat dateFromString:self];  
	NSDate *date2 = [date dateByAddingTimeInterval:intervalTime];
	
	// Convert date object to desired output format
	[dateFormat setDateFormat:targetFormat];
	returnValue = [dateFormat stringFromDate:date2];  
	
	return returnValue;
}



-(NSString *) numberStringFromString:(NSString *)format targetFormat:(NSString *)targetFormat 
{
	
	NSString *returnValue = nil;
	
	// Convert string to date object
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:format];
	NSDate *date = [dateFormat dateFromString:self];  
	
	
	// Convert date object to desired output format
	[dateFormat setDateFormat:targetFormat];
	returnValue = [dateFormat stringFromDate:date];  
	
	return returnValue;
}

-(NSString *) strToFormatedStr:(NSString *)formatStr 
{
    NSMutableString *strDes = [NSMutableString stringWithString:@""];
    
    NSInteger flen = [formatStr length];
    NSInteger len = [self length];
    
    for (int i = 0, j = 0; i < flen; i++)
    {
        if ([formatStr characterAtIndex:i] == '9') 
        {
            if (j >= len)
            {
                [strDes insertString:@" " atIndex:i]; 
            }
            else
                [strDes insertString:[NSString stringWithFormat:@"%c", [self characterAtIndex:j++]] atIndex:i];
        }
        else
            [strDes insertString:[NSString stringWithFormat:@"%c", [formatStr characterAtIndex:i]] atIndex:i];
    }
    
    return (NSString *)strDes;
}

#pragma mark -
#pragma mark 컴마처리 및 수숫점 처리 
-(NSString*) decimalString{
	return [self decimalString:-1];
}

-(NSString*) decimalString:(int)minimum{
	NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
	[fmt setNumberStyle:NSNumberFormatterDecimalStyle];
	if(minimum>=0)[fmt setMinimumFractionDigits:minimum];
	NSString *textData = [fmt stringFromNumber:[NSNumber numberWithDouble:[self doubleValue]]];

	return textData;
}

#pragma mark -
#pragma mark 컴마처리 및 수숫점 처리 Remove '-'
-(NSString *) decimalStringRemoveSubtraction{
    return [self decimalStringRemoveSubtraction:-1];
}

-(NSString *) decimalStringRemoveSubtraction:(int)minimum
{
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
	[fmt setNumberStyle:NSNumberFormatterDecimalStyle];
	if(minimum>=0)[fmt setMinimumFractionDigits:minimum];
    double dValue = [self doubleValue] < 0 ?  [self doubleValue] * -1 : [self doubleValue];
	NSString *textData = [fmt stringFromNumber:[NSNumber numberWithDouble:dValue]];
	return textData;
}

#pragma mark -
#pragma mark "0" => Space
-(NSString *) zeroToSpace
{
    if ([self isEqualToString:@"0"] || [self isEqualToString:@"0.00"]) return @"";
    return self;
}

-(NSString *) removeComma
{
    return [self stringByReplacingOccurrencesOfString:@"," withString:@""];
}

#pragma mark -
#pragma mark "추가 메세지 제거"
-(NSString *) removeAddMsg
{
	NSRange range = [self rangeOfString:@"$$"];
	if (range.location != NSNotFound)
	{
		return [self substringToIndex:range.location];
	}
	
	return self;
}

- (NSString *) stringbyAddingHTMLTags {
    NSString *addedStr = [self stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    //addedStr = [addedStr stringByReplacingOccurrencesOfString:@" " withString:@"&nbsp;"];
    return addedStr;
}

- (NSString *) stringByReplacingHTMLTags
{
    NSString *replacedAddedStr = [self stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    replacedAddedStr = [replacedAddedStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    replacedAddedStr = [replacedAddedStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    NSMutableString *removeTagStr = [NSMutableString string];
    NSScanner *scanner = [NSScanner scannerWithString:replacedAddedStr];
    [scanner setCharactersToBeSkipped:[NSCharacterSet illegalCharacterSet]];
    NSString *tempText = nil;
    // remove other tags
    while (![scanner isAtEnd])
    {
        [scanner scanUpToString:@"<" intoString:&tempText];
        if (tempText != nil){
            [removeTagStr appendString:tempText];
        }
        [scanner scanUpToString:@">" intoString:NULL];
        
        if (![scanner isAtEnd])
            [scanner setScanLocation:[scanner scanLocation] + 1];
        
        tempText = nil;
    }
    return removeTagStr;
}

- (NSString*)trim
{
    if (self == nil)
        return @"";
    else
        return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] ];
}

- (NSString *)stringToHex
{
    char *utf8 = (char*)[self UTF8String];
    NSMutableString *hex = [NSMutableString string];
    while ( *utf8 ) [hex appendFormat:@"%02X" , *utf8++ & 0x00FF];
    
    return [NSString stringWithFormat:@"%@", hex];
}

- (BOOL)isNotEmpty
{
    return [self length] != 0;
}

- (BOOL)isNotBlank
{
    if ([self isNotEmpty])
    {
        NSCharacterSet *nonWhitespaceSet = [[NSCharacterSet whitespaceAndNewlineCharacterSet] invertedSet];
        NSRange range = [self rangeOfCharacterFromSet:nonWhitespaceSet];
        return range.location != NSNotFound;
    }
    
    return NO;
}

-(NSString*) truncateToWidth:(CGFloat)width withFont:(UIFont *)font
{
    // Obtain a mutable copy of this NSString.
    NSMutableString *truncatedString = [self mutableCopy];
    
    // If this NSString is longer than the desired width, truncate.
    if ([self sizeWithFont:font].width > width) {
        // Subtract an ellipsis' worth of width from the desired width to obtain the
        // truncation width.
        width -= [ELLIPSIS sizeWithFont:font].width;
        
        if (width >0)
        {
            
            // While the string is longer than the truncation width, remove characters
            // from the end of the string.
            @try {
                if (truncatedString.length > 1)
                {
                    NSRange range = {truncatedString.length - 1, 1};
                    while ([truncatedString sizeWithFont:font].width > width) {
                        if (truncatedString.length >= range.length)
                        {
                            [truncatedString deleteCharactersInRange:range];
                            range.location -= 1;
                        }
                        else
                            break;
                    }
                    [truncatedString replaceCharactersInRange:range withString:ELLIPSIS];
                }
                
            } @catch (NSException *exception) {
            } @finally {
            }
            
            // Once truncation is complete, append an ellipsis to the end of the string.
        }
    }
    
    return [truncatedString copy];
}


- (NSString *)stringByUrlEncoding
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8));
}


- (BOOL) inStr:(NSString *) subtSring;
{
    return ([self rangeOfString:subtSring].location != NSNotFound);
}


- (NSString *) decodeBase64String;
{
    NSString * decStr = [self copy];
    decStr = [decStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    decStr = [decStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:decStr options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    
    return decodedString;
}

- (NSString *) encodeBase64String;
{
    NSData *plainData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    
    return base64String;
}

@end
