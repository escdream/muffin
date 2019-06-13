//
//  SystemUtil.m
//  SmartVIGS
//
//  Created by itgen on 11. 8. 2..
//  Copyright 2011 itgen. All rights reserved.
//
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
#import "SystemUtil.h"
#import "CommonUtil.h"
#import "OpenUDID.h"
#import "CommonFileUtil.h"
#import "LinkData.h"
#import "CommonDef.h"
#import "ConfigUtil.h"
#import "KeychainItemWrapper.h"

#import <SystemConfiguration/CaptiveNetwork.h>
#import <LocalAuthentication/LocalAuthentication.h>

static SystemUtil* instance;

#define DEV_ID  @"MUFFINE_ID"

@implementation SystemUtil

@synthesize m_sPhoneNo;
@synthesize m_sDeviceID;
@synthesize m_sDeviceID2;
@synthesize m_sMacAddress;
@synthesize m_sDeviceModel;
@synthesize m_sOsVersion;
@synthesize m_nSdkVersion;
@synthesize m_sOSGubunCode;
@synthesize m_sOSGubunCode1;
@synthesize m_sCompanyName;
@synthesize m_sTestDeviceId;
@synthesize m_sMediaCD;
@synthesize m_sAppCode;
@synthesize m_sAppHexCode;
@synthesize m_sPushToken;

@synthesize m_sOrganicCD;          // 조직 코드
@synthesize m_sSeqCD;              // 일련번호
@synthesize m_sEMPDEPT;            // 조작자 부서 코드 HANTOO_EMP_DEPT
@synthesize m_sEMPID;              // 조작자 사번

//@synthesize m_sThemeName;
//@synthesize m_sSkinTheme;
@synthesize m_sAppType;
@synthesize m_nAppMajorVersion;
@synthesize m_nAppMinorVersion;
@synthesize m_nAppMaintVersion;
@synthesize m_sAppBuildDate;
@synthesize m_isUseVersion;
@synthesize m_ucAppType;

//MeritzSec Only
@synthesize m_sMCIVerify, m_ucEventGB, m_sBrachCD, m_sMCISSKey, m_ucRoleCD;

+(id)alloc
{
	NSAssert(instance == nil, @"Attempted to allocate a second instance of a singleton.");
	instance = [super alloc];
	return instance;
}

+(SystemUtil *)instance
{
	if (!instance) {
		instance = [[SystemUtil alloc] initSystemInfo];
	}
	return instance;
}

+(BOOL)isNetworkReachable{
    
	struct sockaddr_in zeroAddr;
    
	bzero(&zeroAddr, sizeof(zeroAddr));
    
	zeroAddr.sin_len = sizeof(zeroAddr);
    
	zeroAddr.sin_family = AF_INET;
    
	SCNetworkReachabilityRef target = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddr);
    
	SCNetworkReachabilityFlags flag;
    
	SCNetworkReachabilityGetFlags(target, &flag);
    
    // 2017.04.24.
    CFRelease(target);
    
	if(flag & kSCNetworkFlagsReachable){
        
		return YES;
        
	}else {
        
		return NO;
        
	}
}

