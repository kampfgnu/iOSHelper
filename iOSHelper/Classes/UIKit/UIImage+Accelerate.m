//
//  UIImage+Accelerate.m
//  iOSHelper
//
//  Created by Thomas Heingärtner on 6/14/13.
//  Copyright (c) 2013 NOUS. All rights reserved.
//

#import "UIImage+Accelerate.h"
#import "UIView+KGAdditions.h"

@implementation UIImage (Accelerate)

+ (UIImage *)blurredImageOfView:(UIView *)view blurLevel:(CGFloat)blurLevel {
    return [UIImage blurredImageOfView:view blurLevel:blurLevel darken:NO];
}

+ (UIImage *)blurredImageOfView:(UIView *)view blurLevel:(CGFloat)blurLevel darken:(BOOL)darken {
    UIImage *screenshot = darken ? [view darkerImageRepresentation] : [view imageRepresentation];
    return [UIImage blurredImage:screenshot blurLevel:blurLevel isJpg:NO];
}

+ (UIImage *)blurredImage:(UIImage *)image blurLevel:(CGFloat)blur {
    return [UIImage blurredImage:image blurLevel:blur isJpg:NO];
}

+ (UIImage *)blurredImage:(UIImage *)image blurLevel:(CGFloat)blur isJpg:(BOOL)isJpg {
    if (isJpg) {
        return [image blurredImageWithBlurLevel:blur];
    }
    else {
        NSData *imageData = UIImageJPEGRepresentation(image, 1); // convert to jpeg
        UIImage *jpgImage = [UIImage imageWithData:imageData];

        return [jpgImage blurredImageWithBlurLevel:blur];
    }
}

- (UIImage *)blurredImageWithBlurLevel:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    
    vImage_Error error;
    
    void *pixelBuffer;
    
    
    //create vImage_Buffer with data from CGImageRef
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    // Create a third buffer for intermediate processing
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    //perform convolution
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    return returnImage;
}

@end
