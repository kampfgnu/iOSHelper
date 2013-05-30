// Part of FoundationKit http://foundationk.it
//
// $empty derived from http://www.wilshipley.com/blog/2005/10/pimp-my-code-interlude-free-code.html


#import <Foundation/Foundation.h>

// Shorthand for NSLocalizedString
NS_INLINE NSString* _(NSString *key) {
  return NSLocalizedString(key, key);
}

NS_INLINE NSString* KGApplicationVersion() {
  return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

NS_INLINE NSString* KGApplicationName() {
  return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
}

// runtime-check if class is available to make code more readable
NS_INLINE BOOL KGClassExists(NSString *className) {
  return NSClassFromString(className) != nil;
}