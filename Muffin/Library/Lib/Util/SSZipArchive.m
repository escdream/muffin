//
//  SSZipArchive.m
//  SSZipArchive
//
//  Created by Sam Soffes on 7/21/10.
//  Copyright Sam Soffes 2010. All rights reserved.
//

#import "SSZipArchive.h"
#include "minizip/zip.h"
#include "minizip/unzip.h"
#import "zlib.h"
#import "zconf.h"

#define CHUNK 16384

@interface SSZipArchive (PrivateMethods)
+ (NSDate *)_dateFor1980;
@end

@implementation SSZipArchive {
	NSString *_path;
	NSString *_filename;
    zipFile _zip;
}

+ (BOOL)unzipFileAtPath:(NSString *)path toDestination:(NSString *)destination {
	return [self unzipFileAtPath:path toDestination:destination overwrite:YES password:nil error:nil];
}

+ (BOOL)unzipFileAtPath:(NSString *)path toDestination:(NSString *)destination overwrite:(BOOL)overwrite password:(NSString *)password error:(NSError **)error {
	// Begin opening
	zipFile zip = unzOpen((const char*)[path UTF8String]);	
	if (zip == NULL) {
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"failed to open zip file" forKey:NSLocalizedDescriptionKey];
		if (error) {
			*error = [NSError errorWithDomain:@"SSZipArchiveErrorDomain" code:-1 userInfo:userInfo];
		}
		return NO;
	}
	
	unz_global_info  globalInfo = {0};
	unzGetGlobalInfo(zip, &globalInfo);
	
	// Begin unzipping
	if (unzGoToFirstFile(zip) != UNZ_OK) {
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"failed to open first file in zip file" forKey:NSLocalizedDescriptionKey];
		if (error) {
			*error = [NSError errorWithDomain:@"SSZipArchiveErrorDomain" code:-2 userInfo:userInfo];
		}
		return NO;
	}
	
	BOOL success = YES;
	int ret;
	unsigned char buffer[4096] = {0};
	NSFileManager *fileManager = [NSFileManager defaultManager];
