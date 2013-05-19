//
//  UIView+Userdata.m
//  iOSHelper
//
//  Created by kampfgnu on 5/3/12.
//  Copyright (c) 2012 NOUS. All rights reserved.
//

#import "UIView+Userdata.h"
#import <objc/runtime.h>

static char const * const userDataKey = "userData";

@implementation UIView (Userdata)

@dynamic userData;

- (id)userData {
    return objc_getAssociatedObject(self, userDataKey);
}

- (void)setUserData:(id)newUserData {
    objc_setAssociatedObject(self, userDataKey, newUserData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
