//
//  CommonUtil.h
//  SmartVIGS
//
//  Created by itgen on 11. 5. 11..
//  Copyright 2011 itgen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
//#import "CommonDef.h"

//calcresize 비율 세팅 모드
//#define RESIZE_TYPE_NORMAL  0       //기본(화면크기 805)
//#define RESIZE_TYPE_SCALE   1       //풀팝업(796)
//#define RESIZE_TYPE_SCREEN  2       //메인스크린 사이즈



#define LAYOUT_VERTICAL		1	// 세로모드만 지원
#define LAYOUT_HORIZON 		2	// 가로모드만 지원
#define LAYOUT_BOTH 		3	// 가로세로 모드 전환


#define LTYPE_DEFAULT		0	// 기본모드(세로모드)
#define	LTYPE_VERTICAL		0	// 세로모드
#define LTYPE_HORIZON		1	// 가로모드



#define CALCUTIL_VERT_WIDTH(x)  [CommonUtil calcResize:x direction:LAYOUT_TYPE_HORIZON mode:LAYER_TYPE_VERTICAL]
#define CALCUTIL_VERT_HEIGHT(y) [CommonUtil calcResize:y direction:LAYOUT_TYPE_VERTICAL mode:LAYER_TYPE_VERTICAL]
//#define CALCUTIL_VERT_HEIGHT(y) [CommonUtil calcResize:y direction:LAYOUT_TYPE_VERTICAL mode:LAYER_TYPE_HORIZON]
//#define CALCUTIL_HORZ_HEIGHT(y) [CommonUtil calcResize:y direction:LAYOUT_TYPE_VERTICAL mode:LAYER_TYPE_VERTICAL]
#define UNCALCUTIL_VERT_WIDTH(x)  [CommonUtil calcUnResize:x direction:LAYOUT_TYPE_HORIZON mode:LAYER_TYPE_VERTICAL]
#define UNCALCUTIL_VERT_HEIGHT(y) [CommonUtil calcUnResize:y direction:LAYOUT_TYPE_VERTICAL mode:LAYER_TYPE_VERTICAL]


#define IS_IPHONE        (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_X      (IS_IPHONE && MAX([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width) == 812.0)
#define     IPHONE_X_STATUS     44
#define     IPHONE_X_OFFSET     5

#define SCREENWIDTH [[UIScreen mainScreen] applicationFrame].size.width
#define SCREENHEIGHT [[UIScreen mainScreen] applicationFrame].size.height
#define SCALE_X_VALUE (414/375.0f)
#define SCALE_Y_VALUE (736/667.0f)


// 폼에서 지원하는 가로/세로 모드
typedef enum _LAYOUT_TYPE
{
    LAYOUT_TYPE_VERTICAL    = 0, 	// 세로화면 일 경우
    LAYOUT_TYPE_HORIZON     = 1,    // 가로화면 일 경우
}LAYOUT_TYPE;

// 폼의 현재 가로/세로 모드 상태
typedef enum _LAYER_TYPE
{
    LAYER_TYPE_VERTICAL     = 0,	// 세로
    LAYER_TYPE_HORIZON      = 1,	// 가로
}LAYER_TYPE;


typedef enum
{
    SESSION_SERVER_PROD  = 0,
    SESSION_SERVER_TEST1,
    SESSION_SERVER_TEST2,
    SESSION_SERVER_VERIFY,
    SESSION_SERVER_PROD_NOT_TESTSERVER,
    SESSION_SERVER_MOTU,
    SESSION_SERVER_VERIFY_PROD,

    
}SESSION_SERVER_INFO;




typedef enum _ANIMATIONTYPE
{
    ANIMATION_FROM_NONE         = 0,
	ANIMATION_FROM_RIGHT        = 1, ///< 오른쪽에서 왼쪽
	ANIMATION_FROM_BOTTON       = 2, ///< 밑에서 위로
	ANIMATION_FROM_LEFT         = 3, ///< 왼쪽에서 오른쪽
	ANIMATION_FROM_TOP          = 4,
    ANIMATION_FROM_RIGHT_FIT    = 5, ///< 오른쪽에서 왼쪽
    ANIMATION_FROM_BOTTON_FIT   = 6, ///< 밑에서 위로
    ANIMATION_FROM_LEFT_FIT     = 7, ///< 왼쪽에서 오른쪽
    ANIMATION_FROM_TOP_FIT      = 8,
    ANIMATION_FROM_CENTER       = 9,
} ANIMATIONTYPE;

