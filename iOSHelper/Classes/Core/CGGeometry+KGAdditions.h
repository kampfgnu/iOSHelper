// Part of iOSKit http://foundationk.it
//
// Partly derived from Sam Soffes' Custom-Licensed SSToolkit: http://github.com/samsoffes/sstoolkit
// Partly derived from jverkoys' Nimbus-Project: http://github.com/jverkoy/nimbus

////////////////////////////////////////////////////////////////////////
#pragma mark - CGRect Helper
////////////////////////////////////////////////////////////////////////

/**
 Creates a new CGRect with (0.,0.) as it's origin, and the same width/height as the original CGRect
 */
NS_INLINE CGRect KGRectWithClearedOrigin(CGRect rect) {
    return CGRectMake(0.f,0.f,rect.size.width, rect.size.height);
}

/**
 Applys UIEdgeInsets to a CGRect.
 */
NS_INLINE CGRect KGRectInset(CGRect rect, UIEdgeInsets insets) {
    return UIEdgeInsetsInsetRect(rect, insets);
}

/**
 Sets a new value for origin.x, leaves all other values unchanged.
 */
NS_INLINE CGRect KGRectSetX(CGRect rect, CGFloat x) {
	return CGRectMake(x, rect.origin.y, rect.size.width, rect.size.height);
}

/**
 Sets a new value for origin.y, leaves all other values unchanged.
 */
NS_INLINE CGRect KGRectSetY(CGRect rect, CGFloat y) {
	return CGRectMake(rect.origin.x, y, rect.size.width, rect.size.height);
}

/**
 Sets a new value for size.width, leaves all other values unchanged.
 */
NS_INLINE CGRect KGRectSetWidth(CGRect rect, CGFloat width) {
	return CGRectMake(rect.origin.x, rect.origin.y, width, rect.size.height);
}

/**
 Sets a new value for size.height, leaves all other values unchanged.
 */
NS_INLINE CGRect KGRectSetHeight(CGRect rect, CGFloat height) {
	return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, height);
}

/**
 Sets a new origin, leaves the size unchanged
 */
NS_INLINE CGRect KGRectSetOrigin(CGRect rect, CGPoint origin) {
	return CGRectMake(origin.x, origin.y, rect.size.width, rect.size.height);
}

/**
 Sets a new size, leaves the origin unchanged
 */
NS_INLINE CGRect KGRectSetSize(CGRect rect, CGSize size) {
	return CGRectMake(rect.origin.x, rect.origin.y, size.width, size.height);
}

/**
 creates a rect from origin and size
 */
NS_INLINE CGRect KGRectFromPointAndSize(CGPoint point, CGSize size) {
	return CGRectMake(point.x, point.y, size.width, size.height);
}

/**
 Translates the origin of a rect by creating a new origin (origin.x+point.x, origin.y+point.y)
 */
NS_INLINE CGRect KGRectAddPoint(CGRect rect, CGPoint point) {
	return CGRectMake(rect.origin.x + point.x, rect.origin.y + point.y, rect.size.width, rect.size.height);
}

/**
 Returns the center-point of a CGRect
 */
NS_INLINE CGPoint KGRectCenter(CGRect rect) {
	return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

/**
 Returns the top-left-point of a center-point relative to size
 */
NS_INLINE CGPoint KGPointTopLeftFromCenterAndSize(CGPoint center, CGSize size) {
    CGPoint topLeft = CGPointZero;
    
    topLeft.x = center.x - size.width/2.f;
    topLeft.y = center.y - size.height/2.f;
    
    return topLeft;
}



////////////////////////////////////////////////////////////////////////
#pragma mark - CGSize Helper
////////////////////////////////////////////////////////////////////////

/**
 Scales a size to another size by keeping the aspect ratio
 */
NS_INLINE CGSize KGSizeAspectScaleToSize(CGSize size, CGSize toSize) {
	CGFloat aspect = 1.f;
    
	if (size.width > toSize.width) {
		aspect = toSize.width / size.width;
	}
    
	if (size.height > toSize.height) {
		aspect = MIN(toSize.height / size.height, aspect);
	}
    
	return CGSizeMake(size.width * aspect, size.height * aspect);
}

/**
 Creates a size that has integral width and height
 */
NS_INLINE CGSize KGSizeIntegral(CGSize size) {
    return CGSizeMake((CGFloat)round((double)size.width), 
                      (CGFloat)round((double)size.height));
}


////////////////////////////////////////////////////////////////////////
#pragma mark - CGPoint Helper
////////////////////////////////////////////////////////////////////////

/**
 Calculates the squared distance between two CGPoints
 */
NS_INLINE CGFloat KGSquaredDistanceBetweenCGPoints(CGPoint p1, CGPoint p2) {
    CGFloat dx = p1.x - p2.x;
    CGFloat dy = p1.y - p2.y;
    
    return dx*dx+dy*dy;
}

/**
 Calculates the distance between two CGPoints
 */
NS_INLINE CGFloat KGDistanceBetweenCGPoints(CGPoint p1, CGPoint p2) {
    return (CGFloat)sqrt((double)KGSquaredDistanceBetweenCGPoints(p1, p2));
}

/**
 Creates a point that has only integral coordinates
 */
NS_INLINE CGPoint KGPointIntegral(CGPoint point) {
    return CGPointMake((CGFloat)round((double)point.x), 
                       (CGFloat)round((double)point.y));
}

////////////////////////////////////////////////////////////////////////
#pragma mark - CGAffineTransform Helper
////////////////////////////////////////////////////////////////////////

/** 
 Creates an affine transform for the given device orientation.
 This is useful for creating a transformation matrix for a view that has been added
 directly to a UIWindow and doesn't automatically have its transformation modified.
 */

NS_INLINE CGAffineTransform KGRotationTransformForOrientation(UIInterfaceOrientation orientation) {
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return CGAffineTransformMakeRotation((CGFloat)(M_PI * 1.5));
        
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return CGAffineTransformMakeRotation((CGFloat)(M_PI / 2.0));
        
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return CGAffineTransformMakeRotation((CGFloat)(-M_PI));
        
    } else {
        return CGAffineTransformIdentity;
    }
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Logging Helper
////////////////////////////////////////////////////////////////////////

NS_INLINE void KGLogRect(CGRect rect) {
    NSLog(@"x: %f, y: %f, w: %f, h: %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

NS_INLINE void KGLogPoint(CGPoint point) {
    NSLog(@"x: %f, y: %f", point.x, point.y);
}

NS_INLINE void KGLogPointWithString(NSString *string, CGPoint point) {
    NSLog(@"%@ x: %f, y: %f", string, point.x, point.y);
}

NS_INLINE void KGLogSize(CGSize size) {
    NSLog(@"w: %f, h: %f", size.width, size.height);
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Comparison Helper
////////////////////////////////////////////////////////////////////////

NS_INLINE BOOL KGRectEqualsRect(CGRect rect1, CGRect rect2) {
    return (rect1.origin.x == rect2.origin.x && rect1.origin.y == rect2.origin.y && rect1.size.width == rect2.size.width && rect1.size.height == rect2.size.height);
}

NS_INLINE BOOL KGPointEqualsPoint(CGPoint point1, CGPoint point2) {
    return (point1.x == point2.x && point1.y == point2.y);
}

NS_INLINE BOOL KGSizeEqualsSize(CGSize size1, CGSize size2) {
    return (size1.width == size2.width && size1.height == size2.height);
}
