//
//  NSData+Additions.h
//  Encoder
//
//  Created by Matt Long on 3/1/12.
//  Copyright (c) 2012 Skye Road Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSData (Additions)

- (NSString*)ga_digest;
+ (NSData*)base64DataFromString:(NSString*)string;
- (NSString*)base64String;
- (NSString*)base64StringOfLength:(unsigned long)length;

@end
