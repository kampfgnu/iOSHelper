//
//  KGDrawEraseImageView.m
//  iOSHelper
//
//  Created by Thomas Heingärtner on 6/28/13.
//  Copyright (c) 2013 nousguide. All rights reserved.
//

#import "KGDrawEraseImageView.h"

#import "CGGeometry+KGAdditions.h"

@interface KGDrawEraseImageView ()
@property (nonatomic, readwrite) CGPoint currentPoint;
@property (nonatomic, readwrite) CGPoint previousPoint1;
@property (nonatomic, readwrite) CGPoint previousPoint2;
@end


@implementation KGDrawEraseImageView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.userInteractionEnabled = YES;
    
    _lineWidth = 20.f;
    _unerase = NO;
}

- (CGFloat)zoomScaleThatFits:(CGSize)target source:(CGSize)source {
    CGFloat w_scale = (target.width / source.width);
    CGFloat h_scale = (target.height / source.height);
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        return ((w_scale < h_scale) ? w_scale : h_scale);
    }
    else {
        return w_scale;
    }
}

- (CGPoint)scalePoint:(CGPoint)point scale:(CGFloat)scale {
    return CGPointMake(point.x * scale, point.y * scale);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if (_unerase && self.originalImage != nil) {
        CGFloat scaleFactor = [self zoomScaleThatFits:self.originalImage.size source:self.frame.size];
        self.previousPoint1 = [self scalePoint:[touch previousLocationInView:self] scale:scaleFactor];
        self.previousPoint2 = self.previousPoint1;
        self.currentPoint = [self scalePoint:[touch locationInView:self] scale:scaleFactor];
    }
    else {
        self.previousPoint1 = [touch previousLocationInView:self];
        self.previousPoint2 = self.previousPoint1;
        self.currentPoint = [touch locationInView:self];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if (_unerase && self.originalImage != nil) {
        CGFloat scaleFactor = [self zoomScaleThatFits:self.originalImage.size source:self.frame.size];
        self.previousPoint2 = self.previousPoint1;
        self.previousPoint1 = [self scalePoint:[touch previousLocationInView:self] scale:scaleFactor];
        self.currentPoint = [self scalePoint:[touch locationInView:self] scale:scaleFactor];
    }
    else {
        self.previousPoint2 = self.previousPoint1;
        self.previousPoint1 = [touch previousLocationInView:self];
        self.currentPoint = [touch locationInView:self];
    }
    
    // calculate mid point
    CGPoint mid1 = KGMidPointBetweenCGPoints(self.previousPoint1, self.previousPoint2);
    CGPoint mid2 = KGMidPointBetweenCGPoints(self.currentPoint, self.previousPoint1);
    
    CGSize originalImageSize = self.originalImage.size;
    UIGraphicsBeginImageContext(originalImageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.image drawInRect:CGRectMake(0, 0, originalImageSize.width, originalImageSize.height)];
    
    CGContextSetBlendMode(context, _unerase ? kCGBlendModeNormal : kCGBlendModeClear);
    
    CGContextMoveToPoint(context, mid1.x, mid1.y);
    // Use QuadCurve is the key
    CGContextAddQuadCurveToPoint(context, self.previousPoint1.x, self.previousPoint1.y, mid2.x, mid2.y);
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, _lineWidth);
    
    if (_unerase && self.originalImage != nil) [[UIColor colorWithPatternImage:self.originalImage] setStroke];
    else [[UIColor clearColor] setStroke];
    
    CGContextStrokePath(context);
    
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

@end
