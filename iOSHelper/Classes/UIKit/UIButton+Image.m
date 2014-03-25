//
//  UIButton+Image.m
//  iOSHelper
//
//  Created by Thomas Heingärtner on 25/03/14.
//  Copyright (c) 2014 NOUS. All rights reserved.
//

#import "UIButton+Image.h"

@implementation UIButton (Image)

+ (UIButton *)buttonWithImage:(UIImage *)image {
    UIButton *button = nil;
    
    if (image != nil) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = (CGRect){CGPointZero,image.size};
        [button setImage:image forState:UIControlStateNormal];
    }
    
    return button;
}

+ (UIButton *)buttonWithImageNamed:(NSString *)imageName {
    return [self buttonWithImage:[UIImage imageNamed:imageName]];
    
}

@end
