#import "NSString+KGAdditions.h"

@implementation NSString (KGAdditions)

- (BOOL)isBlank {
  return [[self trimmed] isEmpty];
}

- (BOOL)isEmpty {
  return ([self length] == 0);
}

- (NSString *)presence {
  if([self isBlank]) {
    return nil;
  } else {
    return self;
  }
}

- (NSRange)stringRange {
  return NSMakeRange(0, [self length]);
}

- (NSString *)trimmed {
  return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)URLEncodedString {
  NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                           (__bridge CFStringRef)self,
                                                                                           NULL,
                                                                                           CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                           kCFStringEncodingUTF8);
  return result;
}

- (NSString*)URLDecodedString {
  NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                           (__bridge CFStringRef)self,
                                                                                                           CFSTR(""),
                                                                                                           kCFStringEncodingUTF8);
  return result;
}

- (BOOL)containsString:(NSString *)string {
	return [self containsString:string options:NSCaseInsensitiveSearch];
}

- (BOOL)containsString:(NSString *)string options:(NSStringCompareOptions)options {
	return [self rangeOfString:string options:options].location == NSNotFound ? NO : YES;
}

- (BOOL)isEqualToStringIgnoringCase:(NSString*)otherString {
	if(!otherString) {
		return NO;
  }
  
	return NSOrderedSame == [self compare:otherString options:NSCaseInsensitiveSearch + NSWidthInsensitiveSearch];
}

- (NSString *)stringBetweenString:(NSString*)start andString:(NSString*)end {
    NSScanner* scanner = [NSScanner scannerWithString:self];
    [scanner setCharactersToBeSkipped:nil];
    [scanner scanUpToString:start intoString:NULL];
    if ([scanner scanString:start intoString:NULL]) {
        NSString* result = nil;
        if ([scanner scanUpToString:end intoString:&result]) {
            return result;
        }
    }
    return nil;
}

- (NSString *)stringByReplacingUnnecessaryWhitespace {
  NSError *error = nil;
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[ ]{2,}"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:&error];
  
  if (regex == nil) {
//    FKLogDebug(@"Couldn't replace unneccessary whitespace because regex couldn't be created: %@", [error localizedDescription]);
    return self;
  } 
  
  return [regex stringByReplacingMatchesInString:self
                                         options:0
                                           range:self.stringRange
                                    withTemplate:@" "];
}

- (NSString *)trimmedStringByReplacingUnnecessaryWhitespace {
  return [[self stringByReplacingUnnecessaryWhitespace] trimmed];
}

- (BOOL)isValidEmailAddress {
  NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+.[A-Z]{2,4}$";
  NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
  NSUInteger regExMatches = [regEx numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)];
  
  if (regExMatches == 0) {
    return NO;
  } else {
    return YES;
  }
}

- (NSString *)firstLetter {
  if (self.length <= 1)
    return self;
  return [self substringToIndex:1];
}

+ (NSString *)uniqueString {
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
	NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
	CFRelease(uuidObj);
	
	return [uuidString stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

+ (NSString *)addSuffix:(NSString *)suffix toString:(NSString *)string {
    NSString *extension = [string pathExtension];
    if (extension == nil) extension = @"";
    else extension = [@"." stringByAppendingString:extension];
    
    NSString *suffixWithExtension = [NSString stringWithFormat:@"%@%@", suffix, extension];
    return [string stringByReplacingOccurrencesOfString:extension withString:suffixWithExtension];
}

@end