+(BOOL)isCellNetwork{
    
	struct sockaddr_in zeroAddr;
    
	bzero(&zeroAddr, sizeof(zeroAddr));
    
	zeroAddr.sin_len = sizeof(zeroAddr);
    
	zeroAddr.sin_family = AF_INET;
    
	SCNetworkReachabilityRef target = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddr);
    
	
    
	SCNetworkReachabilityFlags flag;
    
	SCNetworkReachabilityGetFlags(target, &flag);

    
	if(flag & kSCNetworkReachabilityFlagsIsWWAN){
        
		return YES;
        
	}else {
        
		return NO;
        
	}

}
+(NSString *)getconnectState
{
    if (![self isNetworkReachable]) {
        return @"네트워크 접속 불가능";
    }
    if ([self isCellNetwork])
        return @"3G";
	else
	{
		CFArrayRef netwrorkInterfaceArray = CNCopySupportedInterfaces();
		if(netwrorkInterfaceArray == nil) return @"wifi";
		NSDictionary *networkInfoDict = (__bridge NSDictionary *)CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(netwrorkInterfaceArray, 0));
        
        if (networkInfoDict == nil)
        {
            return @"네트워크 접속 불가능";
        }
        
		NSString* resultString = [[@"wifi [" stringByAppendingString:[networkInfoDict objectForKey:@"SSID"]] stringByAppendingString:@"]"];
		
		// Core Foundation 관리객체반환, Copy, Alloc로 시작되는 함수의 반환값은 명시적으로 Release해야함
		CFRelease((__bridge CFTypeRef)(networkInfoDict));
		CFRelease(netwrorkInterfaceArray);
		
		return resultString;
	}
}

+(int)getAppMajorVersion
{
	return [self instance].m_nAppMajorVersion;
}

+(int)getAppMinorVersion
{
	return [self instance].m_nAppMinorVersion;
}

+(int)getAppMaintVersion
{
	return [self instance].m_nAppMaintVersion;
}

+(NSString *)getAppType
{
	return [self instance].m_sAppType;
}

+ (NSString *) getTestDeviceId
{
	return [self instance].m_sTestDeviceId;
}

+ (NSString *) getDeviceId
{
	return [self instance].m_sDeviceID;
}




+ (NSString *) getDeviceIdSimple10
{
    NSString * result = [[self instance].m_sDeviceID substringToIndex:10];
    return result;
}



- (BOOL) isIPhoneX
{
    return ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && MAX([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width) == 812.0);
}

-(void) initSizeRateInfo
{
    
    double statusbarHeight = STANDARD_STATUSBAR_H;
    
    
//#ifdef IPHONE_X_APPLY
    
    CGRect screenRect = [CommonUtil getWindowArea];   // iPhoneX
    
    if ([self isIPhoneX])
    {
        statusbarHeight = 44;

//        statusheight = 44;
        
//        screenRect.size.height -= 24;
        
    }
    
//#else
    

    
    
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    // test code;
    // 회전 시작후 계산 처리 방식이ㅡ
    // escdream 2017.09.20
#ifdef LANDSCAPE_START_FIX
    if (screenRect.size.width > screenRect.size.height)
    {
        screenRect.size.width = screenRect.size.height;
        screenRect.size.height = [[UIScreen mainScreen] bounds].size.width;
    }
#endif
    
    m_fontSizeRate = CGRectGetWidth(screenRect) / STANDARD_WIDTH_MTS;

    m_screenVertWidthRate = CGRectGetWidth(screenRect) / STANDARD_WIDTH_MTS;
    m_screenVertHeightRate = (CGRectGetHeight(screenRect)-statusbarHeight ) / (STANDARD_HEIGHT_MTS-statusbarHeight);
    
    // 가로모드 비율
    m_screenHorzWidthRate = screenRect.size.height / STANDARD_HEIGHT_MTS;
    m_screenHorzHeightRate = (screenRect.size.width - statusbarHeight) / (STANDARD_WIDTH_MTS - statusbarHeight);
    
    
    if ([self isIPhoneX])
    {
        m_fontSizeRate = (CGRectGetWidth(screenRect) - statusbarHeight) / STANDARD_WIDTH_MTS ;
        
//        m_screenHorzWidthRate = screenRect.size.height  / STANDARD_HEIGHT_MTS;
//r        m_screenHorzHeightRate = ((screenRect.size.width - 5) ) / (STANDARD_WIDTH_MTS);
        
        m_screenHorzWidthRate  = (screenRect.size.height - (IS_IPHONE_X ? IPHONE_X_OFFSET*6 : 0)) / ((STANDARD_HEIGHT_MTS) + (IS_IPHONE_X ? IPHONE_X_OFFSET : 0));
        
        m_screenHorzHeightRate = screenRect.size.width / ((STANDARD_WIDTH_MTS) - (IS_IPHONE_X ? IPHONE_X_OFFSET : 0));
    }
    
}

