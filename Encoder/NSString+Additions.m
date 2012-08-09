//
//  NSString+Additions.m
//  Encoder
//
//  Created by Matt Long on 3/1/12.
//  Copyright (c) 2012 Skye Road Systems, Inc. All rights reserved.
//

#import "NSString+Additions.h"

static char base64EncodingTable[64] = {
  'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
  'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
  'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
  'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};

@implementation NSString (Additions)

- (NSString*)numericOnly
{
  NSMutableString *strippedString = [[NSMutableString alloc] init];
  for (int i=0; i<[self length]; i++) {
    if (isdigit([self characterAtIndex:i])) {
      [strippedString appendFormat:@"%c",[self characterAtIndex:i]];
    }
  }
  return strippedString;
}

- (NSString*)numericOrDecimal
{
  NSMutableString *strippedString = [[NSMutableString alloc] init];
  for (int i=0; i<[self length]; i++) {
    if (isdigit([self characterAtIndex:i]) || [self characterAtIndex:i] == '.') {
      [strippedString appendFormat:@"%c",[self characterAtIndex:i]];
    }
  }
  return strippedString;
}

- (NSString*)ga_digest
{
  const char *cstr = [self cStringUsingEncoding:NSASCIIStringEncoding];
  return [[NSData dataWithBytes:cstr length:strlen(cstr)] ga_digest];
}

- (NSString*)ga_urlencoded
{
  NSString * encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                          NULL,
                                                                                          (__bridge CFStringRef)self,
                                                                                          NULL,
                                                                                          (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                          kCFStringEncodingUTF8 );
  return encodedString;
}

+ (NSString*)base64StringFromData:(NSData*)data
{
  return [self base64StringFromData:data length:[data length]];
}

+ (NSString*)base64StringFromData:(NSData*)data length:(unsigned long)length
{
  unsigned long ixtext, lentext;
  long ctremaining;
  unsigned char input[3], output[4];
  short i, charsonline = 0, ctcopy;
  const unsigned char *raw;
  NSMutableString *result;
  
  lentext = [data length];
  if (lentext < 1)
    return @"";
  result = [NSMutableString stringWithCapacity: lentext];
  raw = [data bytes];
  ixtext = 0;
  
  while (true) {
    ctremaining = lentext - ixtext;
    if (ctremaining <= 0)
      break;
    for (i = 0; i < 3; i++) {
      unsigned long ix = ixtext + i;
      if (ix < lentext)
        input[i] = raw[ix];
      else
        input[i] = 0;
    }
    output[0] = (input[0] & 0xFC) >> 2;
    output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
    output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
    output[3] = input[2] & 0x3F;
    ctcopy = 4;
    switch (ctremaining) {
      case 1:
        ctcopy = 2;
        break;
      case 2:
        ctcopy = 3;
        break;
    }
    
    for (i = 0; i < ctcopy; i++)
      [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
    
    for (i = ctcopy; i < 4; i++)
      [result appendString: @"="];
    
    ixtext += 3;
    charsonline += 4;
    
    if ((length > 0) && (charsonline >= length))
      charsonline = 0;
  }
  return result;
}

- (NSData*)base64Data
{
  unsigned long ixtext, lentext;
  unsigned char ch, inbuf[4], outbuf[3];
  short i, ixinbuf;
  Boolean flignore, flendtext = false;
  const unsigned char *tempcstring;
  NSMutableData *theData;
  
  if (self == nil)
  {
    return [NSData data];
  }
  
  ixtext = 0;
  
  tempcstring = (const unsigned char *)[self UTF8String];
  
  lentext = [self length];
  
  theData = [NSMutableData dataWithCapacity: lentext];
  
  ixinbuf = 0;
  
  while (true)
  {
    if (ixtext >= lentext)
    {
      break;
    }
    
    ch = tempcstring [ixtext++];
    
    flignore = false;
    
    if ((ch >= 'A') && (ch <= 'Z'))
    {
      ch = ch - 'A';
    }
    else if ((ch >= 'a') && (ch <= 'z'))
    {
      ch = ch - 'a' + 26;
    }
    else if ((ch >= '0') && (ch <= '9'))
    {
      ch = ch - '0' + 52;
    }
    else if (ch == '+')
    {
      ch = 62;
    }
    else if (ch == '=')
    {
      flendtext = true;
    }
    else if (ch == '/')
    {
      ch = 63;
    }
    else
    {
      flignore = true;
    }
    
    if (!flignore)
    {
      short ctcharsinbuf = 3;
      Boolean flbreak = false;
      
      if (flendtext)
      {
        if (ixinbuf == 0)
        {
          break;
        }
        
        if ((ixinbuf == 1) || (ixinbuf == 2))
        {
          ctcharsinbuf = 1;
        }
        else
        {
          ctcharsinbuf = 2;
        }
        
        ixinbuf = 3;
        
        flbreak = true;
      }
      
      inbuf [ixinbuf++] = ch;
      
      if (ixinbuf == 4)
      {
        ixinbuf = 0;
        
        outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
        outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
        outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
        
        for (i = 0; i < ctcharsinbuf; i++)
        {
          [theData appendBytes: &outbuf[i] length: 1];
        }
      }
      
      if (flbreak)
      {
        break;
      }
    }
  }
  
  return theData;
}


@end
