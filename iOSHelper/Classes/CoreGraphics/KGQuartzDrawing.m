//
//  KGQuartzDrawing.m
//  iOSHelper
//
//  Created by kampfgnu on 2/27/12.
//  Copyright (c) 2012 NOUS. All rights reserved.
//

#import "KGQuartzDrawing.h"
#import "UIColor+KGAdditions.h"

#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation KGQuartzDrawing

+ (void)drawHorizontalLineAtPosition:(CGPoint)position width:(CGFloat)width color:(UIColor *)color {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetAllowsAntialiasing(context, false);
	
	CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
	CGContextSetLineWidth(context, 1);
	CGContextSetStrokeColorWithColor(context, [color CGColor]);
	
	CGFloat minx = position.x;
	CGFloat maxx = position.x + width;
	CGFloat y = position.y;
	CGContextMoveToPoint(context, minx, y);
	CGContextAddLineToPoint(context, maxx, y);
	CGContextDrawPath(context, kCGPathStroke);
}

+ (void)drawVerticalLineAtPosition:(CGPoint)position height:(CGFloat)height color:(UIColor *)color {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetAllowsAntialiasing(context, false);
	
	CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
	CGContextSetLineWidth(context, 1);
	CGContextSetStrokeColorWithColor(context, [color CGColor]);
	
	CGFloat x = position.x;
	CGFloat miny = position.y;
	CGFloat maxy = position.y + height;
	
	CGContextMoveToPoint(context, x+1, miny);
	CGContextAddLineToPoint(context, x+1, maxy);
	CGContextDrawPath(context, kCGPathStroke);
}

+ (void)drawHorizontalSeparatorLineAtPosition:(CGPoint)position width:(CGFloat)width {
	[KGQuartzDrawing drawHorizontalLineAtPosition:position width:width color:[UIColor blackColor]];
	position.y += 1;
	[KGQuartzDrawing drawHorizontalLineAtPosition:position width:width color:[UIColor colorWithRGBHex:0x687080]];	
}

+ (void)drawVerticalSeparatorLineAtPosition:(CGPoint)position height:(CGFloat)height {	
	[KGQuartzDrawing drawVerticalLineAtPosition:position height:height color:[UIColor colorWithRGBHex:0x687080]];
	position.x += 1;
	[KGQuartzDrawing drawVerticalLineAtPosition:position height:height color:[UIColor blackColor]];
}

+ (UIImage *)image:(UIImage *)image withText:(NSString *)text drawAtPosition:(CGPoint)position {
	return [self image:image withText:text drawAtPosition:position fontSize:18];
}

+ (UIImage *)image:(UIImage *)image withText:(NSString *)text drawAtPosition:(CGPoint)position fontSize:(CGFloat)fontSize  {
    return [self image:image withText:text drawAtPosition:position fontSize:18 color:[UIColor whiteColor]];
}

+ (UIImage *)image:(UIImage *)image withText:(NSString *)text drawAtPosition:(CGPoint)position fontSize:(CGFloat)fontSize color:(UIColor *)color {
    int w = image.size.width;
    int h = image.size.height;
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), image.CGImage);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1);
	
    char* textChar	= (char *)[text cStringUsingEncoding:NSASCIIStringEncoding];
    CGContextSelectFont(context, "Helvetica-Bold", fontSize, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetRGBFillColor(context, color.red*255, color.green*255, color.blue*255, 1);
	
    CGContextShowTextAtPoint(context, position.x, position.y, textChar, strlen(textChar));
	
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
	
	UIImage *retImage = [UIImage imageWithCGImage:imageMasked];
	CGImageRelease(imageMasked);
	
	return retImage;
}

+ (BOOL)writeThumbnailOfImageAtFilepath:(NSString *)filepath toFilepath:(NSString *)toFilepath size:(CGSize)size {
    CGImageRef imageRef = [KGQuartzDrawing thumbImageRefFromImageAtFilepath:filepath size:size];
    return [KGQuartzDrawing writeImageRef:imageRef toFilepath:toFilepath];
}

+ (BOOL)writeThumbnailOfImageData:(NSData *)data toFilepath:(NSString *)toFilepath size:(CGSize)size {
    CGImageRef imageRef = [KGQuartzDrawing thumbImageRefFromImageData:data size:size];
    return [KGQuartzDrawing writeImageRef:imageRef toFilepath:toFilepath];
}

+ (UIImage *)thumbnailOfImageAtFilepath:(NSString *)filepath size:(CGSize)size {
    return [UIImage imageWithCGImage:[KGQuartzDrawing thumbImageRefFromImageAtFilepath:filepath size:size]];
}

