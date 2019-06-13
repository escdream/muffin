//
//  LinkData.m
//  SmartVIGS
//
//  Created by juyoung Kim on 11. 5. 2..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "SystemUtil.h"
#import "LinkData.h"
#import "CommonFileUtil.h"
#import "CommonUtil.h"
#import "LinkDataInfo.h"
#import "NSString+Format.h"

#define	NULL_DATA			@""

#define ITEM_HISTORY_KEY    @"HistoryItem"
#define ITEM_MOTU_HISTORY_KEY    @"MotuHistoryItem"
#define ITEM_BASKET_ELS     @"BasketItemELS"
#define ITEM_BASKET_FUND    @"BasketItemFund"
#define DEFAULT_CODE		@""
#define DEFAULT_CODE_FFUTURE    @""


#pragma mark - DATA_ITME

@implementation DATA_ITEM

@synthesize markettext, value , name , etcInfo;

- (id) init
{
	self = [super init];
	return self;
}

- (void)dealloc
{
	// 2017.04.25.
    markettext = nil;
    market_type = nil;
    value = nil;
    name = nil;
    etcInfo = nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:(int)sequence forKey:@"sequence"];
    [aCoder encodeObject:market_type forKey:@"market_type"];
    [aCoder encodeObject:markettext forKey:@"markettext"];
    [aCoder encodeObject:value forKey:@"value"];
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:etcInfo forKey:@"etcInfo"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        sequence    = [aDecoder decodeIntegerForKey:@"sequence"];
        market_type = [aDecoder decodeObjectForKey:@"market_type"];
        markettext  = [aDecoder decodeObjectForKey:@"markettext"];
        value       = [aDecoder decodeObjectForKey:@"value"];
        name        = [aDecoder decodeObjectForKey:@"name"];
        etcInfo     = [aDecoder decodeObjectForKey:@"etcInfo"];
    }
    return self;
}


- (void)setSequence : (NSUInteger)seq
{
	sequence = seq;
}

- (NSUInteger)getSequence
{
	return sequence;
}

- (void)setMarketType : (NSString*)market
{
	market_type = market;
}

- (NSString*)getMarketType
{
	return market_type;
}

- (void)setItemValue:(NSString*)itemValue
{
	self.value = itemValue;
}

- (NSString*)getItemValue
{
	return value;
}

@end


#pragma mark - LinkDat

@implementation LinkData

static LinkData* sharedLinkData = nil;


+ (LinkData *) sharedLinkData
{
	if (!sharedLinkData)
		sharedLinkData = [[LinkData alloc] init];
	
	return sharedLinkData;
}

+ (void) clean
{
    if( sharedLinkData != nil )
        sharedLinkData = nil;
}

- (id) init
{
	self = [super init];
	if (self) 
		[self initProperty];
	
	return self;
} 

- (void) initProperty
{
	ITEMCODE_MAX_COUNT	= 20;
	m_nCount			= 0;
	
	m_arrHistory		= [[NSMutableArray		alloc] init];

    m_arrStockInvestDiary = [[NSMutableArray alloc] init];
    
	m_mapCodeData		= [[NSMutableDictionary alloc] init];
	m_mapSharedData		= [[NSMutableDictionary alloc] init];
    m_mapSharedMapData  = [[NSMutableDictionary alloc] init];
    // 시간/날짜 정보
	m_timeBP            = [[NSDate alloc]init];
	m_nCurMarketType    = 1;
	m_bInitLoading = NO;
//	m_menuGubun = 0;
}

- (void)dealloc
{
	m_arrHistory	 = nil;
	m_mapSharedData  = nil;
	m_mapCodeData	 = nil;
    m_mapSharedMapData= nil;
	m_timeBP		 = nil;
}



/**
 * @breif Lua Table 저장용도.
 * @param NSString* sKey
 * @param NSMutableDictionary objMap
 * @return None
 */
- (void) setMapData:(NSString*)sKey objMap:(NSMutableDictionary*)objMap
{
    if(m_mapSharedMapData == nil) return;
    [m_mapSharedMapData setObject:objMap forKey:sKey];
}

/**
 * @breif Lua Table 얻어가고 클리어처리 포함.
 * @param NSString* sKey
 * @param BOOL isClear
 * @return NSMutableDictionary*
 */
- (NSMutableDictionary*) getMapData:(NSString*)sKey isClear:(BOOL)isClear
{
    if(m_mapSharedMapData == nil) return nil;
    
    NSMutableDictionary* objRet = [m_mapSharedMapData objectForKey:sKey];
    
    if( isClear )
        [m_mapSharedMapData removeObjectForKey:sKey];
    return objRet;
}

