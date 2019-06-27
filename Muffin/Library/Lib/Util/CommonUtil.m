//
//  CommonUtil.m
//  SmartVIGS
//
//  Created by itgen on 11. 5. 11..
//  Copyright 2011 itgen. All rights reserved.
//
#import "CommonUtil.h"
#include <sys/time.h>
#include <QuartzCore/QuartzCore.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <net/if_dl.h>
#include <netdb.h>
#include <net/if.h>
#include <errno.h>
#include <net/if_dl.h>
#include <mach/mach_host.h>
#include <sys/sysctl.h>
#import <mach/mach.h>
#import "NinePatchImageInfo.h"
//#import "NSData+AES.h"
#import <QuartzCore/QuartzCore.h>
#import "SystemUtil.h"
#import "WebUtil.h"
#import "CommonType.h"
#import "JSON.h"
#import "ResourceManager.h"
#import "CommonFileUtil.h"
#import <AVFoundation/AVAudioPlayer.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "CommonKey.h"
#import "CommonDef.h"
//#import "SessionInfo.h"
//#import "MainMenuItem.h"
#import "amsLibrary.h"
#import <sys/utsname.h> // import it in your header or implementation file.

#import "NSString+Format.h"
#import "NSData+AES.h"


static UIImage* g_imgScreenShot = nil;
static NSString* g_strDeviceOS = nil;

CGColorSpaceRef GetDeviceRGBColorSpace(BOOL isrelease)
{
    static CGColorSpaceRef colorSpaceRef = NULL;
    if (colorSpaceRef == NULL) colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        
        if (isrelease)
        {
            CGColorSpaceRelease(colorSpaceRef);
            colorSpaceRef = NULL;
            
            return NULL;
        }
    
    return colorSpaceRef;
};

//int GetRealLength(char *pszData, int length, BOOL isreverse)
//{
//    if (isreverse)
//    {
//        if(length == 0) length = strlen(pszData);
//        for (int i = length-1; i >= 0; i--)
//        {
//            if (pszData[i] != 0x00 && pszData[i] != 0x20) return i+1;
//        }
//        
//        return length;
//    }
//    
//    if(length == 0) length = strlen(pszData);
//    for (int i = 0; i <= length-1; i++)
//    {
//        if (pszData[i] != 0x00 && pszData[i] != 0x20) return i;
//    }
//    
//    return length;
//}

@implementation CommonUtil

+ (CGRect)convertRectToTopSuperView:(UIView *)view ExistTopTitle:(BOOL)bExist
{
	UIView *superview = [view superview];
	float xPos = view.frame.origin.x , yPos = view.frame.origin.y;
	while (superview) {
		xPos += superview.frame.origin.x;
		yPos += superview.frame.origin.y;
		superview = [superview superview];
	}
	CGRect rect;
	if (bExist)
	{
		rect = CGRectMake( xPos , yPos - 20, view.frame.size.width, view.frame.size.height);
	}
	else
	{
		rect = CGRectMake( xPos , yPos , view.frame.size.width, view.frame.size.height);
	}
	return rect;
}

+ (NSString*)stringfromRect:(CGRect)rect withVisible:(BOOL)visible;
{
	//수정 초기화
	NSMutableString *reVal = [[NSMutableString	alloc] init];
	
	[reVal appendString:[NSString stringWithFormat:@"%.0f", rect.origin.x		]];
	[reVal appendString:@","];
	[reVal appendString:[NSString stringWithFormat:@"%.0f", rect.origin.y		]];
	[reVal appendString:@","];
	[reVal appendString:[NSString stringWithFormat:@"%.0f", rect.size.width		]];
	[reVal appendString:@","];
	[reVal appendString:[NSString stringWithFormat:@"%.0f", rect.size.height	]];
	[reVal appendString:@","];
	[reVal appendString:[NSString stringWithFormat:@"%d", visible				]];
	
	return reVal;
}
+ (CGRect)cgrectfromString:(NSString *)rectString
{
	CGRect rect = CGRectMake(0, 0, 0, 0);
	NSArray *arrRectString = [rectString componentsSeparatedByString:@","];
	if ([arrRectString count] < 3)		return rect;
		
	rect = CGRectMake([[arrRectString objectAtIndex:0] floatValue], [[arrRectString objectAtIndex:1] floatValue], [[arrRectString objectAtIndex:2] floatValue], [[arrRectString objectAtIndex:3] floatValue]);
	return rect;
}

+ (NSInteger)getLineCountFromText:(NSString *)text
{
    return 0;
}

+ (BOOL)isDigit:(NSString*)NumberString
{
    if (NumberString == nil || [NumberString length] == 0 ) {
        return  NO;
    }
    
    BOOL bRet = NO;
    NSInteger  nLen = [NumberString length];
    for (NSInteger i = 0; i < nLen; i++)
    {
        char ch = [NumberString characterAtIndex:i];
        if( '0' <= ch && ch <= '9')
            bRet = YES;
        else
            return NO;
    }
    return bRet;
}

+ (BOOL)isNumeric:(NSString*)NumberString
{
    if (NumberString == nil || [NumberString length] == 0 ) {
        return  NO;
    }
    
    BOOL bRet = NO;
    NSInteger  nLen = [NumberString length];
    for (NSInteger i = 0; i < nLen; i++)
    {
        char ch = [NumberString characterAtIndex:i];
        if( ('0' <= ch && ch <= '9') || ch == '.' || ch == '-' || ch == ' ' )
            bRet = YES;
        else
            return NO;
    }
    return bRet;
}

+ (BOOL) isAlphaNum:(unichar)ch
{
    BOOL bRet = false;
    if( '0' <= ch && ch <= '9')	return true;
    if( 'a' <= ch && ch <= 'z')	return true;
    if( 'A' <= ch && ch <= 'Z')	return true;
    return bRet;
}


+ (unsigned long) getTickCount
{
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return (unsigned long)(tv.tv_sec * 1000 + tv.tv_usec / 1000);
}

+ (unsigned long) getTickCountSeconds
{
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return (unsigned long)tv.tv_sec;
}


+ (float) getCurrentScale
{
    float scale = 1.0f;
    if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) 
    {
        scale = [[UIScreen mainScreen] scale];
    }
    
    return scale;
}

+ (CGSize) CGSizeApplyWithScale:(CGSize)size
{
    CGFloat scale = [CommonUtil getCurrentScale];
    return CGSizeApplyAffineTransform(size, CGAffineTransformMakeScale(scale, scale));
}

+ (void) setCustomLabel:(UILabel *)lable title:(NSString *)title fontSize:(NSInteger)size rect:(CGRect)rect
{
    if (lable == nil) return ;
    
    [lable setText:title];
    [lable setFont:[[ResourceManager sharedManager]getFontWithSize:size]];
    [lable setFrame:rect];
}

+ (void) setCustomLabelWithFont:(UILabel *)lable title:(NSString *)title fontSize:(NSInteger)size
{
    if (lable == nil) return ;
    
    [lable setText:title];
    [lable setFont:[[ResourceManager sharedManager]getFontWithSize:size]];
}

+ (void) setCustomButton:(UIButton *)button title:(NSString*)title fontSize:(NSInteger)size rect:(CGRect)rect
{
    if (button == nil) return;
    
    [button.titleLabel setFont:[[ResourceManager sharedManager] getFontWithSize:size]];
    UIColor *titleColor = [[ResourceManager sharedManager] getColorfromIndex:CID_BUTTON_TEXT];
    [CommonUtil setButtonTitleColor:button normal:titleColor highlited:titleColor selected:titleColor disabled:titleColor];
    [button setBackgroundImage:[[ResourceManager sharedManager] getUIImage:CTL_BUTTON_NORMAL imageOfSize:rect.size] forState:UIControlStateNormal];
    [button setBackgroundImage:[[ResourceManager sharedManager] getUIImage:CTL_BUTTON_HIGH   imageOfSize:rect.size] forState:UIControlStateHighlighted];
    [CommonUtil setButtonTitle:button normal:title highlited:title selected:title disabled:title];
    [button setFrame:rect];
}

+ (void) setButtonImage:(UIButton *)button filename:(NSString *)filename
{
    if (button == nil) return ;
    
    if ([filename hasSuffix:@"_n"])
        filename = [filename substringToIndex:[filename length]-2];
    UIImage *normal = [CommonUtil getImage:[filename stringByAppendingString:@"_n"]];
    UIImage *highlited = [CommonUtil getImage:[filename stringByAppendingString:@"_o"]];
    UIImage *disabled = [CommonUtil getImage:[filename stringByAppendingString:@"_d"]];
    if (normal != nil) [button setImage:normal forState:UIControlStateNormal];
    if (highlited != nil) [button setImage:highlited forState:UIControlStateHighlighted];
    if (highlited != nil) [button setImage:highlited forState:UIControlStateSelected];
    if (disabled != nil) [button setImage:disabled forState:UIControlStateDisabled];
    
}

+ (void) setButtonImage:(UIButton *)button normal:(UIImage *)normal highlited:(UIImage *)highlited selected:(UIImage *)selected disabled:(UIImage *)disabled
{
    if (button == nil) return ;
    
    if (normal != nil) [button setImage:normal forState:UIControlStateNormal];
    if (highlited != nil) [button setImage:highlited forState:UIControlStateHighlighted];
    if (selected != nil) [button setImage:selected forState:UIControlStateSelected];
    if (disabled != nil) [button setImage:disabled forState:UIControlStateDisabled];
}

+ (void) setBackgroundButtonImage:(UIButton *)button normal:(UIImage *)normal highlited:(UIImage *)highlited selected:(UIImage *)selected disabled:(UIImage *)disabled
{
    if (button == nil) return ;
    
    if (normal != nil) [button setBackgroundImage:normal forState:UIControlStateNormal];
    if (highlited != nil) [button setBackgroundImage:highlited forState:UIControlStateHighlighted];
    if (selected != nil) [button setBackgroundImage:selected forState:UIControlStateSelected];
    if (disabled != nil) [button setBackgroundImage:disabled forState:UIControlStateDisabled];
}

