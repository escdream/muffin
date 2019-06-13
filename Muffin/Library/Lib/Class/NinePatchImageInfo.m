//
//  NinePatchImageInfo.m
//  SmartVIGS
//
//  Created by -_-v on 11. 7. 5..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NinePatchImageInfo.h"
#import "NinePatchImageRange.h"
#import "NinePatchImageBlock.h"
#import "CommonFileUtil.h"
#import "CommonUtil.h"


@interface NinePatchImageInfo ()

- (UIImage *)cachedImageOfSize:(CGSize)size;
- (void)setCachedImage:(UIImage *)image ofSize:(CGSize)size;

@end


@implementation NinePatchImageInfo


- (id)initWithResource:(NSString *)filename
{
    if ((self = [super init]))
    {
        m_sizedImageCache = [[NSMutableDictionary alloc] init];
        
		NSString *sImageName = [CommonFileUtil getImageFilePath:filename];
//        NSLog(@"--------------------------- 3");
        
        // escdream 2017.02.15
        NSRange range = [filename rangeOfString:@".9"];
        NSString *strPrevName = nil;
        if ((range.location != NSNotFound) && ([UIScreen mainScreen].bounds.size.width < 375)) {
            
            strPrevName =  [NSString stringWithFormat:@"%@@2x.9.png", [filename substringToIndex:range.location]];
        }

        if (strPrevName)
        {
            if ([[NSFileManager defaultManager] fileExistsAtPath:[CommonFileUtil getImageFilePath:strPrevName]])
            {
                sImageName = [CommonFileUtil getImageFilePath:strPrevName];
            }
        }
        
        UIImage *image = [UIImage imageWithContentsOfFile:sImageName];
		if (image == nil)
		{
			sImageName = [CommonFileUtil getImageFileDefaultPath:filename];
			image = [UIImage imageWithContentsOfFile:sImageName];
		}
//        NSLog(@"--------------------------- 4");
        if (image == nil)
        {
            return self;
        }
        
        m_originalImage = image;
        
        
        CGImageRef imageRef = [image CGImage];
        
		NSUInteger width = CGImageGetWidth(imageRef);
		NSUInteger height = CGImageGetHeight(imageRef);
		CGRect bounds = CGRectMake(0, 0, width, height);
        
        
        
		NSUInteger bytesPerRow = width * 4;
		NSUInteger bitsPerComponent = 8;
        
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		UInt8 *pixelByteData = malloc(height * bytesPerRow);
        memset(pixelByteData, 0x00, height * bytesPerRow);
//        NSLog(@"--------------------------- 5");
		CGContextRef context = CGBitmapContextCreate((void *)pixelByteData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);
        if (context == nil) return self;
        
		CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
		CGContextFillRect(context, bounds);
		
		CGContextDrawImage(context, bounds, imageRef);
//        NSLog(@"--------------------------- 6");
		RGBAPixel *pixelData = (RGBAPixel *)CGBitmapContextGetData(context);
        
		if (pixelData != NULL)
        {
            NSMutableArray *horizontalImageRanges = [NSMutableArray array];
            NinePatchImageRange *rangeInfo = nil;
            for (int index = 0; index < (width - 2); index++)
            {
                BOOL stretchableRange = RGBAPixelIsBlack((pixelData[index + 1]));
                
                if (rangeInfo == nil)
                {
                    rangeInfo = [[NinePatchImageRange alloc] initWithStretchable:stretchableRange withStartIndex:0 withEndIndex:0];
                    [horizontalImageRanges addObject:rangeInfo];
                }
                else
                {
                    if (stretchableRange == rangeInfo.stretchable)
                    {
                        rangeInfo.endIndex++;
                    }
                    else
                    {
                        rangeInfo = [[NinePatchImageRange alloc] initWithStretchable:stretchableRange withStartIndex:index withEndIndex:index];
                        [horizontalImageRanges addObject:rangeInfo];
                    }
                }
            }
//        NSLog(@"--------------------------- 7");
            NSMutableArray *verticalImageRanges = [NSMutableArray array];
            rangeInfo = nil;
            for (int index = 0; index < (height - 2); index++)
            {
                BOOL stretchableRange = RGBAPixelIsBlack((pixelData[(index + 1) * width]));
                if (rangeInfo == nil)
                {
                    rangeInfo = [[NinePatchImageRange alloc] initWithStretchable:stretchableRange withStartIndex:0 withEndIndex:0];
                    [verticalImageRanges addObject:rangeInfo];
                }
                else
                {
                    if (stretchableRange == rangeInfo.stretchable)
                    {
                        rangeInfo.endIndex++;
                    }
                    else
                    {
                        rangeInfo = [[NinePatchImageRange alloc] initWithStretchable:stretchableRange withStartIndex:index withEndIndex:index];
                        [verticalImageRanges addObject:rangeInfo];
                    }
                }
            }
//        NSLog(@"--------------------------- 8");
            NSMutableArray *horizontalTextRanges = [NSMutableArray array];
            rangeInfo = nil;
            for (int index = 0; index < (width - 2); index++)
            {
                BOOL stretchableRange = RGBAPixelIsBlack((pixelData[index + 1 + (height - 1) * width]));
                
                if (rangeInfo == nil)
                {
                    rangeInfo = [[NinePatchImageRange alloc] initWithStretchable:stretchableRange withStartIndex:0 withEndIndex:0];
                    [horizontalTextRanges addObject:rangeInfo];
                }
                else
                {
                    if (stretchableRange == rangeInfo.stretchable)
                    {
                        rangeInfo.endIndex++;
                    }
                    else
                    {
                        rangeInfo = [[NinePatchImageRange alloc] initWithStretchable:stretchableRange withStartIndex:index withEndIndex:index];
                        [horizontalTextRanges addObject:rangeInfo];
                    }
                }
            }
            
            NSMutableArray *verticalTextRanges = [NSMutableArray array];
            rangeInfo = nil;
            for (int index = 0; index < (height - 2); index++)
            {
                BOOL stretchableRange = RGBAPixelIsBlack((pixelData[((index + 2) * width) - 1]));
                if (rangeInfo == nil)
                {
                    rangeInfo = [[NinePatchImageRange alloc] initWithStretchable:stretchableRange withStartIndex:0 withEndIndex:0];
                    [verticalTextRanges addObject:rangeInfo];
                }
                else
                {
                    if (stretchableRange == rangeInfo.stretchable)
                    {
                        rangeInfo.endIndex++;
                    }
                    else
                    {
                        rangeInfo = [[NinePatchImageRange alloc] initWithStretchable:stretchableRange withStartIndex:index withEndIndex:index];
                        [verticalTextRanges addObject:rangeInfo];
                    }
                }
            }
//        NSLog(@"--------------------------- 9");
            m_nUnstretchableWidth = 0;
            for (NinePatchImageRange *rangeInfo in horizontalImageRanges)
            {
                [rangeInfo calculateLength];
                if (rangeInfo.stretchable == NO)
                {
                    m_nUnstretchableWidth += rangeInfo.length;
                }
            }
            
            m_nUnstretchableHeight = 0;
            for (NinePatchImageRange *rangeInfo in verticalImageRanges)
            {
                [rangeInfo calculateLength];
                if (rangeInfo.stretchable == NO)
                {
                    m_nUnstretchableHeight += rangeInfo.length;
           
                }
            }
            
            NSInteger blockCount = [horizontalImageRanges count] * [verticalImageRanges count];
            if (blockCount > 0)
            {
                m_nHorizontalBlocks = [horizontalImageRanges count];
                m_nVerticalBlocks = [verticalImageRanges count];
                
                m_arrImageBlock = [[NSMutableArray alloc] initWithCapacity:blockCount];
                for (NinePatchImageRange *horizontalRangeInfo in horizontalImageRanges)
                {
                    for (NinePatchImageRange *verticalRangeInfo in verticalImageRanges)
                    {
                        UIImage *blockImage = nil;
                        CGImageRef blockImageRef = CGImageCreateWithImageInRect(imageRef, CGRectMake(horizontalRangeInfo.startIndex + 1, verticalRangeInfo.startIndex + 1, horizontalRangeInfo.length, verticalRangeInfo.length));
                        if (blockImageRef != NULL)
                        {
                            blockImage = [UIImage imageWithCGImage:blockImageRef];
                            CGImageRelease(blockImageRef);
                        }

                        NinePatchImageBlock *imageBlock = [[NinePatchImageBlock alloc] initWithImage:blockImage
                                                                                             withRect:CGRectMake(horizontalRangeInfo.startIndex, verticalRangeInfo.startIndex, horizontalRangeInfo.length, verticalRangeInfo.length)
                                                                              withVerticalStretchable:verticalRangeInfo.stretchable
                                                                            withHorizontalStretchable:horizontalRangeInfo.stretchable];
                        [m_arrImageBlock addObject:imageBlock];
                    }
                }
            }
            else
            {
                m_nHorizontalBlocks = 0;
                m_nVerticalBlocks = 0;
                m_arrImageBlock = nil;
            }
//        NSLog(@"--------------------------- 10");
            BOOL incorrectHorizontalTextRange = NO;
            m_horizontalTextRange = nil;
            for (NinePatchImageRange *rangeInfo in horizontalTextRanges)
            {
                [rangeInfo calculateLength];
                if (rangeInfo.stretchable)
                {
                    if (m_horizontalTextRange == nil) m_horizontalTextRange = rangeInfo;
                    else incorrectHorizontalTextRange = YES;
                }
            }
//        NSLog(@"--------------------------- 11");
            if (incorrectHorizontalTextRange)
            {
                //                if( [filename hasPrefix:@"ctl_cmb_n.9"] )
                {
                    // NSLog(@"NinePatch 디버그 ");
                    // NSLog(@"NINEPATCH  incorrectHorizontalTextRange horizontalImageRanges count:%d", horizontalImageRanges.count);
                }
                
//                for (NinePatchImageRange *rangeInfo in horizontalTextRanges)
//                {
//                    // NSLog(@"NINEPATCH  rangeInfo stretch:%d startIndex:%d endIndex:%d", rangeInfo.stretchable, rangeInfo.startIndex, rangeInfo.endIndex);
//                }
                
                m_horizontalTextRange = nil;
            }
            else
            {
//                if (m_horizontalTextRange != nil) [m_horizontalTextRange string];
            }
            
            BOOL incorrectVerticalTextRange = NO;
            m_verticalTextRange = nil;
            for (NinePatchImageRange *rangeInfo in verticalTextRanges)
            {
                [rangeInfo calculateLength];
                if (rangeInfo.stretchable)
                {
                    if (m_verticalTextRange == nil)
                    {
                        m_verticalTextRange = rangeInfo;
                    }
                    else
                    {
                        incorrectVerticalTextRange = YES;
                    }
                }
            }
//        NSLog(@"--------------------------- 12");
            if (incorrectVerticalTextRange)
            {
                m_verticalTextRange = nil;
            }
            else
            {
//                if (m_verticalTextRange != nil)
//                {
//                    [m_verticalTextRange string];
//                }
            }
            
            m_nEffectiveWidth = width - 2;
            m_nEffectiveHeight = height - 2;
		}
        
		CGContextRelease(context);
		CGColorSpaceRelease(colorSpace);
		free(pixelByteData);
    }
    return self;
}

