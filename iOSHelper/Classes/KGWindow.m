//
//  KGWindow.m
//  iOSHelper
//
//  Created by kampfgnu on 5/2/12.
//  Copyright (c) 2012 NOUS. All rights reserved.
//

#import "KGWindow.h"

@implementation KGWindow

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    [super remoteControlReceivedWithEvent:event];
    
	// Handle Remote Control Event
	if (event.type == UIEventTypeRemoteControl) {
		switch (event.subtype) {
			case UIEventSubtypeRemoteControlPlay:
                break;
                
			case UIEventSubtypeRemoteControlTogglePlayPause:
				break;
                
			case UIEventSubtypeRemoteControlPause:
                break;
                
			case UIEventSubtypeRemoteControlStop:
				break;
                
			case UIEventSubtypeRemoteControlPreviousTrack:
				break;
                
			case UIEventSubtypeRemoteControlNextTrack:
				break;
                
			case UIEventSubtypeRemoteControlBeginSeekingForward:
				break;
                
			case UIEventSubtypeRemoteControlEndSeekingForward:
				break;
                
			case UIEventSubtypeRemoteControlBeginSeekingBackward:
				break;
                
			case UIEventSubtypeRemoteControlEndSeekingBackward:
				break;
                
			default:
				break;
		}
	}
}

@end
