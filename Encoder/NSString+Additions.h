//
//  NSString+Additions.h
//  Encoder
//
//  Created by Matt Long on 3/1/12.
//  Copyright (c) 2012 Skye Road Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

- (NSString*)numericOnly;
- (NSString*)numericOrDecimal;
- (NSString*)ga_digest;
- (NSString*)ga_urlencoded;
+ (NSString*)base64StringFromData:(NSData*)data length:(unsigned long)length;
+ (NSString*)base64StringFromData:(NSData *)data;
- (NSData*)base64Data;


@end