typedef enum _LINKFORM_ANIMATIONTYPE
{
//    LINKFORM_ANIMATION_FROM_NONE    = -1,
//    LINKFORM_ANIMATION_FROM_LEFT = 0,
//    LINKFORM_ANIMATION_FROM_RIGHT,
//    LINKFORM_ANIMATION_FROM_TOP,
//    LINKFORM_ANIMATION_FROM_BOTTON,
//    LINKFORM_ANIMATION_FROM_FADEIN,
//    LINKFORM_ANIMATION_FROM_OUT,
    LINKFORM_ANIMATION_FROM_NONE    = 0,
    LINKFORM_ANIMATION_FROM_LEFT ,
    LINKFORM_ANIMATION_FROM_RIGHT,
    LINKFORM_ANIMATION_FROM_TOP,
    LINKFORM_ANIMATION_FROM_BOTTON,
    LINKFORM_ANIMATION_FROM_FADEIN,
    LINKFORM_ANIMATION_FROM_OUT,
    
} LINKFORM_ANIMATIONTYPE;

typedef enum
{
	STOCK_COLOR_UP				=4,
	STOCK_COLOR_DOWN			=1,
	STOCK_COLOR_NONE			=5,
}StockColorValue;

typedef enum
{
	STOCK_SIGN_NO_CHANGE		=0,//0보합
	STOCK_SIGN_UP				=1,//1상승
	STOCK_SIGN_MAXUP			=2,//2상한
	STOCK_SIGN_QUOTES_UP		=3,//3기세상승
	STOCK_SIGN_QUOTES_MAXUP		=4,//4기세상한
	STOCK_SIGN_DOWN				=5,//5하락
	STOCK_SIGN_MAXDOWN			=6,//6하한
	STOCK_SIGN_QUOTES_DOWN		=7,//7기세하락
	STOCK_SIGN_QUOTES_MAXDOWN	=8,//8기세하한
	STOCK_SIGN_NO_TRANSACTION	=9,//9거래없음
}StockSignValue;

CGColorSpaceRef GetDeviceRGBColorSpace(BOOL isrelease);

@class AVAudioPlayer;

@interface CommonUtil : NSObject {

}

+ (CGRect)			convertRectToTopSuperView:(UIView *)view ExistTopTitle:(BOOL)bExist;
+ (NSString*)		stringfromRect:(CGRect)rect withVisible:(BOOL)visible;
+ (CGRect)			cgrectfromString:(NSString *)rectString;
+ (NSInteger)		getLineCountFromText:(NSString *)text;
+ (BOOL)            isDigit:(NSString*)NumberString;
+ (BOOL)            isNumeric:(NSString*)NumberString;
+ (BOOL)            isAlphaNum:(unichar)ch;
+ (unsigned long)	getTickCount;
+ (unsigned long)	getTickCountSeconds;
//+ (unsigned long)   getTickCountMicroSeconds;

// sphenix add code
/*
 * 현재 디바이스의 scale 값을 반환. 
 */
+ (float)           getCurrentScale;
+ (NSInteger )      getDeviceType;
+ (NSString *)      getDeviceOS;
+ (BOOL)            isIpad;
/*
 * 현재 scale을 적용해서 size 반환.
 */
+ (CGSize) CGSizeApplyWithScale:(CGSize)size;
+ (float) getImageValueWithScale:(float)value;

+ (void) setButtonImage:(UIButton *)button filename:(NSString *)filename;
+ (void) setButtonImage:(UIButton *)button normal:(UIImage *)normal highlited:(UIImage *)highlited selected:(UIImage *)selected disabled:(UIImage *)disabled;
+ (void) setBackgroundButtonImage:(UIButton *)button normal:(UIImage *)normal highlited:(UIImage *)highlited selected:(UIImage *)selected disabled:(UIImage *)disabled;
+ (void) setBackgroundButtonImage:(UIButton *)button filename:(NSString *)filename;
+ (void) setButtonTitle:(UIButton *)button normal:(NSString *)normal highlited:(NSString *)highlited selected:(NSString *)selected disabled:(NSString *)disabled;
+ (void) setButtonTitleColor:(UIButton *)button normal:(UIColor *)normal highlited:(UIColor *)highlited selected:(UIColor *)selected disabled:(UIColor *)disabled;

