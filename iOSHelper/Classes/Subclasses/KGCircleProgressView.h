//
//  KGCircleProgressView.h
//  iOSHelper
//
//  Created by Thomas Heingärtner on 10/11/13.
//  Copyright (c) 2013 NOUS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGCircleProgressView : UIView

@property (nonatomic, strong) UIColor *circleProgressColor;
@property (nonatomic, readwrite) CGFloat lineWidth;

- (void)updateProgress:(float)progress;

@end