-(id)initSystemInfo
{
	if( (self = [super init] ) != nil )
	{
		if(m_isInitialized) return self;
		
		self.m_sPhoneNo = @"";
        self.m_sDeviceID = [self getDeviceInfo];
		self.m_sAppType = @"";
//		self.m_sThemeName = @"white";
        self.m_sAppCode = MTS_MEDIA_APP_CODE;
        self.m_sAppHexCode = [CommonUtil stringToHex:m_sAppCode];
        self.m_sMediaCD = MTS_MEDIA_CODE;
        self.m_sOrganicCD = HANTOO_ORGANIC;
        self.m_sEMPDEPT = HANTOO_EMP_DEPT;
        self.m_sEMPID = HANTOO_EMP_ID;
        self.m_sSeqCD = HANTOO_SEQ_NO;
        self.m_sDeviceID2 = [OpenUDID value];
		self.m_sDeviceModel = [[UIDevice currentDevice] model];
		self.m_sOsVersion = [[UIDevice currentDevice] systemVersion];
		self.m_nSdkVersion = 0;
		
		/// MertizSec
		m_ucRoleCD = 0x20;
		/////////////
		
		self.m_sOSGubunCode = @"02";	// 01:안드로이드, 02:아이폰
		self.m_sOSGubunCode1 = @"2";
		self.m_sCompanyName = @"Customer ENC";
		self.m_sPushToken = @"";
		self.m_sTestDeviceId  = [NSString stringWithFormat:@"%@I", [self.m_sDeviceID2 substringWithRange:(NSRange){0,4}]]; //Android =A, iPhone=I, Windows =W, Bada =B
		
		NSString* appVersion  = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
		NSString* buildNumber =[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
		
		NSArray* arrVersions = [appVersion componentsSeparatedByString:@"."];
		
		self.m_nAppMajorVersion = (arrVersions.count > 0) ? [[arrVersions objectAtIndex:0] intValue] : 0;
		self.m_nAppMinorVersion = (arrVersions.count > 1) ? [[arrVersions objectAtIndex:1] intValue] : 0;
		self.m_nAppMaintVersion = (arrVersions.count > 2) ? [[arrVersions objectAtIndex:2] intValue] : 0;
		self.m_sAppBuildDate = buildNumber;
		m_sMacAddress = [CommonUtil GetMACAddress];
		
		m_screenVertHeightRate = 0.0;
		
		[self initSizeRateInfo];
        
        // escdream 2017.11.30 - public ip 셋팅 처리용 기본값
        self.m_sPacketPublicIP = @"000000000000";
        
		m_isInitialized = YES;
	}
	return self;
}

- (double)getFontSizeRate
{
    return m_fontSizeRate;
}


//— 키체인 랩퍼
- (NSString *) getKBSEC_UUID
{
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"KBSEC_UUID" accessGroup:nil];
    NSString* KB_UUID = [wrapper objectForKey:(id)kSecValueData];
    
    if (nil == KB_UUID || [KB_UUID length] < 1)
    {
        KB_UUID = @"";
        
        
//        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
//        KB_UUID = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
//        KB_UUID = [KB_UUID stringByReplacingOccurrencesOfString:@"-" withString:@""];
//        
//        [wrapper setObject:KB_UUID forKey:(id)kSecValueData];
    }
    
    //    NSUserDefaults * pref = [NSUserDefaults standardUserDefaults];
    //    [pref setObject:KB_UUID forKey:@"KBSEC_UUID"];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //[self._DeviceKey setString:[ksDev hashData:KB_UUID]];
    //    [self._DeviceKey setString:KB_UUID];
    //
    //    [wrapper release];
    
    return KB_UUID;
}