+ (void) setBackgroundButtonImage:(UIButton *)button filename:(NSString *)filename
{
    if (button == nil || filename == nil) return ;
    
    UIImage *normalImage    = [[ResourceManager sharedManager] getUIImage:[NSString stringWithFormat:@"%@_n.png", filename] imageOfSize:button.frame.size];
    UIImage *selectedImage  = [[ResourceManager sharedManager] getUIImage:[NSString stringWithFormat:@"%@_o.png", filename] imageOfSize:button.frame.size];
    
    if( normalImage == nil || selectedImage == nil ) return ;
    
    if ([CommonUtil getCurrentScale] == 2.f)
    {
        [button setBackgroundImage:normalImage forState:UIControlStateNormal];
        [button setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
    }
    else
    {
        CGFloat scale = [CommonUtil getCurrentScale]/2;
        CGRect scaledImageRect = CGRectMake(0, 0, normalImage.size.width*scale, normalImage.size.height*scale);
        
        UIGraphicsBeginImageContext(scaledImageRect.size);
        
        [normalImage drawInRect:scaledImageRect];
        UIImage *normalScaleImage = UIGraphicsGetImageFromCurrentImageContext();
        [button setBackgroundImage:normalScaleImage forState:UIControlStateNormal];
        
        [selectedImage drawInRect:scaledImageRect];
        UIImage *selectedScaleImage = UIGraphicsGetImageFromCurrentImageContext();
        [button setBackgroundImage:selectedScaleImage forState:UIControlStateSelected|UIControlStateHighlighted|UIControlStateDisabled];
        
        UIGraphicsEndImageContext();
    }
}


+ (void) setButtonTitle:(UIButton *)button normal:(NSString *)normal highlited:(NSString *)highlited selected:(NSString *)selected disabled:(NSString *)disabled
{
    if (button == nil) return ;
    
    if (normal != nil) [button setTitle:normal forState:UIControlStateNormal];
    if (highlited !=nil) [button setTitle:highlited forState:UIControlStateHighlighted];
    if (selected != nil) [button setTitle:selected forState:UIControlStateSelected];
    if (disabled != nil) [button setTitle:disabled forState:UIControlStateDisabled];
}

+ (void) setButtonTitleColor:(UIButton *)button normal:(UIColor *)normal highlited:(UIColor *)highlited selected:(UIColor *)selected disabled:(UIColor *)disabled
{
    if (button == nil) return ;
    
    if (normal != nil) [button setTitleColor:normal forState:UIControlStateNormal];
    if (highlited !=nil) [button setTitleColor:highlited forState:UIControlStateHighlighted];
    if (highlited !=nil) [button setTitleColor:highlited forState:UIControlStateHighlighted | UIControlStateSelected];
    if (selected != nil) [button setTitleColor:selected forState:UIControlStateSelected];
    if (disabled != nil) [button setTitleColor:disabled forState:UIControlStateDisabled];
}

+ (UIImage *) getImage:(NSString *)filename
{
    if (filename == nil) return nil;

    filename = [filename stringByReplacingOccurrencesOfString:@".png" withString:@""];
    UIImage *image    = [[ResourceManager sharedManager] getUIImage:[NSString stringWithFormat:@"%@.png", filename] imageOfSize:CGSizeMake(0,0)];
    return image;

/*    
    if ([CommonUtil getCurrentScale] == 2.f) return image;
    
    CGRect scaledImageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    UIGraphicsBeginImageContext(scaledImageRect.size);
    
    [image drawInRect:scaledImageRect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    return scaledImage;
 */
}



+ (UIImage *) getCacheImage:(NSString *)filename
{
    if (filename == nil) return nil;
	
    filename = [filename stringByReplacingOccurrencesOfString:@".png" withString:@""];
    UIImage *image    = [[ResourceManager sharedManager] getUICacheImage:[NSString stringWithFormat:@"%@.png", filename] imageOfSize:CGSizeMake(0,0)];
    return image;
}

+ (UIImage *) getImagebyScale:(NSString *)filename
{
    if (filename == nil) return nil;
    
    filename = [filename stringByReplacingOccurrencesOfString:@".png" withString:@""];
    UIImage *image    = [[ResourceManager sharedManager] getUIImage:[NSString stringWithFormat:@"%@.png", filename] imageOfSize:CGSizeMake(0,0)];
    if ([CommonUtil getCurrentScale] == 2.f) return image;
    
    CGRect scaledImageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    UIGraphicsBeginImageContext(scaledImageRect.size);
    
    [image drawInRect:scaledImageRect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

+ (UIImage *) getImage:(NSString *)filename size:(CGSize)size
{
    if (filename == nil) return nil;
    
    // escdream 2017.02.17
    // .9 이미지 파일 로딩 예외처리 추가
    if ([filename hasSuffix:@".png"] == NO)
    {
        NSString *sfileName = [CommonFileUtil getResFilePath:FOLDER_IMAGE fileName:[NSString stringWithFormat:@"%@.png", filename]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:sfileName])
        {
            filename = [filename stringByAppendingString:@".png"];
        }
        else
        {
            filename = [filename stringByAppendingString:@".9.png"];
        }
            
    }
    
    UIImage *image    = [[ResourceManager sharedManager] getUIImage:filename imageOfSize:size];
    if( image == nil ) return nil;
    
    return image;
}

+ (UIImage *) getCacheImage:(NSString *)filename size:(CGSize)size
{
    if (filename == nil) return nil;

    UIImage *image    = [[ResourceManager sharedManager] getUICacheImage:filename imageOfSize:size];
    if( image == nil ) return nil;
    
    return image;
}

+ (UIImage *) getImageWithSize:(CGSize)size filename:(NSString *)filename
{
    if (filename == nil) return nil;
    
    UIImage *image    = [[ResourceManager sharedManager] getUIImage:filename imageOfSize:size];
    if( image == nil ) return nil;
    
    CGRect scaledImageRect = CGRectMake(0, 0, size.width, size.height);

    UIGraphicsBeginImageContext(size);

    [image drawInRect:scaledImageRect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    return scaledImage;
}


+ (UIImage *) getLocalImageWithSize:(CGSize)size filename:(NSString *)filename
{
    if (filename == nil) return nil;
    
    UIImage *image    = [UIImage imageNamed:filename];
    if( image == nil ) return nil;
    
    CGRect scaledImageRect = CGRectMake(0, 0, size.width, size.height);
    
    
    
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, size.width, size.height), [image CGImage]);
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    
//    UIGraphicsBeginImageContext(size);
//    
//    [image drawInRect:scaledImageRect];
//    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
    
    return scaledImage;
}

#pragma mark - Image Resizing
+ (UIImage *)scaleAndRotateImage:(UIImage *)image maxResolution:(int)maxResolution minResolution:(int)minResolution
{
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, minResolution, minResolution);
    if (width > maxResolution || height > maxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = maxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = maxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    CGContextSetInterpolationQuality(context, kCGInterpolationDefault);//kCGInterpolationHigh);
//    CGContextSetShouldAntialias(context, false);

    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

+ (UIImage *) getNinePatchImage:(NSString *)filename size:(CGSize)size
{
    if (filename == nil) return nil;
    
    NinePatchImageInfo *imageInfo = [[NinePatchImageInfo alloc] initWithResource:filename];
    return [imageInfo imageOfSize:size];
}

+ (NSArray *)getNinePatchFullName:(NSString *)filename
{
    NSRange range = [filename rangeOfString:@".9"];
    NSString *strPrevName = nil;
    if (range.location != NSNotFound) {
        strPrevName = [filename substringToIndex:range.location];

        // escdream 2017.02.15
        NSString * small = @"";
        
        if ([strPrevName hasSuffix:@"_n"])
        {
            strPrevName = [strPrevName substringWithRange:NSMakeRange(0, strPrevName.length-2)];
        }
        
        NSString *sfileName = [CommonFileUtil getResFilePath:FOLDER_IMAGE fileName:[NSString stringWithFormat:@"%@_n@2x.9.png", strPrevName]];
        
        // 화면의 가로폭이 375 보다 작은 경우 5s, 5, 4s
        if ([[NSFileManager defaultManager] fileExistsAtPath:sfileName] && ([UIScreen mainScreen].bounds.size.width < 375))
        {
            small = @"@2x";
        }
        else
        {
            sfileName = [CommonFileUtil getResFilePath:FOLDER_IMAGE fileName:[NSString stringWithFormat:@"%@_n%@.9.png", strPrevName, small]];
        }
        
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:sfileName])
        {
            
            if ([strPrevName isEqualToString:@"btn_yellow"])
            {
                return [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@_n%@.9.png", strPrevName, small] , [NSString stringWithFormat:@"%@_o%@.9.png", strPrevName, small] , [NSString stringWithFormat:@"%@%@.9.png", @"btn_disabled", small] , nil];
            }
            
            return [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@_n%@.9.png", strPrevName, small] , [NSString stringWithFormat:@"%@_o%@.9.png", strPrevName, small] , [NSString stringWithFormat:@"%@_d%@.9.png", strPrevName, small] , nil];
        }
        else
        {
            if ([strPrevName hasSuffix:@"_n"])
            {
                sfileName = [strPrevName substringWithRange:NSMakeRange(0, strPrevName.length-2)];
                return [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@_n%@.9.png", strPrevName, small] , [NSString stringWithFormat:@"%@_o%@.9.png", strPrevName, small] , [NSString stringWithFormat:@"%@_d%@.9.png", strPrevName, small] , nil];
            }
            
            return [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@", filename] , [NSString stringWithFormat:@"%@", filename] , [NSString stringWithFormat:@"%@", filename] , nil];
        }
    }
    else{
        NSString *sfileName = [CommonFileUtil getResFilePath:FOLDER_IMAGE fileName:[NSString stringWithFormat:@"%@_n.9.png", filename]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:sfileName])
        {
            return [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@_n.9.png", filename] , [NSString stringWithFormat:@"%@_o.9.png", filename] , [NSString stringWithFormat:@"%@_d.9.png", filename] , nil];
        }
        else
        {
            NSRange rangePng = [filename rangeOfString:@".png"];
            if (rangePng.location == NSNotFound)
            {
                strPrevName = filename;
            }
            else
            {
                strPrevName = [filename substringToIndex:rangePng.location];
            }

            return [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@_n.png", strPrevName] , [NSString stringWithFormat:@"%@_o.png", strPrevName] , [NSString stringWithFormat:@"%@_d.png", strPrevName] ,  nil];
        }
    }
}

+ (float) getPercentfromNumberString:(NSString *)value
{
    return [value floatValue] / 255;
}

+ (void) makeRoundView:(UIView *)window radius:(CGFloat)radius width:(CGFloat)width bordercolor:(UIColor *)bordercolor
{
	if (window == nil) return ;
    
	[window.layer setCornerRadius:radius];
	[window.layer setBorderWidth:width];
	[window.layer setMasksToBounds:YES];
    [window.layer setBorderColor:bordercolor.CGColor];
}

+ (void) makeRoundShadowView:(UIView *)window radius:(CGFloat)radius width:(CGFloat)width bordercolor:(UIColor *)bordercolor
{
	if (window == nil) return ;
    
	[window.layer setCornerRadius:radius];
	[window.layer setBorderWidth:width];
    //	[window.layer setMasksToBounds:YES];
    [window.layer setBorderColor:bordercolor.CGColor];
    
    [window.layer setShadowColor:[UIColor blackColor].CGColor];
    [window.layer setShadowOffset:CGSizeMake(0, 3)];
    [window.layer setShadowRadius:radius];
    [window.layer setShadowOpacity:0.4];
    [window.layer setShouldRasterize:YES];    
    [window.layer setShadowPath:
     [[UIBezierPath bezierPathWithRoundedRect:[window bounds]
                                 cornerRadius:radius] CGPath]];
}

+ (void) makeShodowView:(UIView *)window radius:(CGFloat)radius width:(CGFloat)width shadowcolor:(UIColor *)shadowcolor
{
	if (window == nil) return ;
    
	[window.layer setCornerRadius:radius];
    [window.layer setMasksToBounds:YES];
    
/*    [window.layer setShadowColor:shadowcolor.CGColor];
    [window.layer setShadowOffset:CGSizeMake(0, width)];
    [window.layer setShadowRadius:radius];
    [window.layer setShadowOpacity:0.4];
    [window.layer setShouldRasterize:YES];    
    [window.layer setShadowPath:
     [[UIBezierPath bezierPathWithRoundedRect:[window bounds]
                                 cornerRadius:radius] CGPath]];
*/ 
}



+ (void) makeLineView:(UIView *)window type:(NSInteger)type size:(CGFloat)size linecolor:(UIColor *)linecolor
{
    if (window == nil) return ;
//    [window.layer setPosition:CGPointMake(-1, -1)];
//	[window.layer setCornerRadius:radius];
    
//    CALayer *sublayer = [[CALayer alloc] initWithLayer:window];
//    [window.layer insertSublayer:sublayer above:window.layer];
    if(type==0)
    {

        
//        [window.layer setBounds:CGRectMake(window.frame.size.width, window.frame.origin.y, window.frame.size.width, window.frame.size.height)];
//        [sublayer setBorderWidth:size];
//        [sublayer setMasksToBounds:YES];
//        [sublayer setBorderColor:linecolor.CGColor]; 
    }
    else if(type==1)
    {
//        [window.layer setBounds:CGRectMake(window.frame.origin.x, window.frame.size.height, window.frame.size.width, window.frame.size.height)];

    }

}

+ (id) addSubViewWithNibAndFrame:(NSString *)nibNameNotNil frame:(CGRect)rect target:(UIView *)target
{
	if (nibNameNotNil == nil || target == nil) return nil;
    
	if ([nibNameNotNil isEqualToString:@""]) return nil;
    
	NSArray *arrayForXIB	= [[NSBundle mainBundle] loadNibNamed:nibNameNotNil owner:target options:nil];
	UIView *subView			= [arrayForXIB objectAtIndex:0];
	subView.frame			= rect;
	[target addSubview:subView];
	
	return subView;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - UIAlertView functions

+ (void) ShowAlertWithOk:(NSString *)title message:(NSString *)message delegate:(id)delegate
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
														message:message 
													   delegate:delegate 
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
	[alertView show];
}

+ (void) ShowAlertWithOk:(NSString *)title message:(NSString *)message delegate:(id)delegate tag:(NSInteger)tag
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
														message:message 
													   delegate:delegate 
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
    alertView.tag = tag;
	[alertView show];
}

+ (void) ShowAlertWithCancel:(NSString *)title message:(NSString *)message delegate:(id)delegate;
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
														message:message 
													   delegate:delegate 
											  cancelButtonTitle:@"취소"
											  otherButtonTitles:nil];
	[alertView show];
}

+ (void) ShowAlertWithOkCancel:(NSString *)title message:(NSString *)message delegate:(id)delegate tag:(NSInteger)tag
{
    // 수정함
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
														message:message 
													   delegate:delegate 
											  cancelButtonTitle:@"취소"
											  otherButtonTitles:@"확인", nil];
    alertView.tag = tag;
	[alertView show];
}

+ (void) ShowAlertWithYes:(NSString *)title message:(NSString *)message delegate:(id)delegate tag:(NSInteger)tag
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
														message:message 
													   delegate:delegate 
											  cancelButtonTitle:@"예"
											  otherButtonTitles:nil];
    alertView.tag = tag;
	[alertView show];
}


+ (void) ShowAlertWithYesNo:(NSString *)title message:(NSString *)message delegate:(id)delegate tag:(NSInteger)tag
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
														message:message 
													   delegate:delegate 
											  cancelButtonTitle:NSLocalizedString( @"ALERT_YES", @"" ) 
											  otherButtonTitles:NSLocalizedString(@"ALERT_NO", @""), nil];
    alertView.tag = tag;
	[alertView show];
}

