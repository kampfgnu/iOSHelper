#import "UIView+KGNoise.h"
#include <stdlib.h>

#define kKGNoiseTileDimension     40.f
#define kKGNoiseIntensity         250
#define kKGNoiseDefaultOpacity    0.4f
#define kKGNoisePixelWidth        0.3f

static UIImage * KG_noiseImage;

////////////////////////////////////////////////////////////////////////
#pragma mark - KGNoiseLayer Class Extension
////////////////////////////////////////////////////////////////////////

@interface KGNoiseLayer ()

+ (UIImage *)noiseTileImage;
+ (void)drawPixelInContext:(CGContextRef)context
                     point:(CGPoint)point 
                     width:(CGFloat)width 
                   opacity:(CGFloat)opacity
                whiteLevel:(CGFloat)whiteLevel;

@end

////////////////////////////////////////////////////////////////////////
#pragma mark - UIView+KGNoise
////////////////////////////////////////////////////////////////////////

@implementation UIView (KGNoise)

- (void)applyNoise {
    [self applyNoiseWithOpacity:kKGNoiseDefaultOpacity];
}

- (void)applyNoiseWithOpacity:(CGFloat)opacity {
    KGNoiseLayer *noiseLayer = [KGNoiseLayer noiseLayerWithFrame:self.bounds opacity:opacity];
    
    [self.layer insertSublayer:noiseLayer atIndex:0];
}

- (void)drawNoiseWithOpacity:(CGFloat)opacity {
    [self drawNoiseWithOpacity:opacity blendMode:kCGBlendModeNormal];
}

- (void)drawNoiseWithOpacity:(CGFloat)opacity blendMode:(CGBlendMode)blendMode {
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:self.bounds];
    
    CGContextSaveGState(context);
    {
        CGContextAddPath(context, [path CGPath]);
        CGContextClip(context);
        CGContextSetBlendMode(context, blendMode);
        CGContextSetAlpha(context, opacity);
        [[KGNoiseLayer noiseTileImage] drawAsPatternInRect:self.bounds];
    }
    CGContextRestoreGState(context);    
}

@end

////////////////////////////////////////////////////////////////////////
#pragma mark - KGNoiseLayer
////////////////////////////////////////////////////////////////////////

@implementation KGNoiseLayer

+ (KGNoiseLayer *)noiseLayerWithFrame:(CGRect)frame opacity:(CGFloat)opacity {
    KGNoiseLayer *noiseLayer = [[KGNoiseLayer alloc] init];
    
    noiseLayer.masksToBounds = YES;
    noiseLayer.frame = frame;
    noiseLayer.opacity = opacity;
    
    return noiseLayer;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)context {
    UIGraphicsPushContext(context);
    {
        [[KGNoiseLayer noiseTileImage] drawAsPatternInRect:self.bounds];
    }
    UIGraphicsPopContext();
}

+ (void)drawPixelInContext:(CGContextRef)context
                     point:(CGPoint)point
                     width:(CGFloat)width
                   opacity:(CGFloat)opacity
                whiteLevel:(CGFloat)whiteLevel {
    
    CGColorRef fillColor = [UIColor colorWithWhite:whiteLevel alpha:opacity].CGColor;
    CGRect pointRect = CGRectMake(point.x - (width/2), point.y - (width/2), width, width);
    
    CGContextSetFillColor(context, CGColorGetComponents(fillColor));
    CGContextFillEllipseInRect(context, pointRect);
}

+ (UIImage *)noiseTileImage {
    static dispatch_once_t onceToken;
    
#ifndef __clang_analyzer__
    
    dispatch_once(&onceToken, ^{
        CGFloat imageScale = [UIScreen mainScreen].scale;
        NSUInteger imageDimension = (NSUInteger)(imageScale * kKGNoiseTileDimension);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(nil,imageDimension,imageDimension,8,0,colorSpace,kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
        CFRelease(colorSpace);
        
        for (NSUInteger i=0; i<(kKGNoiseTileDimension * kKGNoiseIntensity); i++) {
            int x = (int)(arc4random() % (imageDimension + 1));
            int y = (int)(arc4random() % (imageDimension + 1));
            int opacity = arc4random() % 100;
            CGFloat whiteLevel = arc4random() % 100;
            
            [KGNoiseLayer drawPixelInContext:context 
                                       point:CGPointMake(x, y)
                                       width:(kKGNoisePixelWidth * imageScale) 
                                     opacity:(opacity) 
                                  whiteLevel:(whiteLevel/100.f)];
        }
        
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        CGContextRelease(context);
        
        KG_noiseImage = [[UIImage alloc] initWithCGImage:imageRef scale:imageScale orientation:UIImageOrientationUp];
    });
    
#endif
    
    return KG_noiseImage;
}

@end