//	NSDate *nineteenEighty = [self _dateFor1980];
	
	do {
		if ([password length] == 0) {
			ret = unzOpenCurrentFile(zip);
		} else {
			ret = unzOpenCurrentFilePassword(zip, [password cStringUsingEncoding:NSASCIIStringEncoding]);
		}
		
		if (ret != UNZ_OK) {
			success = NO;
			break;
		}
		
		// Reading data and write to file
		int read;
		unz_file_info fileInfo = {0};
		ret = unzGetCurrentFileInfo(zip, &fileInfo, NULL, 0, NULL, 0, NULL, 0);
		if (ret != UNZ_OK) {
			success = NO;
			unzCloseCurrentFile(zip);
			break;
		}
		
		char *filename = (char *)malloc(fileInfo.size_filename + 1);
		unzGetCurrentFileInfo(zip, &fileInfo, filename, fileInfo.size_filename + 1, NULL, 0, NULL, 0);
		filename[fileInfo.size_filename] = '\0';
		
		// Check if it contains directory
		NSString *strPath = [NSString stringWithCString:filename encoding:NSUTF8StringEncoding];
		BOOL isDirectory = NO;
		if (filename[fileInfo.size_filename-1] == '/' || filename[fileInfo.size_filename-1] == '\\') {
			isDirectory = YES;
		}
		free(filename);
		
		// Contains a path
		if ([strPath rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"/\\"]].location != NSNotFound) {
			strPath = [strPath stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
		}
		
        
//        NSString * stemp = [strPath lastPathComponent];
        
		NSString* fullPath = [destination stringByAppendingPathComponent:[strPath lastPathComponent]];
		
		if (isDirectory) {
			[fileManager createDirectoryAtPath:fullPath withIntermediateDirectories:YES attributes:nil error:nil];
		} else {
			[fileManager createDirectoryAtPath:[fullPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
		}
		
		if ([fileManager fileExistsAtPath:fullPath] && !isDirectory && !overwrite) {
			unzCloseCurrentFile(zip);
			ret = unzGoToNextFile(zip);
			continue;
		}
		
		FILE *fp = fopen((const char*)[fullPath UTF8String], "wb");
		while (fp) {
			read = unzReadCurrentFile(zip, buffer, 4096);

			if (read > 0) {
				fwrite(buffer, read, 1, fp );
			} else {
				break;
			}
		}
		
		if (fp) {
			fclose(fp);
			
			// Set the original datetime property
            NSDictionary *dict = [fileManager attributesOfItemAtPath:path error:nil];
            NSDate *modifyDate = [dict objectForKey:NSFileModificationDate];
			NSDictionary *attr = [NSDictionary dictionaryWithObject:modifyDate forKey:NSFileModificationDate];
			if (attr) {
				if ([fileManager setAttributes:attr ofItemAtPath:fullPath error:nil] == NO) {
					// Can't set attributes 
					// NSLog(@"Failed to set attributes");
				}
			}
		}
		
		unzCloseCurrentFile( zip );
		ret = unzGoToNextFile( zip );
	} while(ret == UNZ_OK && UNZ_OK != UNZ_END_OF_LIST_OF_FILE);
	
	// Close
	unzClose(zip);
	
	return success;
}



+ (BOOL)unzipDataAtPath:(NSString *)path toMutableData:(NSMutableData *)destination
{
	return [self unzipDataAtPath:path toMutableData:destination password:nil error:nil];
}

+ (BOOL)unzipDataAtPath:(NSString *)path toMutableData:(NSMutableData *)destination password:(NSString *)password error:(NSError **)error {
	// Begin opening
	//zipFile zip = unzOpen2((const char*)[path UTF8String], nil, 1);
    zipFile zip = unzOpen((const char*)[path UTF8String]);
	if (zip == NULL) {
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"failed to open zip file" forKey:NSLocalizedDescriptionKey];
		if (error) {
			*error = [NSError errorWithDomain:@"SSZipArchiveErrorDomain" code:-1 userInfo:userInfo];
		}
		return NO;
	}
	
	unz_global_info  globalInfo = {0};
	unzGetGlobalInfo(zip, &globalInfo);
	
	// Begin unzipping
	if (unzGoToFirstFile(zip) != UNZ_OK) {
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"failed to open first file in zip file" forKey:NSLocalizedDescriptionKey];
		if (error) {
			*error = [NSError errorWithDomain:@"SSZipArchiveErrorDomain" code:-2 userInfo:userInfo];
		}
		return NO;
	}
	
	BOOL success = YES;
	int ret;
	
	do {
		if ([password length] == 0) {
			//ret = unzOpenCurrentFile(zip);
            ret = unzOpenCurrentFile3(zip, NULL, NULL, 0, NULL,1);// 암호화 추가로 인한 파라메터 추가 및 함수 직접호출로 수정 - cory 2012.02.23
		} else {
			ret = unzOpenCurrentFilePassword(zip, [password cStringUsingEncoding:NSASCIIStringEncoding]);
		}
		
		if (ret != UNZ_OK) {
			success = NO;
			break;
		}
		
		// Reading data and write to file
//		int read;
		unz_file_info fileInfo = {0};
		ret = unzGetCurrentFileInfo(zip, &fileInfo, NULL, 0, NULL, 0, NULL, 0);
		if (ret != UNZ_OK) {
			success = NO;
			unzCloseCurrentFile(zip);
			break;
		}
		
		char *filename = (char *)malloc(fileInfo.size_filename + 1);
		unzGetCurrentFileInfo(zip, &fileInfo, filename, fileInfo.size_filename + 1, NULL, 0, NULL, 0);
		filename[fileInfo.size_filename] = '\0';
		
		// Check if it contains directory
//		NSString *strPath = [NSString stringWithCString:filename encoding:NSUTF8StringEncoding];
//		BOOL isDirectory = NO;
//		if (filename[fileInfo.size_filename-1] == '/' || filename[fileInfo.size_filename-1] == '\\') {
//			isDirectory = YES;
//		}
		free(filename);
		
		// Contains a path
//		if ([strPath rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"/\\"]].location != NSNotFound) {
//			strPath = [strPath stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
//		}
        //////////////////////////////////////////////////////
        int read = 0;
        unsigned char buffer[4096] = {0};
        while (1)
        {
        	read = unzReadCurrentFile(zip, buffer, 4096);
              
        	if (read > 0)
                [destination appendData:[NSData dataWithBytes:buffer length:read]];
            else
                break;
        }
        
		unzCloseCurrentFile( zip );
		ret = unzGoToNextFile( zip );

	} while(ret == UNZ_OK && UNZ_OK != UNZ_END_OF_LIST_OF_FILE);
	
	// Close
	unzClose(zip);
	
	return success;
}


