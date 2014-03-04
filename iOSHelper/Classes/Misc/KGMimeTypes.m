//
//  KGMimeTypes.m
//  iOSHelper
//
//  Created by kampfgnu on 8/22/12.
//  Copyright (c) 2012 NOUS. All rights reserved.
//

#import "KGMimeTypes.h"

@interface KGMimeTypes ()

+ (NSMutableDictionary *)mimeTypes;

@end



@implementation KGMimeTypes

+ (NSString *)fileExtensionForMimeType:(NSString *)mimeType {
    NSMutableDictionary *dict = [KGMimeTypes mimeTypes];
    NSString *fileExtension = [dict valueForKey:[mimeType lowercaseString]];
    return fileExtension != nil ? fileExtension : @"xxx";
}

+ (NSString *)mimeTypeForFileExtension:(NSString *)fileExtension {
    NSMutableDictionary *dict = [KGMimeTypes mimeTypes];
    NSArray *array = [dict allKeysForObject:[fileExtension lowercaseString]];
    if (array.count > 0) return [array objectAtIndex:0];
    else return @"type/unknown";
}

+ (NSMutableDictionary *)mimeTypes {
    NSMutableDictionary *mimeTypes = [NSMutableDictionary dictionary];
    [mimeTypes setObject:@"aif" forKey:@"audio/x-aiff"];
    [mimeTypes setObject:@"aiff" forKey:@"audio/x-aiff"];
    [mimeTypes setObject:@"avi" forKey:@"video/avi"];
    [mimeTypes setObject:@"bat" forKey:@"application/bat"];
    [mimeTypes setObject:@"bat" forKey:@"application/x-bat"];
    [mimeTypes setObject:@"bat" forKey:@"application/x-msdos-program"];
    [mimeTypes setObject:@"bmp" forKey:@"image/bmp"];
    [mimeTypes setObject:@"bz2" forKey:@"application/x-bz2"];
    [mimeTypes setObject:@"csv" forKey:@"text/csv"];
    [mimeTypes setObject:@"dmg" forKey:@"application/x-apple-diskimage"];
    [mimeTypes setObject:@"doc" forKey:@"application/msword"];
    [mimeTypes setObject:@"docx" forKey:@"application/vnd.openxmlformats-officedocument.wordprocessingml.document"];
    [mimeTypes setObject:@"eml" forKey:@"message/rfc822"];
    [mimeTypes setObject:@"aps" forKey:@"application/postscript"];
    [mimeTypes setObject:@"exe" forKey:@"application/x-ms-dos-executable"];
    [mimeTypes setObject:@"flv" forKey:@"video/x-flv"];
    [mimeTypes setObject:@"gif" forKey:@"image/gif"];
    [mimeTypes setObject:@"gz" forKey:@"application/x-gzip"];
    [mimeTypes setObject:@"hqx" forKey:@"application/stuffit"];
    [mimeTypes setObject:@"htm" forKey:@"text/html"];
    [mimeTypes setObject:@"html" forKey:@"text/html"];
    [mimeTypes setObject:@"jar" forKey:@"application/x-java-archive"];
    [mimeTypes setObject:@"jpeg" forKey:@"image/jpeg"];
    [mimeTypes setObject:@"jpg" forKey:@"image/jpeg"];
    [mimeTypes setObject:@"m3u" forKey:@"audio/x-mpegurl"];
    [mimeTypes setObject:@"m4a" forKey:@"audio/mp4"];
    [mimeTypes setObject:@"m4v" forKey:@"audio/m4v"];
    [mimeTypes setObject:@"mdb" forKey:@"application/x-msaccess"];
    [mimeTypes setObject:@"mid" forKey:@"audio/midi"];
    [mimeTypes setObject:@"midi" forKey:@"audio/midi"];
    [mimeTypes setObject:@"mov" forKey:@"video/quicktime"];
    [mimeTypes setObject:@"mp3" forKey:@"audio/mpeg"];
    [mimeTypes setObject:@"mp4" forKey:@"video/mp4"];
    [mimeTypes setObject:@"mpeg" forKey:@"video/mpeg"];
    [mimeTypes setObject:@"mpg" forKey:@"video/mpeg"];
    [mimeTypes setObject:@"odg" forKey:@"vnd.oasis.opendocument.graphics"];
    [mimeTypes setObject:@"odp" forKey:@"vnd.oasis.opendocument.presentation"];
    [mimeTypes setObject:@"odt" forKey:@"vnd.oasis.opendocument.text"];
    [mimeTypes setObject:@"ods" forKey:@"vnd.oasis.opendocument.spreadsheet"];
    [mimeTypes setObject:@"ogg" forKey:@"audio/ogg"];
    [mimeTypes setObject:@"pdf" forKey:@"application/pdf"];
    [mimeTypes setObject:@"png" forKey:@"image/png"];
    [mimeTypes setObject:@"ppt" forKey:@"application/vnd.ms-powerpoint"];
    [mimeTypes setObject:@"pptx" forKey:@"application/vnd.openxmlformats-officedocument.presentationml.presentation"];
    [mimeTypes setObject:@"ps" forKey:@"application/postscript"];
    [mimeTypes setObject:@"rar" forKey:@"application/x-rar-compressed"];
    [mimeTypes setObject:@"rtf" forKey:@"application/rtf"];
    [mimeTypes setObject:@"tar" forKey:@"application/x-tar"];
    [mimeTypes setObject:@"sit" forKey:@"application/x-stuffit"];
    [mimeTypes setObject:@"svg" forKey:@"image/svg+xml"];
    [mimeTypes setObject:@"tif" forKey:@"image/tiff"];
    [mimeTypes setObject:@"tiff" forKey:@"image/tiff"];
    [mimeTypes setObject:@"ttf" forKey:@"application/x-font-truetype"];
    [mimeTypes setObject:@"txt" forKey:@"text/plain"];
    [mimeTypes setObject:@"vcf" forKey:@"text/x-vcard"];
    [mimeTypes setObject:@"wav" forKey:@"audio/wav"];
    [mimeTypes setObject:@"wma" forKey:@"audio/x-ms-wma"];
    [mimeTypes setObject:@"wmv" forKey:@"audio/x-ms-wmv"];
    [mimeTypes setObject:@"xls" forKey:@"application/excel"];
    [mimeTypes setObject:@"xlsx" forKey:@"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"];
    [mimeTypes setObject:@"xml" forKey:@"application/xml"];
    [mimeTypes setObject:@"zip" forKey:@"application/zip"];
    
    return mimeTypes;
}

+ (KGMimeType)mimeTypeOfMimeType:(NSString *)mimeType {
    KGMimeType mime = KGMimeTypeUnknown;
    
    if ([mimeType hasPrefix:@"audio"]) {
        mime = KGMimeTypeAudio;
    }
    else if ([mimeType hasPrefix:@"video"]) {
        mime = KGMimeTypeVideo;
    }
    else if ([mimeType hasPrefix:@"image"]) {
        mime = KGMimeTypeImage;
    }
    else if ([mimeType hasPrefix:@"application"]) {
        mime = KGMimeTypeApplication;
    }
    else if ([mimeType hasPrefix:@"text"]) {
        mime = KGMimeTypeText;
    }
    
    return mime;
}

@end