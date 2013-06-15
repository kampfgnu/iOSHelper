//
//  UIImage+Accelerate.h
//  iOSHelper
//
//  Created by Thomas Heingärtner on 6/14/13.
//  Copyright (c) 2013 NOUS. All rights reserved.
//

#import <Accelerate/Accelerate.h>

@interface UIImage (Accelerate)

+ (UIImage *)blurredImageOfView:(UIView *)view blurLevel:(CGFloat)blurLevel;
+ (UIImage *)blurredImageOfView:(UIView *)view blurLevel:(CGFloat)blurLevel darken:(BOOL)darken;
+ (UIImage *)blurredImage:(UIImage *)image blurLevel:(CGFloat)blur;
+ (UIImage *)blurredImage:(UIImage *)image blurLevel:(CGFloat)blur isJpg:(BOOL)isJpg;
//needs to be a jpg UIImage!
- (UIImage *)blurredImageWithBlurLevel:(CGFloat)blur;

@end
