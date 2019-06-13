//
//  HttpFileUpDnMngr.m
//  StdDevCore
//
//  Created by BerdoMac on 2015. 2. 9..
//  Copyright (c) 2015년 DWENC. All rights reserved.
//

#import "HttpFileUpDnMngr.h"
#import "HttpRequestMng.h"
#import "CommonFileUtil.h"

@implementation HttpFileReqItem

@synthesize m_sDefFileName, m_oReqFormMngr, m_sReqURL, m_sResponse, m_sSaveLocalPath;

-(id)init
{
	self = [super init];
	if(self != nil)
	{
		self.m_sDefFileName = @"";
		self.m_sReqURL = @"";
		self.m_sResponse = @"";
		self.m_sSaveLocalPath = @"";
		self.m_oReqFormMngr = nil;
	}
	
	return self;
}

-(void)dealloc
{
	
}

@end

@implementation HttpFileUpDnMngr

static HttpFileUpDnMngr* selfobject = nil;

+(HttpFileUpDnMngr*)getInstance
{
	if(selfobject == nil)
	{
		@synchronized(self)
		{
			if (selfobject == nil)
				selfobject = [[self alloc] init];
			
		}
	}
	
	return selfobject;
}

+(void)releaseInstance
{
	if(selfobject != nil)
	{
		@synchronized(self)
		{
			if(selfobject != nil)
			{
				selfobject = nil;
			}
		}
	}
}

-(id)init
{
	self = [super init];
	if(self != nil)
	{
		m_mapReqDNList = [[NSMutableDictionary alloc] init];
		m_mapReqUpList = [[NSMutableDictionary alloc] init];
        m_bViewer = TRUE;
	}
	
	return self;
}

-(void)dealloc
{
	
}

/**
 * @breif Http File Request
 * @param BOOL bUp 					// Up = true, Down = false
 * @param NSString* sReqURL 		// Full URL
 * @param int nType 				// 0 : Post 1: Get(Direct) 2: Get(Link)
 * @param NSString* sAddPostValue	// nType 0: Add Post Value 2:(Link) fileName
 * @param BOOL bAddForce			// Request First!!
 * @param FormManager* oReqFormMngr // Return FormManager
 * @return None
 * @auther Berdo(JaeWoong-Seok)[EMail:berdo_seok@naver.com]
 * @date 2015. 2. 6.
 */
- (void) requestHttpFile:(BOOL)bUp sReqURL:(NSString*)sReqURL nType:(int)nType sAddPostValue:(NSString*)sAddPostValue bAddForce:(BOOL)bAddForce oReqFormMngr:(FormManager*)oReqFormMngr bViewer:(BOOL)bViewer
{
	if(bUp)
	{
		HttpFileReqItem *newItem = [[HttpFileReqItem alloc] init];
		newItem.m_sReqURL = sReqURL;
		newItem.m_oReqFormMngr = oReqFormMngr;
		
		NSString* sServiceType = @"";
		NSMutableString* sAddValue = [[NSMutableString alloc] init];
		
		[sAddValue appendFormat:@"%@", sReqURL];
		
		switch (nType)
		{
			case REQTYPE_POST:
				sServiceType = @"POSTUP";
				[sAddValue appendString:@"@@Connection`Keep-Alive"];
				[sAddValue appendString:@"@@Content-Type`multipart/form-data; boundary=---------------------------7d13a23b368"];
				break;
//			case REQTYPE_GETDIRECT:
//			case REQTYPE_GETLINK:
//				sServiceType = @"GETUP";
				break;
		}
		
		if (sAddPostValue != nil && ![sAddPostValue isEqualToString:@""])
		{
			[sAddValue appendString:@"@@"];
			[sAddValue appendString:sAddPostValue];
		}
		
		[m_mapReqUpList setObject:newItem forKey:sReqURL];
        [newItem.m_oReqFormMngr addWaitCursor];
		
		[[HttpRequestMng getInstance] RequestData:sServiceType strData:sAddValue strEncoding:@"utf-8" strPageType:@"json" delegate:self timeInterval:30.0f];
	}
	else
	{
		HttpFileReqItem *newItem = [[HttpFileReqItem alloc] init];
		newItem.m_sReqURL = sReqURL;
		newItem.m_oReqFormMngr = oReqFormMngr;
		
		NSString* sServiceType = @"";
		NSMutableString* sAddValue = [[NSMutableString alloc] init];
		
		[sAddValue appendFormat:@"%@", sReqURL];
		
		switch (nType)
		{
			case REQTYPE_POST:
				sServiceType = @"POSTDOWN";
				break;
			case REQTYPE_GETDIRECT:
			case REQTYPE_GETLINK:
				sServiceType = @"GETDOWN";
				break;
		}
		
		if (sAddPostValue != nil && ![sAddPostValue isEqualToString:@""])
		{
			[sAddValue appendString:@"@@"];
			[sAddValue appendString:sAddPostValue];
		}
		
		[m_mapReqDNList setObject:newItem forKey:sReqURL];
        [newItem.m_oReqFormMngr addWaitCursor];
		
		BOOL bRet = [[HttpRequestMng getInstance] RequestData:sServiceType strData:sAddValue strEncoding:@"utf-8" strPageType:@"json" delegate:self timeInterval:30.0f];
        if (!bRet) [newItem.m_oReqFormMngr removeWaitCursor];
	}
    
    m_bViewer = bViewer;
}

