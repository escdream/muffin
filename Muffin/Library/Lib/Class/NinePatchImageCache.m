//
//  NinePatchImageCache.m
//  SmartVIGS
//
//  Created by -_-v on 11. 7. 5..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NinePatchImageCache.h"
#import "NinePatchImageInfo.h"


static NSMutableDictionary *ninePatchCache = nil;


@interface NinePatchImageCache ()

+ (NinePatchImageInfo *)ninePatchImageInfoForResource:(NSString *)filename;

@end


@implementation NinePatchImageCache


+ (NinePatchImageInfo *)ninePatchImageInfoForResource:(NSString *)filename
{
    NinePatchImageInfo *imageInfo;

    @synchronized(self) {
        if (ninePatchCache == nil) {
            ninePatchCache = [[NSMutableDictionary alloc] init];
        }
        
        imageInfo = [ninePatchCache objectForKey:filename];
        if (imageInfo == nil) {
            imageInfo = [[NinePatchImageInfo alloc] initWithResource:filename];
            [ninePatchCache setObject:imageInfo forKey:filename];
        }
    }
    return imageInfo;
}

// 나인패치 이미지, 정보 모두 클리어 
+ (void)releaseNinePatchImageCache
{
    @synchronized(self) {
        if (ninePatchCache != nil) {
            [ninePatchCache removeAllObjects];
        }
    }
}

// 나인패치에 의해 생성되어 사용된 이미지 클리어. 
+ (void)cleanNinePatchSizedImageCache
{
    @synchronized(self) {
        if (ninePatchCache != nil) {
            NinePatchImageInfo *imageInfo;
            NSArray *infos = [ninePatchCache allValues];
            for( imageInfo in infos)
            {
                [imageInfo clearCacheImage];
            }
        }
    }
}


+ (UIImage *)imageOfSize:(CGSize)size forResource:(NSString *)name ofType:(NSString *)extension
{
	NSString *filename = [NSString stringWithFormat:@"%@.9.%@", name, extension];	
    NinePatchImageInfo *imageInfo = [NinePatchImageCache ninePatchImageInfoForResource:filename];
    return [imageInfo imageOfSize:size isCache:FALSE];
}

+ (UIImage *)imageOfSize:(CGSize)size forResource:(NSString *)filename
{
    NinePatchImageInfo *imageInfo = [NinePatchImageCache ninePatchImageInfoForResource:filename];
    return [imageInfo imageOfSize:size isCache:FALSE];
}

+ (UIImage *)cachedImageOfSize:(CGSize)size forResource:(NSString *)filename
{
    NinePatchImageInfo *imageInfo = [NinePatchImageCache ninePatchImageInfoForResource:filename];
    return [imageInfo imageOfSize:size isCache:TRUE];
}

+ (UIImage *)cachedImageOfSize:(CGSize)size forResource:(NSString *)name ofType:(NSString *)extension
{
	NSString *filename = [NSString stringWithFormat:@"%@.9.%@", name, extension];	
    NinePatchImageInfo *imageInfo = [NinePatchImageCache ninePatchImageInfoForResource:filename];
    return [imageInfo imageOfSize:size isCache:TRUE];
}

+ (CGRect)textFrameOfSize:(CGSize)size forResource:(NSString *)name ofType:(NSString *)extension
{
	NSString *filename = [NSString stringWithFormat:@"%@.9.%@", name, extension];	
    NinePatchImageInfo *imageInfo = [NinePatchImageCache ninePatchImageInfoForResource:filename];
    return [imageInfo textFrameOfSize:size];
}


+ (CGRect)textFrameOfSize:(CGSize)size forResource:(NSString *)filename
{
    NinePatchImageInfo *imageInfo = [NinePatchImageCache ninePatchImageInfoForResource:filename];
    return [imageInfo textFrameOfSize:size];
}

+ (CGRect)textMarginOfResource:(NSString *)filename
{
    NinePatchImageInfo *imageInfo = [NinePatchImageCache ninePatchImageInfoForResource:filename];
    return [imageInfo textMargin];
}


@end
