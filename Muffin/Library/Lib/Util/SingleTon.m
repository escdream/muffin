//
//  SingleTon.m
//  ableMTS
//
//  Created by TS on 2017. 4. 17..
//  Copyright © 2017년 ITGen. All rights reserved.
//

#import "SingleTon.h"

@implementation SingleTon

+ (id)sharedInstance
{
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}
//    You need need to override init method as well, because developer can call [[MyClass alloc]init] method also. that time also we have to return sharedInstance only.

@end
