//
//  ResourceManager.m
//  SmartVIGS
//
//  Created by juyoung Kim on 11. 6. 8..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResourceManager.h"
#import "NinePatchImageCache.h"
#import "CommonFileUtil.h"
#import "SystemUtil.h"
#import "CommonUtil.h"
#import "SystemUtil.h"

@implementation ResourceManager
{
    CGFloat FONT_DIS;
    CGFloat FONT_DIS_PLUS;
    CGFloat FONT_SIZE_M;
}

@synthesize m_FormBgColor;
//@synthesize m_sTheme;
@synthesize m_sFontName, m_sNumericFontName;
@synthesize m_sFontBoldName, m_sNumericFontBoldName;
@synthesize m_defaultFont, m_defaultNumericFont;
@synthesize m_defaultFontBold, m_defaultNumericFontBold;
@synthesize m_defaultSignFont, m_FontTheme;

static ResourceManager* sharedManager = nil;

//+(id)alloc
//{
//	NSAssert(sharedManager == nil, @"Attempted to allocate a second instance of a singleton.");
//	sharedManager = [super alloc];
//	return sharedManager;
//}

+(ResourceManager *) sharedManager
{
	if (sharedManager == nil) 
    {
		sharedManager = [[ResourceManager alloc] init];
	}
	return sharedManager;
}

+(void) exitManager
{
    if( sharedManager != nil )
    sharedManager = nil;
}

-(id)init{
	self = [super init];
	if (self)
	{
        // escdream  IPhoneX 예외 처리
        FONT_DIS = D_FONT_DIS;
        FONT_DIS_PLUS = D_FONT_DIS_PLUS;
        FONT_SIZE_M = D_FONT_SIZE_M;
        
        _m_fLineHeight = 1.0f;
        
        if([[SystemUtil instance] isIPhoneX])
        {
            FONT_DIS = D_FONT_DIS * 0.85;
            FONT_DIS_PLUS = D_FONT_DIS_PLUS * 0.85;
            FONT_SIZE_M = D_FONT_SIZE_M *  0.75;
        }
        ////////////////
        
        m_FontTheme = @"";
        
        
		[self initProperty];
		[self loadColorTable];
		[self setDefaultInstance];
	}
	return self;
}
- (void)initProperty
{
//    m_defaultFontSize = [CommonUtil calcResize:FONT_SIZE_M direction:LAYOUT_TYPE_HORIZON mode:LAYER_TYPE_VERTICAL];
    
    
	m_FormBgColor	= nil;
	mMaxPos			= 0;
	m_dicImage = [[NSMutableDictionary alloc] init ];
    m_ColorList = [[NSMutableArray alloc] init];

    

//    if ([m_FontTheme isEqualToString:@"KB"])
    {
        FONT_DIS = D_FONT_DIS;
        FONT_DIS_PLUS = D_FONT_DIS_PLUS;
        FONT_SIZE_M = D_FONT_SIZE_M;
        _m_fLineHeight = 0.8f;
        
        m_defaultFontSize = [CommonUtil calcResize:D_FONT_SIZE_M direction:LAYOUT_TYPE_HORIZON mode:LAYER_TYPE_VERTICAL];
        self.m_sFontName            = FONT_NAME;
        self.m_sFontBoldName        = BOLD_FONT_NAME;
        self.m_sNumericFontName     = NUMERIC_FONT_NAME;
        self.m_sNumericFontBoldName = NUMERIC_BOLD_FONT_NAME;
        
        if([[SystemUtil instance] isIPhoneX])
        {
//            m_defaultFontSize = [CommonUtil calcResize:D_FONT_SIZE_M * 0.975 direction:LAYOUT_TYPE_VERTICAL mode:LAYER_TYPE_VERTICAL];
//            m_defaultFontSize = CALCUTIL_VERT_WIDTH(D_FONT_SIZE_M * 1.);// [CommonUtil calcResize:D_FONT_SIZE_M * 0.975 direction:LAYOUT_TYPE_VERTICAL mode:LAYER_TYPE_VERTICAL];

//            FONT_DIS = D_FONT_DIS * 0.78;
//            FONT_DIS_PLUS = D_FONT_DIS_PLUS * 0.78;
//            FONT_SIZE_M = D_FONT_SIZE_M *  0.68;
            
//            FONT_DIS = D_FONT_DIS * 0.95;
//            FONT_DIS_PLUS = D_FONT_DIS_PLUS * 0.95;
//            FONT_SIZE_M = D_FONT_SIZE_M *  0.85;
        }
    }
    
//	self.m_sTheme = [CommonUtil getStringForKey:k_common_theme basic:[SystemUtil getThemeName]];
    self.m_defaultFont = [UIFont fontWithName:[self getDefaultFontName] size:m_defaultFontSize];
    self.m_defaultFontBold = [UIFont fontWithName:[self getDefaultFontBoldName] size:m_defaultFontSize];
    self.m_defaultNumericFont = [UIFont fontWithName:[self getNumericFontName] size:m_defaultFontSize];
    self.m_defaultNumericFontBold = [UIFont fontWithName:[self getNumericFontBoldName] size:m_defaultFontSize];
    self.m_defaultSignFont = [UIFont fontWithName:SIGN_FONT_NAME size:m_defaultFontSize];
}

