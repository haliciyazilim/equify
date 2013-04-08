//
//  AdManager.m
//  Equify
//
//  Created by Eren Halici on 27.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "AdManager.h"
#import "FlurryAds.h"

static AdManager *sharedInstance = nil;

@interface AdManager ()

@property (copy) CallbackBlock callbackBlock;

@end

@implementation AdManager

- (void)fetch {
    [FlurryAds fetchAdForSpace:@"Equify"
                         frame:[UIScreen mainScreen].bounds
                          size:FULLSCREEN];
}

+ (AdManager *)sharedInstance
{
    @synchronized (self) {
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
        }
    }
    
    return sharedInstance;
}

- (void)showAdWithProbability:(float)probability
                       onView:(UIView*)view
                    withBlock:(CallbackBlock)callbackBlock {
    self.callbackBlock = callbackBlock;
    
    
    if ([FlurryAds adReadyForSpace:@"Equify"]) {
        if (probability*1000 > arc4random() % 1000) {
            [FlurryAds displayAdForSpace:@"Equify"
                              onView:view];
            [FlurryAds setAdDelegate:self];
        } else {
            callbackBlock();
            self.callbackBlock = nil;
        }
    } else {
        [self fetch];
        callbackBlock();
        self.callbackBlock = nil;
    }
}

- (BOOL) spaceShouldDisplay:(NSString*)adSpace interstitial:(BOOL)
interstitial {
    if (interstitial) {
        // Pause app state here
    }
    
    // Continue ad display
    return YES;
}

- (void)spaceDidDismiss:(NSString *)adSpace interstitial:(BOOL)interstitial {
    if (interstitial) {
        // Resume app state here
        
        [self fetch];
        
        self.callbackBlock();
        self.callbackBlock = nil;
    }
}

@end
