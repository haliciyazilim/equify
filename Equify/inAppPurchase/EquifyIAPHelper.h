//
//  RotateMeIAPHelper.h
//  RotateMe
//
//  Created by Alperen Kavun on 13.02.2013.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "IAPHelper.h"

@interface EquifyIAPHelper : IAPHelper

+ (EquifyIAPHelper *) sharedInstance;

- (BOOL) isProductPurchased:(NSString *)productKey;
- (SKProduct *)getProductWithProductIdentifier:(NSString *)productIdentifier;
- (void)restorePurchases;
- (BOOL)isPro;

@end