- (void)clearProperty
{
    if (m_dicImage != nil)
    {
        [m_dicImage removeAllObjects];
        m_dicImage = nil;
    }
}

- (void)reloadProperty
{
    [self initProperty];
    [self loadColorTable];
    [self setDefaultInstance];
}

- (void)setDefaultInstance
{
	m_FormBgColor = [self getColorfromFullColortext:@"042:198198198"];
	m_WhiteColor = [UIColor whiteColor];
	
//	[self setTheme:[SystemUtil getSkinTheme]];
}
//
//- (void) setTheme:(NSString*) theme
//{
//	self.m_sTheme = theme;
//}

- (NSString *)getColorFileName
{
    return [NSString stringWithFormat:@"%@yellow.dat",COLORTABLE_FILENAME];
    //	return [NSString stringWithFormat:@"%@white.dat",COLORTABLE_FILENAME];
//    return [NSString stringWithFormat:@"%@.dat", COLORTABLE_FILENAME];
}

- (NSString*)getDefaultFontName
{
	return self.m_sFontName;
}

- (NSString*)getDefaultFontBoldName
{
    return self.m_sFontBoldName;
}

- (NSString*)getNumericFontBoldName
{
    return self.m_sNumericFontBoldName;
}

- (NSString*)getNumericFontName
{
	return self.m_sNumericFontName;
}

- (UIFont*)getDefaultFont
{
	return self.m_defaultFont;
}

- (UIFont*)getDefaultFontBold
{
    return self.m_defaultFontBold;
}

- (UIFont*)getDefaultNumericFont
{
	return self.m_defaultNumericFont;
}

- (UIFont*)getDefaultNumericFontBold
{
    return self.m_defaultNumericFontBold;
}
	
- (UIFont*)getSignFontWithUnit:(NSInteger)nUnit
	{
    if (nUnit == 0)    return m_defaultSignFont;
    return [UIFont fontWithName:SIGN_FONT_NAME size:m_defaultFontSize + FONT_DIS * nUnit];
	}
	
- (UIFont*)getFontWithSize:(float)size
{
    return [UIFont systemFontOfSize:size];

//    if( size == m_defaultFontSize ) return m_defaultFont;
//	return [UIFont fontWithName:[self getDefaultFontName] size:size];
}

- (UIFont*)getFontWithUnit:(NSInteger)Unit
{
    
    if( Unit == 0 ) return m_defaultFont;
    
    CGFloat fdis = FONT_DIS;
    if (Unit > 0) fdis = FONT_DIS_PLUS;
    
    return [UIFont fontWithName:[self getDefaultFontName] size:(m_defaultFontSize + fdis * Unit)];
}
	
- (UIFont*)getFontBoldWithUnit:(NSInteger)Unit
{
    CGFloat fdis = FONT_DIS;
    if (Unit > 0) fdis = FONT_DIS_PLUS;
    if( Unit == 0 ) return m_defaultFontBold;
    return [UIFont fontWithName:[self getDefaultFontBoldName] size:(m_defaultFontSize + fdis * Unit)];
}

