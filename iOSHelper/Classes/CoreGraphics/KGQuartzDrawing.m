//
//  KGQuartzDrawing.m
//  iOSHelper
//
//  Created by kampfgnu on 2/27/12.
//  Copyright (c) 2012 NOUS. All rights reserved.
//

#import "KGQuartzDrawing.h"
#import "UIColor+KGAdditions.h"

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
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
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
