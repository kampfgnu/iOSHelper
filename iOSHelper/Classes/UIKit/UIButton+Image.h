//
//  UIButton+Image.h
//  iOSHelper
//
//  Created by Thomas Heingärtner on 25/03/14.
//  Copyright (c) 2014 NOUS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Image)

/**
 Creates a button of type "UIButtonTypeCustom" and sets the given image for UIControlStateNormal, and the size of the button
 to the size of the image.
 
 @param image the image for state UIControlStateNormal
 @return a button with type custom and the size of the given image
 */
+ (UIButton *)buttonWithImage:(UIImage *)image;

/**
 Creates a button of type "UIButtonTypeCustom" and sets the given image for UIControlStateNormal, and the size of the button
 to the size of the image.
 
 @param imageName the name of the image
 @return a button with type custom and the size of the given image
 */
+ (UIButton *)buttonWithImageNamed:(NSString *)imageName;

@end
