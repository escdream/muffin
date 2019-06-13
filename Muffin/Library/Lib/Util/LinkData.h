//
//  LinkData.h
//  SmartVIGS
//
//  Created by juyoung Kim on 11. 5. 2..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "LinkDataInfo.h"

#import <Foundation/Foundation.h>

@interface DATA_ITEM : NSObject <NSCoding>
{
	NSUInteger	sequence;           ///< 시퀀스 번호
	NSString*	market_type;        ///< S 펀드 D ELS 금융상품에서 만 사용하는 코드
	NSString*   markettext;         ///< 펀드 , ELS
	NSString*   value;              ///< 종목 코드
    NSString*   name;               ///< 이름
    NSString*   etcInfo;            ///< 기타 정보
}

@property (nonatomic, strong) NSString *markettext;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong, getter = getItemName , setter = setItemName:) NSString *name;
@property (nonatomic, strong, getter = getEtcInfo  , setter = setEtcInfo: ) NSString *etcInfo;


-(void)			setSequence    : (NSUInteger)seq;
-(NSUInteger)	getSequence;

-(void)			setMarketType : (NSString*)market;
-(NSString*)	getMarketType;

-(void)			setItemValue   : (NSString*)itemValue;
-(NSString*)	getItemValue;


@end

@interface LinkData : NSObject
{
	NSUInteger				m_nCount;
	NSMutableDictionary		*m_mapSharedData;
	NSMutableDictionary     *m_mapSharedMapData;
	NSDate					*m_timeBP;
    
    BOOL					m_bInitLoading;
	
	
	NSUInteger				ITEMCODE_MAX_COUNT;
	NSMutableArray			*m_arrHistory;
	NSMutableDictionary		*m_mapCodeData;
    
   
	NSString*              	m_sLastFOMarketType;
	NSUInteger              m_nCurMarketType;
    
    NSMutableArray * m_arrStockInvestDiary;
}

// class Method
+ (LinkData *)		sharedLinkData;
+ (void)             clean;

// method
- (id)				init;
- (void)			initProperty;
- (void)			dealloc;

- (void)			setData			   : (NSString *)sKey value:(NSString *)value;
- (NSString *)		getData			   : (NSString *)sKey;
- (NSString *)      getData            : (NSString *)sKey basic:(NSString *)sBasic;
- (NSString *)		getDataClear	   : (NSString *)sKey isClear:(BOOL)bClear;

- (void)            setSessionInfo;
- (void)            setSystemInfo;
- (void)            setMapData:(NSString*)sKey objMap:(NSMutableDictionary*)objMap;


@end
