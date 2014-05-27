// Part of FoundationKit http://foundationk.it
//
// isBlank see https://github.com/rails/rails/blob/master/activesupport/lib/active_support/core_ext/object/blank.rb


#import <Foundation/Foundation.h>

@interface NSString (KGAdditions)

- (BOOL)isBlank;
- (BOOL)isEmpty;
- (NSString *)presence;
- (NSRange)stringRange;
- (NSString *)trimmed;
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

- (BOOL)containsString:(NSString *)string;
- (BOOL)containsString:(NSString *)string options:(NSStringCompareOptions)options;
- (BOOL)isEqualToStringIgnoringCase:(NSString*)otherString;

/**
 Replaces all occurences of two or more spaces in a row with one space, 
 e.g. "  I   like    FoundationKit   " -> " I like FoundationKit "
 The String doesn't get trimmed.
 
 @return A string that only contains one space in a row
 */
- (NSString *)stringByReplacingUnnecessaryWhitespace;

/**
 Replaces all occurences of two or more spaces in a row with one space and trim the string, 
 e.g. "  I   like    FoundationKit   " -> "I like FoundationKit"
 
 @return A string that only contains one space in a row and no space at the beginning and end
 */
- (NSString *)trimmedStringByReplacingUnnecessaryWhitespace;

/**
 Checks if the string is valid E-Mail address
 @return YES, if the string is a valid E-Mail address, NO otherwise
 */
- (BOOL)isValidEmailAddress;

/**
 Returns first letter of the string
 @return first letter of the string, if string has length 0 it will return the empty string
 */
- (NSString *)firstLetter;

+ (NSString *)uniqueString;

/**
 Inserts the given suffix before the filenameextension (e.g. suffix = "_blah", string = "hello.jpg", output: "hello_blah.jpg"
 */
+ (NSString *)addSuffix:(NSString *)suffix toString:(NSString *)string;

@end
