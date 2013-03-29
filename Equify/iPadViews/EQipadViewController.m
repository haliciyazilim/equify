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
    return image.size.width;
}

-(float) btnGCSize{
    UIImage *image =[UIImage imageNamed:@"game_center_btn.png"];
    return image.size.width;
}

-(float) btnShadowSize{
    return 110.0;
}

-(float) buttonsViewHeight{
    return 293.0+90;
}

-(float) buttonsViewWidth{
    return 580.0+90;
}

-(float) margin{
    return 85;
}

-(float)fontSize{
    return 35.0;
}

-(float) buttonsViewPaddingTop{
    return 45.0;
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