// 시스템 정보를 연결 정보로 설정 // 추가 필요
-(void)setSystemInfo
{
//    [self setData:MEDIA_TYPE        value:[[SessionInfo instance] getMediaCode]];
//    [self setData:PHONE_NUMBER      value:[SystemUtil instance].m_sPhoneNo];
//    [self setData:APP_TYPE          value:[SystemUtil instance].m_sAppType];
//    [self setData:APP_VERSION       value:[[SystemUtil instance] getAppVersionString]];
//    [self setData:DEVICE_MODEL      value:[CommonUtil getDeviceModel]];
//    [self setData:UNIQ_INFO_1         value:[SystemUtil instance].m_sDeviceID];
//    [self setData:UNIQ_INFO_2         value:[SystemUtil instance].m_sDeviceID];
//    [self setData:CLIENT_IP         value:[CommonUtil GetIPAddress]];
//    [self setData:MEDIA_CODE_CONN value:[SystemUtil instance].m_sAppCode];
//    [self setData:MEDIA_CODE_ORDER value:[SystemUtil instance].m_sMediaCD];
//    [self setData:MAC_ADDRESS value:[SystemUtil instance].m_sMacAddress];
//    [self setData:PUSH_ID_HEX value:[SystemUtil instance].m_sAppHexCode];
//    [self setData:PUSH_ID_HEX value:[SystemUtil instance].m_sAppHexCode];
//
//
//    NSString *sDN = [CommonUtil getStringForKey:USER_CERT_DN basic:@""];
//    [self setData:USER_CERT_DN value:sDN];
////    self.m_sOrganicCD = HANTOO_ORGANIC;
////    self.m_sEMPDEPT = HANTOO_EMP_DEPT;
//
//    if ([SystemUtil getAppMaintVersion] > 0)
//        [self setData:TEST_MODE     value:@"1"];
//
//    [self setData:OS_TYPE            value:@"2"];
//    [self setData:OS_VERSION        value:[CommonUtil getDeviceOS]];    // OS Version
//
//
//    NSString * sValue = [NSString stringWithFormat:@"%d", [[SystemUtil instance] isIPhoneX]];
//    [self setData:OS_IPHONE_X        value:sValue];    // OS Version
}

-(void)setSessionInfo
{
}

- (void)resetLoginData
{
}


- (void) setData : (NSString *)sKey value:(NSString *)value
{
	if( m_mapSharedData == nil ) return;
    if (value == nil)
        return;
    
	[m_mapSharedData setObject : value forKey:sKey];
}

- (NSString *) getData : (NSString *)sKey
{
	if( m_mapSharedData == nil )  return NULL_DATA;
	
    // 통신상태 
    if( [sKey isEqualToString:CONN_STATE] )
    {
        return [SystemUtil getconnectState]; 
    }

	NSString *sValue = [m_mapSharedData objectForKey:sKey];
	return sValue == nil ? NULL_DATA : sValue;
}

- (NSString *) getData : (NSString *)sKey basic:(NSString *)sBasic
{
    if([CommonUtil isEmptyString:sBasic])
        sBasic = NULL_DATA;
    
    if( m_mapSharedData == nil )  return sBasic;
    
    // 통신상태
    if( [sKey isEqualToString:CONN_STATE] )
    {
        return [SystemUtil getconnectState];
    }
    
    NSString *sValue = [m_mapSharedData objectForKey:sKey];
    return sValue == nil ? sBasic : sValue;
}

- (void) setLastIntrGroupKey:(NSString *)value
{
	[self setData:GWANSIM_GROUP value:value];
	// 앱 종료후 재실행 후에 사용하기 위해 저장한다.
	[CommonUtil setStringWithKey:value key:GWANSIM_GROUP];
}

- (NSString *) getDataClear : (NSString *)sKey isClear:(BOOL)bClear
{	
	if(m_mapSharedData == nil) return NULL_DATA;
	
	NSString *sValue = [m_mapSharedData objectForKey:sKey];

    if ([sKey isEqualToString:CONN_STATE]) {
        sValue = [SystemUtil getconnectState];
    }

	if( bClear )
		[m_mapSharedData removeObjectForKey:sKey];

    return sValue == nil ? NULL_DATA : sValue;
}


- (NSString *) getOrderPwd
{   
	return [self getData : ORDER_PWD];
}

- (BOOL) isOrderPwdCorrect
{	
	NSString *sValue = [self getData : ORDER_PWD_CONFIRM];
	return [sValue isEqualToString : @"1"];
}

- (void) setOrderPwdCorrect : (BOOL)bCorrect
{
	[self setData : ORDER_PWD_CONFIRM value:bCorrect == true ? @"1" : NULL_DATA];
}




@end
