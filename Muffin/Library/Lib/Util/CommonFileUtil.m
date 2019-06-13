//
//  CommonFileUtil.m
//

#import "CommonFileUtil.h"
#import "CommonDef.h"
#import "SSZipArchive.h"
#import "SystemUtil.h"
#import "OpenUDID.h"

#define	ZIP_FILE_EXT			@"zip"
#define NSEUCKREncoding             (0x80000000 + kCFStringEncodingDOSKorean)


@implementation CommonFileUtil


+ (BOOL) initMakeFolder
{
		// 맵 폴더 생성
	[CommonFileUtil makeFolderOnSD:FOLDER_SCREEN];
		// 시스템 폴더 생성
	[CommonFileUtil makeFolderOnSD:FOLDER_RESOURCE];
		// 이미지 폴더 생성
	[CommonFileUtil makeFolderOnSD:FOLDER_IMAGE];
		// 사운드 폴더 생성
	[CommonFileUtil makeFolderOnSD:FOLDER_SOUND];
		// 버전 폴더 생성
	[CommonFileUtil makeFolderOnSD:FOLDER_VERSION];
		// 사용자 폴더 생성
	[CommonFileUtil makeFolderOnSD:FOLDER_USER];
		// 임시 폴더 생성
	[CommonFileUtil makeFolderOnSD:FOLDER_TEMP];
		// html 폴더 생성
    
	[CommonFileUtil makeFolderOnSD:FOLDER_HTML];
    
    [CommonFileUtil makeFolderOnSD:FOLDER_LOG];
    // CSS 폴더
    [CommonFileUtil makeFolderOnSD:FOLDER_CSS];
    // 폰트 폴더
    [CommonFileUtil makeFolderOnSD:FOLDER_FONT];
	
	// 이미지 다운로드 경로 파일경로를 만들어 줘야 함. -by Berdo 2013-05-23
	[CommonFileUtil makeFolderOnSD:[NSString stringWithFormat:@"user/dnimage"]];
	
	return TRUE;
}

+ (void) deleteUpdateFolder
{
    // 사운드 폴더 생성
    [CommonFileUtil deleteContentsOnSD:FOLDER_SOUND];
    // 피커 폴더 삭제
    [CommonFileUtil deleteContentsOnSD:FOLDER_PICKER];
    // 버전 폴더 삭제
	[CommonFileUtil deleteContentsOnSD:FOLDER_VERSION];
    // 맵 폴더 삭제
	[CommonFileUtil deleteContentsOnSD:FOLDER_SCREEN];
    // 마스터 폴더 삭제
	[CommonFileUtil deleteContentsOnSD:FOLDER_MASTER];
    // HTML 폴더 삭제
    [CommonFileUtil deleteContentsOnSD:FOLDER_HTML];
	// 메세지 테이블 폴더 삭제
	[CommonFileUtil deleteContentsOnSD:FOLDER_TABLE];
    // 시스템 폴더 삭제
	[CommonFileUtil deleteContentsOnSD:FOLDER_RESOURCE];
    // CSS 폴더 삭제
    [CommonFileUtil deleteContentsOnSD:FOLDER_CSS];
    // 폰드 삭제
    [CommonFileUtil deleteContentsOnSD:FOLDER_FONT];
    // 임시 폴더 삭제
	[CommonFileUtil deleteContentsOnSD:FOLDER_TEMP];
}

+(NSString *) getScreenFilePath:(NSString *)sFileName
{
	return [self getResFilePath:FOLDER_SCREEN fileName:sFileName];
}
+(NSString *) getPickerFilePath:(NSString *)sFileName
{
    return [self getResFilePath:FOLDER_PICKER fileName:sFileName];
}

+(NSString *) getScreenFilePath:(NSString *)sFileName extension:(NSString *)sExtension
{
	return [self getResFilePath:FOLDER_SCREEN fileName:sFileName extension:sExtension];
}

