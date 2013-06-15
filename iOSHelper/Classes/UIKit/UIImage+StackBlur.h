//
//  UIImage+StackBlur.h
//  stackBlur
//
//  Created by Thomas LANDSPURG on 07/02/12.
//  Copyright 2012 Digiwie. All rights reserved.
//
// StackBlur implementation on iOS
//
//

#import <Foundation/Foundation.h>

@interface UIImage (StackBlur) 

+ (UIImage *)blurredImageOfView:(UIView *)view inRadius:(CGFloat)inRadius;
+ (UIImage *)blurredImageOfView:(UIView *)view inRadius:(CGFloat)inRadius darken:(BOOL)darken;
+ (UIImage *)blurredImage:(UIImage *)image inRadius:(NSUInteger)inRadius;
- (UIImage *)stackBlur:(NSUInteger)radius;
- (UIImage *)normalize;
+ (void)applyStackBlurToBuffer:(UInt8 *)targetBuffer width:(const int)w height:(const int)h withRadius:(NSUInteger)inradius;

@end

