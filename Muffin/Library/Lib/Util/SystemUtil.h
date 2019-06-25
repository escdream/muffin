//
//  SystemUtil.h
//  SmartVIGS
//
//  Created by itgen on 11. 8. 2..
//  Copyright 2011 itgen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define MAIN_CAPTION_HEIGHT             39.0
#define MAIN_QUICKMENU_HEIGHT           50.0
#define MAIN_SISE_HEIGHT                29.0

@class KSDevice;

@interface SystemUtil : NSObject
{
	BOOL			m_isInitialized;
	NSString		*m_sPhoneNo;
    NSString        *m_sDeviceID2;          // 폼 전송 서버에 요청할때 쓰임
	NSString		*m_sDeviceID;
    NSString        *m_sMediaCD;            // 매체 코드 스마트폰 ' 28
	NSString		*m_sAppCode;            // 앱 코드 B1100, B1200, B1300 등등
    NSString        *m_sAppHexCode;         // 앱 헥사 코드
    NSString        *m_sOrganicCD;          // 조직 코드
    NSString        *m_sSeqCD;              // 일련번호
    NSString        *m_sEMPDEPT;            // 조작자 부서 코드 HANTOO_EMP_DEPT
    NSString        *m_sEMPID;              // 조작자 사번
	NSString		*m_sMacAddress;
	NSString		*m_sDeviceModel;
	NSString		*m_sOsVersion;
	int				m_nSdkVersion;
    NSString        *m_sPushToken;
	
	NSString		*m_sOSGubunCode;
	NSString		*m_sOSGubunCode1;
	NSString		*m_sCompanyName;
	NSString		*m_sAppType;
    
    NSMutableArray  *m_arrSoundName;
	
	int				m_nAppMajorVersion;			// Major Change
	int				m_nAppMinorVersion;			// Minor Change
    int             m_nAppMaintVersion;			// Maintenance Change (Bugfix)
	NSString*		m_sAppBuildDate;			// Build Date
    
    double          m_fontSizeRate;
    double          m_screenVertWidthRate;
    double          m_screenVertHeightRate;
    double          m_screenHorzWidthRate;
    double          m_screenHorzHeightRate;
	
	double          m_screenScaleVertHeightRate;
	double          m_screenCustomVertHeightRate;
	
	KSDevice		*m_ksDevice;
    
//	id<IMessageDelegate>   m_mainViewController;        // 메세지 델리게이트로 메인뷰 컨트롤러만 받는다.
	NSInteger       m_nRateType;
    BOOL            m_bRateType;
}

@property (nonatomic, strong) NSString	*m_sPhoneNo;
@property (nonatomic, strong) NSString	*m_sDeviceID;
@property (nonatomic, strong) NSString	*m_sDeviceID2;
@property (nonatomic, strong) NSString	*m_sMacAddress;
@property (nonatomic, strong) NSString	*m_sDeviceModel;
@property (nonatomic, strong) NSString	*m_sOsVersion;
@property (nonatomic, assign) int		m_nSdkVersion;
@property (nonatomic, strong) NSString	*m_sOSGubunCode;
@property (nonatomic, strong) NSString	*m_sOSGubunCode1;
@property (nonatomic, strong) NSString	*m_sCompanyName;
@property (nonatomic, strong) NSString	*m_sTestDeviceId;
@property (nonatomic, strong, getter = getMediaCD   ) NSString  *m_sMediaCD;            ///< 매체 코드 스마트폰 ' 28
@property (nonatomic, strong, getter = getAppCode   ) NSString  *m_sAppCode;            ///< 앱 코드 B1100, B1200, B1300 등등
@property (nonatomic, strong, getter=  getAppHexCode) NSString  *m_sAppHexCode;         ///< 앱 헥사 코드
@property (nonatomic, strong, getter = getOrganicCD ) NSString  *m_sOrganicCD;          ///< 조직 코드
@property (nonatomic, strong, getter = getSeqCD     ) NSString  *m_sSeqCD;              ///< 일련번호
@property (nonatomic, strong, getter = getEMPDPT    ) NSString  *m_sEMPDEPT;            ///< 조작자 부서 코드 HANTOO_EMP_DEPT
@property (nonatomic, strong, getter = getEMPID     ) NSString  *m_sEMPID;              ///< 조작자 사번
@property (nonatomic, strong ) NSString        *m_sPushToken;                           ///< 푸쉬 토큰

