//////////////////////////////////////////////////////////////////////////////////////////////////////
// Class Name  : NSString+Format.h / ItgenStdDev
// Description : 특정 포맷값을 만드는 함수
////////////////////////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>


@interface NSString(Format)

-(NSString *) dateStringFromString:(NSString *)format targetFormat:(NSString *)targetFormat;
-(NSString *) dateStringFromString:(NSString *)format targetFormat:(NSString *)targetFormat intervalTime:(NSTimeInterval)intervalTime;

-(NSString *) numberStringFromString:(NSString *)format targetFormat:(NSString *)targetFormat;

-(NSString *) strToFormatedStr:(NSString *)formatStr;

-(NSString*) decimalString;
-(NSString*) decimalString:(int)minimum;

-(NSString *) decimalStringRemoveSubtraction;
-(NSString *) decimalStringRemoveSubtraction:(int)minimum;

-(NSString *) zeroToSpace;
-(NSString *) removeComma;

-(NSString *) removeAddMsg;


- (NSString *)stringByUrlEncoding;

- (NSString *)stringbyAddingHTMLTags;
- (NSString *)stringByReplacingHTMLTags;
- (NSString*)trim;
- (NSString *)stringToHex;
- (BOOL)isNotBlank;
- (NSString*) truncateToWidth:(CGFloat)width withFont:(UIFont *)font;

- (NSString *) decodeBase64String;
- (NSString *) encodeBase64String;


- (BOOL) inStr:(NSString *) subtSring;
@end