+(NSString *) getMasterFilePath:(NSString *)sFileName
{
	return [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@", FOLDER_MASTER, sFileName]];	
}

+(NSString *) getSystemFilePath:(NSString *)sFileName
{
	return [self getResFilePath:FOLDER_RESOURCE fileName:sFileName];
}

+ (NSString*)getMasterFileTempPath:(NSString*)sFileName
{
    return [self getResFilePath:FOLDER_MASTER fileName:sFileName];
}

+(NSString *) getImageFilePath:(NSString *)sFileName
{
//	return [self getResFilePath:[NSString stringWithFormat:@"%@", FOLDER_THEME] fileName:sFileName];
	return [self getResFilePath:FOLDER_IMAGE fileName:sFileName];
}

+(NSString *) getImageFileDefaultPath:(NSString *)sFileName
{
//	return [self getResFilePath:[NSString stringWithFormat:@"%@", FOLDER_THEME] fileName:sFileName];
	return [self getResFilePath:FOLDER_IMAGE fileName:sFileName];
}

// escdream 2017.02.17
+(BOOL) getImageFileExist:(NSString *)sFileName
{
    return ([[NSFileManager defaultManager]fileExistsAtPath:[self getResFilePath:FOLDER_IMAGE fileName:sFileName]]);
}

+(NSString *) getUserFilePath:(NSString *)sFileName
{
	NSString *sRetFileName = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@", FOLDER_USER, sFileName]];
	return sRetFileName;
}

+ (NSString *)	getHtmlFilePath:(NSString *)sFileName
{
	return [self getResFilePath:FOLDER_HTML fileName:sFileName];
}

+ (NSString *)	getMsgTblFilePath:(NSString*)sFileName
{
	return [self getResFilePath:FOLDER_TABLE fileName:sFileName];
}

+(NSString *) getResFilePath:(NSString *)sSubPath fileName:(NSString *)sFileName
{
	NSString *sRetFileName = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@", sSubPath, sFileName]];
	if ([[NSFileManager defaultManager]fileExistsAtPath:sRetFileName])
	{
		return sRetFileName;
	}
	else
	{
		NSString *sNameOnly = [sFileName stringByDeletingPathExtension];
		NSString *sExtension = [sFileName pathExtension];
		sRetFileName = [[NSBundle mainBundle] pathForResource:sNameOnly ofType:sExtension inDirectory:sSubPath];
		
		return sRetFileName;
	}
}

+(NSString *) getResFilePath:(NSString *)sSubPath fileName:(NSString *)sFileName extension:(NSString *)sExtension
{
	NSString *sRetFileName = [[CommonFileUtil getDocumentPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@.%@", sSubPath, sFileName, sExtension]];
	if ([[NSFileManager defaultManager]fileExistsAtPath:sRetFileName])
	{
		return sRetFileName;
	}
	else
	{
		sRetFileName = [[NSBundle mainBundle] pathForResource:sFileName ofType:sExtension inDirectory:sSubPath];
		
		return sRetFileName;
	}
}

+(NSString *) getDocumentPath
{
    NSArray* arrayDocument = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
	return [arrayDocument objectAtIndex:0];
}

+(NSString *) getDocumentFilePath:(NSString *)sFileName
{
	NSString *sDocFileName = [NSString stringWithFormat:@"%@/%@", [self getDocumentPath], sFileName];	
	return sDocFileName;
}

+(BOOL) makeFolderOnSD:(NSString *)sSubPath
{
	NSString *sFolderName = [self getDocumentFilePath:sSubPath];	
	NSFileManager *fileManager = [NSFileManager defaultManager];

	BOOL bRet = [fileManager createDirectoryAtPath:sFolderName withIntermediateDirectories:TRUE attributes:nil error:nil];	
	return bRet;
}

+(void) deleteContentsOnSD:(NSString *)sSubPath
{
	NSString *sFolderName = [self getDocumentFilePath:sSubPath];	
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *arrContents = [fileManager contentsOfDirectoryAtPath:sFolderName error:nil];
    if( arrContents != nil && [arrContents count] > 0 )
    {
        for( NSString *sFileName in arrContents )
        {
            if( [sFileName hasPrefix:@"."] ) continue;
            NSString *sFullFileName = [NSString stringWithFormat:@"%@/%@", sFolderName, sFileName];
            [fileManager removeItemAtPath:sFullFileName error:nil];   
        }
    }
}

+(BOOL) saveFile:(NSString *)strFilePath data:(NSData *)data
{	
	NSString *sSaveFile = [self getDocumentFilePath:strFilePath];	

	NSString *sFolder = [strFilePath stringByDeletingLastPathComponent];
	if (![CommonFileUtil makeFolderOnSD:sFolder])
    {
        NSString *sError = [NSString stringWithFormat:@"%@ , 폴더를 만드는데 실패 하였습니다." , sSaveFile];
        NSLog(@"sError [%@]" , sError);
        return NO;
    }

	return [data writeToFile:sSaveFile atomically:FALSE];
}

/**
 @method    saveFile: fileString:
 @brief		파일저장
 @param		filePath : 파일경로
 @param		fileString : 저장할 문자열
 @return	없음
 @date		2013.09.23
 */
+(BOOL) saveFile:(NSString *)filePath fileString:(NSString *)fileString
{
	NSString *sSaveFile = [self getDocumentFilePath:filePath];
	
	NSString *sFolder = [filePath stringByDeletingLastPathComponent];
	[CommonFileUtil makeFolderOnSD:sFolder];
	
	return [fileString writeToFile:sSaveFile atomically:FALSE encoding:NSEUCKREncoding error:nil];
}

+(BOOL) moveFile:(NSString *)sFromFile toFile:(NSString *)sToFile
{
	NSString *sFolder = [sToFile stringByDeletingLastPathComponent];
	[CommonFileUtil makeFolderOnSD:sFolder];
	
	NSString *sFromFullPath = [self getDocumentFilePath:sFromFile];	
	NSString *sToFullPath = [self getDocumentFilePath:sToFile];	
	
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
	
    // 이전 파일이 남아있는 경우 삭제한다.
	if ([fileManager fileExistsAtPath:sToFullPath]) [fileManager removeItemAtPath:sToFullPath error:nil];
	
	BOOL isSuccess = [fileManager moveItemAtPath:sFromFullPath toPath:sToFullPath error:&error];
	if( isSuccess )
	{
		// 이전 파일이 남아있는 경우 삭제한다.
		if ([fileManager fileExistsAtPath:sFromFullPath]) [fileManager removeItemAtPath:sFromFullPath error:nil];
	}
    else
    {
        NSString *errMsg = [error localizedDescription];
        NSLog(@"VersionDownload File MoveError : %@", errMsg);
    }
    
    
    NSLog(@"download File %@", sToFile);
	return isSuccess;
}


+(BOOL) copyFile:(NSString *)sFromFile toFile:(NSString *)sToFile
{
    NSString *sFolder = [sToFile stringByDeletingLastPathComponent];
    [CommonFileUtil makeFolderOnSD:sFolder];
    
    NSString *sFromFullPath = [self getDocumentFilePath:sFromFile];
    NSString *sToFullPath = [self getDocumentFilePath:sToFile];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    BOOL isSuccess = [fileManager copyItemAtPath:sFromFullPath toPath:sToFullPath error:&error];
    if( isSuccess )
    {
        NSLog(@"copy File Success : %@", sToFile);
    }
    else
    {
        NSString *errMsg = [error localizedDescription];
        NSLog(@"copy File Error : %@", errMsg);
    }
    return isSuccess;
}

+ (BOOL) removeFile:(NSString *)sFile
{
	NSString *sFullPath = [self getDocumentFilePath:sFile];	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	return [fileManager removeItemAtPath:sFullPath error:nil];
}

+ (BOOL) removeAtPath:(NSString *)path
{
    if (path == nil) return NO;
    if ([path length] <= 0) return NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isdirectory = NO;
    if (![fileManager fileExistsAtPath:path]) return NO;
    if (![fileManager isDeletableFileAtPath:path]) 
    {
        NSLog(@"removeAtPath not deletable!!!");

        return NO;
    }
    
    @try
    {
        NSError *error = nil;
        if (!isdirectory) [fileManager removeItemAtPath:path error:&error];
    }
    @catch (NSException *e)
    {
        NSLog(@"removeAtPath error: %@", [e reason]);
        
        return NO;
    }
    
    return YES;
}

+ (NSString *)replaceNextStringInFile:(NSString *)filename target:(NSString*)target replace:(NSString *)replace length:(NSInteger)length
{
    NSString *string = @"";
    NSString *filepath = [self getDocumentFilePath:filename];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath] ) {
        NSData *data= [[NSFileManager defaultManager] contentsAtPath:filepath];
        NSString *fileData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSArray *fileArray = [fileData componentsSeparatedByString:target];
        if ([fileArray count] >= 2 ){
            NSString *str1 = [fileArray objectAtIndex:0];
            NSString *str2 = [[fileArray objectAtIndex:1] substringFromIndex:length];
            string = [[[str1 stringByAppendingString:target]stringByAppendingString:replace] stringByAppendingString:str2];
        }
    }else{
        NSLog(@"Not Found file:%@" , filename);
    }
    return string;
}


// 파일 압축 해제
+ (BOOL) unzipFile:(NSString *)strFilePath
{
	@try {
        strFilePath = [strFilePath stringByReplacingOccurrencesOfString:@"ZIP_FILE_EXT" withString:@""];
        
		NSString *sZipFileName = [NSString stringWithFormat:@"%@.%@", strFilePath, ZIP_FILE_EXT];	
		NSString *sFileContent = [self getDocumentFilePath:sZipFileName];		
		NSString *sDestFilePath = [sFileContent stringByDeletingLastPathComponent];	
		
		BOOL bRet = [SSZipArchive unzipFileAtPath:sFileContent toDestination:sDestFilePath];
		if( bRet == TRUE )
		{
//             NSLog(@"unzipFile Success: file path is:%@", sFileContent);
		}
		else
		{
             NSLog(@"Failure to unzipFile : %@", sFileContent);
		}
		
		[self removeFile:sZipFileName];
		
		return TRUE;
		
	} 
	@catch(NSException *exIO)
	{
		
	}
	
	return FALSE;
}

// 파일 압축 해제
+ (BOOL) unzipFile:(NSString *)strFilePath targetFolder:(NSString *)folder
{
	@try {
        NSString *sZipFileName = strFilePath;
        if( ![strFilePath hasSuffix:ZIP_FILE_EXT] )
            sZipFileName = [NSString stringWithFormat:@"%@.%@", strFilePath, ZIP_FILE_EXT];
		NSString *sFileContent = [self getDocumentFilePath:sZipFileName];
		NSString *sDestFilePath = [self getDocumentFilePath:folder];
		
		BOOL bRet = [SSZipArchive unzipFileAtPath:sFileContent toDestination:sDestFilePath];
		if( bRet == TRUE )
		{
			// NSLog(@"unzipFile Success: file path is:%@", sFileContent);
		}
		else
		{
			// NSLog(@"Failure to unzipFile : %@", sFileContent);
		}
		
        // 원본 압축 파일 삭제
		[self removeFile:sZipFileName];
		
		return TRUE;
		
	}
	@catch(NSException *exIO)
	{
		
	}
	
	return FALSE;
}

// 폴더 압축 
+ (BOOL) zipFolder:(NSString *)strFolder zipFile:(NSString *)strTargetFile
{
	@try {
		strFolder= [self getDocumentFilePath:strFolder];
		
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:strFolder];
		NSMutableArray *arrFiles = [[NSMutableArray alloc] init];
		
		NSString *file, *fullPath;
		while( (file = [dirEnum nextObject]) )
		{
			fullPath = [NSString stringWithFormat:@"%@%@", strFolder, file];
            BOOL isDir;
            if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir] && !isDir) {
                NSLog(@"zipFolder : %@", file);
                [arrFiles addObject:file];
            }
		}
		
		NSString *sDestFilePath = [self getDocumentFilePath:strTargetFile];
		
		BOOL bRet = [SSZipArchive createZipFileAtPath:sDestFilePath withFilesAtPaths:arrFiles basePath:strFolder];
		if( bRet == TRUE )
		{
		}
		else
		{
			NSLog(@"Failure to zipFolder : %@", strFolder);
		}
		
 		return TRUE;
		
	}
	@catch(NSException *exIO)
	{
		
	}
	
	return FALSE;
}

