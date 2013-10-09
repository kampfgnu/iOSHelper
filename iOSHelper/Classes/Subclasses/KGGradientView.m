//
//  KGGradientView.m
//  iOSHelper
//
//  Created by Thomas Heingärtner on 10/9/13.
//  Copyright (c) 2013 NOUS. All rights reserved.
//

#import "KGGradientView.h"

@interface KGGradientView ()
@property (nonatomic, strong) NSMutableArray *colors;
@property (nonatomic, assign) CGFloat *locations;
@end

@implementation KGGradientView

- (id)initWithFrame:(CGRect)frame colors:(NSArray *)colors locations:(NSArray *)locations {
    self = [super initWithFrame:frame];
    if (self) {
        self.colors = [NSMutableArray array];
        for (UIColor *c in colors) {
            [_colors addObject:(id)c.CGColor];
        }
        
        _locations = malloc(locations.count * sizeof(float));
        for (int i = 0; i < locations.count; i++) {
            NSNumber *n = locations[i];
            _locations[i] = [n floatValue];
        }
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    NSArray *gradientColors = [NSArray arrayWithObjects:(id) _startColor.CGColor, _endColor.CGColor, nil];
    
//    CGFloat gradientLocations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)_colors, _locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient);
}

@end
