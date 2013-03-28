//
//  EQipadViewController.m
//  Equify
//
//  Created by Abdullah Karacabey on 14.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "EQipadViewController.h"

@interface EQipadViewController ()

@end

@implementation EQipadViewController

-(float) btnSize{
    
    UIImage *image=[UIImage imageNamed:@"main_btn.png"];
    NSLog(@"imagesise: %f",image.size.width);
    return image.size.width;
}

-(float) btnGCSize{
    return [UIImage imageNamed:@"game_center_btn.png"].size.width;
}

-(float) btnShadowSize{
    return 110.0;
}

-(float) buttonsViewHeight{
    return 293.0;
}

-(float) buttonsViewWidth{
    return 580.0;
}

-(float) screenWidth{
    return [[UIScreen mainScreen] bounds].size.height;
}


-(void) setBackgrounds{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg.jpg"]];
}

-(UIImageView *) setLogo{
    UIImage * logo=[UIImage imageNamed:@"equify_logo.png"];
    UIImageView * logoView=[[UIImageView alloc] initWithImage:logo];
    logoView.frame=CGRectMake(80, 80, logo.size.width, logo.size.height);
    return logoView;
    
}


@end