+ (CGImageRef)thumbImageRefFromImageAtFilepath:(NSString *)filepath size:(CGSize)size {
    NSURL *url = [NSURL fileURLWithPath:filepath];
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)url, NULL);
    CGImageRef imageRef = [KGQuartzDrawing thumbImageRefFromImageSource:imageSource size:size];
    CFRelease(imageSource);
    
    return imageRef;
}

+ (CGImageRef)thumbImageRefFromImageData:(NSData *)data size:(CGSize)size {
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    CGImageRef imageRef = [KGQuartzDrawing thumbImageRefFromImageSource:imageSource size:size];
    CFRelease(imageSource);
    
    return imageRef;
}

+ (CGImageRef)thumbImageRefFromImageSource:(CGImageSourceRef)imageSource size:(CGSize)size {
    CGImageRef thumbnail = NULL;
    
    NSDictionary* d = [NSDictionary dictionaryWithObjectsAndKeys:
                       (id)kCFBooleanTrue, kCGImageSourceShouldAllowFloat,
                       (id)kCFBooleanFalse, kCGImageSourceCreateThumbnailWithTransform,
                       (id)kCFBooleanTrue, kCGImageSourceCreateThumbnailFromImageAlways,
                       [NSNumber numberWithInt:size.width], kCGImageSourceThumbnailMaxPixelSize,
                       nil];
    thumbnail = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, (__bridge CFDictionaryRef)d);
    
    // Make sure the thumbnail image exists before continuing.
    if (thumbnail == NULL){
        NSLog(@"Thumbnail image not created from image source.");
        thumbnail = NULL;
    }
    
    return thumbnail;
}

+ (BOOL)writeImageRef:(CGImageRef)imageRef toFilepath:(NSString *)toFilepath {
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:toFilepath];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, NULL);
    CGImageDestinationAddImage(destination, imageRef, nil);
    
    BOOL success = YES;
    
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"Failed to write image to %@", toFilepath);
        success = NO;
    }
    
    CFRelease(destination);
    
    return success;
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark - pdf stuff
////////////////////////////////////////////////////////////////////////

+ (UIImage *)imageOfPdfData:(NSData *)data page:(int)page scale:(CGFloat)scale {
    CGDataProviderRef dataProv = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    CGPDFDocumentRef docRef = CGPDFDocumentCreateWithProvider(dataProv);
    CGDataProviderRelease(dataProv);
    
    CGPDFPageRef pageRef = CGPDFDocumentGetPage(docRef, page);
    
    UIImage *image = [KGQuartzDrawing imageOfPage:pageRef scale:scale];
    
    CGPDFDocumentRelease(docRef);
    
    return image;
}

+ (UIImage *)imageOfPage:(CGPDFPageRef)page scale:(CGFloat)scale {
    CGRect cropBoxRect = CGPDFPageGetBoxRect(page, kCGPDFCropBox);
    CGRect mediaBoxRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
    CGRect pageRect = CGRectIntersection(cropBoxRect, mediaBoxRect);
    pageRect.origin = CGPointZero;
    
    pageRect.size = CGSizeMake(pageRect.size.width, pageRect.size.height);
    cropBoxRect.size = CGSizeMake(cropBoxRect.size.width*scale, cropBoxRect.size.height*scale);
    
    UIGraphicsBeginImageContext(cropBoxRect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // White BG
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(context, pageRect);
    
    CGContextSaveGState(context);
    
    CGContextTranslateCTM(context, 0.0, pageRect.size.height*scale);
    CGContextScaleCTM(context, scale, -scale);
    CGContextConcatCTM(context, CGPDFPageGetDrawingTransform(page, kCGPDFCropBox, pageRect, 0, true));
    
    CGContextDrawPDFPage(context, page);
//    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
//    CGContextSetRenderingIntent(context, kCGRenderingIntentDefault);
    
    CGContextRestoreGState(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (CGSize)cropBoxSizeOfCGPDFPageRef:(CGPDFPageRef)pageRef {
    CGRect cropBoxRect = CGPDFPageGetBoxRect(pageRef, kCGPDFCropBox);
    
    return cropBoxRect.size;
}

+ (CGSize)cropBoxSizeOfPDFData:(NSData *)data page:(int)page {
    CGDataProviderRef dataProv = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    CGPDFDocumentRef docRef = CGPDFDocumentCreateWithProvider(dataProv);
    CGDataProviderRelease(dataProv);
    
    CGPDFPageRef pageRef = CGPDFDocumentGetPage(docRef, page);
    CGSize size = [self cropBoxSizeOfCGPDFPageRef:pageRef];
    
    CGPDFDocumentRelease(docRef);
    
    return size;
}

+ (CGSize)cropBoxSizeOfFirstPageWithPDFData:(NSData *)data {
    return [self cropBoxSizeOfPDFData:data page:1];
}

@end