+ (void) ShowAlert:(NSString *)title message:(NSString *)message delegate:(id)delegate tag:(NSInteger)tag
 cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
														message:message 
													   delegate:delegate 
											  cancelButtonTitle:cancelButtonTitle  
											  otherButtonTitles:nil];
	
    alertView.tag = tag;
	if (otherButtonTitles != nil) 
	{
		[alertView addButtonWithTitle:otherButtonTitles];
		
		va_list args;
		va_start(args, otherButtonTitles);
		NSString *otherTitles = nil;
		while( (otherTitles = va_arg(args, NSString *)) != nil )
		{
			[alertView addButtonWithTitle:otherTitles];
		}
		va_end(args);
    }
	
	[alertView show];
}


#pragma mark -
#pragma mark 창 관련 함수.

+ (void) presentModalView:(UIView *)superview source:(UIView *)sourceview animated:(BOOL)animated
{
    if (superview == nil) return ;
    if (sourceview == nil) return ;

    [superview addSubview:sourceview];
}



#pragma mark - performselector 함수 래퍼 API

+ (BOOL) performSelector:(SEL)selector target:(id)target withObject:(id)object
{
	if (target == nil) return FALSE;
	
	if (![target respondsToSelector:selector]) return FALSE;
	
	[target performSelector:selector withObject:object];
	
	return TRUE;
}

+ (BOOL) performSelector2:(SEL)selector target:(id)target withObject:(id)object anotherObject:(id)anotherObject
{
	if (target == nil) return FALSE;
	
	if (![target respondsToSelector:selector]) return FALSE;
	
	[target performSelector:selector withObject:object withObject:anotherObject];
	return TRUE;
}

+ (BOOL) perfromSelectorWithDelay:(SEL)selector target:(id)target withObject:(id)object delay:(CGFloat)delay
{
    if (target == nil) return FALSE;
	
	if (![target respondsToSelector:selector]) return FALSE;
    
    
    [target performSelector:selector withObject:object afterDelay:delay];
    
    return TRUE;
}

+ (CGSize) GetScreenSize
{
    CGRect rect = [[UIScreen mainScreen] bounds];

    rect = [CommonUtil getWindowArea];

    if (IS_IPHONE_X)
        rect.size.height += 20;
    
    
    CGSize screenSize = CGSizeMake(rect.size.width, rect.size.height);
    int nSBHeight = [CommonUtil GetStatusBarHeight] ;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) 
        screenSize = CGSizeMake(screenSize.width, screenSize.height-nSBHeight);
    else
    {
        // iOS8 적용으로 인한 이전버전 기능 유지 -by Berdo
        if ([[SystemUtil instance].m_sOsVersion floatValue] < 8.0)
            screenSize = CGSizeMake(screenSize.height, screenSize.width);
        else
            screenSize = CGSizeMake(screenSize.width, screenSize.height);
        
        
    }
    return screenSize;
}


+ (CGSize) GetDeviceResolution
{
    CGSize screenSize = [self GetScreenSize];
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) screenSize = CGSizeMake(320, 560);
    
    float scale = [CommonUtil getCurrentScale];
    return CGSizeApplyAffineTransform(screenSize, CGAffineTransformMakeScale(scale, scale));
}

+ (int) GetStatusBarHeight
{
    if ([[SystemUtil instance] isIPhoneX])
        return 44;
    else
        return 20;
}

+ (CGRect) GetResizeRect:(CGRect)rect
{
    rect = CGRectMake(rect.origin.x, rect.origin.y, [CommonUtil calcResize:rect.size.width direction:LAYOUT_TYPE_HORIZON mode:0], [CommonUtil calcResize:rect.size.height direction:LAYOUT_TYPE_VERTICAL mode:0]);
    return rect;
}

+ (BOOL)isIPhone5
{
    if ([[UIScreen mainScreen] bounds].size.height > 568.0) return NO;
    return YES;
//     if( [[CommonUtil getPlatformName] hasPrefix:@"iPhone5"] ) return TRUE;
//    else return FALSE;
}

+ (BOOL) IsVerticalDeviceOrientation
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    return (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown);
}

+ (BOOL) IsVerticalOrientation
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];

    if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return TRUE;
    }

    if(orientation == UIInterfaceOrientationLandscapeRight ||
       orientation == UIInterfaceOrientationLandscapeLeft) {
        return FALSE;
    }
    return TRUE;
}


// IOS 6.0 버전에서는 notification 디바이스 오리엔테이션 이벤트가 바뀜.
+ (BOOL)IsVerticalDeviceOrientationByVersions
{
//    if  ([[CommonUtil getDeviceOS] floatValue] >= 6.0f)
//    {
//        return [CommonUtil IsVerticalDeviceOrientation];
//    }else{
        return [CommonUtil IsVerticalOrientation];
//    }
}

+ (CGRect) getKeyboardRect:(NSNotification *)aNotification show:(BOOL)show
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_3_2
	return [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
#else
	return [[[aNotification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
#endif
	// 경고 수정하려면 아래와 같이 하면 됨.
//	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
//	CGRect keyboardRect = [[[aNotification userInfo] objectForKey:show ? UIKeyboardFrameBeginUserInfoKey : UIKeyboardFrameEndUserInfoKey] CGRectValue];
//	if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown)
//	{
//        return CGRectMake(0, 0, CGRectGetWidth(keyboardRect), CGRectGetHeight(keyboardRect));
//	}
//	
//	return CGRectMake(0, 0, CGRectGetHeight(keyboardRect), CGRectGetWidth(keyboardRect));
}

+ (CGFloat) getTopOffset
{
    if ([[CommonUtil getDeviceOS] floatValue] >= 7.0f)
        return 20.f;
    else
        return 0.f;
}

+ (NSString *)getDeviceOS
{
    if (g_strDeviceOS != nil)
        return g_strDeviceOS;
    
    UIDevice *device = [UIDevice currentDevice];
    
    g_strDeviceOS = [NSString stringWithFormat:@"%f", [[device systemVersion] floatValue]];
    return g_strDeviceOS;
}

+ (NSString *) GetDeviceModel
{
    UIDevice *device = [UIDevice currentDevice];
    
    return [NSString stringWithFormat:@"%@_%@_%@", [device model], [device systemName], [device systemVersion]];
}

+ (NSString *) getDeviceModel
{
    return [UIDevice currentDevice].model;
}
+ (NSInteger ) getDeviceType
{
    NSString *strDevice = [UIDevice currentDevice].model;
    if ([strDevice caseInsensitiveCompare:@"Ipad"]  || [strDevice caseInsensitiveCompare:@"ipad simulator"]) {
        BOOL isIPad2 = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad &&
                        [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]);
        if (isIPad2) return Ipad2;
        else    return Ipad1;
    }else if ([strDevice caseInsensitiveCompare:@"iPhone"] || [strDevice caseInsensitiveCompare:@"iphone simulator"])
        return Iphone;
    else if ([strDevice caseInsensitiveCompare:@"iPod touch"])
        return Ipod_touch;
    
    
    return -1;
}

+(double) calcResize:(CGFloat)size direction:(LAYOUT_TYPE)dir mode:(LAYER_TYPE)mode
{
	double rate = [[SystemUtil instance] getScreenRateOfDir:dir mode:mode];
	//    float calcSize =(float)(rate * size);
	return rate * size;
}

+(double)calcUnResize:(CGFloat)size direction:(LAYOUT_TYPE)dir mode:(LAYER_TYPE)mode
{
	double rate = [[SystemUtil instance] getScreenRateOfDir:dir mode:mode];
    return size / rate;
}

+(BOOL)isIpad
{
    NSString *strDevice = [UIDevice currentDevice].model;
    if ([strDevice caseInsensitiveCompare:@"ipad"] || [strDevice caseInsensitiveCompare:@"ipad simulator"])
        return YES;
    else
        return NO;
}

+ (NSString *) getErrorMessageWithCode:(NSInteger)code
{
    switch (code)
    {
        case 90001 :
            return NSLocalizedString(@"ERROR_CHECK_PUBLIC_CERT_90001", @"");
        case 90002 :
            return NSLocalizedString(@"ERROR_CHECK_PUBLIC_CERT_90002", @"");
        case 90003 :
            return NSLocalizedString(@"ERROR_CHECK_PUBLIC_CERT_90003", @"");
        case 90004 :
            return NSLocalizedString(@"ERROR_CHECK_PUBLIC_CERT_90004", @"");
        case 90005 :
            return NSLocalizedString(@"ERROR_CHECK_PUBLIC_CERT_90005", @"");
        case 90006 :
            return NSLocalizedString(@"ERROR_CHECK_PUBLIC_CERT_90006", @"");
        case 90007 :
            return NSLocalizedString(@"ERROR_CHECK_PUBLIC_CERT_90007", @"");
        case 90009 :
            return NSLocalizedString(@"ERROR_CHECK_PUBLIC_CERT_90009", @"");
        case 90011 :
            return NSLocalizedString(@"ERROR_CHECK_PUBLIC_CERT_90011", @"");
        case 90012 :
            return NSLocalizedString(@"ERROR_CHECK_PUBLIC_CERT_90012", @"");
        case 90013 :
            return NSLocalizedString(@"ERROR_CHECK_PUBLIC_CERT_90013", @"");
    }
    
    return NSLocalizedString(@"ERROR_CHECK_PUBLIC_CERT", @"");
}

+ (NSString *) GetIPAddress
{
    BOOL success;
    BOOL find_success = FALSE;
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    NSString  *address = @"";
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0) // this second test keeps from picking up the loopback address
            {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"]) { // found the WiFi adapter
                    address =  [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
                    find_success = TRUE;
                }else if ([name isEqualToString:@"pdp_ip0"]) { // found the 3G adapter
                    address =  [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
                    find_success = TRUE;
                }
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    
    if(find_success == FALSE) address = @"127.0.0.1"; // IP를 못 찾았을 경우 localhost IP Set.
    
    NSArray *arrIpLevel = [address componentsSeparatedByString:@"."];
    //NSLog(@"0000=>[%d]",[arrIpLevel count]);
    if([arrIpLevel count]  !=4 )return @"";
    int level1 = [[arrIpLevel objectAtIndex:0] intValue];
    int level2 = [[arrIpLevel objectAtIndex:1] intValue];
    int level3 = [[arrIpLevel objectAtIndex:2] intValue];
    int level4 = [[arrIpLevel objectAtIndex:3] intValue];
    
    return [NSString stringWithFormat:@"%03d%03d%03d%03d",
            level1, level2, level3, level4];
    
    //    return address;
}


+ (NSString *) GetMACAddress
{
#ifndef IFT_ETHER
#define IFT_ETHER 0x6
#endif

    struct ifaddrs * startIFAddrs = NULL;
    struct ifaddrs * currentIFAddr = NULL;
    const struct sockaddr_dl *sockAddrDl = NULL;
    const unsigned char *base = NULL;
//    char szMacAddress[256] = {0x00, };
    char * szMacAddress = 0;
    szMacAddress = (char *)malloc(256);
    memset(szMacAddress, 0x0, 255);

    
    // 무조건 랜카드 맥주소 반환. 3G 상황에서도.
    if (getifaddrs(&startIFAddrs) == 0) 
    {
        currentIFAddr = startIFAddrs;
        while (currentIFAddr != 0) 
        {
            if ((currentIFAddr->ifa_flags & IFF_UP) != 0 && 
                (currentIFAddr->ifa_addr->sa_family == AF_LINK) && 
                (((const struct sockaddr_dl *) currentIFAddr->ifa_addr)->sdl_type == IFT_ETHER))
            {
                sockAddrDl = (const struct sockaddr_dl *)currentIFAddr->ifa_addr;
                base = (const unsigned char*) &sockAddrDl->sdl_data[sockAddrDl->sdl_nlen];
                for (int i = 0; i < sockAddrDl->sdl_alen; i++) 
                {
                    //김재인 과장님이 맥주소에 :을 빼자고 하셔서 주석처리 - 2012.10.25 홍재
//                    if (i != 0) strcat(szMacAddress, ":");
                    
                    char partialAddr[3] = {0x00, };
                    sprintf(partialAddr, "%02X", base[i]);
                    strncat(szMacAddress, partialAddr, strlen(partialAddr));
                    // escdream 2018.03.12 취약점 처리 추가  strcat -> strncat
                }
                break;
            }
            
            currentIFAddr = currentIFAddr->ifa_next;
        }
        
        freeifaddrs(startIFAddrs);
    }
    
    NSString * sRet = [NSString stringWithFormat:@"%s", szMacAddress];
    
    free((char *) szMacAddress);
    
    return sRet;
}

#pragma mark - NSUserDefault Wrapper

+ (BOOL) getBoolForKey:(NSString *)key basic:(BOOL)basic
{
    if (key == nil) return NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if( [defaults objectForKey:key] == nil ) return basic;
    
    return [defaults boolForKey:key];
}

+ (void) setBoolWithKey:(BOOL)value key:(NSString *)key
{
    if (key == nil) return ;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:value forKey:key];
    [defaults synchronize];
}

+ (NSInteger) getIntegerForKey:(NSString *)key basic:(NSInteger)basic
{
    if (key == nil) return 0;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger value = basic;
    
    if ([defaults integerForKey:key])
    {
        value = [defaults integerForKey:key];
    }
    return value;
}

+ (void) setIntegerWithKey:(NSInteger)value key:(NSString *)key
{
    if (key == nil) return ;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:value forKey:key];
    [defaults synchronize];
}

+ (float) getFloatForKey:(NSString *)key basic:(float)basic
{
    if (key == nil) return 0.f;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    float value = [defaults floatForKey:key];
    
    return value;
}

+ (void) setFloatWithKey:(float)value key:(NSString *)key
{
    if (key == nil) return ;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:value forKey:key];
}


