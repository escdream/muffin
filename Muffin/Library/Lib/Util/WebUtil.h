//
//  WebUtil.h
//  SmartVIGS
//
//  Created by Kim juyoung on 11. 11. 7..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebUtil : NSObject

+(NSString*) getStringURL:(NSString*)strType;
+(NSURL*)getHttpUtrlFromWeburlInfile:(NSString*)strType;

@end