- (void)dealloc
{
    m_sizedImageCache = nil;
    m_arrImageBlock = nil;
    m_horizontalTextRange = nil;
    m_verticalTextRange = nil;
}

- (void) clearCacheImage
{
    [m_sizedImageCache removeAllObjects];
}

- (UIImage *)imageOfSize:(CGSize)size isCache:(BOOL)isCache
{
    if( size.width == 0 || size.height == 0 ) return nil;
//    if ([CommonUtil isIPhone5]) {
        size = CGSizeApplyAffineTransform(size, CGAffineTransformMakeScale(3.0, 3.0));
//    }else{
//        size = CGSizeApplyAffineTransform(size, CGAffineTransformMakeScale(2.5, 2.5));
//    }
    
    
    int sizeWidth = size.width;
    int sizeHeight = size.height;
    
    if ((m_nEffectiveWidth == 0 && m_nUnstretchableWidth == 0) || (m_nEffectiveWidth - m_nUnstretchableWidth == 0)) {
        return nil;
    }
        
    if ((m_nEffectiveHeight == 0 && m_nUnstretchableHeight == 0) || (m_nEffectiveHeight - m_nUnstretchableHeight == 0)) {
        return nil;
    }
    
    CGFloat horizontalScale = (CGFloat)(sizeWidth - m_nUnstretchableWidth) / (m_nEffectiveWidth - m_nUnstretchableWidth);
    CGFloat verticalScale = (CGFloat)(sizeHeight - m_nUnstretchableHeight) / (m_nEffectiveHeight - m_nUnstretchableHeight);
    

    if( isCache )
    {
        UIImage *cachedImage = [self cachedImageOfSize:size];
        if (cachedImage != nil) {
            return cachedImage;
        }
    }
	
	if (m_arrImageBlock == nil || CGSizeEqualToSize(size, CGSizeZero))
    {
        return nil;
    }
   
    CGFloat x = 0;
    
    
    for (int horizontalIndex = 0; horizontalIndex < m_nHorizontalBlocks; horizontalIndex++) {
        CGFloat y = 0;
        NinePatchImageBlock *imageBlock = nil;

        for (int verticalIndex = 0; verticalIndex < m_nVerticalBlocks; verticalIndex++) {
            imageBlock = [m_arrImageBlock objectAtIndex:(horizontalIndex * m_nVerticalBlocks + verticalIndex)];

            CGFloat imageWidth = imageBlock.rect.size.width;
            CGFloat imageHeight =imageBlock.rect.size.height;
            
            CGFloat width = imageWidth;
            CGFloat height = imageHeight;
            
            if (imageBlock.horizontalStretchable)
                width = imageWidth * horizontalScale;
            
            if (imageBlock.verticalStretchable)
                height = imageHeight * verticalScale;
            
            imageBlock.currentDrawingRect = CGRectMake(x, y, width, height);
            y += height;
        }
        
        if( imageBlock != nil )
            x += imageBlock.currentDrawingRect.size.width;
    }
    
    UIGraphicsBeginImageContext(size);
    
    for (NinePatchImageBlock *imageBlock in m_arrImageBlock)
    {
        [imageBlock.image drawInRect:imageBlock.currentDrawingRect];
    }
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if( isCache )
    {
        [self setCachedImage:scaledImage ofSize:size];
    }
    return scaledImage;
}

