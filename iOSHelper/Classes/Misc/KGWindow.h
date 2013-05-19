//
//  KGWindow.h
//  iOSHelper
//
//  Created by kampfgnu on 5/2/12.
//  Copyright (c) 2012 NOUS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KGWindowDelegate;

@interface KGWindow : UIWindow

@property (nonatomic, unsafe_unretained) id<KGWindowDelegate> delegate;
@end


@protocol KGWindowDelegate <NSObject>

- (void)window:(KGWindow *)window remoteControlReceivedWithEvent:(UIEvent *)event;

@end