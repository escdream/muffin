//
//  CommonFileUtil.h
//  SmartVIGS
//
//  Created by kanam on 11. 7. 31..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define	FOLDER_SCREEN		@"screen"
#define FOLDER_QRY			@"screen/qry"
#define FOLDER_PICKER       @"picker"
#define	FOLDER_RESOURCE		@"resource"
#define FOLDER_USERRES      @"resource/user"
#define	FOLDER_SOUND		@"sound"
#define FOLDER_HTML			@"html"
#define FOLDER_TABLE		@"tbl"
#define	FOLDER_MASTER		@"master"
#define	FOLDER_VERSION		@"version"
#define	FOLDER_USER			@"user"
#define	FOLDER_TEMP			@"temp"
#define FOLDER_DOWNLOAD     @"download"
#define FOLDER_DOC_TEMP     @"Document/download"
#define FOLDER_LOCAL        @"local"
#define FOLDER_LOG			@"log"
#define	FOLDER_IMAGE        @"image"
#define FOLDER_CSS          @"css"
#define FOLDER_FONT         @"font"
#define FOLDER_THEME_TG       @"@"
#define FOLDER_TEMPIMAGE_TG   @"tempimg@"

@interface CommonFileUtil : NSObject {

}
+ (NSString *)		getResFilePath:(NSString *)sSubPath fileName:(NSString *)sFileName;
+ (NSString *)		getResFilePath:(NSString *)sSubPath fileName:(NSString *)sFileName extension:(NSString *)sExtension;
+ (NSString *)		getScreenFilePath:(NSString *)sFileName;
+ (NSString *)		getScreenFilePath:(NSString *)sFileName extension:(NSString *)sExtension;
+ (NSString *)		getMasterFilePath:(NSString *)sFileName;
+ (NSString *)		getSystemFilePath:(NSString *)sFileName;
+ (NSString *)		getImageFilePath:(NSString *)sFileName;
+ (NSString *)		getImageFileDefaultPath:(NSString *)sFileName;
+ (NSString *)		getUserFilePath:(NSString *)sFileName;
+ (NSString *)		getHtmlFilePath:(NSString *)sFileName;
+ (NSString *)		getMsgTblFilePath:(NSString*)sFileName;
+ (NSString *)      getPickerFilePath:(NSString *)sFileName;


+(BOOL) getImageFileExist:(NSString *)sFileName;


+ (BOOL)			makeFolderOnSD:(NSString *)sSubPath;
+ (void)            deleteUpdateFolder;
+ (void)            deleteContentsOnSD:(NSString *)sSubPath;
+ (BOOL)			saveFile:(NSString *)strFilePath data:(NSData *)data;
+ (BOOL)			saveFile:(NSString *)filePath fileString:(NSString *)fileString;
+ (BOOL)			moveFile:(NSString *)sFromFile toFile:(NSString *)sToFile;
+ (BOOL)			copyFile:(NSString *)sFromFile toFile:(NSString *)sToFile;
+ (NSString *)		getDocumentFilePath:(NSString *)sFileName;
+ (NSString *)		getDocumentPath;
+ (BOOL)			unzipFile:(NSString *)strFilePath;
+ (BOOL)            unzipDataWithPathByXMS:(NSString *)strFilePath toMutableData:(NSMutableData *)data;
+ (BOOL)            unzipFile:(NSString *)strFilePath targetFolder:(NSString *)folder;
+ (BOOL)			zipFolder:(NSString *)strFolder zipFile:(NSString *)strTargetFile;
+ (BOOL)			initMakeFolder;
+ (NSString *)      getVersionFilePath:(NSString *)sFileName;
+ (BOOL) removeFile:(NSString *)sFile;
+ (NSString *)      replaceNextStringInFile:(NSString *)filename target:(NSString*)target replace:(NSString *)replace length:(NSInteger)length;
+ (NSString *)      getUserPath:(NSString *)sFileName;
+ (NSString *)      SaveImageFile:(UIImage*)image filename:(NSString*)filename type:(NSInteger)type;
+ (NSString*) getOnlyFileName:(NSString*)sURLPath bUseUUID:(BOOL)bUseUUID;


// 임시 처리 함수
+ (NSString*)getMasterFileTempPath:(NSString*)sFileName;

/*
 * 주어진 경로의 파일 삭제 2011/10/13
 */
+ (BOOL) removeAtPath:(NSString *)path;

//ItgenStdDev
+ (void)setShareDataFile:(NSString*)fileName fileData:(NSDictionary*)data;
+ (NSMutableDictionary*)getShareDataFile:(NSString*)fileName;
+ (NSString *)dataFilePath:(NSString*)name;
+ (void) doFirstHtmlCopy;
@end
