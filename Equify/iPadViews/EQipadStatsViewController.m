//
//  EQipadStatsViewController.m
//  Equify
//
//  Created by Abdullah Karacabey on 14.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "EQipadStatsViewController.h"

@interface EQipadStatsViewController ()

@end

@implementation EQipadStatsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (CGSize) getMainViewSize {
    return CGSizeMake(720.0, 480.0);
}
- (CGSize) getInnerSize {
    CGSize size = [self getMainViewSize];
    return CGSizeMake(size.height-50.0, size.width-50.0);
}
- (CGFloat) lineHeight {
    return 60.0;
}
-(CGFloat) headerHeight {
    return 68.0;
}
-(CGFloat) headerSingleLineHeight {
    return 3.0;
}
-(CGFloat) headerDoubleLineHeight {
    return 5.0;
}
-(CGFloat) seperatorHeight {
    return 3.0;
}
-(CGFloat) closeButtonHeight {
    return 45.0;
}
- (CGFloat) buttonsTop {
    return 8.0;
}
-(CGFloat) closeButtonsTop {
    return 10.0;
}
-(CGFloat) headerFontSize {
    return 45.0;
}
-(CGFloat) fontSize {
    return 30.0;
}
-(CGFloat) labelWidth {
    return 450.0;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