@property (nonatomic, strong) NSString	*m_sAppType;
//@property (nonatomic, strong) NSString	*m_sThemeName;
//@property (nonatomic, strong) NSString  *m_sSkinTheme;
@property (nonatomic, assign) int		m_nAppMajorVersion;
@property (nonatomic, assign) int		m_nAppMinorVersion;
@property (nonatomic, assign) int		m_nAppMaintVersion;
@property (nonatomic, strong) NSString*	m_sAppBuildDate;

@property (nonatomic, getter = getAppType,     setter= setAppType:,     assign) char m_ucAppType;
@property (nonatomic, getter = getUseVersion , setter = setUseVersion:, assign) BOOL m_isUseVersion;

//MeritzSec Only..
@property (nonatomic, getter = getMCIVerify , setter = setMCIVerify:, retain) NSString* m_sMCIVerify;	///< MCI Verify MeritzSec
@property (nonatomic, getter = getEventGB , setter = setEventGB:, assign) char m_ucEventGB;				///< EventGB MeritzSec
@property (nonatomic, getter = getBrachCD , setter = setBrachCD:, retain) NSString* m_sBrachCD;			///< BranchCD MeritzSec
@property (nonatomic, getter = getMCISSKey , setter = setMCISSKey:, retain) NSString* m_sMCISSKey;		///< MCISessionKey MeritzSec
@property (nonatomic, getter = getRoleCD , setter = setRoleCD:, assign) char m_ucRoleCD;				///< Role Code MeritzSec


// public id info
@property (nonatomic, strong) NSString * m_sPacketPublicIP; // 패킷전송시 단말번호로 사용될 아이피정보

+ (id)				alloc;
+ (SystemUtil *)	instance;
+ (int)				getAppMajorVersion;
+ (int)				getAppMinorVersion;
+ (int)             getAppMaintVersion;
+ (NSString *)		getAppType;
//+ (NSString *)		getThemeName;
//+ (void)			setThemeName:(NSString *)name;
+ (BOOL)            isCellNetwork;
+ (BOOL)            isNetworkReachable;
+ (NSString *)      getconnectState;
+ (NSString *)		getDeviceId;
+ (NSString *)      getDeviceIdSimple10;
+ (NSString *)      getTestDeviceId;
+ (void)            setTimerdisabled:(BOOL)bBool;
+ (void)            setTimerDisabledUsrSetting;
//+ (NSString*)       getSkinTheme;
//+ (void)            setSkinTheme:(NSString*)sSkinTheme;
+ (NSString*)		getCompanyName;
+ (void)            setConnectIP;
- (NSInteger)       getScreenRateMode;
- (id)				initSystemInfo;
-(void)             initSizeRateInfo;
- (void)            addSoundName:(NSString*)sName;

- (NSString*)		getAppName;

- (NSString*)		getAppVersionStringFakeCheck;
- (NSString*)		getAppVersionString;			// 일반 버전형식(#.#.#)
- (NSString*)		getAppVersionStringBy6;			// 6자리 버전형식(######)

- (NSString*)		toStringEx;
//- (id) getMainViewController;
//- (void)            setMainViewController:(id<IMessageDelegate>)vc;
- (NSString*)       getOSVersion;
- (double) getScreenRateOfDir:(NSInteger)dir mode:(NSInteger)mode;
- (double) getScreenRateOfDir:(NSInteger)dir mode:(NSInteger)mode type:(NSInteger)type;
- (void) setScreenRateMode : (NSInteger) nType;
- (double)getFontSizeRate;


+ (NSString*)checkLBSServerList:(NSArray*)arrLBSList;

- (BOOL) isIPhoneX;
- (BOOL) isIPhoneXMax;
@end
