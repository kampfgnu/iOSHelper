//
//  KGGradientView.h
//  iOSHelper
//
//  Created by Thomas Heingärtner on 10/9/13.
//  Copyright (c) 2013 NOUS. All rights reserved.
//

@interface KGGradientView : UIView

// init this class e.g. like this:
// KGGradientView *g = [[KGGradientView alloc] initWithFrame:CGRectMake(0.f, 0.f, 200.f, 400.f) colors:@[[UIColor redColor], [UIColor blueColor]] locations:@[@0, @1]];
- (id)initWithFrame:(CGRect)frame colors:(NSArray *)colors locations:(NSArray *)locations;

@end
