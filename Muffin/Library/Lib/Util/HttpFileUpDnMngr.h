//
//  HttpFileUpDnMngr.h
//  StdDevCore
//
//  Created by BerdoMac on 2015. 2. 9..
//  Copyright (c) 2015년 DWENC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormManager.h"
#import "HttpRequestMng.h"

#define REQTYPE_POST 				0
#define REQTYPE_GETDIRECT 			1
#define REQTYPE_GETLINK 			2

/**
 * @interface HttpFileReqItem
 * @breif Http File Request Item
 * @auther Berdo(JaeWoong-Seok)[EMail:berdo_seok@naver.com]
 * @date 2015. 2. 6.
 */
@interface HttpFileReqItem : NSObject

@property(nonatomic, strong) NSString* m_sReqURL;
@property(nonatomic, strong) FormManager* m_oReqFormMngr;
@property(nonatomic, strong) NSString* m_sSaveLocalPath;
@property(nonatomic, strong) NSString* m_sDefFileName;
@property(nonatomic, strong) NSString* m_sResponse;

@end

/**
 * @interface HttpFileUpDnMngr
 * @breif Http File Upload Down Manager
 *
 * Singleton Pattern
 *
 * @auther Berdo(JaeWoong-Seok)[EMail:berdo_seok@naver.com]
 * @date 2015. 2. 6.
 */
@interface HttpFileUpDnMngr : NSObject <HttpRequestMngDelegate>
{
	NSMutableDictionary* m_mapReqDNList;
	NSMutableDictionary* m_mapReqUpList;
    BOOL                 m_bViewer;
}

+ (HttpFileUpDnMngr*) getInstance;
+ (void) releaseInstance;

- (void) requestHttpFile:(BOOL)bUp sReqURL:(NSString*)sReqURL nType:(int)nType sAddPostValue:(NSString*)sAddPostValue bAddForce:(BOOL)bAddForce oReqFormMngr:(FormManager*)oReqFormMngr bViewer:(BOOL)bViewer;

@end