#pragma mark - Zipping

+ (BOOL)createZipFileAtPath:(NSString *)path withFilesAtPaths:(NSArray *)paths basePath:(NSString *)basePath
{
	BOOL success = NO;
	SSZipArchive *zipArchive = [[SSZipArchive alloc] initWithPath:path];
	if ([zipArchive open]) {
		for (NSString *path in paths) {
			[zipArchive writeFile:path basePath:basePath];
		}
		success = [zipArchive close];
	}
	return success;
}


- (id)initWithPath:(NSString *)path {
	if ((self = [super init])) {
		_path = [path copy];
	}
	return self;
}


- (void)dealloc {
}


- (BOOL)open {
	NSAssert((_zip == NULL), @"Attempting open an archive which is already open");
	_zip = zipOpen([_path UTF8String], APPEND_STATUS_CREATE);
	return (NULL != _zip);
}


- (void)zipInfo:(zip_fileinfo*)zipInfo setDate:(NSDate*)date
{
    NSCalendar* currCalendar = [NSCalendar currentCalendar];
    uint flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents* dc = [currCalendar components:flags fromDate:date];
    zipInfo->tmz_date.tm_sec = (uInt)[dc second];
    zipInfo->tmz_date.tm_min = (uInt)[dc minute];
    zipInfo->tmz_date.tm_hour = (uInt)[dc hour];
    zipInfo->tmz_date.tm_mday = (uInt)[dc day];
    zipInfo->tmz_date.tm_mon = (uInt)[dc month] - 1;
    zipInfo->tmz_date.tm_year = (uInt)[dc year];
}


- (BOOL)writeFile:(NSString *)path basePath:(NSString *)basePath
{
	NSAssert((_zip != NULL), @"Attempting to write to an archive which was never opened");
	
    NSString *sFullPath = [basePath stringByAppendingString:path];
	FILE *input = fopen([sFullPath UTF8String], "r");
	if (NULL == input) {
		return NO;
	}
	
	zipOpenNewFileInZip(_zip, [path UTF8String], NULL, NULL, 0, NULL, 0, NULL, Z_DEFLATED,
						Z_DEFAULT_COMPRESSION);
	
	void *buffer = malloc(CHUNK);
	unsigned int len = 0;
	while (!feof(input)) {
		len = (unsigned int) fread(buffer, 1, CHUNK, input);
		zipWriteInFileInZip(_zip, buffer, len);
	}
	
	zipCloseFileInZip(_zip);
	free(buffer);
	return YES;
}


- (BOOL)writeData:(NSData *)data filename:(NSString *)filename {
    if (!_zip) {
		return NO;
    }
    if (!data) {
		return NO;
    }
    zip_fileinfo zipInfo = {0};
    [self zipInfo:&zipInfo setDate:[NSDate date]];
	
	zipOpenNewFileInZip(_zip, [filename UTF8String], &zipInfo, NULL, 0, NULL, 0, NULL, Z_DEFLATED, Z_DEFAULT_COMPRESSION);
	
    zipWriteInFileInZip(_zip, data.bytes, (uint)data.length);
	
	zipCloseFileInZip(_zip);
	return YES;
}

- (BOOL)close {
	NSAssert((_zip != NULL), @"Attempting to close an archive which was never opened");
	zipClose(_zip, NULL);
	return YES;
}

#pragma mark - Private

+ (NSDate *)_dateFor1980 {
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setDay:1];
	[comps setMonth:1];
	[comps setYear:1980];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDate *date = [gregorian dateFromComponents:comps];

	return date;
}

@end