+ (NSString *) getStringForKeyEx:(NSString *)key basic:(NSString *)basic
{
    if (key == nil) return @"";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults stringForKey:key];
    if (value != nil && [value length] > 0)
    {
        return [CommonUtil getDecodeText:value];
    }
    
    return basic == nil ? @"" : [NSString stringWithString:basic];
}

+ (void) setStringWithKeyEx:(NSString *)value key:(NSString *)key
{
    
    if (key == nil || value == nil) return ;
    
    value = [CommonUtil getEncodeText:value];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:value forKey:key];
    [defaults synchronize];
    
}


+ (NSString *) getStringForKey:(NSString *)key basic:(NSString *)basic
{
    if (key == nil) return @"";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults stringForKey:key];
    if (value != nil && [value length] > 0) return value;
    
    return basic == nil ? @"" : [NSString stringWithString:basic];
}


+ (BOOL) getBoolConfigForKey:(NSString *)key basic:(BOOL)basic
{
    if (key == nil) return basic;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *value = [defaults stringForKey:key];
    if (value != nil && [value length] > 0)
    {
        if( [value caseInsensitiveCompare:@"true"] == NSOrderedSame )
            return TRUE;
        if( [value isEqualToString:@"Y"] ) 
            return TRUE;
        if( [value isEqualToString:@"1"] ) 
            return TRUE;
        return FALSE;
    }
    
    return basic;
}

+ (void) setStringWithKey:(NSString *)value key:(NSString *)key
{

    if (key == nil || value == nil) return ;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:value forKey:key];
    [defaults synchronize];

}

+ (id) getObjectForKey:(NSString *)key
{
    if (key == nil) return nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *unArchiveData = [defaults objectForKey:key];
    if (unArchiveData == nil) return nil;
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:unArchiveData];
}

+ (void) setObjectWithKey:(id)object key:(NSString *)key
{
    if (key == nil || object == nil) return ;
    
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:object];
    if( archiveData == nil ) return;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:archiveData forKey:key];
    [defaults synchronize];
}

// 스트링 데이터 암호화해서 저장
+ (BOOL) saveStringWithEncryption:(NSString *)key enryptkey:(NSString *)encryptkey vector:(NSString *)vector data:(NSString *)data
{
    if (key == nil || encryptkey == nil || data == nil) return NO;

    NSData *dataSource      = [NSData dataWithBytes:[data UTF8String] length:strlen([data UTF8String])];
    NSData *encryptedData   = [dataSource aesEncryptWithKey:encryptkey initialVector:vector] ; // 암호화
    if (encryptedData == nil) return NO;
    
    [[NSUserDefaults standardUserDefaults] setObject:encryptedData forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

+ (BOOL) saveDataWithEncryption:(NSString *)key enryptkey:(NSString *)encryptkey vector:(NSString *)vector data:(NSData *)data
{
    if (key == nil || encryptkey == nil || data == nil) return NO;
    
    NSData *encryptedData = [data aesEncryptWithKey:encryptkey initialVector:vector]; // 암호화
    if (encryptedData == nil) return NO;
    
    [[NSUserDefaults standardUserDefaults] setObject:encryptedData forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

/*
 * 암호화된 데이터를 복호환된 스트링으로 반환
 */
+ (NSString *) getStringWithDecryption:(NSString *)key decryptkey:(NSString *)decryptkey vector:(NSString *)vector 
{
    if (key == nil || decryptkey == nil) return nil;
    
    NSData *dataSource      = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (dataSource == nil) return nil;
    
    NSData *decryptedData   = [dataSource aesDecryptWithKey:decryptkey initialVector:vector];
    if (decryptedData == nil) return nil;
    
    NSInteger length = [decryptedData length]+1;
    const char *buffer = malloc(length);
    memset((void *)buffer, 0x00, length);
    
    [decryptedData getBytes:(void *)buffer range:NSMakeRange(0, [decryptedData length])];
    NSString *resultString = [NSString stringWithUTF8String:buffer];
    free((void *)buffer);
    
    return resultString;
}

/*
 * 암호환된 데이터를 복호화된 데이터로 반환
 */
+ (NSData *) getDataWithDecryption:(NSString *)key decryptkey:(NSString *)decryptkey vector:(NSString *)vector 
{
    if (key == nil || decryptkey == nil) return nil;
    
    NSData *dataSource = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (dataSource == nil) return nil;
    
    NSData *decryptData = [dataSource subdataWithRange:NSMakeRange(0, [dataSource length])];

    return [decryptData aesDecryptWithKey:key initialVector:vector];
}

+ (void) removeObjectForKey:(NSString *)key
{
    if (key == nil) return ;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

#pragma mark -
#pragma Date functions

+ (int)numberOfDaysBetween:(NSString *)startDate and:(NSString *)endDate
{
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyyMMdd"];
    
    NSDate *dateStart = [f dateFromString:startDate];
    NSDate *dateEnd = [f dateFromString:endDate];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:dateStart
                                                          toDate:dateEnd
                                                         options:NSCalendarWrapComponents];
    
    return (int)[components day];
}

+ (NSString*)offsetFromDay:(NSString*)startDate offsetDay:(int)nOffsetDay
{
    NSDateFormatter *beginFormatter = [[NSDateFormatter alloc] init];
    beginFormatter.dateFormat = @"yyyyMMdd";
    NSDate *beginDate = [beginFormatter dateFromString:startDate];
    
    NSDate *endDate = [beginDate dateByAddingTimeInterval:(nOffsetDay * 60 * 60 * 24)];
    
    return [beginFormatter stringFromDate:endDate];
}

+ (NSTimeInterval)offsetFromTime:(NSString*)sStartTime endTime:(NSString*)sEndTime
{
    
    NSDateFormatter *beginFormatter = [[NSDateFormatter alloc] init];
    beginFormatter.dateFormat = @"yyyyMMddHHmmss";
    NSDate *beginDate = [beginFormatter dateFromString:sStartTime];
    
    NSDateFormatter *endFormatter = [[NSDateFormatter alloc] init];
    endFormatter.dateFormat = @"yyyyMMddHHmmss";
    NSDate *endDate = [endFormatter dateFromString:sEndTime];
    
    NSTimeInterval interval = [endDate timeIntervalSinceDate:beginDate];
    return interval;
}


+ (NSString *) stringFromDateWithFormat:(NSDate *)dateTime format:(NSString *)format
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setLocale:[NSLocale currentLocale]];
	[dateFormatter setDateFormat:format];
	
	NSString *formattedDateString = [dateFormatter stringFromDate:dateTime];
	
	return formattedDateString;
}

+ (NSDate *) dateFromFormattedString:(NSString *)dateString format:(NSString *)format
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setLocale:[NSLocale currentLocale]];
	[dateFormatter setDateFormat:format];
	
	NSDate *dateTime = [dateFormatter dateFromString:dateString];
	
	return dateTime;
}

+ (CGRect) getRectFromStringByComma:(NSString *)value
{
    if (value == nil) return CGRectZero;

    NSArray *rectArray = [value componentsSeparatedByString:@","];
    if ([rectArray count] != 5) return CGRectZero;
    
    return CGRectMake([[rectArray objectAtIndex:0] intValue], [[rectArray objectAtIndex:1] intValue], 
                      [[rectArray objectAtIndex:2] intValue], [[rectArray objectAtIndex:3] intValue]);
}

+ (float) getImageValueWithScale:(float)value
{
    float scale = [self getCurrentScale] / 2.0f;
    return value * scale;
}

+ (NSString *) getReplaceFromString:(NSString *)value expr:(NSString *)expr substitute:(NSString *)substitute
{
    NSMutableString *mstr = [NSMutableString stringWithString:value];
    NSRange substr = [mstr rangeOfString:expr];
    while (substr.location != NSNotFound) {
        [mstr replaceCharactersInRange:substr withString:substitute];
        substr = [mstr rangeOfString:expr];
    }
    
    return mstr;
}

+ (NSString *) getCurrencyFromString:(NSString *)value formatter:(NSNumberFormatter *)formatter
{
    if (formatter == nil) formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setFormatterBehavior:NSNumberFormatterBehaviorDefault];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    return [formatter stringFromNumber:[NSNumber numberWithFloat:[value floatValue]]];
}

+ (NSString *) getcurrencyFromFloat:(CGFloat)value formatter:(NSNumberFormatter *)formatter
{
    if (value <= 0) return @"";
    if (formatter == nil) formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setFormatterBehavior:NSNumberFormatterBehaviorDefault];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    return [formatter stringFromNumber:[NSNumber numberWithFloat:value]];
}

+ (NSString *) getcurrencyFromDouble:(double)value formatter:(NSNumberFormatter *)formatter
{
    if (value <= 0) return @"";
    if (formatter == nil) formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setFormatterBehavior:NSNumberFormatterBehaviorDefault];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    return [formatter stringFromNumber:[NSNumber numberWithDouble:value]];
}

#pragma mark -
#pragma mark - 

+ (UIColor *) getColorForFluctuating:(NSInteger)value
{	
    switch(value)
    {
		case 2:
		case 4:
			return [[ResourceManager sharedManager] getDownColor];
            
		case 1:
		case 3:
            return [[ResourceManager sharedManager] getUpColor];
    }
    
    return [[ResourceManager sharedManager] getBasicTextColor];
}

+ (BOOL) isDisplayFluctuatingValue:(NSInteger)value
{
    switch(value)
    {
        case '2' :
        case '4' :
        case '1' :
        case '3' :
            return YES;
    }
     
    return NO;
}

+ (void)animationWithType:(NSInteger)nAniType  duration:(CGFloat)duration Target:(UIView*)target frame:(CGRect)rect callback:(void (^)(BOOL success))callback
{
    CGRect shiftrect = rect;
    switch (nAniType) {
        case ANIMATION_FROM_LEFT:
        {
            shiftrect.origin.x -= shiftrect.size.width;
            break;
        }
        case ANIMATION_FROM_RIGHT:
        {
            shiftrect.origin.x += shiftrect.size.width;            
            break;
        }
        case ANIMATION_FROM_TOP:
        {
            shiftrect.origin.y -= shiftrect.size.height;
            break;
        }
        case ANIMATION_FROM_BOTTON:
        {
            shiftrect.origin.y += shiftrect.size.height;
            break;
        }
        case ANIMATION_FROM_CENTER:
        {
            [UIView animateWithDuration:duration
                             animations:^(void)
             {
                 target.alpha = 1;
                 target.transform = CGAffineTransformMakeScale(1, 1);
             }
                             completion:callback
             ];
            return;
        }
        default:
            break;
    }
    [target setFrame:shiftrect];    
    [UIView animateWithDuration:duration
                     animations:^(void) 
     {
         [target setFrame:rect];
     } 
                     completion:callback];

}
+ (void)animationWithTypePop:(NSInteger)nAniType  duration:(CGFloat)duration Target:(UIView*)target frame:(CGRect)rect formRect:(CGRect)formRect callback:(void (^)(BOOL success))callback
{
    
    CGRect shiftrect = rect;
    switch (nAniType) {
        case ANIMATION_FROM_LEFT:
        {
            shiftrect.origin.x -= shiftrect.size.width;
            break;
        }
        case ANIMATION_FROM_LEFT_FIT:
        {
            shiftrect.origin.x -= shiftrect.size.width;
            rect.origin.x -= (rect.size.width - formRect.size.width)/2;
            break;
        }
        case ANIMATION_FROM_RIGHT:
        {
            shiftrect.origin.x += shiftrect.size.width;
            break;
        }
        case ANIMATION_FROM_RIGHT_FIT:
        {
            shiftrect.origin.x += shiftrect.size.width;
            rect.origin.x += (rect.size.width - formRect.size.width)/2;
            break;
        }
        case ANIMATION_FROM_TOP:
        {
            shiftrect.origin.y -= shiftrect.size.height;
            break;
        }
        case ANIMATION_FROM_TOP_FIT:
        {
            shiftrect.origin.y -= shiftrect.size.height;
            rect.origin.y -= (rect.size.height - formRect.size.height)/2 - formRect.origin.y - [CommonUtil GetStatusBarHeight];
            break;
        }
        case ANIMATION_FROM_BOTTON:
        {
            shiftrect.origin.y += shiftrect.size.height;
            break;
        }
        case ANIMATION_FROM_BOTTON_FIT:
        {
            shiftrect.origin.y += shiftrect.size.height;
            rect.origin.y = (rect.size.height - formRect.size.height - formRect.origin.y)/2 - [CommonUtil GetStatusBarHeight];
            break;
        }
        case ANIMATION_FROM_CENTER:
        {
            [UIView animateWithDuration:duration
                             animations:^(void)
             {
                 target.alpha = 1;
                 target.transform = CGAffineTransformMakeScale(1, 1);
             }
                             completion:callback
             ];
            return;
        }
        default:
            break;
    }
    [target setFrame:shiftrect];
    [UIView animateWithDuration:duration
                     animations:^(void)
     {
         [target setFrame:rect];
     }
                     completion:callback];
    
}
+ (void)animationWithTypeLinkForm:(NSInteger)nAniType  duration:(CGFloat)duration Target:(UIView*)target frame:(CGRect)rect callback:(void (^)(BOOL success))callback
{
    CGRect shiftrect = rect;
    switch (nAniType) {
        case LINKFORM_ANIMATION_FROM_LEFT:
        {
            shiftrect.origin.x -= shiftrect.size.width;
            break;
        }
        case LINKFORM_ANIMATION_FROM_RIGHT:
        {
            shiftrect.origin.x += shiftrect.size.width;
            break;
        }
        case LINKFORM_ANIMATION_FROM_TOP:
        case LINKFORM_ANIMATION_FROM_FADEIN:
        {
            shiftrect.origin.y -= shiftrect.size.height;
            break;
        }
        case LINKFORM_ANIMATION_FROM_BOTTON:
        {
            shiftrect.origin.y += shiftrect.size.height;
            break;
        }
//        case LINKFORM_ANIMATION_FROM_FADEIN:
//        {
//            [UIView animateWithDuration:duration
//                             animations:^(void)
//             {
//                 target.alpha = 1;
//                 target.transform = CGAffineTransformMakeScale(1, 1);
//             }
//                             completion:callback
//             ];
//            return;
//        }
        default:
            break;
    }
    [target setFrame:shiftrect];
    [UIView animateWithDuration:duration
                     animations:^(void)
     {
         [target setFrame:rect];
     }
                     completion:callback];
    
}
+ (NSInteger) getScrollBarIndicatorStyle
{
    if ([[self getTheme] isEqualToString:@"0"])
        return UIScrollViewIndicatorStyleWhite;
    return UIScrollViewIndicatorStyleBlack;
}