- (UIFont*)getFontBoldWithSize:(CGFloat)ftSize
{
//    return [UIFont fontWithName:[self getDefaultFontBoldName] size:ftSize];
    
    return [UIFont boldSystemFontOfSize:ftSize];
    
}

- (UIFont*)getFontBoldWithFont:(UIFont *) font;
{
//    return [UIFont fontWithName:[self getDefaultFontBoldName] size:font.pointSize];
    return [UIFont boldSystemFontOfSize:font.pointSize];
}


- (UIFont*)getNumericFontWithUnit:(NSInteger)Unit
{
    CGFloat fdis = FONT_DIS;
    if (Unit > 0) fdis = FONT_DIS_PLUS;
    if( Unit == 0 ) return m_defaultNumericFont;
	return [UIFont fontWithName:[self getNumericFontName] size:(m_defaultFontSize + fdis * Unit)];
}

- (UIFont*)getNumericFontBoldWithUnit:(NSInteger)Unit
{
    CGFloat fdis = FONT_DIS;
    if (Unit > 0) fdis = FONT_DIS_PLUS;
    if( Unit == 0 ) return m_defaultNumericFontBold;
    return [UIFont fontWithName:[self getNumericFontBoldName] size:(m_defaultFontSize + fdis * Unit)];
}

- (UIFont*)getNumbericFontWithSize:(CGFloat)size
{
    if (size == 0 ) return m_defaultNumericFont;
    return [UIFont fontWithName:[self getNumericFontName] size:(size * [[SystemUtil instance] getFontSizeRate])];
}


- (UIFont*)getFontSizeInWithUnit:(NSString*)data size:(CGSize)size Unit:(NSInteger)type
{
    
    if ([data isEqualToString:@""]) return [self getFontWithUnit:type];
    
    UIFont *font = [self getFontWithUnit:type];
    CGSize getFontSize;
    
    while (YES) {
        getFontSize = [data sizeWithFont:font];
        if (((getFontSize.width <= size.width) /*&& (font.lineHeight <= (size.height + 2))*/) || getFontSize.height < 8)
        {
            if( type < -10 ) type = -10;  // 최저 폰트는 보장
            break;
        }
        type--;
        font = [self getFontWithUnit:type];
    }
    
    return [self getFontWithUnit:type];
}

- (UIFont*)getFontBoldSizeInWithUnit:(NSString*)data  size:(CGSize)size Unit:(NSInteger)type
{
    if ([data isEqualToString:@""]) return [self getFontWithUnit:type];

    UIFont *font = [self getFontBoldWithUnit:type];
    CGSize getFontSize;
    
    while (YES) {
        getFontSize = [data sizeWithFont:font];
        if (((getFontSize.width <= size.width) /*&& (font.lineHeight <=size.height)*/) || getFontSize.height < 8)
        {
            if( type < -10 ) type = -10;  // 최저 폰트는 보장
            break;
        }
        type--;
        font = [self getFontBoldWithUnit:type];
    }
    return [self getFontBoldWithUnit:type];
}


- (UIFont*)getFontSizeInWithUnit:(NSString*)data width:(NSInteger)width Unit:(NSInteger)type
{
    if ([data isEqualToString:@""]) return [self getFontWithUnit:type];

    UIFont *font = [self getFontWithUnit:type];
	CGSize getFontSize;
	
	while (YES) {
		getFontSize = [data sizeWithFont:font];
		if (getFontSize.width <= width || getFontSize.height < 8)
		{
            if( type < -10 ) type = -10;  // 최저 폰트는 보장
			break;
		}
        type--;
        font = [self getFontWithUnit:type];
	}
    
	return [self getFontWithUnit:type];
}