+ (BOOL) unzipDataWithPathByXMS:(NSString *)strFilePath toMutableData:(NSMutableData *)data
{
	@try {
		BOOL bRet = [SSZipArchive unzipDataAtPath:strFilePath toMutableData:data];
		if( bRet == TRUE )
		{
			// NSLog(@"unzipFile Success: file path is:%@", sFileContent);
			// 원본 압축 파일 삭제		
		}
		else
		{
			 NSLog(@"Failure to unzipFile : %@", strFilePath);
		}
		
		//[self removeFile:sZipFileName];
		
		return TRUE;
		
	} 
	@catch(NSException *exIO)
	{
		
	}
	
	return FALSE;
}

/**
 * @brief Get User Path
 * @param NSString* sFileName
 * @return NSString*
 * @author Berdo(JaeWoong-Seok)[EMail:berdo_seok@naver.com]
 * @date 2012-01-03
 */
+ (NSString *)getUserPath:(NSString *)sFileName
{
    NSString *sRetFileName = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@", FOLDER_USER, sFileName]];
    
    return sRetFileName;
}

/**
 * @brief Save Image File
 * @param UIImage* image        // image object
 * @param NSString* filename    // save filename
 * @param NSInterger type       // image type
 * @return NSString*            // return imagefile full path
 * @author Berdo(JaeWoong-Seok)[EMail:berdo_seok@naver.com]
 * @date 2012-01-18
 */