+ (CGRect) getRectInParent:(CGRect)frameRect parentRect:(CGRect)parentRect
{
    int nWidth = frameRect.size.width;
    if( parentRect.size.width != 0 && frameRect.origin.x + frameRect.size.width > parentRect.size.width )
    nWidth = parentRect.size.width - frameRect.origin.x;
    int nHeight = frameRect.size.height;
    if( parentRect.size.height != 0 && frameRect.origin.y + frameRect.size.height > parentRect.size.height )
    nHeight = parentRect.size.height - frameRect.origin.y;

    CGRect contRect = CGRectMake(frameRect.origin.x, frameRect.origin.y, nWidth, nHeight);
    return contRect;
}

+ (NSString *) getShortURL:(NSString *)data company:(NSString *)company
{
    if (data == nil) return @"";
    NSArray *dataArray = [data componentsSeparatedByString:@"\n"];
    if ([dataArray count] < 8) return [NSString stringWithFormat:@"%@", data];
    
    NSString *basicURL = [WebUtil getStringURL:@"MOBILENEWS"];
    NSString *shortURL = [NSString stringWithFormat:@"%@", company];
    if (basicURL != nil && ![basicURL isEqualToString:@""])
    {
        NSString *selectedString = @"1";
        NSString *category1 = [dataArray objectAtIndex:0];
        NSString *category2 = [dataArray objectAtIndex:1];
        if ([category1 isEqualToString:@"3"]) selectedString = @"2";
        else if ([category1 isEqualToString:@"1"] && [category2 isEqualToString:@"FC2"]) selectedString = @"3";
        shortURL = [NSString stringWithFormat:@"{\"longUrl\":\"%@?selected=%@&fgubunz3=%@&datez8=%@&timez6=%@&sendidz6=%@&typejmcode=%@\"}", 
                              basicURL, selectedString, category2, 
                              [dataArray objectAtIndex:2], [dataArray objectAtIndex:3], 
                              [dataArray objectAtIndex:4], [dataArray objectAtIndex:5]];
        
        NSData *requestData = [shortURL dataUsingEncoding:NSUTF8StringEncoding];
        NSString *apiEndpoint = [NSString stringWithFormat:@"https://www.googleapis.com/urlshortener/v1/url"];
        NSMutableURLRequest *requestForDownload = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiEndpoint] 
                                                                          cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.f];
        [requestForDownload setHTTPMethod:@"POST"];
        [requestForDownload setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [requestForDownload setHTTPBody:requestData];
        
        NSError *error = nil;
        NSHTTPURLResponse *responseForDownload = nil;
        NSMutableData *responseData = [[NSMutableData alloc] initWithData:[NSURLConnection sendSynchronousRequest:requestForDownload
                                                                                  returningResponse:&responseForDownload error:&error]];
        NSInteger statusCode = [responseForDownload statusCode];        
        if (responseData != nil && statusCode == 200)
        {
            NSString *shortURLData = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            NSDictionary *responseDictionary = [shortURLData JSONValue];
            
            return [NSString stringWithFormat:@"%@ %@", company, [responseDictionary objectForKey:@"id"]];
        }
        
        return @"";
    }
    
    return shortURL;
}

+ (NSString *) getAppStoreDownloadUri
{
    return @"https://itunes.apple.com/kr/app/id350742701";
}

// 앱스토어 마켓 주소 받아다 처리!!!!
+ (NSString *) getAndroidMarketDownloadUri
{
    return @"market://details?id=com.Lab.ITGenLab.neo.trade";
}

+ (NSString *) getDirectAppStoreUrl
{
    return @"https://itunes.apple.com/kr/app/id350742701";
}

+ (NSString *) getDirectAndroidAppStoreUrl
{
    return @"ITGenLabStdDev://content";
}



+ (BOOL) isFirstRun
{
    BOOL isFirstRun = [self getBoolForKey:k_isfirstrun basic:TRUE];
    
    return isFirstRun;
}


+ (void) setFirstRun:(BOOL)isFirst
{
	[self setBoolWithKey:isFirst key:k_isfirstrun];
}


/**
 * @brief Screen Capture
 * @param UIViewController* view // Capture UIViewController
 * @param NSString* filename     // Capture FileName
 * @param NSInterger* type       // Image Type
 * @return NSString*             // Return Capture File FullPath
 * @author Berdo(JaeWoong-Seok)[EMail:berdo_seok@naver.com]
 * @date 2012-01-18
 */
+(NSString*)SetScreenCapture:(UIViewController*)view filename:(NSString*)filename type:(NSInteger)type
{
    // View Size를 캡춰한다. -by Berdo 2012-01-18
    CGRect screenRect = view.view.frame;//[[UIScreen mainScreen] bounds];
    UIGraphicsBeginImageContext(screenRect.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextFillRect(ctx, screenRect);
    
    [view.view.layer renderInContext:ctx];
    UIImage *imgscrshot = UIGraphicsGetImageFromCurrentImageContext();
    NSString *strFileFullPath = [CommonFileUtil SaveImageFile:imgscrshot filename:filename type:type];
    UIGraphicsEndImageContext();

    return strFileFullPath;
}

/**
 * @brief Parse Event Param
 * @param NSString* strParam    //Event Parameter
 * @param NSString* strSep //Parse Separator
 * @return NSArray*
 * @author(JaeWoong-Seok)[EMail:berdo_seok@naver.com]
 * @date 2012-03-20
 */
+(NSArray*)ParseEventParam:(NSString*)strParam strSep:(NSString*)strSep
{
    NSString* strChangeParam = [strParam stringByReplacingOccurrencesOfString:strSep withString:@"`"];
    strChangeParam = [strChangeParam stringByReplacingOccurrencesOfString:@"<<" withString:@""];
    strChangeParam = [strChangeParam stringByReplacingOccurrencesOfString:@">>" withString:@""];
    
    NSArray *arrRet = [strChangeParam componentsSeparatedByString:@"`"];
    
    return arrRet;
}

// 아이패드에서는 홀수 영역인 경우 라벨 텍스트가 번져 보이는 경우가 발생한다. 그래서 강제로 짝수로 맞추는 함수 작성. ㅠ.ㅠ
+ (CGRect) makeEventRect:(CGRect)rect
{
    rect.origin.x = (int)(rect.origin.x);
    rect.origin.y = (int)(rect.origin.y);
    if( (int)(rect.size.width) % 2 != 0 )
        rect.size.width = (int)(rect.size.width) + 1;
    if( (int)(rect.size.height) % 2 != 0 )
        rect.size.height = (int)(rect.size.height) + 1;
    return rect;
}

+ (BOOL) isIpadOne
{
    // 카메라 가능
    BOOL isIPad2 = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]);
    return !isIPad2;
}

+ (void) removeAllSubView:(UIView *)view
{
    NSArray *arrSubView = [view subviews];
    if( arrSubView == nil ) return;
    
    for( UIView *subView in arrSubView )
    {
        [subView removeFromSuperview];
    }
}

+ (void)LogUsedCpu
{
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return ;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return ;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return ;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    NSLog(@"%f" , tot_cpu);
    
}

+ (void)LogUsedMemory:(NSString *)tag
{
    struct task_basic_info t_info;
    mach_msg_type_number_t t_info_count = TASK_BASIC_INFO_COUNT;
    
    if (task_info(current_task(), TASK_BASIC_INFO, (task_info_t)&t_info, &t_info_count) !=  KERN_SUCCESS)
    {
        NSLog(@"[%@] %s(): Error in task_info(): %s", tag, __FUNCTION__, strerror(errno));
    }
    
    vm_size_t rss = t_info.resident_size;  //Activity Monitor의 Real Memory
    vm_size_t vs = t_info.virtual_size;  // Activity Monitor의 Virtual Memory
    
    NSLog(@"[%@] RSS: %u KB, VS: %u KB.", tag, rss/1024, vs/1024);

}
//
+ (NSString*)getTheme
{
    return [self getStringForKey:k_common_theme basic:config_themedefault];
}

+(UIImage *)resizeImage:(UIImage *)image width:(float)resizeWidth height:(float)resizeHeight{
    UIGraphicsBeginImageContext(CGSizeMake(resizeWidth, resizeHeight));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, resizeHeight);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, resizeWidth, resizeHeight), [image CGImage]);
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (UIColor*)getGridBackgroundColor
{
    return [[ResourceManager sharedManager] getColorfromIndex:CID_CELL_BACK];
}

+ (UIColor*)getGridSeperateColor
{
    return [[ResourceManager sharedManager] getColorfromIndex:CID_INNERLINE];
}

+ (UIView*)getGridBackgroundView:(CGRect)frame
{
    UIView *cellView = [[UIView alloc] initWithFrame:frame];
    [cellView setBackgroundColor:[self getGridBackgroundColor]];
    return cellView;
}

///// 아이디 암호화

/////++
+ (NSString *) getEncodeText:(NSString *)strData
{
    @try {
        if(strData == nil || [strData length] == 0) return @"";
		
        const char *input = [strData UTF8String];
        char *output = malloc(strlen(input) * 3);
        memset(output, 0x00, strlen(input) * 3);
        //BASE64_Encode((ks_uint8 *)output, (ks_uint8 *)input, strlen(input));
		[self EncyptUserID:output sBuff:(char*)input slength:(int)strlen(input) Flag:YES];
		
        NSString *sEncodeText = [NSString stringWithUTF8String:output];
        free(output);
        return sEncodeText;
    }
    @catch(NSException *ex)
    {
    }
    
    return strData;
}

+ (NSString *) getDecodeText:(NSString *)strData
{
    @try {
        if(strData == nil || [strData length] == 0) return @"";
        
        const char *input = [strData UTF8String];
        char *output = malloc(strlen(input) * 3);
        memset(output, 0x00, strlen(input) * 3);
        //BASE64_Decode((ks_uint8 *)output, (ks_uint8 *)input, strlen(input));
		[self EncyptUserID:output sBuff:(char*)input slength:(int)strlen(input) Flag:NO];
        NSString *sDecodeText = [NSString stringWithUTF8String:output];
        free(output);
        return sDecodeText;
    }
    @catch(NSException *ex)
    {
    }
    
    return strData;
}
//int XOR_ID(char *tBuff, char *key, int slength, int klength)
+ (int)XOR_ID:(char *)tBuff key:(char *)key slength:(int)slength klength:(int)klength
{
    for(int i = 0, j = 0; i < slength; i++, j++)
    {
        j %= klength;
        tBuff[i] ^= key[j];
    }
    
    return 0;
}

