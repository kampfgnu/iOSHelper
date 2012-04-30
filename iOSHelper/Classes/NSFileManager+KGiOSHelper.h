//
//  NSFileManager+KGiOSHelper.h
//  iOSHelper
//
//  Created by kampfgnu on 4/30/12.
//  Copyright (c) 2012 NOUS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (KGiOSHelper)

+ (NSString *)documentsNoBackupDirectoryPath;
+ (BOOL)writeDataToNoBackupDirectory:(NSData *)data filename:(NSString *)filename;
+ (BOOL)fileExistsAtNoBackupDirectory:(NSString *)filename;

@end