+ (void) setCustomButton:(UIButton *)button title:(NSString*)title fontSize:(NSInteger)size rect:(CGRect)rect;
+ (void) setCustomLabel:(UILabel *)lable title:(NSString *)title fontSize:(NSInteger)size rect:(CGRect)rect;
+ (void) setCustomLabelWithFont:(UILabel *)lable title:(NSString *)title fontSize:(NSInteger)size;

+ (UIImage *) getImage:(NSString *)filename;
+ (UIImage *) getCacheImage:(NSString *)filename;

+ (UIImage *) getImage:(NSString *)filename size:(CGSize)size;
+ (UIImage *) getCacheImage:(NSString *)filename size:(CGSize)size;

+ (UIImage *) getNinePatchImage:(NSString *)filename size:(CGSize)size;
+ (UIImage *) getImagebyScale:(NSString *)filename;
+ (UIImage *) getImageWithSize:(CGSize)size filename:(NSString *)filename;
+ (UIImage *) getLocalImageWithSize:(CGSize)size filename:(NSString *)filename;

+ (UIImage *) scaleAndRotateImage:(UIImage *)image maxResolution:(int)maxResolution minResolution:(int)minResolution;
//+ (UIImage *) getImage:(NSString *)filename size:(CGSize)size;
//+ (UIImage *) makeColorImage:(UIColor *)color size:(CGSize)size;

+ (NSArray *)getNinePatchFullName:(NSString *)filename; // NSArray index 0 ; Off 이름 index 1 : ON 이름

+ (float)getPercentfromNumberString:(NSString *)value;

// 사각형 창 모서리에 라운드 주는 함수
+ (void) makeRoundView:(UIView *)window radius:(CGFloat)radius width:(CGFloat)width bordercolor:(UIColor *)bordercolor;
+ (void) makeShodowView:(UIView *)window radius:(CGFloat)radius width:(CGFloat)width shadowcolor:(UIColor *)shadowcolor;
+ (void) makeRoundShadowView:(UIView *)window radius:(CGFloat)radius width:(CGFloat)width bordercolor:(UIColor *)bordercolor;
+ (id) addSubViewWithNibAndFrame:(NSString *)nibNameNotNil frame:(CGRect)rect target:(UIView *)target;
+ (UIImage *)imageWithColor:(UIColor *)color;

// View에 라인을 그려주는 함수.
+ (void) makeLineView:(UIView *)window type:(NSInteger)type size:(CGFloat)size linecolor:(UIColor *)linecolor;

#pragma mark -
#pragma mark Alert Window

/*
 * OK 버튼만 있는 알림 창
 */
+ (void) ShowAlertWithOk:(NSString *)title message:(NSString *)message delegate:(id)delegate;
+ (void) ShowAlertWithOk:(NSString *)title message:(NSString *)message delegate:(id)delegate tag:(NSInteger)tag;

/*
 * Cancel 버튼만 있는 알림 창
 */
+ (void) ShowAlertWithCancel:(NSString *)title message:(NSString *)message delegate:(id)delegate;

/*
 * OK-CANCEL 버튼 있는 알림 창
 */
+ (void) ShowAlertWithOkCancel:(NSString *)title message:(NSString *)message delegate:(id)delegate tag:(NSInteger)tag;

/*
 * YES 버튼만 있는 알림 창
 */
+ (void) ShowAlertWithYes:(NSString *)title message:(NSString *)message delegate:(id)delegate tag:(NSInteger)tag;

/*
 * YES-NO 버튼 있는 알림 창
 */
+ (void) ShowAlertWithYesNo:(NSString *)title message:(NSString *)message delegate:(id)delegate tag:(NSInteger)tag;

/*
 * 사용자 정의 알림 창
 */
+ (void) ShowAlert:(NSString *)title message:(NSString *)message delegate:(id)delegate tag:(NSInteger)tag  
 cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

/*
 * 상위 창에 뷰를 넣어주는 함수
 */
+ (void) presentModalView:(UIView *)superview source:(UIView *)sourceview animated:(BOOL)animated;

/*
 * add sphenix 2011/11/06 일반 창에 공통 다이알로그 넣을 수 있도룩 추가.
 */
+ (void) openCommonDialog:(id)target type:(NSString *)sDlgType param1:(NSString *)sParam1 param2:(NSString *)sParam2;
/*
 * performselector 함수 래퍼 API
 */
+ (BOOL) performSelector:(SEL)selector target:(id)target withObject:(id)object;
+ (BOOL) performSelector2:(SEL)selector target:(id)target withObject:(id)object anotherObject:(id)anotherObject;
+ (BOOL) perfromSelectorWithDelay:(SEL)selector target:(id)target withObject:(id)object delay:(CGFloat)delay;

