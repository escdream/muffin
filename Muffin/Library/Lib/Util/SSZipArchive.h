//
//  SSZipArchive.h
//  SSZipArchive
//
//  Created by Sam Soffes on 7/21/10.
//  Copyright Sam Soffes 2010. All rights reserved.
//
//  Based on ZipArchive by aish
//  http://code.google.com/p/ziparchive
//

#import <Foundation/Foundation.h>

@interface SSZipArchive : NSObject

+ (BOOL)unzipFileAtPath:(NSString *)path toDestination:(NSString *)destination;
+ (BOOL)unzipFileAtPath:(NSString *)path toDestination:(NSString *)destination overwrite:(BOOL)overwrite password:(NSString *)password error:(NSError **)error;

+ (BOOL)unzipDataAtPath:(NSString *)path toMutableData:(NSMutableData *)destination;
+ (BOOL)unzipDataAtPath:(NSString *)path toMutableData:(NSMutableData *)destination password:(NSString *)password error:(NSError **)error;

// Zip
+ (BOOL)createZipFileAtPath:(NSString *)path withFilesAtPaths:(NSArray *)filenames  basePath:(NSString *)basePath;

- (id)initWithPath:(NSString *)path;
- (BOOL)open;
- (BOOL)writeFile:(NSString *)path basePath:(NSString *)basePath;
- (BOOL)writeData:(NSData *)data filename:(NSString *)filename;
- (BOOL)close;

@end
