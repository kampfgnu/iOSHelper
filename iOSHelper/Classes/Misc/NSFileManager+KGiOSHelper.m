//
//  NSFileManager+KGiOSHelper.m
//  iOSHelper
//
//  Created by kampfgnu on 4/30/12.
//  Copyright (c) 2012 NOUS. All rights reserved.
//

#import "NSFileManager+KGiOSHelper.h"
#import "KGMacros.h"

#import "sys/xattr.h"

#define KGNoBackupDirectory @".noBackup"

@implementation NSFileManager (KGiOSHelper)

+ (NSString *)documentsNoBackupDirectoryPath {
    BOOL useCacheDir = SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(@"5.0");
    BOOL setHidden = YES;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(useCacheDir ? NSCachesDirectory : NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *dir = [paths objectAtIndex:0];
    NSString *noBackupDir = [dir stringByAppendingPathComponent:KGNoBackupDirectory];
    NSURL *noBackupDirUrl = [NSURL fileURLWithPath:noBackupDir];
    
    NSFileManager *fileManager = [NSFileManager new];
    if (![fileManager fileExistsAtPath:noBackupDir]) {
        if ([fileManager createDirectoryAtPath:noBackupDir withIntermediateDirectories:YES attributes:nil error:nil]) {
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.1")) {
                BOOL success = [noBackupDirUrl setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:nil];
//                NSLog(@"success: %i", success);
            }
            else if (SYSTEM_VERSION_EQUAL_TO(@"5.0.1")) {
                const char* filePath = [[noBackupDirUrl path] fileSystemRepresentation];
                const char* attrName = "com.apple.MobileBackup";
                u_int8_t attrValue = 1;
                int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
//                NSLog(@"success: %i", result);
            }
        }
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