/*
 * 화면 사이즈
 */
+ (CGSize) GetScreenSize;
/*
 * 상태바 크기 
 */
+ (int) GetStatusBarHeight;
/*
 * rect 사이즈 변환
 */
+ (CGRect) GetResizeRect:(CGRect)rect;
/*
 * 화면 해상도
 */
+ (CGSize) GetDeviceResolution;

/*
 * 세로모드 인지 반환
 */
+ (BOOL) IsVerticalDeviceOrientation;
+ (BOOL) IsVerticalOrientation;

// IOS6에서는 이벤트가 달라서 해당 함수로 처리함
+ (BOOL)IsVerticalDeviceOrientationByVersions;
/*
 * 키보드 크기 반환.
 */
+ (CGRect) getKeyboardRect:(NSNotification *)aNotification show:(BOOL)show;

/*
 *  iOS 7.0 이상 화면 위치
 */
+ (CGFloat) getTopOffset;

/*
 * 단말 모델 + OS + 버전
 */
+ (NSString *) GetDeviceModel;
+ (NSString *) getDeviceModel;

/*
 * 코드에 따른 에러 메시지 반환
 */
+ (NSString *) getErrorMessageWithCode:(NSInteger)code;

/*
 * 아이피 얻어오는 함수
 */
+ (NSString *) GetIPAddress;

/*
 * 맥어드레스 얻어오는 함수
 */
+ (NSString *) GetMACAddress;

// NSUserDefault 함수들
+ (BOOL) getBoolForKey:(NSString *)key basic:(BOOL)basic;
+ (void) setBoolWithKey:(BOOL)value key:(NSString *)key;
+ (NSInteger) getIntegerForKey:(NSString *)key basic:(NSInteger)basic;
+ (void) setIntegerWithKey:(NSInteger)value key:(NSString *)key;
+ (float) getFloatForKey:(NSString *)key basic:(float)basic;
+ (void) setFloatWithKey:(float)value key:(NSString *)key;
+ (NSString *) getStringForKey:(NSString *)key basic:(NSString *)basic;
+ (void) setStringWithKey:(NSString *)value key:(NSString *)key;
+ (id) getObjectForKey:(NSString *)key;
+ (void) setObjectWithKey:(id)object key:(NSString *)key;
+ (BOOL) getBoolConfigForKey:(NSString *)key basic:(BOOL)basic;
+ (BOOL) isFormDeTest;

+ (NSString *) getStringForKeyEx:(NSString *)key basic:(NSString *)basic;
+ (void) setStringWithKeyEx:(NSString *)value key:(NSString *)key;

/*
 * 스트링 데이터 암호화해서 저장
 */
+ (BOOL) saveStringWithEncryption:(NSString *)key enryptkey:(NSString *)encryptkey vector:(NSString *)vector data:(NSString *)data;
+ (BOOL) saveDataWithEncryption:(NSString *)key enryptkey:(NSString *)encryptkey vector:(NSString *)vector data:(NSData *)data;
/*
 * 암호화된 데이터를 복호환된 스트링으로 반환
 */
+ (NSString *) getStringWithDecryption:(NSString *)key decryptkey:(NSString *)decryptkey vector:(NSString *)vector ;

/*
 * 암호환된 데이터를 복호화된 데이터로 반환
 */
+ (NSData *) getDataWithDecryption:(NSString *)key decryptkey:(NSString *)decryptkey vector:(NSString *)vector ;

+ (void) removeObjectForKey:(NSString *)key;

/*
 * 두 날짜의 차이
 */
+ (int)numberOfDaysBetween:(NSString *)startDate and:(NSString *)endDate;
+ (NSString*)offsetFromDay:(NSString*)startDate offsetDay:(int)nOffsetDay;
+ (NSTimeInterval)offsetFromTime:(NSString*)sStartTime endTime:(NSString*)sEndTime;
/*
 * 주어진 날짜를 포맷에 맞는 스트링으로 반환.
 */
+ (NSString *) stringFromDateWithFormat:(NSDate *)dateTime format:(NSString *)format;

/*
 * 포맷된 스트링에서 날짜 반환
 */
+ (NSDate *) dateFromFormattedString:(NSString *)dateString format:(NSString *)format;

/*
 * ,로 구분된 문자열에서 사각형 반환
 */
