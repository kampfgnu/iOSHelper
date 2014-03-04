//
//  KGMimeTypes.h
//  iOSHelper
//
//  Created by kampfgnu on 8/22/12.
//  Copyright (c) 2012 NOUS. All rights reserved.
//

@interface KGMimeTypes : NSObject

typedef enum {
    KGMimeTypeAudio,
    KGMimeTypeVideo,
    KGMimeTypeImage,
    KGMimeTypeApplication,
    KGMimeTypeText,
    KGMimeTypeOther,
    KGMimeTypeUnknown
} KGMimeType;

+ (NSString *)fileExtensionForMimeType:(NSString *)mimeType;
+ (NSString *)mimeTypeForFileExtension:(NSString *)fileExtension;

+ (KGMimeType)mimeTypeOfMimeType:(NSString *)mimeType;

@end