//int RRotate(char *tBuff, char *sBuff, int slength, int Per, int SByte)
+ (int)RRotate:(char *)tBuff sBuff:(char *)sBuff slength:(int)slength Per:(int)Per SByte:(int)SByte
{
	int  i = 0;
    char ttmp[16], stmp[16];
    char tmp[128];
    
    // Per단위 미만인 경우 이동하지 않고 copy만 하기 위해
    //
    memcpy(tmp, sBuff, slength);
    memcpy(tBuff, sBuff, slength);
    for(i = 0; i < slength-Per+1; i+=Per)
    {
        // Per단위만큼 자른다
        sprintf(stmp, "%.*s", Per, sBuff+i);
        for(int j = 0; j < Per; j++)
        {
            if(j - SByte < 0) ttmp[j] = stmp[j-SByte+Per];
            else			  ttmp[j] = stmp[j-SByte];
        }
        memcpy(tmp+i, ttmp, Per);
    }
    memcpy(tBuff, tmp, slength);
    
    return i;
}

//int LRotate(char *tBuff, char *sBuff, int slength, int Per, int SByte)
+ (int)LRotate:(char *)tBuff sBuff:(char *)sBuff slength:(int)slength Per:(int)Per SByte:(int)SByte
{
    int  i = 0;
    char ttmp[16], stmp[16];
    char tmp[128];
    
    // Per단위 미만인 경우 이동하지 않고 copy만 하기 위해
    memcpy(tmp, sBuff, slength);
    
    for(i = 0; i < slength-Per+1; i+=Per)
    {
        // Per단위만큼 자른다
        sprintf(stmp, "%.*s", Per, sBuff+i);
        for(int j = 0; j < Per; j++)
        {
            if(j + SByte >= Per) ttmp[j] = stmp[j+SByte-Per];
            else				 ttmp[j] = stmp[j+SByte];
        }
        memcpy(tmp+i, ttmp, Per);
    }
    memcpy(tBuff, tmp, slength);
    
    return i;
}


// 암호화 : Flag(암호화:1, 복호화:0)
//void EncyptUserID(char *tBuff, char *sBuff, int slength, BOOL Flag)
+ (void)EncyptUserID:(char*)tBuff sBuff:(char*)sBuff slength:(int)slength Flag:(BOOL)Flag
{
	char key[2] = { 0x01, 0x0e };
    
    if(Flag == TRUE)		// Encryption
    {
        // 3Byte단위로 1Byte씩 우측으로 이동
        //        RRotate(tBuff, sBuff, slength, 4, 1);
        [self RRotate:tBuff sBuff:sBuff slength:slength Per:4 SByte:1];
        
        // 암호화키와 Xor를 한다.
        //        XOR_ID(tBuff, key, slength, sizeof(key));
        [self XOR_ID:tBuff key:key slength:slength klength:sizeof(key)];
    }
    else if(Flag == FALSE)	// Decryption
    {
        // 암호화키와 Xor를 한다.
        memcpy(tBuff, sBuff, slength);
        //        XOR_ID(tBuff, key, slength, sizeof(key));
        [self XOR_ID:tBuff key:key slength:slength klength:sizeof(key)];
        
        // 3Byte단위로 1Byte씩 좌측으로 이동
        //        LRotate(tBuff, tBuff, slength, 4, 1);
        [self LRotate:tBuff sBuff:tBuff slength:slength Per:4 SByte:1];
    }
}
/////--

+ (int) checkLengthNullWithData:(char*)Data nLength:(int)nLength
{
	for( int i = nLength-1; i >= 0; i-- )
	{
		if( Data[i] != 0x00 ) return i+1;
	}
	
	return nLength;
}

+ (NSString*) getStringWithData:(char*)Data nLength:(int)nLength
{
	NSString *strData = nil;
	@try
	{
		int nNullLength = [self checkLengthNullWithData:Data nLength:nLength];
		strData = [[NSString alloc] initWithBytes:Data length:nNullLength encoding:NSEUCKREncoding];	 // "EUC-KR"
	}
	@catch( id theException )
	{
		strData = @"";
	}
	
	NSString *value=[[NSString alloc] initWithBytes:Data
											  length:nLength
											encoding:NSEUCKREncoding];
	if(nLength > 1 && value == nil){
		value = [[NSString alloc] initWithBytes:Data
                                         length:nLength-1
                                       encoding:NSEUCKREncoding];
	}
	return value;
	
	return strData;
}

//+ (NSString*) getStringTrimSpaceWithData:(char*)Data nLength:(int)nLength isreverse:(BOOL)isreverse
//(NSString *) getStringNETrimSpace:(NSInteger)length isreverse:(BOOL)isreverse isname:(BOOL)isname
//{
//    if( m_nBufferLength <= m_nBufferPos ) return nil;
//    
//    NSString *newData = [[[NSString alloc] initWithBytes:(m_szBuffer+m_nBufferPos) length:GetRealLength(m_szBuffer+m_nBufferPos, (isname ? (length-1) : length), isreverse) encoding:NSEUCKREncoding] autorelease];
//    if (newData == nil) newData = @"";
//	
//    m_nBufferPos += length;
//    if (m_isAttribure) m_nBufferPos++;
//    
//    return newData;
//}

+ (NSString*) getErrMessage:(NSString*)strErrCode
{
	if([strErrCode length] < 2) return @"에러";
	NSString* strFileName = [NSString stringWithFormat:@"msgtbl%@.tbl", [strErrCode substringToIndex:2]];
	
	NSString *filePathName = [CommonFileUtil getMsgTblFilePath:strFileName];
	if(filePathName == nil) return @"메세지 테이블이 없습니다.";
	
	NSString *fileName	= [CommonFileUtil getResFilePath:FOLDER_TABLE fileName:strFileName];
	NSString *dataString= @"";
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:fileName])
	{
		NSData *data = [[NSFileManager defaultManager] contentsAtPath:fileName];
		dataString = [[NSString alloc] initWithData:data encoding:0x80000000 + kCFStringEncodingDOSKorean];
	}
	else
	{
		NSString *strPath = [[NSBundle mainBundle] pathForResource:[[strFileName componentsSeparatedByString:@"."] objectAtIndex:0] ofType:@"tbl"];
        dataString = [[NSString alloc] initWithContentsOfFile:strPath encoding:0x80000000 + kCFStringEncodingDOSKorean error:nil];
	}
	
	NSArray *ArrLine = [dataString componentsSeparatedByString:@"\n"];
	NSString* linedata;
	NSString* strKey;
	NSString* strMsg = @"메세지가 테이블에 없습니다.";
	for (int i = 0 ; i < [ArrLine count]; i++)
    {
		linedata = [ArrLine objectAtIndex:i];
		if ([linedata isEqualToString:@""]) continue;
		if ([linedata length] <= 5) continue;
		strKey = [[linedata substringToIndex:5] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		
		if([strKey isEqualToString:strErrCode])
		{
			strMsg = [[linedata substringFromIndex:5] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
			break;
		}
	}
	
	return strMsg;
}

+ (UIImage*) screenShotImpl:(UIView*)targetView frame:(CGRect)tRect
{
    
//    CGRect theScreenRect = CGRectApplyAffineTransform(tRect, CGAffineTransformMakeScale(2.0, 2.0));
    CGRect theScreenRect = tRect;
//    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(theScreenRect.size, NO, 0);
//    else
//        UIGraphicsBeginImageContext(theScreenRect.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [[UIColor clearColor] set];
    CGContextFillRect(ctx, theScreenRect);
    
    CALayer *layer = [targetView layer];
    [layer renderInContext:ctx];
    
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	return screenshot;
}

+ (BOOL) saveScreenShot:(NSString*)sFileName target:(UIView*)targetView frame:(CGRect)tRect target:(id)target completeSel:(SEL)completeSelector
{
    if (sFileName == nil || targetView == nil) return NO;
	
	UIImage* imgScreenShot = [self screenShotImpl:targetView frame:targetView.bounds];
	if (imgScreenShot == nil) return NO;
    
    //    CGRect theScreenRect = CGRectApplyAffineTransform(tRect, CGAffineTransformMakeScale(2.0, 2.0));
    tRect = CGRectApplyAffineTransform(tRect, CGAffineTransformMakeScale([self getCurrentScale], [self getCurrentScale]));
    
    CGFloat barHeight = [CommonUtil GetStatusBarHeight] * [self getCurrentScale];
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(imgScreenShot.CGImage, CGRectMake(CGRectGetMinX(tRect), CGRectGetMinY(tRect) + barHeight, CGRectGetWidth(tRect), CGRectGetHeight(tRect)- barHeight));
    
    imgScreenShot = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
	
//    if ([sFileName hasSuffix:@".png"] == NO) sFileName = [sFileName stringByAppendingString:@".png"];
//    NSString *filepath = [CommonFileUtil getDocumentFilePath:[NSString stringWithFormat:@"%@%@", FOLDER_IMAGE, sFileName]];

//    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(imgScreenShot)];
//    [imageData writeToFile:filepath atomically:YES];
    // 앨범에 저장
    UIImageWriteToSavedPhotosAlbum(imgScreenShot, target, completeSelector, nil);
    
    return YES;
	
/*
    if (sFileName == nil || targetView == nil) return NO;
    CGRect theScreenRect = tRect;
    
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(theScreenRect.size, NO, 0);
    else
        UIGraphicsBeginImageContext(theScreenRect.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [[UIColor clearColor] set];
    CGContextFillRect(ctx, theScreenRect);
    
    CALayer *layer = [targetView layer];
    [layer renderInContext:ctx];
    
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if ([sFileName hasSuffix:@".png"] == NO) sFileName = [sFileName stringByAppendingString:@".png"];
    NSString *filepath = [CommonFileUtil getDocumentFilePath:[NSString stringWithFormat:@"%@/%@/%@", FOLDER_THEME, [SystemUtil getThemeName], sFileName]];
    // Save the image
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(screenshot)];
    [imageData writeToFile:filepath atomically:YES];
    return YES;
 */
}

+ (BOOL) captureScreen:(NSString*)sFileName target:(UIView*)targetView frame:(CGRect)tRect
{
    if (sFileName == nil || targetView == nil) return NO;
    if ([sFileName hasSuffix:@".png"] == NO) sFileName = [sFileName stringByAppendingString:@".png"];
    NSString *filepath = [CommonFileUtil getDocumentFilePath:[NSString stringWithFormat:@"%@/%@", FOLDER_IMAGE,  sFileName]];
	[[NSFileManager defaultManager] removeItemAtPath:filepath error:nil];
	
	if (g_imgScreenShot != nil) g_imgScreenShot = nil;

	UIImage* imgScreenShot = [self screenShotImpl:targetView frame:tRect];
	if (imgScreenShot == nil) return NO;
    g_imgScreenShot = imgScreenShot;
	return YES;
}

+ (BOOL) saveCapture:(NSString*)sFileName
{
    if (sFileName == nil) return NO;
	
    if ([sFileName hasSuffix:@".png"] == NO) sFileName = [sFileName stringByAppendingString:@".png"];
    NSString *filepath = [CommonFileUtil getDocumentFilePath:[NSString stringWithFormat:@"%@/%@", FOLDER_IMAGE, sFileName]];
	
	if (g_imgScreenShot != nil)
	{
		NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(g_imgScreenShot)];
		[imageData writeToFile:filepath atomically:YES];
		
		return YES;
	}
	return NO;
}

+ (StockColorValue)getStockColorValue:(NSString *)signString
{
	StockColorValue colorValue = STOCK_COLOR_NONE;
	@try
	{
		if( [signString isEqualToString:@"+"] )
		{
			return STOCK_COLOR_UP;
		}
		else if( [signString isEqualToString:@"-"] )
		{
			return STOCK_COLOR_DOWN;
		}
		
		switch ([signString intValue])
		{
			case 1:
			case 2:
			case 3:
			case 4:
				colorValue = STOCK_COLOR_UP;
				break;
			case 5:
			case 6:
			case 7:
			case 8:
				colorValue = STOCK_COLOR_DOWN;
				break;
			default:
				break;
		}
	}
	@catch (NSException *exception) {
	}
	
	return colorValue;
}

+ (NSString*) decimalString:(NSString*)strValue
{
	return [self decimalString:strValue nDigits:-1];
}

+ (NSString*) decimalString:(NSString*)strValue nDigits:(int)minimum
{
	NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
	[fmt setNumberStyle:NSNumberFormatterDecimalStyle];
	if(minimum>=0)[fmt setMinimumFractionDigits:minimum];
	NSString *textData = [fmt stringFromNumber:[NSNumber numberWithDouble:[strValue doubleValue]]];
	return textData;
}

