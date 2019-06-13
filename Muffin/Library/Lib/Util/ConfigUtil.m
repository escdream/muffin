//
//  ConfigUtil.m
//  SmartVIGS
//
//

#import "ConfigUtil.h"
#import "CommonUtil.h"
#import "CommonFileUtil.h"
#import "NSDataAdditions.h"
#import "LinkData.h"

// 클라우드 사용 여부
#define	MAIN_COMMON_CLOUD			@"common.cloud"
// 클라우드
#define	CLOUD_COMMON_VERSION		@"common.cloud.version.common"
#define	CLOUD_MEDIA_VERSION			@"common.cloud.version.media"
#define	CLOUD_VERSION_ID			@"common.cloud.version.id"
#define	CLOUD_INTEREST_FIELDS		@"common.cloud.interest.fields"
#define	MAIN_COMMON_CLOUD_SETTING	@"common.cloud.setting"
#define	CONFIG_FILE_NAME			@"Config.dat"

@implementation ConfigUtil

+ (void) loadConfigFile
{
	@try
	{
		NSString *sFileName = [CommonFileUtil getUserFilePath:CONFIG_FILE_NAME];
		NSData *data = [NSData dataWithContentsOfFile:sFileName];
		if( data == nil ) return;
		NSString *sContents = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		
		for (NSString *component in [sContents componentsSeparatedByString:@"\n"])
		{
			NSArray *keyValue = [component componentsSeparatedByString:@"="];
			if( [keyValue count] != 2 ) continue;
			
			NSString *sKey = [keyValue objectAtIndex:0];
			NSString *sValue = [keyValue objectAtIndex:1];
			
			[CommonUtil setStringWithKey:sValue key:sKey];

/*			if( [sKey isEqualToString:k_common_start_screen] || [sKey isEqualToString:k_common_locationlock_use] || [sKey isEqualToString:k_common_locationlock_add1] ||
			   [sKey isEqualToString:k_common_locationlock_add2] || [sKey isEqualToString:k_common_locationlock_latitude1] || [sKey isEqualToString:k_common_locationlock_longtude1] ||
			   [sKey isEqualToString:k_common_locationlock_distance1] || [sKey isEqualToString:k_common_locationlock_latitude2] || [sKey isEqualToString:k_common_locationlock_longtude2] ||
			   [sKey isEqualToString:k_common_locationlock_distance2] || [sKey isEqualToString:k_common_locationlock_send] || [sKey isEqualToString:k_common_locationlock_phone] ||
			   [sKey isEqualToString:INTEREST_KOSPI_COLOR] || [sKey isEqualToString:INTEREST_KOSDAQ_COLOR] || [sKey isEqualToString:k_display_lock_password] )
			{
				[CommonUtil setStringWithKey:sValue key:sKey];
			}
			else if( [sKey isEqualToString:MAIN_COMMON_KEEPCERTLOGIN] || [sKey isEqualToString:MAIN_COMMON_RECVREAL] || [sKey isEqualToString:MAIN_COMMON_INQUIRY_LOGIN] ||
					[sKey isEqualToString:MAIN_COMMON_HOGA_INVERSE] || [sKey isEqualToString:MAIN_COMMON_FONTTYPE] || [sKey isEqualToString:MAIN_KEEP_ORDERPWD] ||
					[sKey isEqualToString:MAIN_COMMON_KEEPLIGHT] || [sKey isEqualToString:MAIN_ALRIM_CHEGYUL] || [sKey isEqualToString:PUSH_ALRIM] || [sKey isEqualToString:MAIN_ALRIM_MARKET] ||
					[sKey isEqualToString:MAIN_ORDER_CONFIRM] || [sKey isEqualToString:MAIN_ORDER_HORIZON] || [sKey isEqualToString:MAIN_ORDER_KEYPAD] || [sKey isEqualToString:INTEREST_QWAY] ||
					[sKey isEqualToString:INTEREST_DIRECT] || [sKey isEqualToString:INTEREST_KOSPI_BOLD] || [sKey isEqualToString:INTEREST_KOSDAQ_BOLD] ||
					[sKey isEqualToString:TICKER_ALRIM_KOSPI] || [sKey isEqualToString:TICKER_ALRIM_KOSDAQ] || [sKey isEqualToString:TICKER_ALRIM_KOSPI200] ||
					[sKey isEqualToString:TICKER_ALRIM_DOWJONES] || [sKey isEqualToString:TICKER_ALRIM_NASDAQ] || [sKey isEqualToString:TICKER_ALRIM_SNP] ||
					[sKey isEqualToString:TICKER_ALRIM_SNP_FUTURES] || [sKey isEqualToString:TICKER_ALRIM_NASDAQ_FUTURES] || [sKey isEqualToString:TICKER_ALRIM_NIKKEI] ||
					[sKey isEqualToString:TICKER_ALRIM_HONGKONGHANG] || [sKey isEqualToString:TICKER_ALRIM_HONGKONGH] || [sKey isEqualToString:TICKER_ALRIM_TAIWAN] ||
					[sKey isEqualToString:TICKER_ALRIM_SANGHAE] || [sKey isEqualToString:TICKER_ALRIM_SINGAPORE] || [sKey isEqualToString:TICKER_ALRIM_KOSPI_UNDER] ||
					[sKey isEqualToString:TICKER_ALRIM_KOSDAQ_UNDER] || [sKey isEqualToString:TICKER_ALRIM_KOSPI200_UNDER] || [sKey isEqualToString:TICKER_ALRIM_DOWJONES_UNDER] ||
					[sKey isEqualToString:TICKER_ALRIM_NASDAQ_UNDER] || [sKey isEqualToString:TICKER_ALRIM_SNP_UNDER] || [sKey isEqualToString:TICKER_ALRIM_SNP_FUTURES_UNDER] ||
					[sKey isEqualToString:TICKER_ALRIM_NASDAQ_FUTURES_UNDER] || [sKey isEqualToString:TICKER_ALRIM_NIKKEI_UNDER] ||
					[sKey isEqualToString:TICKER_ALRIM_HONGKONGHANG_UNDER] || [sKey isEqualToString:TICKER_ALRIM_HONGKONGH_UNDER] || [sKey isEqualToString:TICKER_ALRIM_TAIWAN_UNDER] ||
					[sKey isEqualToString:TICKER_ALRIM_SANGHAE_UNDER] || [sKey isEqualToString:TICKER_ALRIM_SINGAPORE_UNDER] || [sKey isEqualToString:ETC_DISPLAYLOCK_USE] )
			{
				if( [sValue isEqualToString:@"1"] || [sValue isEqualToString:@"true"] )
					[CommonUtil setBoolWithKey:true key:sKey];
				else
					[CommonUtil setBoolWithKey:false key:sKey];
			}
			else
			{
				[CommonUtil setStringWithKey:sVaue key:sKey];
			}
*/ 
		}
	}
	@catch(NSException *e)
	{
		NSLog(@"loadConfig Error : %@", [e reason]);
	}
	return;	
}