/**
 * @breif process Send Event FormManager
 * @param BOOL bUp
 * @param NSString* sSuccess
 * @param NSString* sMessage
 * @param NSString* sReqURL
 * @param NSString* sRetInfoExt
 * @param FormManager* sendForm
 * @return None
 * @auther Berdo(JaeWoong-Seok[EMail:berdo_seok@naver.com]
 * @date 2015-02-09
 */
- (void) processSendEventFormManager:(BOOL)bUp sSuccess:(NSString*)sSuccess sMessage:(NSString*)sMessage sReqURL:(NSString*)sReqURL sRetInfoExt:(NSString*)sRetInfoExt sendForm:(FormManager*)sendForm
{
	NSMutableDictionary* mapRet = [[NSMutableDictionary alloc] init];
	
	[mapRet setObject:sSuccess forKey:@"success"];
	[mapRet setObject:sMessage forKey:@"message"];
	[mapRet setObject:sReqURL forKey:@"requrl"];
	
    sRetInfoExt = [sRetInfoExt stringByReplacingOccurrencesOfString:@"\r\n" withString:NULL_DATA];
	
	if (bUp)
		[mapRet setObject:sRetInfoExt forKey:@"retvalue"];
	else
		[mapRet setObject:sRetInfoExt forKey:@"savepath"];
	
    [sendForm removeWaitCursor];
	[CommonUtil performSelector2:@selector(processEventHttpFile:mapParam:) target:sendForm withObject:bUp?@"TRUE":@"FALSE" anotherObject:mapRet];
}

#pragma mark - Http Delegate
-(void) onHttpPageDownloadFinished:(BOOL)bAsync bSucces:(BOOL)bSucces strResponse:(NSString*)strResponse strPageType:(NSString*)strPageType strReqURL:(NSString*)strReqURL;
{
	
}

-(void) onHttpPageUploadFinished:(BOOL)bAsync bSucces:(BOOL)bSucces strResponse:(NSString*)strResponse strPageType:(NSString*)strPageType strReqURL:(NSString*)strReqURL
{
    HttpFileReqItem* recvItem = [[m_mapReqUpList objectForKey:strReqURL] copy];
    [m_mapReqUpList removeObjectForKey:strReqURL];
//    NSLog(@"################## start recvItem string Count : %d", recvItem.retainCount);
	if (recvItem == nil) return;
	
	// 업로드 리턴은 페이지 데이터 형태로 받을때에는 이 이벤트로 처리됨. -by Berdo 2015-02-09
	if(bSucces)
	{
		recvItem.m_sResponse = strResponse;
		
		[self processSendEventFormManager:NO sSuccess:@"UP_S" sMessage:@"업로드 성공" sReqURL:strReqURL sRetInfoExt:recvItem.m_sResponse sendForm:recvItem.m_oReqFormMngr];
	}
	else
	{
		[self processSendEventFormManager:NO sSuccess:@"UP_F" sMessage:@"업로드 실패" sReqURL:strReqURL sRetInfoExt:recvItem.m_sResponse sendForm:recvItem.m_oReqFormMngr];
	}
	
//	[m_mapReqUpList removeObjectForKey:strReqURL];
//    NSLog(@"################## end recvItem string Count : %d", recvItem.retainCount);
}

