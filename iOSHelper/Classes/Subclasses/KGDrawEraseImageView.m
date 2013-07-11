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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    self.previousPoint1 = [touch previousLocationInView:self];
    self.previousPoint2 = [touch previousLocationInView:self];
    self.currentPoint = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    self.previousPoint2 = self.previousPoint1;
    self.previousPoint1 = [touch previousLocationInView:self];
    self.currentPoint = [touch locationInView:self];
    
    // calculate mid point
    CGPoint mid1 = KGMidPointBetweenCGPoints(self.previousPoint1, self.previousPoint2);
    CGPoint mid2 = KGMidPointBetweenCGPoints(self.currentPoint, self.previousPoint1);
    
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    CGContextSetBlendMode(context, _unerase ? kCGBlendModeNormal : kCGBlendModeClear);
    
    CGContextMoveToPoint(context, mid1.x, mid1.y);
    // Use QuadCurve is the key
    CGContextAddQuadCurveToPoint(context, self.previousPoint1.x, self.previousPoint1.y, mid2.x, mid2.y);
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, _lineWidth);
    
    if (_unerase) [[UIColor colorWithPatternImage:self.originalImage] setStroke];
    else [[UIColor clearColor] setStroke];
    
    CGContextStrokePath(context);
    
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

@end
