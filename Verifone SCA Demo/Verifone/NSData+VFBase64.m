//
//  NSData+Base64.m
//  PointSample
//
//  Copyright (c) 2014 VeriFone. All rights reserved.
//

#import "NSData+VFBase64.h"

static const char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation NSData (VFBase64)

- (NSString *)vfbase64String {
    const unsigned char * objRawData = [self bytes];
    char * objPointer;
    char * strResult;

    // Get the raw data length and ensure we actually have data
    int intLength = (int)[self length];
    if (intLength == 0) return nil;

    // Setup the string based result placeholder and pointer within that placeholder
    strResult = (char *)calloc(((intLength + 2) / 3) * 4, sizeof(char));
    objPointer = strResult;

    // Iterate through everything
    while (intLength > 2) { // Keep going until we have less than 24 bits
        *objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
        *objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
        *objPointer++ = _base64EncodingTable[((objRawData[1] & 0x0f) << 2) + (objRawData[2] >> 6)];
        *objPointer++ = _base64EncodingTable[objRawData[2] & 0x3f];

        // We just handled 3 octets (24 bits) of data
        objRawData += 3;
        intLength -= 3;
    }

    // Now deal with the tail end of things
    if (intLength != 0) {
        *objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
        if (intLength > 1) {
            *objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
            *objPointer++ = _base64EncodingTable[(objRawData[1] & 0x0f) << 2];
            *objPointer++ = '=';
        } else {
            *objPointer++ = _base64EncodingTable[(objRawData[0] & 0x03) << 4];
            *objPointer++ = '=';
            *objPointer++ = '=';
        }
    }

    // Terminate the string-based result
    *objPointer = '\0';

    NSString *resultString = [NSString stringWithCString:strResult encoding:NSASCIIStringEncoding];
    free(strResult);

    // Return the results as an NSString object
    return resultString;
}

@end
