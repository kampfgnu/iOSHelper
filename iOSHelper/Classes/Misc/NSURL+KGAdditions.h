//
//  NSURL+KGAdditions.h
//  iOSHelper
//
//  Created by Thomas Heingärtner on 6/13/13.
//  Copyright (c) 2013 NOUS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (KGAdditions)

- (NSString *)cacheKey;
- (NSString *)cacheKeyWithPrefix:(NSString *)prefix suffix:(NSString *)suffix;

@end