-(void) onHttpFileDownloadFinished:(BOOL)bAsync bSucces:(BOOL)bSucces szResponse:(NSData*)szResponse strPageType:(NSString*)strPageType reqURL:(ITGHTTPFileRequest*)reqURL
{
	HttpFileReqItem *recvItem = [m_mapReqDNList objectForKey:reqURL.URL];
	
	if (recvItem == nil) return;
	
	
	if( [recvItem.m_oReqFormMngr getFormState] == STATE_CLOSE || [recvItem.m_oReqFormMngr getFormState] == STATE_DESTROY )
	{
		// 엄한 자식에게 떤지다 죽는 경우 막기
		[m_mapReqDNList removeObjectForKey:reqURL.URL];
		return;
	}
	
	if(bSucces)
	{
		NSString* sFileName = nil;
		
		if (recvItem.m_sDefFileName == nil || [recvItem.m_sDefFileName isEqualToString:@""])
        {
            if (reqURL.m_sAddValue == nil || [reqURL.m_sAddValue isEqualToString:@""])
                sFileName = [CommonFileUtil getOnlyFileName:reqURL.URL bUseUUID:YES];
            else
                sFileName = reqURL.m_sAddValue;
        }
		else
			sFileName = recvItem.m_sDefFileName;
		
		if (m_bViewer)
		recvItem.m_sSaveLocalPath = [NSString stringWithFormat:@"%@%@", FOLDER_TEMP, sFileName];
        else
            recvItem.m_sSaveLocalPath = [NSString stringWithFormat:@"%@%@", FOLDER_DOWNLOAD, sFileName];
		
		if([CommonFileUtil saveFile:recvItem.m_sSaveLocalPath data:szResponse])
		{
    NSLog(@"(ITGHTTPFileRequest) file download success : %@", sFileName);
			[self processSendEventFormManager:NO sSuccess:@"DN_S" sMessage:@"다운로드 성공" sReqURL:reqURL.URL sRetInfoExt:recvItem.m_sSaveLocalPath sendForm:recvItem.m_oReqFormMngr];
		}
		else
		{
			[self processSendEventFormManager:NO sSuccess:@"DN_F" sMessage:@"파일저장 실패" sReqURL:reqURL.URL sRetInfoExt:recvItem.m_sSaveLocalPath sendForm:recvItem.m_oReqFormMngr];
		}
	}
	else
	{
		[self processSendEventFormManager:NO sSuccess:@"DN_F" sMessage:@"다운로드 실패" sReqURL:reqURL.URL sRetInfoExt:recvItem.m_sSaveLocalPath sendForm:recvItem.m_oReqFormMngr];
	}
	
	[m_mapReqDNList removeObjectForKey:reqURL.URL];
}

-(void) onHttpFileUploadFinished:(BOOL)bAsync bSucces:(BOOL)bSucces szResponse:(NSData*)szResponse strPageType:(NSString*)strPageType strReqURL:(NSString*)strReqURL
{
	
}

//-(void)onHttpDownloadFinished:(BOOL)bAsync bSucces:(BOOL)bSucces strDownloadFile:(NSString*)strDownloadFile strPageType:(NSString*)strPageType strReqURL:(NSString*)strReqURL
//{
//	if(bSucces)
//	{
//		NSLog(@"Http Success[%@][^%@^]", strReqURL, strDownloadFile);
//		if([strPageType isEqualToString:@"json"])
//		{
//			NSData* recvData = [[[NSData alloc] initWithBytes:[strDownloadFile UTF8String] length:strlen([strDownloadFile UTF8String])] autorelease];
//			
//			[NetSession receiveProcess:PROC_RECEIVED_DATA_JSON recvData:recvData recvSize:(int)[recvData length]];
//		}
//		else if([strPageType isEqualToString:@"xml"])
//		{
//			//			m_HttpRecXmlData = [[TBXML alloc] initWithXMLString:strDownloadFile];
//			//
//			//			[m_oFormMngr fireEvent:@"DATAMANAGER" event:@"OnHttpRequestReceive" paramType:@"SSSS" paramValue:[NSString stringWithFormat:@"<<TRUE>><<%@>>><<%@>><<%@>>", strPageType, strReqURL, strDownloadFile]];
//		}
//	}
//	else
//	{
//		NSLog(@"Http Error[%@][^%@^]", strReqURL, strDownloadFile);
//		if ([strPageType isEqualToString:@"json"])
//		{
//			NSString* sErrorData = @"{\"json\":[{\"trcode\":\"\",\"rqid\":\"\",\"targetsvr\":\"\",\"lang\":\"KR\",\"nextflag\":\"L\",\"nextkey\":\"\",\"msgcode\":\"404\",\"msg\":\"Page가 존재하지 않습니다.\"}]}";
//			
//			NSData* szErrData = [[[NSData alloc] initWithBytes:[sErrorData UTF8String] length:strlen([sErrorData UTF8String])] autorelease];
//			
//			[NetSession receiveProcess:PROC_RECEIVED_DATA_JSON recvData:szErrData recvSize:(int)[szErrData length]];
//		}
//	}
//}
//
//-(void) onHttpuploading:(int)nType strURL:(NSString*)strURL nRecvDataLen:(int)nRecvDataLen strMsg:(NSString*)strMsg strResponse:(NSString*)strResponse strReqPageType:(NSString*)strReqPageType
//{
//	
//}


@end
