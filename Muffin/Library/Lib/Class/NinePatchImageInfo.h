//
//  NinePatchImageInfo.h
//  SmartVIGS
//
//  Created by -_-v on 11. 7. 5..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef struct _RGBAPixel {
	UInt8 red;
	UInt8 green;
	UInt8 blue;
	UInt8 alpha;	
} RGBAPixel;


#define RGBAPixelIsBlack(pixel) (pixel.red == 0 && pixel.green == 0 && pixel.blue == 0 && pixel.alpha == 255 ? YES : NO)
#define PRINT_RGBAPixel(pixel)  // NSLog(@"%d %d %d %d", pixel.red, pixel.green, pixel.blue, pixel.alpha)


@class NinePatchImageRange;


@interface NinePatchImageInfo : NSObject {
    NSInteger m_nEffectiveWidth;      // NinePatch정보영역을 제외한 순순 이미지 크기. 보통 좌우 1픽셀씩 제외한다.
    NSInteger m_nEffectiveHeight;     //
    NSInteger m_nHorizontalBlocks;    // 가로 나인패치 구분 갯수
    NSInteger m_nVerticalBlocks;      // 세로 나인패치 구분 갯수
    
    NSInteger m_nUnstretchableWidth;  // 고정넓이
    NSInteger m_nUnstretchableHeight; // 고정높이
    
    NSMutableArray *m_arrImageBlock;

    NinePatchImageRange *m_horizontalTextRange;
    NinePatchImageRange *m_verticalTextRange;
    
    NSMutableDictionary *m_sizedImageCache;
    
    UIImage * m_originalImage;
    
}


- (id)initWithResource:(NSString *)filename;

- (UIImage *)imageOfSize:(CGSize)size;
- (UIImage *)imageOfSize:(CGSize)size  isCache:(BOOL)isCache;
- (CGRect)textFrameOfSize:(CGSize)size;
- (CGRect)textMargin;
- (void) clearCacheImage;

@end
