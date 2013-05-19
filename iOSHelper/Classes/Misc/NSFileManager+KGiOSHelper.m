//
//  NSFileManager+KGiOSHelper.m
//  iOSHelper
//
//  Created by kampfgnu on 4/30/12.
//  Copyright (c) 2012 NOUS. All rights reserved.
//

#import "NSFileManager+KGiOSHelper.h"

#import "KGDefines.h"

#import "sys/xattr.h"

@implementation NSFileManager (KGiOSHelper)

+ (NSString *)documentsNoBackupDirectoryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *noBackupDir = [documentsDir stringByAppendingPathComponent:KGNoBackupDirectory];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:noBackupDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:noBackupDir withIntermediateDirectories:NO attributes:nil error:nil];
        u_int8_t b = 1;
        setxattr([noBackupDir fileSystemRepresentation], "com.apple.MobileBackup", &b, 1, 0, 0);
    }
    
    return noBackupDir;
}

+ (BOOL)writeDataToNoBackupDirectory:(NSData *)data filename:(NSString *)filename {
    if (data != nil) {
        NSString *filepath = [[self documentsNoBackupDirectoryPath] stringByAppendingPathComponent:filename];
        return [data writeToFile:filepath atomically:NO];
    }
    else return NO;
}

+ (BOOL)fileExistsAtNoBackupDirectory:(NSString *)filename {
    NSString *filepath = [[self documentsNoBackupDirectoryPath] stringByAppendingPathComponent:filename];
    return [[NSFileManager defaultManager] fileExistsAtPath:filepath];
}

+ (NSData *)dataInNoBackupDirectoryWithFilename:(NSString *)filename {
    NSString *filepath = [[self documentsNoBackupDirectoryPath] stringByAppendingPathComponent:filename];
    return [NSData dataWithContentsOfFile:filepath];
}

@end