- (NSString*)getDeviceInfo
{
//
//// KB Device 추가 처리
//
//    // 기존 스마톡S사용자인 경우 아래의 KBSEC_UUID 정보가 저장되어 있으므로
//    // 저장된값이 있을 경우 우선 확인해서 처리 하는 경우로 변경
//    NSString *deviceId = [self getKBSEC_UUID];
//
//    if ([deviceId isEqualToString:@""] || deviceId.length == 0)
//    {
//        char mackey[16] = {'e', 'F', 'r', 'i', 'e', 'n', 'd', 'S', 'm', 'a', 'r', 't', 'K', 'i', 's', 's'};
////        char mackey[16] = {'K', 'B', 'S', 'e', 'c', 'u', 'r', 'i', 't', 'e', 's', '.', 'd', 'a', 't', 'a'};
//        KSDevice *ksDev = [[KSDevice alloc] initWithAlgorithm:KS_DEVICE_HASH_HMACSHA mackey:mackey];
//
//
//        NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
////
//        // escdream 2018.01.19
//        // 키체인 그룹을 번들 정보로 구분 처리 한다.
//        if ( [bundleIdentifier isEqualToString:@"kr.co.youfirst.ableMTS.inhouse"])
//        {
//            ksDev.sharingGroup = @"UXWU24W42T.kr.co.youfirst";
//            //ksDev.sharingGroup = @"STDQZN44CH.kr.co.youfirst"; //  처리 확인할것
//        }
//        else if ( [bundleIdentifier isEqualToString:@"kr.kbsec.iplustar"])
//           // ksDev.sharingGroup = @"STDQZN44CH.kr.co.youfirst"; //  처리 확인할것
//            ksDev.sharingGroup = @"5A2TBAQ7TV.kr.kbsec";
//
////#ifdef INHOUSE_BUILD
////        ksDev.sharingGroup = @"UXWU24W42T.kr.co.youfirst";
////#else
////        ksDev.sharingGroup = @"STDQZN44CH.kr.co.youfirst";
////        ksDev.sharingGroup = @"5A2TBAQ7TV.kr.kbsec.iplustar";
////#endif
//
//        deviceId = [ksDev getIdForKey:DEV_ID];
//
//        if (deviceId == nil || [deviceId length] == 0) {
//            deviceId = [CommonUtil getStringForKey:DEV_ID basic:@""];
//
//            // escdream 2018.01.19 - keychain sharing update!
//            if ((deviceId != nil) && (deviceId.length > 0))
//            {
//                //  키체인에 저장한다.
//                [ksDev setId:deviceId forKey:DEV_ID];
//            }
//        }
//        if(deviceId == nil || [deviceId length] == 0)      {   //키체인에 device id 가 존재하지 않으면
//            // 2. device id 포맷을 설정한다.
//            NSString *hashedUUID = [ksDev getUUIDIsHashed:YES];
//            NSString *hashedDevName = [ksDev getDeviceNameIsHashed:YES];
//            NSString *hashedSysVer = [ksDev getSystemVersionIsHashed:YES];
//
//            if (hashedUUID == nil || hashedDevName == nil || hashedSysVer == nil) {
//                NSLog(@"기기값 추출이 잘못되었습니다.");
//            }
//            NSString *aDeviceId = [NSString stringWithFormat:@"%@%@%@", hashedUUID, hashedDevName, hashedSysVer];
//
//            // 3. device id를 해쉬한다.(option)
//            deviceId = [ksDev hashData:aDeviceId];
//            // 4. 키체인에 저장한다.
//            int ret = [ksDev setId:deviceId forKey:DEV_ID];
//
//            [CommonUtil setStringWithKey:deviceId key:DEV_ID];
//
//        }
//    }
//
//    return deviceId;
    return @"";
}

-(void)dealloc
{
	
}

- (void)addSoundName:(NSString*)sName
{
    if (m_arrSoundName == nil ) m_arrSoundName = [[NSMutableArray alloc] init];
    
    [m_arrSoundName addObject:sName];
}

