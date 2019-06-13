//
//  NSData+toString.m
//  ItgenStdDev
//
//  Created by  on 12. 9. 10..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSData+toString.h"

@implementation NSData (toString)

- (NSString *)toString:(NSStringEncoding)encoding
{
    char *newDataPointer = (char *)calloc(self.length, sizeof(char));
    memcpy(newDataPointer, self.bytes, self.length);
    NSString *str = [NSString stringWithCString:newDataPointer encoding:encoding];
    free(newDataPointer);
    return str;
}

@end