- (UIFont*)getFontBoldSizeInWithUnit:(NSString*)data width:(NSInteger)width Unit:(NSInteger)type
{
    if ([data isEqualToString:@""]) return [self getFontWithUnit:type];

    
    UIFont *font = [self getFontBoldWithUnit:type];
    CGSize getFontSize;
    
    while (YES) {
        getFontSize = [data sizeWithFont:font];
        if (getFontSize.width <= width || getFontSize.height < 8)
        {
            if( type < -10 ) type = -10;  // 최저 폰트는 보장
            break;
        }
        type--;
        font = [self getFontBoldWithUnit:type];
    }
    return [self getFontBoldWithUnit:type];
}

- (UIFont*)getNumericFontSizeInWithUnit:(NSString*)data width:(NSInteger)width Unit:(NSInteger)type
{
	UIFont *font = [self getNumericFontWithUnit:type];
	CGSize getFontSize;
	
	while (YES) {
		getFontSize = [data sizeWithFont:font];
		if (getFontSize.width <= width || getFontSize.height < 8)
		{
            if( type < -10 ) type = -10;  // 최저 폰트는 보장
			break;
		}
        type--;
        font = [self getNumericFontWithUnit:type];
	}
	return [self getNumericFontWithUnit:type];
}

- (UIFont*)getNumericFontBoldSizeInWithUnit:(NSString*)data width:(NSInteger)width Unit:(NSInteger)type
{

    if ([data isEqualToString:@""]) return [self getFontWithUnit:type];
    
    UIFont *font = [self getNumericFontBoldWithUnit:type];
    CGSize getFontSize;
    
	while (YES) {
		getFontSize = [data sizeWithFont:font];
		if (getFontSize.width <= width || getFontSize.height < 8)
		{
            if( type < -7 ) type = -7;  // 최저 폰트는 보장 
			break;
		}
        type--;
        font = [self getNumericFontBoldWithUnit:type];
	}
    return [self getNumericFontBoldWithUnit:type];
}


- (NSInteger)getFontsizeWithUnit:(NSInteger)Unit
{
    return m_defaultFontSize + FONT_DIS * Unit;
}

- (NSInteger)getDefaultFontSize
{
	return	m_defaultFontSize;
}

-(UIImage*)getUIImage:(NSString *)imageName imageOfSize:(CGSize)imgaeSize isCache:(BOOL)isCache
{
	UIImage  *tImage   = nil;
    imgaeSize = CGSizeMake((int)imgaeSize.width, (int)imgaeSize.height);
    if( imageName == nil || [imageName length] == 0 ) return nil;
    
    NSString *tmpImgName = imageName;
    
	if( [imageName hasSuffix:@".png"] == FALSE && [imageName hasSuffix:@".jpg"] == FALSE && [imageName hasSuffix:@".gif"] == FALSE )
    {
		tmpImgName = [imageName stringByAppendingString:@".png"];
        
        if (![CommonFileUtil getImageFileExist:tmpImgName])
        {

            tmpImgName = [imageName stringByAppendingString:@".9.png"];
            if (![CommonFileUtil getImageFileExist:tmpImgName])
            {
//                if ([imageName rangeOfString:STR_COMPONENT_NINE].location != NSNotFound)
//                    tmpImgName = [imageName stringByAppendingString:@".9.png"];
            }
        }
        
    }
    else  if (![CommonFileUtil getImageFileExist:tmpImgName])
    {
        tmpImgName = [imageName stringByReplacingOccurrencesOfString:@".png" withString:@".9.png"];
    }
    
    
    imageName = tmpImgName;
    
	if ([imageName rangeOfString:STR_COMPONENT_NINE].location != NSNotFound) 
	{
        if( imgaeSize.width == 0 || imgaeSize.height == 0 )
        {
            return nil;
        }
        tImage = [NinePatchImageCache imageOfSize:imgaeSize forResource:imageName];
        
        if (tImage == nil) {
	        tImage = [NinePatchImageCache imageOfSize:imgaeSize forResource:imageName];
        }
	}
	else {
        if( isCache )
        {
            if ([m_dicImage objectForKey:imageName])
            {
                tImage = [m_dicImage objectForKey:imageName];
                if( tImage != nil ) return tImage;
            }
        }
        NSString *imgFileName = [CommonFileUtil getImageFilePath:imageName];
        if (imgFileName)
        {
//            NSLog(@"--------------------------- 1");
            tImage = [UIImage imageWithContentsOfFile:imgFileName];
            
        }else{
            
            tImage = [UIImage imageWithContentsOfFile:[CommonFileUtil getImageFilePath:imageName]];
        }
//            NSLog(@"--------------------------- 2");
        if (tImage && isCache)
        {	
            [m_dicImage setObject:tImage forKey:imageName];
        }		
	}
    if( tImage == nil )
    {
        //        NSLog(@"Iamge Load Fail : %@", imageName);
    }
	return tImage;
}

