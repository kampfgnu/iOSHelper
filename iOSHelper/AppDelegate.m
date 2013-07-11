//
//  AppDelegate.m
//  iOSHelper
//
//  Created by kampfgnu on 4/30/12.
//  Copyright (c) 2012 NOUS. All rights reserved.
//

#import "AppDelegate.h"

#import "KGDrawEraseImageView.h"

@interface AppDelegate ()

- (void)test;

@end


@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self.window makeKeyAndVisible];

    [self test];
    
//    NSDate *date = [NSDate dateFromHTTPDateString:@"Wed, 29 May 2013 12:34:01 GMT"];

    return YES;
}

- (void)test {
//    NSLog(@"file exists: %i", [NSFileManager fileExistsAtNoBackupDirectory:@"muh"]);
//    
//    NSLog(@"filepath: %@", [NSFileManager documentsNoBackupDirectoryPath]);
//    
//    NSData *data = [@"blablabla" dataUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"saved file to nobackupdir: %i", [NSFileManager writeDataToNoBackupDirectory:data filename:@"muh"]);
//    
//    NSLog(@"file exists: %i", [NSFileManager fileExistsAtNoBackupDirectory:@"muh"]);
    
//    KGTimeConverter *t = [KGTimeConverter timeConverterWithNumber:[NSNumber numberWithFloat:86401]];
//    t.timeUnit = KGTimeUnitSecond;
//    t.timeFormat = KGTimeFormatDaysHoursMinutesSeconds;
//    
//    NSLog(@"milliseconds: %f, seconds: %f, minutes: %f, hours: %f, days: %f", t.milliseconds, t.seconds, t.minutes, t.hours, t.days);
//    NSLog(@"timeString: %@", t.timeString);
    
    KGDrawEraseImageView *imgView = [[KGDrawEraseImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 500.f, 500.f)];
    imgView.unerase = YES;
    imgView.image = [UIImage imageNamed:@"transparent.png"];
    imgView.originalImage = [UIImage imageNamed:@"test2.png"];
    [self.window addSubview:imgView];
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
