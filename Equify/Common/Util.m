//
//  Util.m
//  Equify
//
//  Created by Abdullah Karacabey on 4/10/13.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "Util.h"



NSString* LocalizedImageName(NSString* name, NSString* extension){
    NSString* suffix = NSLocalizedString(@"IMAGE_FILENAME_SUFFIX", nil);
    if([suffix compare:@""] == 0)
        return [NSString stringWithFormat:@"%@.%@",name,extension];
    else
        return [NSString stringWithFormat:@"%@-%@.%@",name,suffix,extension];
}

@implementation Util

@end