- (NSString*) getAppName
{
    NSString *sAppName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
	return sAppName;
}

- (NSString*) getAppVersionStringFakeCheck
{
    
    return [NSString stringWithFormat:@"%d.%d%d", self.m_nAppMajorVersion, self.m_nAppMinorVersion, self.m_nAppMaintVersion];
}

- (NSString*) getAppVersionString
{
   return [NSString stringWithFormat:@"%d.%d.%d", self.m_nAppMajorVersion, self.m_nAppMinorVersion, self.m_nAppMaintVersion];
}

- (NSString*) getAppVersionStringBy6
{
    if (m_nAppMaintVersion > 0)
        return [NSString stringWithFormat:@"%02d%02d%02d", self.m_nAppMajorVersion, self.m_nAppMinorVersion, self.m_nAppMaintVersion];
    else
        return [NSString stringWithFormat:@"%02d%02d", self.m_nAppMajorVersion, self.m_nAppMinorVersion];
}

- (NSString*) toStringEx
{
	NSString* strText = @"세션 정보 ----------------\n";
	strText = [strText stringByAppendingFormat:@"전화번호 : %@\n", self.m_sPhoneNo];
	strText = [strText stringByAppendingFormat:@"디바이스번호 : %@\n", self.m_sDeviceID];
	strText = [strText stringByAppendingFormat:@"맥어드레스 : %@\n", self.m_sMacAddress];
	strText = [strText stringByAppendingFormat:@"모델명 : %@\n", self.m_sDeviceModel];
	strText = [strText stringByAppendingFormat:@"OS버전 : %@\n", self.m_sOsVersion];
	strText = [strText stringByAppendingFormat:@"SDK버전 : %d\n", self.m_nSdkVersion];
	
	return strText;
}

- (NSString*)getOSVersion
{
    return self.m_sOsVersion;
}

+ (NSString*) getCompanyName
{
	return [self instance].m_sCompanyName;
}

+ (void)setTimerdisabled:(BOOL)bBool
{
    [UIApplication sharedApplication].idleTimerDisabled = bBool;
}

+ (void)setTimerDisabledUsrSetting
{
    NSString *keep = [ConfigUtil loadConfigData:@"comfingfile" sKeyName:@"common.keep_light"];
    BOOL bType = (([keep isEqualToString:@""] || [keep isEqualToString:@"1"]) ? YES : NO );
    if( bType )
    {
        [UIApplication sharedApplication].idleTimerDisabled = YES;
    }else{
        [UIApplication sharedApplication].idleTimerDisabled = NO;
    }
}

//- (id<IMessageDelegate>) getMainViewController
//{
//    return m_mainViewController;
//}

//- (void) setMainViewController:(id <IMessageDelegate>)vc
//{
//    if (![NSClassFromString(@"MainViewController") isSubclassOfClass:[vc class]])
//        return;
//    m_mainViewController = vc;
//}

- (double) getScreenRateOfDir:(NSInteger)dir mode:(NSInteger)mode
{
    if( mode == LAYOUT_TYPE_VERTICAL )
    {
        if( dir == LAYER_TYPE_VERTICAL )
            return m_screenVertHeightRate;
        else
            return m_screenVertWidthRate;
    }
    else
    {
        if( dir == LAYER_TYPE_VERTICAL )
            return m_screenHorzHeightRate;
        else
            return m_screenHorzWidthRate;
    }
}

- (double) getScreenRateOfDir:(NSInteger)dir mode:(NSInteger)mode type:(NSInteger)type
{
	if( mode == LAYOUT_TYPE_VERTICAL )
	{
		if( dir == LAYER_TYPE_VERTICAL )
		{
//			if (type == RESIZE_TYPE_NORMAL)
//				return m_screenVertHeightRate;
//			else if (type == RESIZE_TYPE_SCREEN)
//				return m_screenCustomVertHeightRate;
//			else
				return m_screenScaleVertHeightRate;
		}
		else
			return m_screenVertWidthRate;
	}
	else
	{
		if( dir == LAYER_TYPE_VERTICAL )
			return m_screenHorzHeightRate;
		else
			return m_screenHorzWidthRate;
	}
}

