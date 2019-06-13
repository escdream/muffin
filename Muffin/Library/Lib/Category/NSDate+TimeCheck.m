//
//  NSDate+TimeCheck.m
//  SmartVIGS
//
//  Created by KDJ on 13. 10. 7..
//
//

#import "NSDate+TimeCheck.h"

@implementation NSDate (TimeCheck)

static NSTimeInterval g_lastInterval = 0;

+ (void) beginTimeCheck
{
	g_lastInterval = [[NSDate date] timeIntervalSinceReferenceDate];
}

+ (void)traceTimeCheck:(const char *)file line:(int)line
{
	NSTimeInterval currentInterval = [[NSDate date] timeIntervalSinceReferenceDate];
	
	NSString* fileName = [[NSString stringWithUTF8String:file] lastPathComponent];
	NSLog(@"%@(%d) %f ms", fileName, line, (currentInterval-g_lastInterval)*1000);
	
	g_lastInterval = [[NSDate date] timeIntervalSinceReferenceDate];;
}

@end
