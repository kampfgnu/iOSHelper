//
//  KGDeviceInfo.m
//  iOSHelper
//
//  Created by Thomas Heingärtner on 17/12/13.
//  Copyright (c) 2013 NOUS. All rights reserved.
//

#import "KGDeviceInfo.h"

#include <sys/sysctl.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation KGDeviceInfo

+ (NSString *)ipAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

+ (NSString *)hardwarePlatform {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    return platform;
}

+ (NSString *)appVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (BOOL)isTablet {
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

+ (NSString *)systemName {
    return [UIDevice currentDevice].systemName;
}

+ (NSString *)iosVersion {
    return [UIDevice currentDevice].systemVersion;
}

+ (NSString *)vendorId {
    return [[UIDevice currentDevice].identifierForVendor UUIDString];
}

+ (NSString *)model {
    return [UIDevice currentDevice].model;
}

+ (BOOL)isCrappy {
    static BOOL isCrappyDevice = YES;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BOOL isSimulator = NO;
        BOOL isIPad2 = ([KGDeviceInfo isTablet] && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]);
        BOOL hasRetina = [[UIScreen mainScreen] scale] > 1.f;
        
#if TARGET_IPHONE_SIMULATOR
        isSimulator = YES;
#endif
        if (isIPad2 || hasRetina || isSimulator) {
            isCrappyDevice = NO;
        }
    });
    
    return isCrappyDevice;
}

+ (BOOL)isSimulator {
#if TARGET_IPHONE_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

+ (BOOL)hasFourInchDisplay {
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568.f);
}

+ (void)printAll {
    NSLog(@"ipaddress: %@, hardwarePlatform: %@, appVersion: %@, isTablet: %i, systemName: %@, iosVersion: %@, vendorId: %@, model: %@, isCrappy: %i, isSimulator: %i, hasFourInchDisplay %i", [self ipAddress], [self hardwarePlatform], [self appVersion], [self isTablet], [self systemName], [self iosVersion], [self vendorId], [self model], [KGDeviceInfo isCrappy], [KGDeviceInfo isSimulator], [KGDeviceInfo hasFourInchDisplay]);
}

@end
