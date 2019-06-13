//
//  NSDate+TimeCheck.h
//  SmartVIGS
//
//  Created by KDJ on 13. 10. 7..
//
//

#import <Foundation/Foundation.h>

#define BEGIN_TIMECHECK [NSDate beginTimeCheck]
#define	TRACE_TIMECHECK [NSDate traceTimeCheck:__FILE__ line:__LINE__]

@interface NSDate (TimeCheck)

+(void) beginTimeCheck;
+(void) traceTimeCheck:(const char*)file line:(int)line;

@end