-(CGSize) getUIImageSize:(NSString *)imageName
{
    UIImage *tImage = [UIImage imageWithContentsOfFile:[CommonFileUtil getImageFilePath:imageName]];
    if (tImage)
        return tImage.size;
    else
        return CGSizeMake(0, 0);
}

-(UIImage*)getUIImage:(NSString *)imageName imageOfSize:(CGSize)imgaeSize
{
    if (imageName == nil) {
        return nil;
    }
    return [self getUIImage:imageName imageOfSize:imgaeSize isCache:FALSE];
}

-(UIImage*)getUICacheImage:(NSString *)imageName imageOfSize:(CGSize)imgaeSize
{
    return [self getUIImage:imageName imageOfSize:imgaeSize isCache:TRUE];
}

- (NSString*) getImageFileName:(NSString*)imageName stateString:(NSString*)strState
{
    if( [imageName hasSuffix:@".png"])
        imageName = [imageName substringToIndex:[imageName length] - 4];
    NSUInteger nInsertPos = [imageName rangeOfString:STR_COMPONENT_NINE].location;
    NSMutableString* sFindFile = [NSMutableString stringWithString:imageName];
    if (nInsertPos != NSNotFound) [sFindFile insertString:strState atIndex:nInsertPos];
    else [sFindFile appendString:strState];
    return (NSString*)sFindFile;
}

//-(NSMutableDictionary*)getStateUIImage:(NSString *)imageName imageOfSize:(CGSize)imageSize
//{
//    if( [imageName hasSuffix:@".png"])
//        imageName = [imageName substringToIndex:[imageName length] - 4];
//
//    NSArray *arSubStr = [NSArray arrayWithObjects:IMG_STR_OFF, IMG_STR_ON, IMG_STR_DIS, nil];
//    NSArray *arKeyStr = [NSArray arrayWithObjects:IMGDIC_NORMAL, IMGDIC_ACTIVE, IMGDIC_DISABLE, nil];
//    
//    NSMutableDictionary* dicRet = [[[NSMutableDictionary alloc] init] autorelease];
//    NSUInteger nInsertPos = [imageName rangeOfString:STR_COMPONENT_NINE].location;
//    UIImage *getImg = nil;
//    NSString* subStr = nil;
//    for (int i = 0; i < [arSubStr count]; i++)
//    {
//        subStr = [arSubStr objectAtIndex:i];
//        NSMutableString* sFindFile = [NSMutableString stringWithString:imageName];
//        if (nInsertPos != NSNotFound) [sFindFile insertString:subStr atIndex:nInsertPos];
//        else [sFindFile appendString:subStr];
//        
//        getImg = [self getUIImage:sFindFile imageOfSize:imageSize];
//        if (getImg == nil) continue;
//        
//        [dicRet setObject:getImg forKey:[arKeyStr objectAtIndex:i]];
//    }
//
//    return dicRet;
//}

-(CGRect)getTextRectofSize:(CGSize)size forResource:(NSString *)name ofType:(NSString *)extension
{
    NSString* strFile = name;
    if ([name hasSuffix:extension] == NO)
        strFile = [strFile stringByAppendingFormat:@".%@", extension];
    
    return [NinePatchImageCache textFrameOfSize:size forResource:strFile];
}

			
- (void)removeImage:(NSString *)ImageName
{
	[m_dicImage removeObjectForKey:ImageName];
}


-(void)setFormBgColor:(NSString *)color
{
	if ([color length] < 12) return;
	m_FormBgColor = [self getColorfromFullColortext:color];
}


-(UIColor*)getFormBgColor
{
	return m_FormBgColor;
}

