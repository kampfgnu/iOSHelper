//
//  KGQuartzDrawing.h
//  iOSHelper
//
//  Created by kampfgnu on 2/27/12.
//  Copyright (c) 2012 NOUS. All rights reserved.
//

@interface KGQuartzDrawing : NSObject

+ (void)drawHorizontalLineAtPosition:(CGPoint)position width:(CGFloat)width color:(UIColor *)color;
+ (void)drawVerticalLineAtPosition:(CGPoint)position height:(CGFloat)height color:(UIColor *)color;

+ (void)drawHorizontalSeparatorLineAtPosition:(CGPoint)position width:(CGFloat)width;
+ (void)drawVerticalSeparatorLineAtPosition:(CGPoint)position height:(CGFloat)height;


+ (UIImage *)image:(UIImage *)image withText:(NSString *)text drawAtPosition:(CGPoint)position;
+ (UIImage *)image:(UIImage *)image withText:(NSString *)text drawAtPosition:(CGPoint)position fontSize:(CGFloat)fontSize;
+ (UIImage *)image:(UIImage *)image withText:(NSString *)text drawAtPosition:(CGPoint)position fontSize:(CGFloat)fontSize color:(UIColor *)color;

+ (BOOL)writeThumbnailOfImageAtFilepath:(NSString *)filepath toFilepath:(NSString *)toFilepath size:(CGSize)size;
+ (BOOL)writeThumbnailOfImageData:(NSData *)data toFilepath:(NSString *)toFilepath size:(CGSize)size;
+ (UIImage *)thumbnailOfImageAtFilepath:(NSString *)filepath size:(CGSize)size;
+ (CGImageRef)thumbImageRefFromImageAtFilepath:(NSString *)filepath size:(CGSize)size;
+ (CGImageRef)thumbImageRefFromImageData:(NSData *)data size:(CGSize)size;
+ (BOOL)writeImageRef:(CGImageRef)imageRef toFilepath:(NSString *)toFilepath;

+ (UIImage *)imageOfPdfData:(NSData *)data page:(int)page scale:(CGFloat)scale;
+ (UIImage *)imageOfPage:(CGPDFPageRef)page scale:(CGFloat)scale;

+ (CGSize)cropBoxSizeOfCGPDFPageRef:(CGPDFPageRef)pageRef;
+ (CGSize)cropBoxSizeOfPDFData:(NSData *)data page:(int)page;
+ (CGSize)cropBoxSizeOfFirstPageWithPDFData:(NSData *)data;

+ (CGGradientRef)createGradientWithColors:(NSArray *)colors;
+ (CGGradientRef)createGradientWithColors:(NSArray *)colors locations:(NSArray *)locations;
+ (void)drawGradient:(CGGradientRef)gradient inRect:(CGRect)rect context:(CGContextRef)context;
+ (void)drawRoundedRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius context:(CGContextRef)context;
/**
 This function draws a rounded rect with iOS 5's new style of UITableViews (grouped)
 */
+ (void)drawInsetBeveledRoundedRect:(CGRect)rect radius:(CGFloat)radius fillColor:(UIColor *)fillColor context:(CGContextRef)context;

@end