+ (CGRect) getRectFromStringByComma:(NSString *)value;

/*
 * 숫자를 currency 스타일 문자열로 반환해주는 함수.
 */
+ (NSString *) getCurrencyFromString:(NSString *)value formatter:(NSNumberFormatter *)formatter;
+ (NSString *) getcurrencyFromFloat:(CGFloat)value formatter:(NSNumberFormatter *)formatter;
+ (NSString *) getcurrencyFromDouble:(double)value formatter:(NSNumberFormatter *)formatter;

// 문자열 대체함수
+ (NSString *) getReplaceFromString:(NSString *)value expr:(NSString *)expr substitute:(NSString *)substitute;

/*
 * fluctuating 값 보여줄지 말지.
 */
+ (BOOL) isDisplayFluctuatingValue:(NSInteger)value;

/*
 * 상세 화면 보여주기.
 */
+ (UIColor *) getColorForFluctuating:(NSInteger)value;

/*
 * 애니메이션
 */
+ (void)animationWithType:(NSInteger)nAniType  duration:(CGFloat)duration Target:(UIView*)target frame:(CGRect)rect callback:(void (^)(BOOL success))callback;
+ (void)animationWithTypePop:(NSInteger)nAniType  duration:(CGFloat)duration Target:(UIView*)target frame:(CGRect)rect formRect:(CGRect)formRect callback:(void (^)(BOOL success))callback;
+ (void)animationWithTypeLinkForm:(NSInteger)nAniType  duration:(CGFloat)duration Target:(UIView*)target frame:(CGRect)rect callback:(void (^)(BOOL success))callback;

/*
 * scroll indicator style 반환.
 */
+ (NSInteger) getScrollBarIndicatorStyle;

/*
 * 부모 영역을 벗어나지 않도록 조정하여 리턴 .
 */
+ (CGRect) getRectInParent:(CGRect)frameRect parentRect:(CGRect)parentRect;

/*
 * 트위터/페이스북에서 데이터를 가지고 shorturl을 만들어 주는 함수
 */
+ (NSString *) getShortURL:(NSString *)data company:(NSString *)company;

/*
 * iTunes 앱 스토어 다운로드 링크 시 필요한 앱 구별자 반환.
 */
+ (NSString *) getAppStoreDownloadUri;
+ (NSString *) getDirectAppStoreUrl;

/*
 * 안드로이드 마켓 정보
 */
+ (NSString *) getAndroidMarketDownloadUri;
+ (NSString *) getDirectAndroidAppStoreUrl;

/*
 * 설치후 최초 실행인지 여부 반환 
 */
+ (BOOL) isFirstRun;
+ (void) setFirstRun:(BOOL)isFirst;

+ (NSString*)SetScreenCapture:(UIViewController*)view filename:(NSString*)filename type:(NSInteger)type;
+ (NSArray*)ParseEventParam:(NSString*)strParam strSep:(NSString*)strSep;
+ (CGRect) makeEventRect:(CGRect)rect;

/*
 * 카메라 있는지 없는지 유무 ipad 1과 이후 버전을 구분한다.
 */

+ (BOOL) isIpadOne;

+ (void) removeAllSubView:(UIView *)view;

// CPU 사용량
+ (void)LogUsedCpu;

// Memory 사용량

+ (void)LogUsedMemory:(NSString *)tag;

// 스킨 테마
+ (NSString*)getTheme;

// 리사이징 이미지
+ (UIImage *)resizeImage:(UIImage *)image width:(float)resizeWidth height:(float)resizeHeight;

+ (UIColor*)getGridBackgroundColor;

+ (UIColor*)getGridSeperateColor;

+ (UIView*)getGridBackgroundView:(CGRect)frame;

+ (BOOL)isIPhone5;
+ (NSString *) getPlatformName;

// 메세지/코드 테이블(다국어)
+ (NSString *) getLocale;
+ (NSString *) getMsgTblText:(NSString *)sValue;
//+ (NSString *) getLangMessage:(NSString *)sKey;

