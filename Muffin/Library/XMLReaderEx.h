//
//  XMLReader.h
//  ableMTS
//
//  Created by escdream on 2017. 12. 29..
//  Copyright © 2017년 ITGen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLReaderEx : NSObject
{
    NSMutableArray *dictionaryStack;
    NSMutableString *textInProgress;
    NSError *errorPointer;
}

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError *)errorPointer;
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError *)errorPointer;


@end
