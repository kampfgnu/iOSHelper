//
//  NSURL+GETParameters.m
//  iOSHelper
//
//  Created by Thomas Heingärtner on 7/4/13.
//  Copyright (c) 2013 NOUS Wissensmanagement GmbH. All rights reserved.
//

#import "NSURL+GETParameters.h"

@implementation NSURL (GETParameters)

- (NSString *)valueForParameter:(NSString *)parameter {
    NSDictionary *parameters = [self parameterDictionary];
    
    return [parameters objectForKey:parameter];
}

- (NSDictionary *)parameterDictionary {
    NSString *string = [self scannableString];
    NSScanner *scanner = [NSScanner scannerWithString:string];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"&?"]];
    
    NSString *temp;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [scanner scanUpToString:@"?" intoString:nil];       //ignore the beginning of the string and skip to the vars
    while ([scanner scanUpToString:@"&" intoString:&temp]) {
        NSArray *parts = [temp componentsSeparatedByString:@"="];
        if ([parts count] == 2) {
            [dict setObject:[parts objectAtIndex:1] forKey:[parts objectAtIndex:0]];
        }
    }
    
    return dict;
}

- (NSString *)scannableString {
    return [[self.absoluteString stringByReplacingOccurrencesOfString:@"+" withString:@" "]
            stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)stringWithoutGETParameters {
    NSString *string = [self scannableString];
    NSScanner *scanner = [NSScanner scannerWithString:string];
    
    NSString *outputString = nil;
    [scanner scanUpToString:@"?" intoString:&outputString];
    
    return outputString;
}

@end
