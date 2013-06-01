//
//  KGCGRectHelper.m
//  iOSHelper
//
//  Created by Thomas Heingärtner on 6/1/13.
//  Copyright (c) 2013 NOUS. All rights reserved.
//

#import "KGCGRectHelper.h"

@implementation KGCGRectHelper

+ (void)logRect:(CGRect)rect {
    NSLog(@"x: %f, y: %f, w: %f, h: %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.width);
}

@end