// 리사이징 관련 함수
+(double)calcResize:(CGFloat)size direction:(LAYOUT_TYPE)dir mode:(LAYER_TYPE)mode;
+(double)calcUnResize:(CGFloat)size direction:(LAYOUT_TYPE)dir mode:(LAYER_TYPE)mode;
//+(float) calcUnResize:(float)size direction:(int)dir mode:(int)mode;
// 암호화
+ (NSString *) getEncodeText:(NSString *)strData;
+ (NSString *) getDecodeText:(NSString *)strData;
+ (void)EncyptUserID:(char*)tBuff sBuff:(char*)sBuff slength:(int)slength Flag:(BOOL)Flag;
+ (int)LRotate:(char *)tBuff sBuff:(char *)sBuff slength:(int)slength Per:(int)Per SByte:(int)SByte;
+ (int)RRotate:(char *)tBuff sBuff:(char *)sBuff slength:(int)slength Per:(int)Per SByte:(int)SByte;
+ (int)XOR_ID:(char *)tBuff key:(char *)key slength:(int)slength klength:(int)klength;

+ (int) checkLengthNullWithData:(char*)Data nLength:(int)nLength;
+ (NSString*) getStringWithData:(char*)Data nLength:(int)nLength;
+ (NSString*) getErrMessage:(NSString*)strErrCode;

+ (BOOL) saveScreenShot:(NSString*)sFileName target:(UIView*)targetView frame:(CGRect)tRect target:(id)target completeSel:(SEL)completeSelector;
+ (StockColorValue)getStockColorValue:(NSString *)signString;

+ (NSString*) decimalString:(NSString*)strValue;
+ (NSString*) decimalString:(NSString*)strValue nDigits:(int)minimum;
+ (NSString*) getCurrentStartScreen;

+ (UIImage *) getDaebiTagImageName:(NSString *) daebiTag;
+ (NSString *)getDaebiTagImagePath:(NSString *) daebiTag;
+ (BOOL) isAutoLogin;
+ (void) setAutoLogin:(BOOL)isAuto;

// 컬러 스트링 변환
+ (UIColor*) colorWithHexString:(NSString*) hexString;
+ (NSString*) hexStringWithUIColor:(UIColor*) color;

+ (BOOL)isJailBreakPhone;
+ (BOOL) captureScreen:(NSString*)sFileName target:(UIView*)targetView frame:(CGRect)tRect;
+ (BOOL) saveCapture:(NSString*)sFileName;
//+ (void) presentViewControllerCustom:(UIViewController *)uvSender uvReceiver:(UIViewController *)uvReceiver animated:(BOOL)isAnimated;
//+ (void) dismissViewControllerCustom:(UIViewController *)uvSender animated:(BOOL)isAnimated;
//+ (void) setIsiOS8;
//+ (BOOL) isiOS8;
//+ (BOOL) isGetFileUrl:(NSString*)strUrl;
//+ (BOOL) isGetFileAtchId:(NSString*)strUrl;
+(NSMutableDictionary*)getSystemLog;
+ (NSString*)fillSpace:(NSString*)target length:(NSInteger)nlength;
+ (NSString*)fillCharater:(NSString*)target length:(NSInteger)nlength character:(NSString*)sChar;
+ (void) copyDefaultSound;
+ (BOOL)isPossibleCall;
+ (BOOL)stringContainsEmoji:(NSString *)string;
+ (NSString *)stringToHex:(NSString*)sTarget;
// YES 면 1.5 비율 이하 디바이스 (Ipad , Iphone4)
+ (BOOL)getDeviceTypeByScreenRate;
+ (BOOL)textHasKorean:(NSString*)text;
+ (BOOL)isKoreanContain:(NSString*)sCharText;
+ (void) setButtonImageInset :(UIButton *) btn width:(CGFloat)width height:(CGFloat)height;
+ (void) setButtonImageInset :(UIButton *) btn width:(CGFloat)width height:(CGFloat)height useCalcResize:(BOOL)bUse;;
+ (BOOL) isEmptyString :(NSString *)sString;

+ (void) setServerConnectInfo:(int) nServerIndex;
+ (int) getServerConnectInfo;
+ (BOOL) isTestServer;

// escdream 2017.11.30 - 디바이스 버젼 정보 처리 추가
+ (NSString *) getDeviceName;

+ (NSString *) DecodeWebStr:(NSString *) value;

+ (CGRect) getWindowArea;

+ (void) ios11TableFatch:(UITableView *) aTable;


+ (NSInteger)checkPhoneType;
+ (CGFloat)iosScaleX : (CGFloat) x;
+ (CGFloat)iosScale : (CGFloat)x fixPercent:(float)percent;
+ (CGFloat)iosScaleY : (CGFloat) y;
+ (void)iosScaleRect:(UIView *)target;
+ (void) iosChangeScaleView:(UIView *)targetView fontSizeFix:(float)percent;
@end

