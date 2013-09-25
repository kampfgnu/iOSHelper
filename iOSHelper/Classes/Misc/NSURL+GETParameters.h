//
//  NSURL+GETParameters.h
//  iOSHelper
//
//  Created by Thomas Heingärtner on 7/4/13.
//  Copyright (c) 2013 NOUS Wissensmanagement GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (GETParameters)

- (NSString *)valueForParameter:(NSString *)parameter;
- (NSDictionary *)parameterDictionary;
- (NSString *)stringWithoutGETParameters;

@end
