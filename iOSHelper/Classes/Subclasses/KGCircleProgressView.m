//
//  KGCircleProgressView.m
//  iOSHelper
//
//  Created by Thomas Heingärtner on 10/11/13.
//  Copyright (c) 2013 NOUS. All rights reserved.
//

#import "KGCircleProgressView.h"

@interface KGCircleProgressView ()
@property (nonatomic, readwrite) float progress;
@end

@implementation KGCircleProgressView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.progress = 0.f;
        self.circleProgressColor = [UIColor whiteColor];
        self.lineWidth = 1.f;
    }
    return self;
}

- (void)updateProgress:(float)progress {
    _progress = progress;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *progressCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2)
                                                                  radius:MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))/2 - (_lineWidth/2)
                                                              startAngle:(CGFloat) - M_PI_2
                                                                endAngle:(CGFloat)(- M_PI_2 + _progress * 2 * M_PI)
                                                               clockwise:YES];
    [_circleProgressColor setStroke];
    progressCircle.lineWidth = _lineWidth;
    [progressCircle stroke];
}

@end
