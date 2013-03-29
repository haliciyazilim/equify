//
//  EQipadSettingsViewController.m
//  Equify
//
//  Created by Abdullah Karacabey on 27.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "EQipadSettingsViewController.h"

@interface EQipadSettingsViewController ()

@end

@implementation EQipadSettingsViewController

-(CGSize)winSize{
    return CGSizeMake(480*1.5,320*1.5);
}

-(CGSize)buttonSize{
    return CGSizeMake(175.0*1.5, 40.0*1.5);
}

-(float)buttonFontSize{
    return 25.0*1.5;
}
-(float)headerFontSize{
    return 25.0*1.5;
}

-(float)creditsLFontSize{
    return 22.0*1.5;
}
-(float)creditsMFontSize{
    return 20.0*1.5;
}

-(CGSize)creditsContentSize{
    return CGSizeMake([self winSize].width-40*1.5, 800*1.5);
}

@end
