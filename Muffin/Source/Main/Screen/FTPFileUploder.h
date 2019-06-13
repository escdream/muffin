//
//  FTPFileUploder.h
//  Muffin
//
//  Created by JoonHo Kang on 30/05/2019.
//  Copyright © 2019 ESCapeDREAM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FTPFileUploder;

@protocol FTPFileUploaderDelegate <NSObject>

@optional
- (void) UploadProcess:(FTPFileUploder *) FileUploader nState:(int)nState sMessage:(NSString *) sMessage;
@end





@interface FTPFileUploder : NSObject <NSStreamDelegate>

@property (nonatomic, strong, readwrite) NSInputStream *fileStream;
@property (nonatomic, strong, readwrite) NSOutputStream *networkStream;
@property (nonatomic, assign, readonly) NSUInteger networkOperationCount;
@property (nonatomic, assign, readwrite) size_t bufferOffset;
@property (nonatomic, assign, readwrite) size_t bufferLimit;
@property (nonatomic, assign, readonly) uint8_t *buffer;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *process;

@property (nonatomic, strong) id<FTPFileUploaderDelegate> delegate;


@property (nonatomic, strong) NSString * ftpUrl;
@property (nonatomic, strong) NSString * ftpUserName;
@property (nonatomic, strong) NSString * ftpUserPassword;


- (void) upload:(NSString *) sPath;

@end

NS_ASSUME_NONNULL_END
