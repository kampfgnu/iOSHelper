//
//  NSURL+KGAdditions.m
//  iOSHelper
//
//  Created by Thomas Heingärtner on 6/13/13.
//  Copyright (c) 2013 NOUS. All rights reserved.
//

#import "NSURL+KGAdditions.h"
#import <CommonCrypto/CommonDigest.h>

#define KGCacheKeyPrefix @"default_prefix"
#define KGCacheKeySuffix @"default_suffix"

@implementation NSURL (KGAdditions)

- (NSString *)cacheKey {
    return [self cacheKeyWithPrefix:KGCacheKeyPrefix suffix:KGCacheKeySuffix];
}

- (NSString *)cacheKeyWithPrefix:(NSString *)prefix suffix:(NSString *)suffix {
    const char *str = [self.absoluteString UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    
    if (prefix == nil) prefix = @"";
    if (suffix == nil) suffix = @"";
    
    return [NSString stringWithFormat:@"%@_%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%@",
            prefix, r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15], suffix];
}

@end
