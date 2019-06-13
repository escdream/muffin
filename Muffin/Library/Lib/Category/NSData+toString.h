//
//  NSData+toString.h
//  ItgenStdDev
//
//  Created by  on 12. 9. 10..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (toString)

/*
 문자열로 치환하는 과정에서 가비지값이 들어가는것을 방지하기 위해 추가
 */
- (NSString *)toString:(NSStringEncoding)encoding;

@end