- (void) setScreenRateMode : (NSInteger) nType
{
	m_nRateType = nType;
}

- (NSInteger) getScreenRateMode
{
    // 비율에 따라서 살짝 깨지는 경우가 발생해서
	return m_nRateType;
}

// App Type
- (void) setAppType:(char)ucNew
{
    self.m_ucAppType = ucNew;
}


// App UseVersion Property Method -by Berdo 2014-06-02
- (void) setUseVersion:(BOOL)bNew
{
    m_isUseVersion = bNew;
}

- (BOOL) getUseVersion
{
    return m_isUseVersion;
}

- (NSString*) getMCIVerify
{
	return m_sMCIVerify;
}

- (void) setMCIVerify:(NSString*)sNew
{
	self.m_sMCIVerify = sNew;
}

- (char) getEventGB
{
	return m_ucEventGB;
}

- (void) setEventGB:(char)ucNew
{
	self.m_ucEventGB = ucNew;
}

- (NSString*) getBrachCD
{
	return m_sBrachCD;
}

- (void) setBrachCD:(NSString*)strNew
{
	self.m_sBrachCD = strNew;
}

- (NSString*) getMCISSKey
{
	return m_sMCISSKey;
}

- (void) setMCISSKey:(NSString*)strNew
{
	self.m_sMCISSKey = strNew;
}

- (char) getRoleCD
{
	return m_ucRoleCD;
}

- (void) setRoleCD:(char)ucNew
{
	self.m_ucRoleCD = ucNew;
}


+ (NSString*)checkLBSServerList:(NSArray*)arrLBSList
{
	NSString *filePath = [CommonFileUtil getSystemFilePath:@"fundappip.dat"];
    NSData *mainMenuContents =  [[NSFileManager defaultManager] contentsAtPath:filePath];
    NSString *dataString = [[NSString alloc] initWithData:mainMenuContents encoding:NSEUCKREncoding];

    dataString = [dataString stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
    
    NSArray *arrLine = [dataString componentsSeparatedByString:@"\n"];
    
    NSString *sLinkData = [dataString stringByReplacingOccurrencesOfString:@"\n" withString:@":"];
    [[LinkData sharedLinkData] setData:@"&FUNDAPP_IP_LIST" value:sLinkData];
    
    for (int i = 0; i < [arrLBSList count]; i++) {
        NSString *sLBSServer = [[arrLBSList objectAtIndex:i]  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        for (int j = 0; j < [arrLine count]; j++ ) {
            NSString *sFileServer = [[arrLine objectAtIndex:j] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([sFileServer isEqualToString:sLBSServer]) {
                return sFileServer;
            }
        }
    }
    
    // LBSList에 없으면 랜덤으로 돌린 인덱스로 문구에서 넣는다.
    srandom((unsigned)time(NULL));
    long nNumber = random();
    long nRandomIndex =  nNumber % [arrLine count];
    
    return [arrLine objectAtIndex:nRandomIndex];
}
                            

+ (void)setConnectIP
{
    NSString *filePath = [CommonFileUtil getSystemFilePath:@"fundappip.dat"];
    NSData *mainMenuContents =  [[NSFileManager defaultManager] contentsAtPath:filePath];
    NSString *dataString = [[NSString alloc] initWithData:mainMenuContents encoding:NSEUCKREncoding];
    
    dataString = [dataString stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
    
    NSString *sLinkData = [dataString stringByReplacingOccurrencesOfString:@"\n" withString:@":"];
    [[LinkData sharedLinkData] setData:@"&FUNDAPP_IP_LIST" value:sLinkData];
}


@end
