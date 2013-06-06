//
//  NSFileManager+KGiOSHelper.h
//  iOSHelper
//
//  Created by kampfgnu on 4/30/12.
//  Copyright (c) 2012 NOUS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (KGiOSHelper)

+ (NSString *)documentsDirectoryPath;
+ (NSString *)cachesDirectoryPath;
+ (NSString *)documentsNoBackupDirectoryPath;
+ (BOOL)writeDataToNoBackupDirectory:(NSData *)data filename:(NSString *)filename;
+ (BOOL)fileExistsAtNoBackupDirectory:(NSString *)filename;
+ (NSData *)dataInNoBackupDirectoryWithFilename:(NSString *)filename;
+ (NSData *)dataAtPath:(NSString *)path;
+ (void)createPathIfNotExists:(NSString *)path;
+ (BOOL)isPDF:(NSString *)filePath;
+ (BOOL)deleteFileAtPath:(NSString *)path;

@end
