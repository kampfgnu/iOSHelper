//
//  KGDeviceInfo.h
//  iOSHelper
//
//  Created by Thomas Heingärtner on 17/12/13.
//  Copyright (c) 2013 NOUS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGDeviceInfo : NSObject

+ (NSString *)ipAddress;
+ (NSString *)hardwarePlatform;
+ (NSString *)appVersion;
+ (BOOL)isTablet;
+ (NSString *)iosVersion;
+ (NSString *)vendorId;
+ (NSString *)model;

+ (void)printAll;

@end