- (UIImage *)imageOfSize:(CGSize)size
{
    return [self imageOfSize:size isCache:FALSE];
}

- (CGRect)textFrameOfSize:(CGSize)size
{
    CGFloat x, y, width, height;

    float rate = 0.5;
    
    if (m_horizontalTextRange == nil) {
        x = 0;
        width = size.width;
    } else {
        x = m_horizontalTextRange.startIndex * rate;
        width = size.width - (m_nEffectiveWidth - m_horizontalTextRange.length) * rate;
    }
    
    if (m_verticalTextRange == nil) {
        y = 0;
        height = size.height;
    } else {
        y = m_verticalTextRange.startIndex * rate;
        height = size.height - (m_nEffectiveHeight - m_verticalTextRange.length) * rate;
    }
    
    return CGRectMake(x, y, width, height);
}

- (CGRect)textMargin
{
    CGFloat x, y, width, height;
    
    float rate = 0.5;
    
    if (m_horizontalTextRange == nil) {
        x = 0;
        width = 0;
    } else {
        x = m_horizontalTextRange.startIndex * rate;
        width = (m_nEffectiveWidth - m_horizontalTextRange.endIndex - 1) * rate;
    }
    
    if (m_verticalTextRange == nil) {
        y = 0;
        height = 0;
    } else {
        y = m_verticalTextRange.startIndex * rate;
        height = (m_nEffectiveHeight - m_verticalTextRange.endIndex - 1) * rate;
    }
    
    return CGRectMake(x, y, width, height);
}


- (UIImage *)cachedImageOfSize:(CGSize)size
{
    return [m_sizedImageCache objectForKey:NSStringFromCGSize(size)];
}

- (void)setCachedImage:(UIImage *)image ofSize:(CGSize)size
{
	if (size.width == 0 || size.height == 0) return;
    if (image == nil) 
    {
        // NSLog(@"setCachedImage image is nil image:%p:", image);
        return ;
    }
    [m_sizedImageCache setObject:image forKey:NSStringFromCGSize(size)];
}

@end
