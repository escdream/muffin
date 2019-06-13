//
//  AFNetworkConnect.h
//  OneShotpadForMeritzStockSample
//
//  Created by Min joungKim on 2016. 7. 12..
//  Copyright © 2016년 rowem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFNetworkConnect : NSObject

+ (void)callAsyncHTTP:(NSString *)path param:(NSMutableDictionary *)params withBlock:(void(^)(id result, NSError *error))completion;
+ (void)callAsyncHTTPWithHeader:(NSString *)path param:(NSMutableDictionary *)params headers:(NSMutableDictionary *)headers withBlock:(void(^)(id result, NSError *error))completion;


@end
