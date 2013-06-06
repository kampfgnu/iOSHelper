//
//  NSFileManager+KGiOSHelper.m
//  iOSHelper
//
//  Created by kampfgnu on 4/30/12.
//  Copyright (c) 2012 NOUS. All rights reserved.
//

#import "NSFileManager+KGiOSHelper.h"

#import "sys/xattr.h"

#define KGNoBackupDirectory @"NoBackup"

@implementation NSFileManager (KGiOSHelper)

+ (NSString *)documentsNoBackupDirectoryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *noBackupDir = [documentsDir stringByAppendingPathComponent:KGNoBackupDirectory];
    
    NSFileManager *fileManager = [NSFileManager new];
    if (![fileManager fileExistsAtPath:noBackupDir]) {
        [fileManager createDirectoryAtPath:noBackupDir withIntermediateDirectories:YES attributes:nil error:nil];
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
    return [[NSFileManager new] fileExistsAtPath:filepath];
}

+ (NSData *)dataInNoBackupDirectoryWithFilename:(NSString *)filename {
    NSString *filepath = [[self documentsNoBackupDirectoryPath] stringByAppendingPathComponent:filename];
    return [NSData dataWithContentsOfFile:filepath];
}

+ (void)createPathIfNotExists:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager new];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+ (BOOL)isPDF:(NSString *)filePath {
	BOOL state = NO;
	if (filePath != nil) {
		const char *path = [filePath fileSystemRepresentation];
		int fd = open(path, O_RDONLY); // Open the file
        
        // We have a valid file descriptor
		if (fd > 0) {
			const char sig[1024]; // File signature buffer
			ssize_t len = read(fd, (void *)&sig, sizeof(sig));
			state = (strnstr(sig, "%PDF", len) != NULL);
			close(fd); // Close the file
		}
	}
    
	return state;
}

+ (BOOL)deleteFileAtPath:(NSString *)path {
    return [[NSFileManager new] removeItemAtPath:path error:nil];
}

@end
