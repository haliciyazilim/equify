//
//  RotateMeIAPHelper.m
//  RotateMe
//
//  Created by Alperen Kavun on 13.02.2013.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "EquifyIAPHelper.h"
#import "EquifyIAPSpecificValues.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"

@implementation EquifyIAPHelper
{
    NSString *currentProductIdentifier;
    UILabel *descriptionLabel;
    UILabel *priceLabel;
    UIButton *buyButton;
    UIActivityIndicatorView *activity;
    UIAlertView *currentAlert;
    BOOL canShowCompletedAlert;
}

+ (EquifyIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static EquifyIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSDictionary *products = @{iProKey : iProSecret};
        sharedInstance = [[self alloc] initWithProductsDictionary:products];
        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(productPurchaseCompleted:) name:IAPHelperProductPurchasedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(enableBuyButton) name:IAPHelperEnableBuyButtonNotification object:nil];
    });
    return sharedInstance;
}

- (void)productPurchaseCompleted:(NSNotification *)notif {
    [self enableBuyButton];
    UIAlertView *productPurchased = [[UIAlertView alloc] initWithTitle:@""
                                       message:NSLocalizedString(@"PRODUCT_PURCHASED", nil)
                                      delegate:self
                             cancelButtonTitle:NSLocalizedString(@"OK", nil)
                             otherButtonTitles:nil,nil];
    [productPurchased show];
}

- (SKProduct *) getProductWithProductIdentifier:(NSString *)productIdentifier {
    for (SKProduct* product in self.products) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            return product;
        }
    }
    return nil;
}
- (void)closeStore {
    activity = nil;
    priceLabel = nil;
    descriptionLabel = nil;
    buyButton = nil;
    self.storeContainer = nil;
    [self.currentStore removeFromSuperview];
    self.currentStore = nil;

    currentProductIdentifier = nil;
}
- (void) buyCurrentProduct {
    [self disableBuyButton];
    if([[EquifyIAPHelper sharedInstance] canMakePurchases]){
        [[EquifyIAPHelper sharedInstance] buyProduct:[[EquifyIAPHelper sharedInstance] getProductWithProductIdentifier:currentProductIdentifier]];
    }
    else{
        UIAlertView *couldNotMakePurchasesAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"IN_APP_PURCHASES", nil)
                 message:NSLocalizedString(@"COULD_NOT_MAKE_PURCHASES", nil)
                delegate:self
       cancelButtonTitle:NSLocalizedString(@"OK", nil)
       otherButtonTitles:nil,nil];
        [couldNotMakePurchasesAlert show];
    }
}

- (void)restorePurchasesWithActivityFrame:(CGRect)frame {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (status != NotReachable) {
        [self.presentingController.view setUserInteractionEnabled:NO];
        
        [self addActivityToView:self.presentingController.view withFrame:frame];
        
        [[EquifyIAPHelper sharedInstance] restoreCompletedTransactions];
    } else {
        UIAlertView *noConnection = [[UIAlertView alloc] initWithTitle:@""
                                    message:NSLocalizedString(@"CONNECTION_ERROR", nil)
                                    delegate:self
                                    cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                    otherButtonTitles:nil,nil];
        [noConnection show];
    }
}
- (void) getProductAndBuyWithActivityFrame:(CGRect)frame {
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (status != NotReachable) {
    
        [self.presentingController.view setUserInteractionEnabled:NO];
        
        [self addActivityToView:self.presentingController.view withFrame:frame];
        
        if (!self.products) {
            [self requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
                self.products = products;
                [self productBlock];
            }];
        } else {
            [self productBlock];
        }
    } else {
        UIAlertView *noConnection = [[UIAlertView alloc] initWithTitle:@""
                                            message:NSLocalizedString(@"CONNECTION_ERROR", nil)
                                            delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                            otherButtonTitles:nil,nil];
        [noConnection show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self buyProduct:[self getProductWithProductIdentifier:iProKey]];
    } else {
        [self enableBuyButton];
    }
}
- (void) productBlock {
//    [self removeActivity];
    NSNumberFormatter *priceFormatter = [[NSNumberFormatter alloc] init];
    [priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    SKProduct *myProduct = [self getProductWithProductIdentifier:iProKey];
    
    [priceFormatter setLocale:myProduct.priceLocale];
    
    NSString *priceStr = [priceFormatter stringFromNumber:[myProduct price]];
    NSString *descriptionStr = [myProduct localizedDescription];
    
    NSString *messageStr = [NSString stringWithFormat:@"%@ \n %@",descriptionStr, priceStr];
    
    currentAlert = [[UIAlertView alloc]
                    initWithTitle:[myProduct localizedTitle]
                    message:messageStr
                    delegate:self
                    cancelButtonTitle:NSLocalizedString(@"CANCEL", nil)
                    otherButtonTitles:NSLocalizedString(@"BUY", nil), nil];
    
    [currentAlert show];
}
- (BOOL) isProductPurchased:(NSString *)productKey {
    return [self productPurchased:productKey];
}
- (BOOL)isPro {
    NSString *device = [[UIDevice currentDevice] name];
    NSString *proString = [NSString stringWithFormat:@"%@%@",iProSecret,device];
    
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:iProKey] isEqualToString:[self sha1:proString]]) {
        return YES;
    } else {
        return NO;
    }
}
- (void) disableBuyButton {
    [buyButton setEnabled:NO];
}
- (void) enableBuyButton {
    [self removeActivity];
    [self.presentingController.view setUserInteractionEnabled:YES];
}
@end