+ (NSString *) getPlatformName
{
	size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char *machine = malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
    /*
     07	  Possible values:
     08	  "iPhone1,1" = iPhone 1G
     09	  "iPhone1,2" = iPhone 3G
     10	  "iPod1,1"   = iPod touch 1G
     11	  "iPod2,1"   = iPod touch 2G
     "iPhone5,2"	= iPhone 5
     12
     
     "i386" > iPhone Simulator
     "iPhone1,1" = iPhone 1G
     "iPhone1,2" = iPhone 3G
     "iPhone2,1" = iPhone 3GS
     "iPhone3,1" = iPhone 4
     "iPod1,1" = iPod touch 1G
     "iPod2,1" = iPod touch 2G
     "iPod3,1" = iPod touch 3G
     
     */
	NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    
	free(machine);
	return platform;
}

+ (NSString*) getCurrentStartScreen
{
	NSString* strStartScreenNO = @"1000";
    
//	if( [[SessionInfo instance] getMenuLevel] == kMainMenuItemScreenAuthNone )
//		return strStartScreenNO;
//	
//	int nStartScreenIndex = [[CommonUtil getStringForKey:k_common_start_screen basic:@"3"] intValue];
//	
//	switch (nStartScreenIndex) {
//		case 0:	// 관심
//			strStartScreenNO = @"1234";
//			break;
//		case 1:	// 현재가
//			strStartScreenNO = @"1111";
//			break;
//		case 2:	// 선옵현재가
//			strStartScreenNO = @"3111";
//			break;
//		case 3:	// 시장동향
//			strStartScreenNO = @"1311";
//			break;
//		case 4:	// 국내지수
//			strStartScreenNO = @"1151";
//			break;
//	}
    
	return strStartScreenNO;
}

////
+ (UIImage *) getDaebiTagImageName:(NSString *) daebiTag{
	
	NSString *daebiTagImageName =[self getDaebiTagImagePath:daebiTag];
//	UIImage *daebiImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:daebiTagImageName ofType:@"png"]];
	UIImage *daebiImage = [CommonUtil getImage:daebiTagImageName];
	return daebiImage;
}
//대비 이미지 패스
+ (NSString *)getDaebiTagImagePath:(NSString *) daebiTag
{
	StockSignValue signValue = (StockSignValue)[daebiTag intValue];
    //	int signValue = [daebiTag intValue];
	
	NSString *daebiTagImageName =nil;
	
	switch (signValue)
	{
		case STOCK_SIGN_UP:
		case STOCK_SIGN_QUOTES_UP:
			daebiTagImageName = @"tri_red2";//@"up.png";
			break;
		case STOCK_SIGN_MAXUP:
		case STOCK_SIGN_QUOTES_MAXUP:
			daebiTagImageName = @"pinktri_sm";//@"up2.png";
			break;
		case STOCK_SIGN_DOWN:
		case STOCK_SIGN_QUOTES_DOWN:
			daebiTagImageName = @"tri_blue2";//@"down.png";
			break;
		case STOCK_SIGN_MAXDOWN:
		case STOCK_SIGN_QUOTES_MAXDOWN:
			daebiTagImageName = @"bluetri_sm";//@"down2.png";
			break;
		default:
			daebiTagImageName = @"";//@"equal_nil.png";
			break;
	}
	return daebiTagImageName;
}

+ (void) setAutoLogin:(BOOL)isAuto
{
	[CommonUtil setBoolWithKey:isAuto key:k_common_inquiry_login];
}
+ (BOOL) isAutoLogin
{
	return [CommonUtil getBoolConfigForKey:k_common_inquiry_login basic:YES];
}

// 스트링을 컬러로 변환한다.
+ (UIColor*) colorWithHexString:(NSString*) hexString
{
	if([hexString length] == 10)
	{
		NSRange alphaRange;
		alphaRange.location	= 2;
		alphaRange.length	= 2;
		
		NSRange redRange;
		redRange.location	= 4;
		redRange.length		= 2;
		
		NSRange greenRange;
		greenRange.location	= 6;
		greenRange.length	= 2;
		
		NSRange blueRange;
		blueRange.location	= 8;
		blueRange.length	= 2;
		
		char *cStr;
		
		const char *cRed	= [[NSString stringWithFormat:@"0x%@",[hexString substringWithRange:redRange]] UTF8String];
		const char *cGreen	= [[NSString stringWithFormat:@"0x%@",[hexString substringWithRange:greenRange]] UTF8String];
		const char *cBlue	= [[NSString stringWithFormat:@"0x%@",[hexString substringWithRange:blueRange]] UTF8String];
		const char *cAlpha	= [[NSString stringWithFormat:@"0x%@",[hexString substringWithRange:alphaRange]] UTF8String];
		
		float red	= strtof(cRed	, &cStr) / 255.0;
		float green	= strtof(cGreen	, &cStr) / 255.0;
		float blue	= strtof(cBlue	, &cStr) / 255.0;
		float alpha	= strtof(cAlpha	, &cStr) / 255.0;
		
		UIColor *color = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:alpha];
		
		return color;
	}
	else
	{
		return nil;
	}
}

// 컬러를 스트링으로 반환한다.
+ (NSString*) hexStringWithUIColor:(UIColor*) color
{
	NSString *returnString = @"";
	
	CGColorRef		colorRef	= color.CGColor;
	const CGFloat	*components = CGColorGetComponents(colorRef);
	
	CGFloat r	= components[0];
	CGFloat g	= components[1];
	CGFloat b	= components[2];
	CGFloat a	= components[3];
	
	if (r < 0.0f) r = 0.0f;
	if (g < 0.0f) g = 0.0f;
	if (b < 0.0f) b = 0.0f;
	if (a < 0.0f) a = 0.0f;
	if (r > 1.0f) r = 1.0f;
	if (g > 1.0f) g = 1.0f;
	if (b > 1.0f) b = 1.0f;
	if (a > 1.0f) a = 1.0f;
	
	returnString = [NSString stringWithFormat:@"0x%02X%02X%02X%02X",(int)(a * 255), (int)(r * 255), (int)(g * 255), (int)(b * 255)];
	
	return returnString;
}

//jailbreak 탈옥체크
+ (BOOL)isJailBreakPhone
{
	NSLog(@"탈옥폰 체크!!!");
    
#if TARGET_IPHONE_SIMULATOR
    
	// -> other Sources/AhnLab/ 에서 .h파일은 냅두고 .a 라이브러리 파일은 프로젝트에서 빼면~ 시뮬레이터는 정상 작동합니다...- -;
	return FALSE;	// -> 시뮬레이터일 경우 무조건 통과!!
	
#else //TARGET_IPHONE_DEVICE
	
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSInteger roundedValue = round(interval);
    
    /* 탈옥폰 사용  (시작) */
    // 탈옥폰 사용금지 (시뮬레이터에서는 실행안됨)
    amsLibrary *ams = [[amsLibrary alloc] init];
    NSInteger  isJB = [ams a3142:@"AHN_3379024345_TK"];
    
    
    
    NSLog(@"Jailbreak Result : %ld" , (long)isJB);
    NSLog(@"Time Interval : %ld" , (long)roundedValue);
    
    long checking = (long)(isJB - roundedValue);
    
    NSLog(@"Checking Result : %ld" , checking);
    
    if (!(checking >= JS_NORMAL - 2 && checking <= JS_NORMAL + 2)) {
        return TRUE;
    }
	else {
		NSLog(@"순정 폰입니다.");
		return FALSE;
    }
#endif
    
}

+ (NSString *) getLocale
{
	//    NSLocale *locale = [NSLocale currentLocale];
	//    NSString *localeKey = [[locale localeIdentifier] lowercaseString];
	
	NSString *sLocale = [CommonUtil getStringForKey:k_common_language basic:@"ko"];
	
	if ([sLocale isEqualToString:@"en"])
		sLocale = @"en_us";
	else
		sLocale = @"ko_kr";
	//    NSLog(@"Application Locale : %@", sLocale/*[locale localeIdentifier]*/);
	return sLocale;
}


+ (NSString *) getMsgTblText:(NSString *)sValue
{
    if (![sValue isKindOfClass:[NSString class]]) {
        return @"";
    }
    if  ( sValue == nil || [sValue length] == 0)
        return @"";
    return sValue;
    @try {
        if (![sValue isKindOfClass:[NSString class]]) {
            return @"";
        }
        if  ( sValue == nil || [sValue length] == 0) return @"";
        // message table
        NSString *sRtnValue = @"";
        NSArray  *arrValue = [sValue componentsSeparatedByString:SEPERATOR];
        
        if ([sValue length] > 0 && [arrValue count] > 0)
        {
            for (__strong NSString *sString in arrValue)
            {
                if (sString == nil) {
                    continue;
                }
                NSRange langRange = [sString rangeOfString:MESSAGE_KEY];
                if ( langRange.location != NSNotFound )
                {
                    NSArray *arrLangValue = [sString componentsSeparatedByString:SEP];
                    if (arrLangValue.count == 2)
                    {
                        //					sString = [CommonUtil getLangMessage:[arrLangValue objectAtIndex:1]];
                    }
                }
                
                sRtnValue = [NSString stringWithFormat:@"%@%@", sRtnValue, sString];
            }
        }
        else
            sRtnValue = sValue;
        
        return sRtnValue;
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        return sValue;
    }
}


// 로그인하여 정보를 셋팅하여야하나 아직 없어서 그냥 하드코딩함..  - cory 2015.05.16.
+(NSMutableDictionary*)getSystemLog
{
	NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
	[dic setObject:[NSString stringWithFormat:@"%@", @"3"		]				forKey:@"platform"	];		// 모름
	[dic setObject:[NSString stringWithFormat:@"%@", @"DWSM"	]				forKey:@"seid"		];		// 모름
	[dic setObject:[NSString stringWithFormat:@"%@", @"1111111111111111111"]	forKey:@"auth"		];		// 모름
	[dic setObject:[NSString stringWithFormat:@"%@", @"1000"	]				forKey:@"version"	];		// 모름
	[dic setObject:[NSString stringWithFormat:@"%@", @"chopisal"]				forKey:@"usid"		];		// 모름
	
	return dic;
}

+ (NSString*)fillSpace:(NSString*)target length:(NSInteger)nlength
{
    if ([target length] > nlength )
    {
        return target;
    }
    
    for (NSInteger i = [target length]; i < nlength ; i++) {
        target = [target stringByAppendingString:@" "];
    }

    return target;
}

+ (NSString*)fillCharater:(NSString*)target length:(NSInteger)nlength character:(NSString*)sChar
{
    if ([target length] > nlength )
    {
        return target;
    }
    
    for (NSInteger i = [target length]; i < nlength ; i++) {
        target = [target stringByAppendingString:sChar];
    }
    
    return target;
}

+ (void)copyDefaultSound{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    

    NSArray *pathArray = [NSArray arrayWithObjects:@"System/Library/Audio/UISounds/", @"Library/Ringtones/", nil];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    documentsPath = [NSString stringWithFormat:@"%@/%@" , documentsPath ,FOLDER_SOUND];
    for (NSString *sPath in pathArray) {
        for (NSString *fileName in [fileManager contentsOfDirectoryAtPath:sPath error:nil]) {
            NSString *fromPath = [sPath stringByAppendingPathComponent:fileName];
            NSString *toPath = [documentsPath stringByAppendingPathComponent:fileName];
            
            if (![fileManager fileExistsAtPath:toPath]) {
                NSError *error = nil;
                if (![fileManager copyItemAtPath:fromPath toPath:toPath error:&error]) {
                    NSLog(@"fielname [%@]", fileName);
                }else{
                    NSString *sSavePath = [toPath stringByReplacingOccurrencesOfString:documentsPath withString:@""];
                    [[SystemUtil instance] addSoundName:sSavePath];
                }
                if (error != nil) {
                    NSLog(@"error [%@]" , [error debugDescription]);
                }
            }
        }
    }
}

+ (NSArray*)readFileDatabyOneLine:(NSString*)sFileText
{
    NSArray *arrLineData = [sFileText componentsSeparatedByString:@"\r\n"];
    if ([arrLineData count] == 0)
        return nil;
    
    if ([arrLineData count] == 1)
    {
        arrLineData = [sFileText componentsSeparatedByString:@"\n"];
    }
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (int i = 0; i < [arrLineData count]; i++)
    {
        NSString *sLine = [arrLineData objectAtIndex:i];
        if (sLine == nil || [sLine length] == 0) {
            [temp addObject:[NSNumber numberWithInt:i]];
        }
    }
    
    NSInteger j = [arrLineData count];
    
    for (j = 0; j < [temp count]; j++) {
//        NSString *sLineData = [temp objectAtIndex:j];
        
    }

    
    return arrLineData;
}

+ (BOOL)isPossibleCall
{
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    NSString *mmc = [carrier mobileNetworkCode];
    
    if (mmc == nil || [mmc length] == 0 || [mmc isEqualToString:@"65535"]) {
        return NO;
    }else{
        return YES;
    }
    
    return NO;
}


+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }else if (0x263a)
                 returnValue = YES;
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

