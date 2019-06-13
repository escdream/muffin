//
//  FTPFileUploder.m
//  Muffin
//
//  Created by JoonHo Kang on 30/05/2019.
//  Copyright © 2019 ESCapeDREAM. All rights reserved.
//

#import "FTPFileUploder.h"
#include <CFNetwork/CFNetwork.h>

enum {
    kSendBufferSize = 32768
};


@implementation FTPFileUploder
{
    uint8_t _buffer[kSendBufferSize];
}

@synthesize process;
@synthesize fileStream;
@synthesize networkStream;
@synthesize bufferOffset;
@synthesize bufferLimit;
@synthesize buffer;


- (void) uploadFiles:(id)sender {
    
    [self sendProcessEvent:10000 sMessage:@"Upload Complete"];
    NSLog(@"Uploading Files");
    
    if (!self.isSending) {
        NSString *filePath;
        
        filePath = [[NSBundle mainBundle]pathForResource:@"App" ofType:@"ipa"];
        
        [self startSend:filePath];
    }
    else
        NSLog(@"Skipped");
}


- (void) upload:(NSString *) sPath;
{
    [self sendProcessEvent:10001 sMessage:@"Upload Start"];
    if (!self.isSending) {
        [self startSend:sPath];
    }
    else
    {
        [self sendProcessEvent:10002 sMessage:@"Uploading... is Skip"];
    }
}



- (void)startSend:(NSString *)filePath {
    BOOL success;
    NSURL *url;
    
    url = [NSURL URLWithString:_ftpUrl];
    
    success = (url != nil);
    
    if (success) {
        url = CFBridgingRelease(
                                CFURLCreateCopyAppendingPathComponent(NULL, (__bridge CFURLRef)url, (__bridge CFStringRef)[filePath lastPathComponent], false)
                                );
        success = (url != nil);
    }
    
    if (!success) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Invalid URL" message:@"Can not upload file." delegate:nil cancelButtonTitle:@"Okey" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        self.fileStream = [NSInputStream inputStreamWithFileAtPath:filePath];
        assert(self.fileStream != nil);
        
        [self.fileStream open];
        
        self.networkStream = CFBridgingRelease(
                                               CFWriteStreamCreateWithFTPURL(NULL, (__bridge CFURLRef)url)
                                               );
        
        success = [self.networkStream setProperty:_ftpUserName forKey:(id)kCFStreamPropertyFTPUserName];
        success = [self.networkStream setProperty:_ftpUserPassword forKey:(id)kCFStreamPropertyFTPPassword];
        
        self.networkStream.delegate = self;
        [self.networkStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.networkStream open];
    }
}


//Deletegate Events
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
#pragma unused(aStream)
    assert(aStream == self.networkStream);
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            NSLog(@"Opened connection");
            [self sendProcessEvent:10000 sMessage:@"Open Connection"];
        } break;
            
        case NSStreamEventHasBytesAvailable: {
            NSLog(@"NSStreamEventHasBytesAvailable");
        } break;
            
        case NSStreamEventHasSpaceAvailable: {
            NSLog(@"Sending");
            [self sendProcessEvent:20000 sMessage:@"Sending"];

            if (self.bufferOffset == self.bufferLimit) {
                NSInteger bytesRead;
                
                bytesRead = [self.fileStream read:self.buffer maxLength:kSendBufferSize];
                
                if (bytesRead == -1) {
                    NSLog(@"File read error");
                    [self sendProcessEvent:-10000 sMessage:@"File read Error"];

                    if (self.networkStream != nil) {
                        [self.networkStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                        self.networkStream.delegate = nil;
                        [self.networkStream close];
                        self.networkStream = nil;
                    }
                    if (self.fileStream != nil) {
                        [self.fileStream close];
                        self.fileStream = nil;
                    }
                }
                else if (bytesRead == 0) {
                    if (self.networkStream != nil) {
                        [self.networkStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                        self.networkStream.delegate = nil;
                        [self.networkStream close];
                        self.networkStream = nil;
                    }
                    if (self.fileStream != nil) {
                        [self.fileStream close];
                        self.fileStream = nil;
                    }
                    NSLog(@"Upload Complete");
                    [self sendProcessEvent:99999 sMessage:@"Upload Complete"];
                }
                else {
                    self.bufferOffset = 0;
                    self.bufferLimit  = bytesRead;
                }
            }
            
            if (self.bufferOffset != self.bufferLimit) {
                NSInteger bytesWritten;
                bytesWritten = [self.networkStream write:&self.buffer[self.bufferOffset] maxLength:self.bufferLimit - self.bufferOffset];
                assert(bytesWritten != 0);
                if (bytesWritten == -1) {
                    NSLog(@"Network Write Error");
                    
                    if (self.networkStream != nil) {
                        [self.networkStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                        self.networkStream.delegate = nil;
                        [self.networkStream close];
                        self.networkStream = nil;
                    }
                    if (self.fileStream != nil) {
                        [self.fileStream close];
                        self.fileStream = nil;
                    }
                }
                else {
                    self.bufferOffset += bytesWritten;
                }
            }
        } break;
            
        case NSStreamEventErrorOccurred: {
            [self sendProcessEvent:-10001 sMessage:@"File Open Error"];
            NSLog(@"Stream Open Error");
            
            if (self.networkStream != nil) {
                [self.networkStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                self.networkStream.delegate = nil;
                [self.networkStream close];
                self.networkStream = nil;
            }
            if (self.fileStream != nil) {
                [self.fileStream close];
                self.fileStream = nil;
            }
        } break;
            
        case NSStreamEventEndEncountered: {
        } break;
            
        default: {
            NSLog(@"Default Not found");
        } break;
    }
}


- (void) sendProcessEvent:(int) nState sMessage:(NSString *) sMessage
{
    if (_delegate)
    {
        if ([_delegate respondsToSelector:@selector(UploadProcess:nState:sMessage:)])
        {
            [_delegate UploadProcess:self nState:nState sMessage:sMessage];
        }
    }
}

//Code for uploading
- (BOOL)isSending {
    return (self.networkStream != nil);
}

- (uint8_t *)buffer {
    return self->_buffer;
}


@end
