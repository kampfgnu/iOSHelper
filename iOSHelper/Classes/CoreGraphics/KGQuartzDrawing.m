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
    if (imageSource == NULL) return NULL;
    
    CGImageRef imageRef = [KGQuartzDrawing thumbImageRefFromImageSource:imageSource size:size];
    CFRelease(imageSource);
    
    return imageRef;
}

+ (CGImageRef)thumbImageRefFromImageData:(NSData *)data size:(CGSize)size {
    if (data == nil) return NULL;
    
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    CGImageRef imageRef = [KGQuartzDrawing thumbImageRefFromImageSource:imageSource size:size];
    CFRelease(imageSource);
    
    return imageRef;
}

+ (CGImageRef)thumbImageRefFromImageSource:(CGImageSourceRef)imageSource size:(CGSize)size {
    if (imageSource == NULL) return NULL;
    
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
    if (imageRef == NULL) return NO;
    
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

+ (CGGradientRef)createGradientWithColors:(NSArray *)colors {
    return [KGQuartzDrawing createGradientWithColors:colors locations:nil];
}

+ (CGGradientRef)createGradientWithColors:(NSArray *)colors locations:(NSArray *)locations {
    NSUInteger colorsCount = colors.count;
    
	if (colorsCount < 2) {
		return nil;
	}
    
	CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors objectAtIndex:0] CGColor]);
    
	CGFloat *gradientLocations = NULL;
	NSUInteger locationsCount = [locations count];
	
    if (locationsCount == colorsCount) {
		gradientLocations = (CGFloat *)malloc(sizeof(CGFloat) * locationsCount);
        
        for (NSUInteger i = 0; i < locationsCount; i++) {
			gradientLocations[i] = [[locations objectAtIndex:i] floatValue];
		}
	}
    
	NSMutableArray *gradientColors = [[NSMutableArray alloc] initWithCapacity:colorsCount];
	[colors enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
		[gradientColors addObject:(id)[(UIColor *)object CGColor]];
	}];
    
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    
	if (gradientLocations) {
		free(gradientLocations);
	}
    
	return gradient;
}

+ (void)drawGradient:(CGGradientRef)gradient inRect:(CGRect)rect context:(CGContextRef)context {
    CGContextSaveGState(context);
	CGContextClipToRect(context, rect);
	CGPoint start = CGPointMake(rect.origin.x, rect.origin.y);
	CGPoint end = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
	CGContextDrawLinearGradient(context, gradient, start, end, 0);
	CGContextRestoreGState(context);
}

+ (void)drawRoundedRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius context:(CGContextRef)context {
    CGPoint min = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
	CGPoint mid = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
	CGPoint max = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    
	CGContextMoveToPoint(context, min.x, mid.y);
	CGContextAddArcToPoint(context, min.x, min.y, mid.x, min.y, cornerRadius);
	CGContextAddArcToPoint(context, max.x, min.y, max.x, mid.y, cornerRadius);
	CGContextAddArcToPoint(context, max.x, max.y, mid.x, max.y, cornerRadius);
	CGContextAddArcToPoint(context, min.x, max.y, min.x, mid.y, cornerRadius);
    
	CGContextClosePath(context);
	CGContextFillPath(context);
}

+ (void)drawInsetBeveledRoundedRect:(CGRect)rect radius:(CGFloat)radius fillColor:(UIColor *)fillColor context:(CGContextRef)context {
    //contract the bounds of the rectangle in to account for the stroke
    CGRect drawRect = CGRectInset(rect, 1.0f, 1.0f);
    
	//contract the height by 1 to account for the white bevel at the bottom
    drawRect.size.height -= 1.0f;
    
    //Save the current state so we don't persist anything beyond this operation
	CGContextSaveGState(context);
    
    //Generate the rounded rectangle paths
    CGPathRef boxPath = [[UIBezierPath bezierPathWithRoundedRect: drawRect cornerRadius: radius] CGPath];
    //For the stroke, offset by half a pixel to ensure proper drawing
    CGPathRef strokePath = [[UIBezierPath bezierPathWithRoundedRect: CGRectInset(drawRect, -0.5f, -0.5f) cornerRadius: radius] CGPath];
    
    /*Draw the bevel effect*/
    CGContextSaveGState(context);
    //Set the color to be slightly transparent white
    CGContextSetFillColorWithColor(context, [[UIColor colorWithWhite: 1.0f alpha: 0.8f] CGColor]);
    //Clip the region to only the visible portion to optimzie drawing
    CGContextClipToRect(context, CGRectMake(rect.origin.x, rect.origin.y+rect.size.height-radius, rect.size.width, radius));
    //draw the left corner curve
    CGRect corner = CGRectMake(rect.origin.x, (rect.origin.y+rect.size.height)-(2*radius)-1, (radius*2)+1, (radius*2)+1);
    CGContextFillEllipseInRect(context, corner);
    //draw the right corner
    corner.origin.x = rect.origin.x + rect.size.width - (radius*2)-1;
    CGContextFillEllipseInRect(context, corner);
    //draw the rectangle in the middle
    //set the blend mode to replace any existing pixels (or else we'll see visible overlap)
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextFillRect(context, CGRectMake(rect.origin.x+radius, rect.origin.y+rect.size.height-radius, rect.size.width-(2*radius),radius+1));
    CGContextRestoreGState(context);
    
    /*Draw the main region */
    CGContextSaveGState(context);
    //fill it with our colour of choice
    CGContextSetFillColorWithColor(context, [fillColor CGColor]);
    //use the stroke path so the boundaries line up with the stroke (else we'll see a gap on retina devices)
    CGContextAddPath(context, strokePath);
    //fill it
    CGContextFillPath(context);
    CGContextRestoreGState(context);
    
    /*Main fill region inner drop shadow*/
    /*(This is done by duplicating the path, offsetting the duplicate by 1 pixel, and using the EO winding fill rule to fill the gap between the two)*/
    CGContextSaveGState(context);
    //set the colour to be a VERY faint grey
    CGContextSetFillColorWithColor(context, [[UIColor colorWithWhite: 0.0f alpha: 0.08f] CGColor]);
    //clip the shadow to the top of the box (to reduce overhead)
    CGContextClipToRect(context, CGRectMake( drawRect.origin.x, drawRect.origin.y, drawRect.size.width, radius ));
    //add the first instance of the path
    CGContextAddPath(context, boxPath);
    //translate the draw origin down by 1 pixel
    CGContextTranslateCTM(context, 0.0f, 1.0f);
    //add the second instance of the path
    CGContextAddPath(context, boxPath);
    //use the EO winding rule to fill the gap between the two paths
    CGContextEOFillPath(context);
    CGContextRestoreGState(context);
    
    /*Outer Stroke*/
    /*This is drawn outside of the fill region to prevent the fill region bleeding over in some cases*/
    CGContextSaveGState(context);
    //set the line width to be 1 pixel
    CGContextSetLineWidth(context, 1.0f);
    //set the the colour to be a very transparent shade of grey
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithWhite: 0.0f alpha: 0.18f] CGColor]);
    //set up the path to draw the stroke along
    CGContextAddPath(context, strokePath);
    //set the blending mode to replace underlying pixels on this layer (so the background will come through through)
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    //draw the path
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    //Restore the previous CG state
	CGContextRestoreGState(context);
}

@end
