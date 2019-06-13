//
//  NSData+AES.h
//  FranklinPlanner
//
//  Created by SPHENIX on 11. 6. 23..
//  Copyright 2011 sphenix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSData (NSData_AES)

/**
 * do AES encryption
 *
 * key:
 * iv: initial vector (if not nil: CBC mode / nil: ECB mode)
 */
- (NSData *) aesEncryptWithKey:(NSString *)key initialVector:(NSString *)vector;

/**
 * do AES decryption
 *
 * key:
 * iv: initial vector (if not nil: CBC mode / nil: ECB mode)
 */
- (NSData *) aesDecryptWithKey:(NSString *)key initialVector:(NSString *)vector;


// SannelLibaray 에 있는 함수를 옮겨옴
- (NSData *)AES128EncryptWithKey:(NSString *)key;
- (NSData *)AES128DecryptWithKey:(NSString *)key;

@end