+ (NSString *)stringToHex:(NSString*)sTarget
{
    char *utf8 = (char*)[sTarget UTF8String];
    NSMutableString *hex = [NSMutableString string];
    while ( *utf8 ) [hex appendFormat:@"%02X" , *utf8++ & 0x00FF];
    
    return [NSString stringWithFormat:@"%@", hex];
}

+ (BOOL)getDeviceTypeByScreenRate
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGFloat screenRate = CGRectGetHeight(rect) / CGRectGetWidth(rect);
    
    if (screenRate < 1.6) {
        return YES;
    }
    
    return NO;
}

// 한글자씩만.. 비교를..
+ (BOOL)textHasKorean:(NSString*)text
{
//    NSArray *arrayJongSung = [[NSArray alloc] initWithObjects:@"ㄱ",@"ㄲ",@"ㄳ",@"ㄴ",@"ㄵ",@"ㄶ",@"ㄷ", @"ㄸ" ,@"ㄹ",@"ㄺ",@"ㄻ",@" ㄼ",@"ㄽ",@"ㄾ",@"ㄿ",@"ㅀ",@"ㅁ",@"ㅂ",@"ㅄ",@"ㅅ",@"ㅆ",@"ㅇ",@"ㅈ",@"ㅊ",@"ㅋ",@" ㅌ",@"ㅍ",@"ㅎ",nil];
//    NSArray *arrayJaum = [[NSArray alloc] initWithObjects:@"ㅏ", @"ㅑ", @"ㅓ", @"ㅕ", @"ㅗ", @"ㅛ", @"ㅜ", @"ㅠ", @"ㅡ", @"ㅣ", @"ㅐ", @"ㅒ", @"ㅔ", @"ㅖ", @"ㅢ", @"ㅘ", @"ㅟ", @"ㅞ", @"ㅙ" , nil];
    
    
    for (int i = 0; i < text.length; i++)
    {
        
        NSInteger code = [text characterAtIndex:i];
        
        if(0x1100 <= code && code <= 0x11FF) // 한글 자모
            return YES;
        
        if(0x3130 <= code && code <= 0x318F) // 호환용 한글 자모
            return YES;
        
        if(0xAC00 <= code && code <= 0xD7AF) // 한글 소리 마디
            return YES;
//        
//        BOOL bComp = NO;
//        NSString *sComp = [text substringWithRange:NSMakeRange(i, 1)];
//        for (int j = 0; j < [arrayJongSung count]; j++) {
//            NSString *sChar = [arrayJongSung objectAtIndex:j];
//            if ([sChar isEqualToString:sComp])
//                bComp = YES;
//        }
//        
//        for (int k = 0; k < [arrayJaum count]; k++) {
//            NSString *sChar = [arrayJaum objectAtIndex:k];
//            if ([sChar isEqualToString:sComp])
//                bComp = YES;
//        }
//        
//        if (bComp) {
//            return YES;
//        }
    }
    return NO;
}

// 자음 모음만 들어가 있는 것도 비교 한다.
+ (BOOL)isKoreanContain:(NSString*)sCharText
{
    int nTextChar = [sCharText characterAtIndex:0];

    NSArray *arrayJongSung = [[NSArray alloc] initWithObjects:@"ㄱ",@"ㄲ",@"ㄳ",@"ㄴ",@"ㄵ",@"ㄶ",@"ㄷ", @"ㄸ" ,@"ㄹ",@"ㄺ",@"ㄻ",@" ㄼ",@"ㄽ",@"ㄾ",@"ㄿ",@"ㅀ",@"ㅁ",@"ㅂ",@"ㅄ",@"ㅅ",@"ㅆ",@"ㅇ",@"ㅈ",@"ㅊ",@"ㅋ",@" ㅌ",@"ㅍ",@"ㅎ",nil];
    NSArray *arrayJaum = [[NSArray alloc] initWithObjects:@"ㅏ", @"ㅑ", @"ㅓ", @"ㅕ", @"ㅗ", @"ㅛ", @"ㅜ", @"ㅠ", @"ㅡ", @"ㅣ", @"ㅐ", @"ㅒ", @"ㅔ", @"ㅖ", @"ㅢ", @"ㅘ", @"ㅟ", @"ㅞ", @"ㅙ" , nil];
    if( nTextChar >= 44032 && nTextChar <= 55203 )
        return true;
    
    for( int i = 0 ; i < [arrayJongSung count] ; i++ )
    {
        
        for (int j = 0 ; j < [arrayJongSung count]; j++) {
            NSString *sChar = [arrayJongSung objectAtIndex:j];
            if( [sCharText isEqualToString:sChar])
                return true;
        }
        
        for( int j = 0 ; j < [arrayJaum count] ; j++ )
        {
            NSString *sChar = [arrayJaum objectAtIndex:j];
            if( [sCharText isEqualToString:sChar])
                return true;
        }
    }

    return NO;
}

+ (void) setButtonImageInset :(UIButton *) btn width:(CGFloat)width height:(CGFloat)height
{
    [CommonUtil setButtonImageInset:btn width:width height:height useCalcResize:YES];
}

+ (void) setButtonImageInset :(UIButton *) btn width:(CGFloat)width height:(CGFloat)height useCalcResize:(BOOL)bUse
{
    if(bUse)
    {
        width = [CommonUtil calcResize:width direction:LAYOUT_TYPE_HORIZON mode:LAYER_TYPE_VERTICAL];
        height = [CommonUtil calcResize:height direction:LAYOUT_TYPE_VERTICAL mode:LAYER_TYPE_VERTICAL];
    }
    
    CGFloat yOffset = (btn.frame.size.height - height) /2;
    CGFloat xOffset = (btn.frame.size.width - width) /2;
    
    [btn setImageEdgeInsets:UIEdgeInsetsMake(yOffset, xOffset, yOffset, xOffset)];
}

+ (BOOL) isEmptyString :(NSString *)sString
{
    if(sString == nil || [sString length] <= 0)
        return YES;
    
    return NO;
}


#pragma  Server connect state flag..

+ (void) setServerConnectInfo:(int) nServerIndex;
{
    [CommonUtil setStringWithKey:[NSString stringWithFormat:@"%d", nServerIndex] key:@"Session.ServerInfo.Key"];
}

+ (int) getServerConnectInfo
{
    return [[CommonUtil getStringForKey:@"Session.ServerInfo.Key"  basic:@"-1"] integerValue];
}

+ (BOOL) isTestServer
{
    return (!([CommonUtil getServerConnectInfo] == 0));
}

+ (NSString *) getDeviceName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

+ (NSString *) DecodeWebStr:(NSString *) value;
{
    NSMutableString * str = [[NSMutableString alloc] initWithString:@""];
    
    if (value == nil || value.length == 0) return @"";
    
    @try {
        
        char sCode[] = "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789";
        char* val = (char *)[[value trim] cStringUsingEncoding:NSUTF8StringEncoding];
        
        int i = 0;
        int j = 0;
        
        
        int iValLen = strlen(val);
        int iCodeLen = strlen(sCode);
        
        
        while (i < iValLen)
        {
            j = 0;
            while (j < iCodeLen)
            {
                if(val[i] == sCode[j]) {
                    [str appendFormat:@"%c", sCode[iCodeLen - j - 1]];
                    j = iCodeLen;
                }
                j++;
            }
            i++;
        }
    } @catch (NSException *exception) {
        str = (NSMutableString *)@"";
    } @finally {
        return str;
    }
    
}

+ (CGRect) getWindowArea

{
    if (IS_IPHONE_X)
    {
        // Type 1
        CGRect windowRect = [[UIScreen mainScreen] bounds];
        
        int nMode = [CommonUtil IsVerticalOrientation] ? LTYPE_VERTICAL : LTYPE_HORIZON;
        if( nMode == LTYPE_VERTICAL || nMode == LTYPE_DEFAULT )
        {
            return CGRectMake(0,
                              [CommonUtil GetStatusBarHeight],
                              MIN(windowRect.size.width, windowRect.size.height),
                              MAX(windowRect.size.width, windowRect.size.height)-[CommonUtil GetStatusBarHeight]);
        }
        else
        {
            return CGRectMake(30,
                              0,
                              MAX(windowRect.size.width, windowRect.size.height),
                              MIN(windowRect.size.width, windowRect.size.height));
        }
        // Type2
/*
        UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
        if (viewController.view.safeAreaInsets.top > 0)
        {
            // iPhoneX
            NSLog(@"iPhoneX SafeArea Frame : %@", NSStringFromCGRect(viewController.view.safeAreaLayoutGuide.layoutFrame));
            return viewController.view.safeAreaLayoutGuide.layoutFrame;
        }
*/
    }
    return [[UIScreen mainScreen] bounds];
}

// escdream 2018.07.05
+ (void) ios11TableFatch:(UITableView *) aTable
{
    if (@available(iOS 11.0, *))
    {
        aTable.estimatedRowHeight = 0;
        aTable.estimatedSectionHeaderHeight = 0;
        aTable.estimatedSectionFooterHeight = 0;
        [aTable setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        [aTable setInsetsContentViewsToSafeArea:NO];
    }
}

#pragma mark - Private Methods
+ (NSInteger)checkPhoneType
{
    if((SCREENWIDTH == 375) || (SCREENWIDTH == 667))
        return 6;
    else if((SCREENWIDTH == 414) || (SCREENWIDTH == 736))
        if (SCREENHEIGHT > 800)
            return 9;
        else
            return 7;
    else
        return 5;
}

+ (CGFloat)iosScaleX : (CGFloat) x;
{
    switch ([CommonUtil checkPhoneType]) {
        case 7 :
            return (x * SCALE_X_VALUE);
            break;
        case 9  :
            return (x * SCALE_X_VALUE);
            break;
        default:
            break;
    }
    return x;
}


+ (CGFloat)iosScale : (CGFloat)x fixPercent:(float)percent
{
    switch ([CommonUtil checkPhoneType]) {
//        case 6 :
//            if (x == 320) return 375;
//            else return (x * 1.171875) * percent;
//            break;
        case 7 :
            return (x * SCALE_X_VALUE)  * percent;
            break;
        default:
            break;
    }
    return x;
}

+ (CGFloat)iosScaleY : (CGFloat) y;
{
    switch ([CommonUtil checkPhoneType]) {
//        case 6 :
//            if (y == 480 || y == 568) return 667;
//            if (y == 460 || y == 548) return 647;
//            //            else return (y * 1.389584);
//            else return (y * 1.2);
//            break;
        case 7 :
//            if (y == 480 || y == 568) return 736;
//            if (y == 460 || y == 548) return 716;
//            //            else return (y * 1.533334);
            return (y * SCALE_Y_VALUE);
            //            else return (y * 1.2);
            break;
        case 9 :
            //            if (y == 480 || y == 568) return 736;
            //            if (y == 460 || y == 548) return 716;
            //            //            else return (y * 1.533334);
            return (y * SCALE_MAX_Y_VALUE);
            //            else return (y * 1.2);
            break;
        default:
            break;
    }
    return y;
}


+ (void)iosScaleRect:(UIView *)target;
{
    CGRect r;
    
    if ([target isKindOfClass:NSClassFromString(@"EDImageView")] || target.tag == -500000)
    {
        
        CGFloat sx = target.frame.origin.x;
        CGFloat sy = target.frame.origin.y;
        
        r = CGRectMake([self iosScaleX:target.frame.origin.x],
                              [self iosScaleY:target.frame.origin.y],
                              [self iosScaleX:target.frame.size.width],
                              [self iosScaleY:target.frame.size.height]);
        
        sx = sx + (r.origin.x - sx) / 2;
        sy = sy + ((r.origin.y - sy) + (r.size.height - target.frame.size.height)) / 2;

        r.origin.x = sx;
        r.origin.y = sy;
        r.size.width = [self iosScaleX:target.frame.size.width];
        r.size.height = [self iosScaleX:target.frame.size.height];
        
        
    }
    else
    {
    
         r = CGRectMake([self iosScaleX:target.frame.origin.x],
                              [self iosScaleY:target.frame.origin.y],
                              [self iosScaleX:target.frame.size.width],
                              [self iosScaleY:target.frame.size.height]);
    
    }
    
    target.frame = r;
}



+ (void) iosChangeScaleView:(UIView *)targetView fontSizeFix:(float)percent
{
    for (UIView* subView in targetView.subviews) {
        if ([subView isKindOfClass:[UIView class]] || [subView isKindOfClass:[UITableView class]])
        {
            [CommonUtil iosChangeScaleView:subView fontSizeFix:percent];
        };
        
        [CommonUtil iosScaleRect:subView];
        
        //        if ([subView respondsToSelector:@selector(font)] == NO) continue;
        //        if ([subView respondsToSelector:@selector(setFont:)] == NO) continue;
        //        if ([[(id)subView font] isKindOfClass:[UIFont class]] == NO) continue;
        
        //        CGFloat fontSize = ((UIFont*)[(id)subView font]).pointSize;
        //        [(id)subView setFont:HYUNDAI_FONT([SDIUtils iosScale:fontSize fixPercent:percent])];
    }
}


@end

