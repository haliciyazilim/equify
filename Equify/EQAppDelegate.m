//
//  EQAppDelegate.m
//  Equify
//
//  Created by Alperen Kavun on 13.02.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "EQAppDelegate.h"
#import "EQBundleInitializer.h"
#import "EQDatabaseManager.h"
#import "GameCenterManager.h"
#import "EQGameViewController.h"
#import "TypeDefs.h"

#import <QuartzCore/QuartzCore.h>

#import "Flurry.h"
#import "FlurryAds.h"

@implementation EQAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIImage *image;
    if([[UIScreen mainScreen] bounds].size.height == 568){
        image = [UIImage imageNamed:@"game_bg-568h.jpg"];
    }
    else{
        image = [UIImage imageNamed:@"game_bg.jpg"];
    }
    
    _window.backgroundColor = [UIColor colorWithPatternImage:image];
    
    [Flurry setDebugLogEnabled:NO];
    [Flurry setShowErrorInLogEnabled:NO];
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    [Flurry startSession:@"6MG7535QST48WHJ22TS4"];
    [FlurryAds initialize:self.window.rootViewController];
    
    [EQBundleInitializer initializeBundle];
    
    [[GameCenterManager sharedInstance] authenticateLocalUser];
    
    return YES;
}

void uncaughtExceptionHandler(NSException *exception) {
    [Flurry logError:@"Uncaught" message:@"Crash!" exception:exception];
}

-(BOOL)shouldAutorotate
{
    return YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    if (getCurrentGameState() == GAME_STATE_PLAYING) {
        [[EQGameViewController runningInstance] pauseGame];
    } else if (getCurrentGameState() == GAME_STATE_TRANSITION) {
        setCurrentGameState(GAME_STATE_TRANSITION2);
        [[EQGameViewController runningInstance] inGameMenu];
    }
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
