//
//  TIAppDelegate.m
//  TapIt
//
//  Created by Hyung-Suk Kim on 5/13/13.
//  Copyright (c) 2013 Hyung-Suk Kim. All rights reserved.
//

#import "TIAppDelegate.h"

#import "TIFileManager.h"

@implementation TIAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // check if it is the first launch
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults boolForKey:@"Initialized"]) {
        
        // copy example files into documents directory
        [TIFileManager copyResourceToDocument:@"example"
                                       ofType:@"csv"];
        [TIFileManager copyResourceToDocument:@"example01"
                                       ofType:@"wav"];
        [TIFileManager copyResourceToDocument:@"example02"
                                       ofType:@"wav"];
        [TIFileManager copyResourceToDocument:@"example03"
                                       ofType:@"wav"];
        
        // set default settings values
        NSString* preSessionString = @"In this study you will be asked to tap to the audio. Please use the entire area of the touchscreen for your taps.\n\nTap the play button to start a task. When the audio stops and you are finished tapping, tap the next button to continue.";
        [defaults setObject:preSessionString
                     forKey:@"PreSession"];
        
        NSString* postSessionString = @"Thank you for participating!";
        [defaults setObject:postSessionString
                     forKey:@"PostSession"];
        
        [defaults setBool:YES
                   forKey:@"Randomize"];
        [defaults setBool:YES
                   forKey:@"AllowPause"];
        
        [defaults setBool:NO
                   forKey:@"UseCue"];
        
        // raise initialized flag
        [defaults setBool:YES
                   forKey:@"Initialized"];
        
        // save defaults
        [defaults synchronize];
    }
    
    return YES;
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