-(UIColor *)getColorfromIndex:(NSInteger)nColorIndex{
//    NSLog(@"getColorfromIndex selcect [%d]" , nColorIndex);
	if (nColorIndex <= 0 || nColorIndex > mMaxPos)
		return m_WhiteColor;
	
	return [m_ColorList objectAtIndex:nColorIndex];
}


-(BOOL)loadColorTable
{
	NSString *path = [CommonFileUtil getImageFilePath:[self getColorFileName]];
	if (path)
	{
        NSString *sFileText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
		NSArray *arrLine = [sFileText componentsSeparatedByString:@"\r\n"];
        
        if ([arrLine count] == 1)
        {
            arrLine = [sFileText componentsSeparatedByString:@"\n"];
        }
        
		mMaxPos = [[arrLine objectAtIndex:0] intValue];

//		m_ColorList set = [[NSMutableArray alloc] initWithCapacity:mMaxPos + 1];
		[self initColorList];
		
        NSInteger nRealCount = mMaxPos;
        if ([arrLine count] < mMaxPos)
            nRealCount = [arrLine count] - 1;
        
		for (int i = 1 ; i <= nRealCount; i++)
		{
			if ([[arrLine objectAtIndex:i] length] <= 0) continue;
			
			NSString *sColorKey = [arrLine objectAtIndex:i];
			NSInteger Index		= [[sColorKey substringToIndex:COLOR_KEY_SIZE] intValue];			
			NSString *sColor	=  [sColorKey substringFromIndex:COLOR_KEY_SIZE+1];
			
			UIColor *uiItem = [self getColorfromIntColor:sColor];
			
			[m_ColorList replaceObjectAtIndex:Index withObject:uiItem];
		}
	}
	else 
	{
		// NSLog(@"%@ file is not found", [self getColorFileName]);
	}
	return YES;
}

-(void)initColorList
{
	UIColor *item;
	for (int i = 0 ; i < mMaxPos + 1; i++)
	{
		item = [UIColor whiteColor];
        if  ( [m_ColorList count] < mMaxPos + 1)
            [m_ColorList addObject:item];
	}
}

-(UIColor *)getUpColor
{
	return [self getColorfromIndex:CID_UPSIDE];
}
-(UIColor *)getDownColor
{
	return [self getColorfromIndex:CID_DOWNTREND];
}
-(UIColor *)getSteadyColor
{
	return [self getColorfromIndex:CID_STEADY];
}
-(UIColor *)getBasicTextColor
{
	return [self getColorfromIndex:CID_BASIC_TEXT];
}
-(UIColor *)getBasicBackGroundColor
{
	return [self getColorfromIndex:CID_BASIC_BACK];	
}

-(UIColor *)getInputDisableTextColor
{
    // 향후에 색상테이블에 추가되면 테이블에서 읽는것을 변경 
	return [UIColor colorWithRed:178/255.f green:178/255.f blue:178/255.f alpha:1.0];
}


- (UIColor *) getPopupBasicBackgroundColor
{
//    if ([[SystemUtil instance] isTx]) return [UIColor colorWithRed:154.f/255 green:170.f/255 blue:187.f/255 alpha:1];

    return [UIColor whiteColor];
}

-(UIColor *)getTitleTextColor 
{
	return [self getColorfromIndex:CID_TITLE_TEXT];
}

-(UIColor *)getPopupMessageTextColor 
{
	return [self getColorfromIndex:CID_BASICPOPUP_TEXT];
}

-(UIColor *)getCellBackGroundColor
{
	return [self getColorfromIndex:CID_CELL_BACK];
}
-(UIColor *)getHelpTextColor
{
    return [self getColorfromIndex:CID_SUB_TEXT];
}

