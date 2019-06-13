//
//  NinePatchImageCache.h
//  SmartVIGS
//
//  Created by -_-v on 11. 7. 5..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NinePatchImageCache : NSObject {
    
}

+ (void)releaseNinePatchImageCache;
+ (void)cleanNinePatchSizedImageCache;

+ (UIImage *)imageOfSize:(CGSize)size forResource:(NSString *)name ofType:(NSString *)extension;
+ (CGRect)textFrameOfSize:(CGSize)size forResource:(NSString *)name ofType:(NSString *)extension;
+ (UIImage *)imageOfSize:(CGSize)size forResource:(NSString *)name;
+ (UIImage *)cachedImageOfSize:(CGSize)size forResource:(NSString *)filename;
+ (CGRect)textFrameOfSize:(CGSize)size forResource:(NSString *)name;
+ (CGRect)textMarginOfResource:(NSString *)filename;
+ (UIImage *)cachedImageOfSize:(CGSize)size forResource:(NSString *)name ofType:(NSString *)extension;

@end
