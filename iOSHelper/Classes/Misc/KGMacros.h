//
//  KGMacros.h
//  iOSHelper
//
//  Created by Thomas Heingärtner on 6/6/13.
//  Copyright (c) 2013 NOUS. All rights reserved.
//

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define _(key)	NSLocalizedString(key, key)

// Use like this:
// + (id)sharedInstance {
//  KGDefineSingletonUsingBlock(^{
//    return [[self alloc] init];
//  });
// }
#define KGDefineSingletonUsingBlock(block) \
static dispatch_once_t pred; \
__strong static id sharedObject_ = nil; \
dispatch_once(&pred, ^{ sharedObject_ = block(); }); \
return sharedObject_;