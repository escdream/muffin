//
//  NinePatchImageRange.m
//  SmartVIGS
//
//  Created by -_-v on 11. 7. 5..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NinePatchImageRange.h"


@implementation NinePatchImageRange

@synthesize stretchable;
@synthesize startIndex;
@synthesize endIndex;
@synthesize length;


- (id)initWithStretchable:(BOOL)rangeStretchable withStartIndex:(int)start withEndIndex:(int)end
{
    if ((self = [super init]) != nil) {
        stretchable = rangeStretchable;
        startIndex = start;
        endIndex = end;
        length = -1;
    }
    return self;
}

- (void)calculateLength
{
    length = endIndex - startIndex + 1;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"NinePatchImageRange : stretchable = %d, startIndex = %d, endIndex = %d, length = %d", stretchable, startIndex, endIndex, length];
}

@end