+ (void) saveConfigItem:(NSOutputStream *)stream key:(NSString*)sKey basic:(NSString *)sBasicValue
{
	NSString *sValue = [CommonUtil getStringForKey:sKey basic:sBasicValue];
	NSString *sData = [NSString stringWithFormat:@"%@=%@\n", sKey, sValue];
	NSData *data = [sData dataUsingEncoding:NSUTF8StringEncoding];
	[stream write:data.bytes maxLength:[data length]];
}

+ (void) saveConfigFile
{
	NSString *sFileName = [CommonFileUtil getUserFilePath:CONFIG_FILE_NAME];
	
	@try
	{
		NSOutputStream *outputStream = [NSOutputStream outputStreamToFileAtPath:sFileName append:NO];
		[outputStream open];
		
//		[self saveConfigItem:outputStream key:k_common_start_screen basic:@""];
//		[self saveConfigItem:outputStream key:k_common_recv_real basic:@""];
//		[self saveConfigItem:outputStream key:k_common_inquiry_login basic:@""];
//		[self saveConfigItem:outputStream key:k_common_hogarevcolor basic:@""];
//		[self saveConfigItem:outputStream key:k_common_auto_vaccine basic:@""];
//		[self saveConfigItem:outputStream key:k_common_fonttype basic:@""];
//		[self saveConfigItem:outputStream key:k_common_keep_pwd basic:@""];
//		[self saveConfigItem:outputStream key:k_common_keep_light basic:@""];
//		[self saveConfigItem:outputStream key:k_alrim_chegyul basic:@""];
//		[self saveConfigItem:outputStream key:k_alrim_push basic:@""];
//		[self saveConfigItem:outputStream key:k_alrim_market basic:@""];
//		[self saveConfigItem:outputStream key:k_alrim_vibrator basic:@""];
//		[self saveConfigItem:outputStream key:k_order_confirm basic:@""];
//		[self saveConfigItem:outputStream key:k_order_horizon_mode basic:@""];
//		[self saveConfigItem:outputStream key:k_maemae_order_keypad basic:@""];
//		[self saveConfigItem:outputStream key:k_common_select_qway basic:@""];
//		[self saveConfigItem:outputStream key:k_common_select_direct basic:@""];
//		[self saveConfigItem:outputStream key:k_common_locationlock_use basic:@""];
//		[self saveConfigItem:outputStream key:k_common_locationlock_add1 basic:@""];
//		[self saveConfigItem:outputStream key:k_common_locationlock_add2 basic:@""];
//		[self saveConfigItem:outputStream key:k_common_locationlock_latitude1 basic:@""];
//		[self saveConfigItem:outputStream key:k_common_locationlock_longtude1 basic:@""];
//		[self saveConfigItem:outputStream key:k_common_locationlock_distance1 basic:@""];
//		[self saveConfigItem:outputStream key:k_common_locationlock_latitude2 basic:@""];
//		[self saveConfigItem:outputStream key:k_common_locationlock_longtude2 basic:@""];
//		[self saveConfigItem:outputStream key:k_common_locationlock_distance2 basic:@""];
//		[self saveConfigItem:outputStream key:k_common_locationlock_send basic:@""];
//		[self saveConfigItem:outputStream key:k_common_locationlock_phone basic:@""];
//		[self saveConfigItem:outputStream key:k_common_kospi_color basic:@"183"];
//		[self saveConfigItem:outputStream key:k_common_kosdaq_color basic:@"183"];
//		[self saveConfigItem:outputStream key:k_common_kospi_bold basic:@""];
//		[self saveConfigItem:outputStream key:k_common_kosdaq_bold basic:@""];
//		[self saveConfigItem:outputStream key:k_jisu_kospi basic:@""];
//		[self saveConfigItem:outputStream key:k_jisu_kosdaq basic:@""];
//		[self saveConfigItem:outputStream key:k_jisu_kospi200 basic:@""];
//		[self saveConfigItem:outputStream key:k_jisu_dowjones basic:@""];
//		[self saveConfigItem:outputStream key:k_jisu_nasdaq basic:@""];
//		[self saveConfigItem:outputStream key:k_jisu_snp basic:@""];
//		[self saveConfigItem:outputStream key:k_jisu_snp_futures basic:@""];
//		[self saveConfigItem:outputStream key:k_jisu_nasdaq_future basic:@""];
//		[self saveConfigItem:outputStream key:k_jisu_nikkei basic:@""];
//		[self saveConfigItem:outputStream key:k_jisu_hongkonghang basic:@""];
//		[self saveConfigItem:outputStream key:k_jisu_hongkongh basic:@""];
//		[self saveConfigItem:outputStream key:k_jisu_taiwan basic:@""];
//		[self saveConfigItem:outputStream key:k_jisu_sanghae basic:@""];
//		[self saveConfigItem:outputStream key:k_jisu_singapore basic:@""];
//		[self saveConfigItem:outputStream key:k_jisu_under_kospi basic:@""];
//		[self saveConfigItem:outputStream key:k_jisu_under_kosdaq basic:@""];
//		[self saveConfigItem:outputStream key:k_jisu_under_kospi200 basic:@""];
//		[self saveConfigItem:outputStream key:k_jisu_under_dowjones basic:@""];
//		[self saveConfigItem:outputStream key:k_jisu_under_nasdaq basic:@""];
//		[self saveConfigItem:outputStream key:k_jisu_under_snp basic:@""];
//		[self saveConfigItem:outputStream key:k_jisu_under_snp_futures basic:@""];
//		[self saveConfigItem:outputStream key:k_jisu_under_nasdaq_future basic:@""];
//		[self saveConfigItem:outputStream key:k_jisu_under_nikkei basic:@""];
//		[self saveConfigItem:outputStream key:k_jisu_under_hongkonghang basic:@""];
//		[self saveConfigItem:outputStream key:k_jisu_under_hongkongh basic:@""];
//		[self saveConfigItem:outputStream key:k_jisu_under_taiwan basic:@""];
//		[self saveConfigItem:outputStream key:k_jisu_under_sanghae basic:@""];
//		[self saveConfigItem:outputStream key:k_jisu_under_singapore basic:@""];
//		[self saveConfigItem:outputStream key:k_display_use_lock basic:@""];
//		[self saveConfigItem:outputStream key:k_display_lock_password basic:@""];
					
		[outputStream close];
	}
	@catch (NSException *e)
	{
		NSLog(@"saveConfig Error : %@", [e reason]);
	}
}