-(UIColor *)getColorfromIntColor:(NSString *)intColor
{
    if ([intColor length] < 9) {
		
		if ( [intColor length] < 6 ) return m_WhiteColor;
		unsigned int red, green, blue;
		NSRange range;
		range.length = 3;
			
		range.location = 0; 
		[[NSScanner scannerWithString:[intColor substringWithRange:range]] scanHexInt:&red];
		range.location = 2; 
		[[NSScanner scannerWithString:[intColor substringWithRange:range]] scanHexInt:&green];
		range.location = 4; 
		[[NSScanner scannerWithString:[intColor substringWithRange:range]] scanHexInt:&blue];    
		
		return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];	
    }
	else
	{
		CGFloat red = [[intColor substringWithRange:NSMakeRange(0, 3)] floatValue];
		CGFloat green = [[intColor substringWithRange:NSMakeRange(3, 3)] floatValue];
		CGFloat blue = [[intColor substringWithRange:NSMakeRange(6, 3)] floatValue];
    
		return [UIColor colorWithRed:(red / 255.f) green:(green / 255.f) blue:(blue / 255.f) alpha:1];
	}
}

-(UIColor *)getColorfromHexColor:(NSString *)intColor
{

    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[intColor substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[intColor substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[intColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];

}


-(UIColor *)getColorfromFullColortext:(NSString *)ColorText
{
	UIColor *color = m_WhiteColor;
	if( ColorText == nil || [ColorText length] == 0 ) return color;

    
    if ([ColorText hasPrefix:@"#"])
    {
        ColorText = [ColorText substringWithRange:NSMakeRange(1, ColorText.length - 1)];
        color = [self getColorfromHexColor:ColorText];
        return color;
    }
    
    
    NSString *sColorKey = @"0";
    NSString *sColorValue = nil;
    NSRange range = [ColorText rangeOfString:@":"];
    if( range.location == NSNotFound )
    {
        if ([ColorText length] == 9)
        {
            sColorValue = ColorText;
        }
        else
        sColorKey = ColorText;
    }
    else
    {
        sColorKey = [ColorText substringToIndex:range.location];
        sColorValue = [ColorText substringFromIndex:range.location+1];
    }

    int nColorKey = [sColorKey intValue];
    if (nColorKey == 0) {
		if( sColorValue != nil )
            color = [self getColorfromIntColor:sColorValue];
    } else {
        color = [self getColorfromIndex:nColorKey];
		if( color == nil && sColorValue != nil )
		{
			color = [self getColorfromIntColor:sColorValue];			
		}
    }
    
    if (color == nil)   color = m_WhiteColor;

	return color;
}

-(NSString*)makeStringKeyfromColor:(NSInteger)key
{
    NSString* strReKey = @"000";
    NSString* strkey = [NSString stringWithFormat:@"%d" , (int)key];
    if ( [strkey length] > 3 )
        return strReKey;
    else if ( [strkey length] == 1 )
        strReKey = [@"00" stringByAppendingString:strkey];
    else if ( [strkey length] == 2 )
        strReKey = [@"0" stringByAppendingString:strkey];    
    return strReKey;
}

-(void)dealloc
{
	[NinePatchImageCache releaseNinePatchImageCache];
	
}

-(void)cleanImageCache
{
    [m_dicImage removeAllObjects];
	[NinePatchImageCache cleanNinePatchSizedImageCache];
}


- (NSArray *)  getFontSizeInfo:(CGFloat) dis_minus  :(CGFloat)dis_plus;
{
    
    NSMutableArray * array = [[NSMutableArray alloc] init];
    
    for (int i=-10; i< 11; i++)
    {
        CGFloat fdis = dis_minus;
        if (i > 0) fdis = dis_plus;

        NSString * s = [NSString stringWithFormat: @"[unit=%d  size=%f", i, (m_defaultFontSize + (fdis * [[SystemUtil instance] getFontSizeRate]) * i)] ;
        [array addObject:s];
    }
    
    return array;
    
}


- (void) setM_FontTheme:(NSString *)sFontTheme
{
    if (![m_FontTheme isEqualToString:sFontTheme])
    {
        m_FontTheme = sFontTheme;
        
        [self reloadProperty];
    }
}

- (CGSize) calcTextWidth:(NSString *) sText :(UIFont *)aFont;
{
    NSDictionary *userAttributes = @{NSFontAttributeName: aFont,
                                     NSForegroundColorAttributeName: [UIColor blackColor]};
    return [sText sizeWithAttributes: userAttributes];
}


@end
