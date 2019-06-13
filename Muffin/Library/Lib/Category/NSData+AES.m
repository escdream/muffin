//
//  NSData+AES.m
//  FranklinPlanner
//
//  Created by SPHENIX on 11. 6. 23..
//  Copyright 2011 sphenix. All rights reserved.
//

#import "NSData+AES.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation NSData (AES128)

- (NSData *) aesEncryptWithKey:(NSString *)key initialVector:(NSString *)vector
{
    NSInteger keyLength = [key length];
    if (keyLength != kCCKeySizeAES128 && keyLength != kCCKeySizeAES192 && keyLength != kCCKeySizeAES256)
    {
        // NSLog(@"key length is not 128/192/256 bits");

        return nil;
    }
    
    // 벡터는 옵션이므로 사용하려면 상호간에 스트링 인코딩을 맞춰야 한다. 안맞추면 값 다름. 정 귀찮으면 사용하지 않으면 됨. 몰라서 개고생 함.
    NSInteger vecLength = [vector length];
    char vectorBytes[vecLength + 1];
    bzero(vectorBytes, sizeof(vectorBytes));
    [vector getCString:vectorBytes maxLength:sizeof(vectorBytes) encoding:NSUTF8StringEncoding];
    
    char keyBytes[keyLength + 1];
    bzero(keyBytes, sizeof(keyBytes));
    [key getCString:keyBytes maxLength:sizeof(keyBytes) encoding:NSUTF8StringEncoding];
    
    size_t numBytesEncrypted = 0;
    size_t encryptedLength = [self length] + kCCBlockSizeAES128;
    char* encryptedBytes = malloc(encryptedLength);
    
    CCCryptorStatus result = CCCrypt(kCCEncrypt, 
                                     kCCAlgorithmAES128 , 
                                     //default: CBC (when initial vector is supplied)
                                     (vector == nil ? kCCOptionECBMode | kCCOptionPKCS7Padding : kCCOptionPKCS7Padding), 
                                     keyBytes, 
                                     keyLength, 
                                     vectorBytes,
                                     [self bytes], 
                                     [self length],
                                     encryptedBytes, 
                                     encryptedLength,
                                     &numBytesEncrypted);
    
    if(result == kCCSuccess) return [NSData dataWithBytesNoCopy:encryptedBytes length:numBytesEncrypted];
    
    free(encryptedBytes);

    return nil;
}

- (NSData *) aesDecryptWithKey:(NSString *)key initialVector:(NSString *)vector
{
    if (key == nil) return nil;

    NSInteger  keyLength = [key length];
    if (keyLength != kCCKeySizeAES128 && keyLength != kCCKeySizeAES192 && keyLength != kCCKeySizeAES256)
    {
        // NSLog(@"key length is not 128/192/256 bits");

        return nil;
    }
    
    // 벡터는 옵션이므로 사용하려면 상호간에 스트링 인코딩을 맞춰야 한다. 안맞추면 값 다름. 정 귀찮으면 사용하지 않으면 됨. 몰라서 개고생 함.
    NSInteger  vecLength = [vector length];
    char vectorBytes[vecLength + 1];
    bzero(vectorBytes, sizeof(vectorBytes));
    [vector getCString:vectorBytes maxLength:sizeof(vectorBytes) encoding:NSUTF8StringEncoding];
    
    char keyBytes[keyLength+1];
    bzero(keyBytes, sizeof(keyBytes));
    [key getCString:keyBytes maxLength:sizeof(keyBytes) encoding:NSUTF8StringEncoding];
    
    size_t numBytesDecrypted = 0;
    size_t decryptedLength = [self length] + kCCBlockSizeAES128;
    char* decryptedBytes = malloc(decryptedLength);

    CCCryptorStatus result = CCCrypt(kCCDecrypt, 
                                     kCCAlgorithmAES128 , 
                                     //default: CBC (when initial vector is supplied)
                                     (vector == nil ? kCCOptionECBMode | kCCOptionPKCS7Padding : kCCOptionPKCS7Padding), 
                                     keyBytes, 
                                     keyLength, 
                                     vectorBytes,
                                     [self bytes], 
                                     [self length],
                                     decryptedBytes, 
                                     decryptedLength,
                                     &numBytesDecrypted);
    
    if(result == kCCSuccess) return [NSData dataWithBytesNoCopy:decryptedBytes length:numBytesDecrypted];

    free(decryptedBytes);

    return nil;
}

- (NSData *)AES128EncryptWithKey:(NSString *)key {
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES128+1]; // room for terminator (unused) // oorspronkelijk 256
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES128, // oorspronkelijk 256
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

- (NSData *)AES128DecryptWithKey:(NSString *)key {
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES128+1]; // room for terminator (unused) // oorspronkelijk 256
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES128, // oorspronkelijk 256
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}


@end