+ (void) setCloudSetting
{
	[CommonUtil setBoolWithKey:true key:MAIN_COMMON_CLOUD_SETTING];
}

+ (BOOL) isCloudSetting
{
	return [CommonUtil getBoolForKey:MAIN_COMMON_CLOUD_SETTING basic:false];
}

+ (void) saveConfigData:(NSString*)sFileName sKeyName:(NSString*)sKeyName sValue:(NSString*)sValue
{
    NSString *sCofngiID = [[LinkData sharedLinkData] getData:USER_ID];
    sFileName = [sFileName stringByAppendingString:sCofngiID];
    NSMutableDictionary *dict = [CommonUtil getObjectForKey:sFileName];
    if (dict == nil)
    {
        dict = [[NSMutableDictionary alloc] init];
        [dict setValue:sValue forKey:sKeyName];
        [CommonUtil setObjectWithKey:dict key:sFileName];
    }
    else
    {
        [dict setValue:sValue forKey:sKeyName];
        [CommonUtil setObjectWithKey:dict key:sFileName];
    }
	
}

+ (NSString*) loadConfigData:(NSString*)sFileName sKeyName:(NSString*)sKeyName
{
    NSString *sCofngiID = [[LinkData sharedLinkData] getData:USER_ID];
    sFileName = [sFileName stringByAppendingString:sCofngiID];
    NSMutableDictionary *dict = [CommonUtil getObjectForKey:sFileName];
    if (dict == nil)
    {
        return @"";
    }
    else
    {
        NSString *sValue = [dict objectForKey:sKeyName];
        if( sValue == nil ) return @"";
        else                return sValue;
    }
	return @"";
}

@end
