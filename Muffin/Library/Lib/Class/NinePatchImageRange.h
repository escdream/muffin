//
//  NinePatchImageRange.h
//  SmartVIGS
//
//  Created by -_-v on 11. 7. 5..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NinePatchImageRange : NSObject {
    
}

@property (nonatomic, assign) BOOL stretchable;
@property (nonatomic, assign) int startIndex;
@property (nonatomic, assign) int endIndex;
@property (nonatomic, assign) int length;


- (id)initWithStretchable:(BOOL)rangeStretchable withStartIndex:(int)start withEndIndex:(int)end;
- (void)calculateLength;

@end