+ (NSString*)SaveImageFile:(UIImage*)image filename:(NSString*)filename type:(NSInteger)type
{
    NSData *imgdata = nil;
    
    switch (type)
    {
    case 0:         // PNG
        {
            imgdata = UIImagePNGRepresentation(image);
        }break;
    case 1:         // JPG
        {
            imgdata = UIImageJPEGRepresentation(image, 1.0);
        }break;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *strDocumentDirectory = [paths objectAtIndex:0];
    NSString *strfullPath = [strDocumentDirectory stringByAppendingPathComponent:filename];
    [fileManager createFileAtPath:strfullPath contents:imgdata attributes:nil];
    
    return strfullPath;
}

/**
 * @breif FileName Extract.
 * @param String sURLPath
 * @return String
 * @auther Berdo(JaeWoong-Seok)[EMail:berdo_seok@naver.com]
 * @date 2015. 2. 6.
 */
+ (NSString*) getOnlyFileName:(NSString*)sURLPath bUseUUID:(BOOL)bUseUUID
{
	NSString* sRet = @"";
	
	NSRange rangeFind =	[sURLPath rangeOfString:@"/" options:NSBackwardsSearch];
	
	if (rangeFind.location != NSNotFound)
	{
		NSString* sOnlyFileName = [sURLPath substringWithRange:NSMakeRange(rangeFind.location+1, [sURLPath length]-(rangeFind.location+1))];
		
		NSRange rangeDot = [sOnlyFileName rangeOfString:@"." options:NSBackwardsSearch];
		if (rangeDot.location != NSNotFound)
			sRet = sOnlyFileName;
		else
			sRet = [OpenUDID value];
	}
	else
	{
		if(bUseUUID)
			sRet = [OpenUDID value];
	}
	
	return sRet;
}

// ItgenStdDev
+ (void)setShareDataFile:(NSString*)fileName fileData:(NSDictionary*)data
{
	[data writeToFile:[self dataFilePath:fileName ] atomically:YES];
}


+ (NSMutableDictionary*)getShareDataFile:(NSString*)fileName
{
	
	//ST_DEBUG_LOG( @" 로드 완료 ======= " );
	
	NSString *filePath = [self dataFilePath:fileName];
	
	//ST_DEBUG_LOG( @"filePath %@ " , filePath );
	
	if( [[NSFileManager defaultManager]fileExistsAtPath:filePath] )
	{
		//ST_DEBUG_LOG( @" 찿았다.== " );
		
		NSMutableDictionary *data	= [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
		
		return data;
	}
	else
	{
		return NULL;
	}
	
	return NULL;
	
}

/*
 *	파일경로 반환
 */
+ (NSString *)dataFilePath:(NSString*)name
{
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	//ST_DEBUG_LOG( @" 파일 경로 %@ " , [documentsDirectory stringByAppendingPathComponent:name] );
	
	return [documentsDirectory stringByAppendingPathComponent:name];
	
}

/**
 * @breif get Version File Path
 * @param NSString* sFileName
 * @return NSString*
 * @auther Berdo(JaeWoong-Seok[EMail:berdo_seok@naver.com]
 * @date 2013-05-07
 */
+ (NSString *) getVersionFilePath:(NSString *)sFileName
{
//    NSString *sNameOnly = [sFileName stringByDeletingPathExtension];
//    NSString *sExtension = [sFileName pathExtension];
    return [self getResFilePath:FOLDER_VERSION fileName:sFileName];
//    return [self getResFilePath:FOLDER_VERSION fileName:sNameOnly extension:sExtension];
}

+(NSString *) getResVerFilePath:(NSString *)sSubPath fileName:(NSString *)sFileName
{
	NSString *sRetFileName = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@", sSubPath, sFileName]];
	if ([[NSFileManager defaultManager]fileExistsAtPath:sRetFileName])
	{
		return sRetFileName;
	}
	else
	{
		NSString *sNameOnly = [sFileName stringByDeletingPathExtension];
		NSString *sExtension = [sFileName pathExtension];
		sRetFileName = [[NSBundle mainBundle] pathForResource:sNameOnly ofType:sExtension inDirectory:sSubPath];
		
        NSLog(@"sSubPath = [%@][%@][%@][%@]", sNameOnly, sExtension, sSubPath, sRetFileName);
		
		return sRetFileName;
	}
}


+ (void) doFirstHtmlCopy
{
    NSString * resourcePath = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"html/" ];
    NSArray* resContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:resourcePath error:nil];//   contentsOfDirectoryAtPath:copyItemAtPath:@"/html"  error:NULL];
    NSString * destPath = [CommonFileUtil getHtmlFilePath:@"/"];
    if (destPath == nil)
    {
        [CommonFileUtil makeFolderOnSD:FOLDER_HTML];
        destPath = [CommonFileUtil getHtmlFilePath:@"/"];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    for (int i=0; i<resContents.count; i++){
        
        NSString* obj = resContents[i];
        NSError* error;
        NSString * srcFile = [NSString stringWithFormat:@"%@%@", resourcePath, obj];
        NSString * destFile = [NSString stringWithFormat:@"%@/%@", destPath, obj];
        
        if ([[destFile pathExtension] isEqualToString:@"html"]) continue;
        
        
        BOOL isSuccess = [fileManager copyItemAtPath:srcFile toPath:destFile error:&error];
        if( isSuccess )
        {
           // NSLog(@"copy File Success : %@ --> %@",srcFile, destFile);
        }
        else
        {
            NSString *errMsg = [error localizedDescription];
            NSLog(@"copy File Error : %@", errMsg);
        }
    }
}


@end

