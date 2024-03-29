//
//  AdManager.m
//  Equify
//
//  Created by Eren Halici on 27.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#define kAdRepeatMin 4
#define kAdRepeatMax 6

#import "AdManager.h"
#import "FlurryAds.h"
#import "EquifyIAPHelper.h"

static AdManager *sharedInstance = nil;

@interface AdManager ()

@property (copy) CallbackBlock callbackBlock;
@property int adCountDown;

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

- (id)init
{
    self = [super init];
    if (self) {
        self.adCountDown = arc4random_uniform(kAdRepeatMax - kAdRepeatMin) + kAdRepeatMin - 1;
        
        [self fetch];
    }
    return self;
}

- (void)showAdOnView:(UIView*)view
           withBlock:(CallbackBlock)callbackBlock {
    self.callbackBlock = callbackBlock;

    if ([[EquifyIAPHelper sharedInstance] isPro]){
        callbackBlock();
        self.callbackBlock = nil;
    } else {
        if (self.adCountDown == 0) {
            if ([FlurryAds adReadyForSpace:@"Equify"]) {
                self.adCountDown = arc4random_uniform(kAdRepeatMax - kAdRepeatMin) + kAdRepeatMin - 1;
                [FlurryAds displayAdForSpace:@"Equify"
                                      onView:view];
                [FlurryAds setAdDelegate:self];
                
            } else {
                self.adCountDown = 0;
                [self fetch];
                callbackBlock();
                self.callbackBlock = nil;
            }
            
        } else {
            self.adCountDown--;
            callbackBlock();
            self.callbackBlock = nil;
        }
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
