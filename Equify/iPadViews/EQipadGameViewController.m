//
//  EQipadGameViewController.m
//  Equify
//
//  Created by Abdullah Karacabey on 14.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "EQipadGameViewController.h"

@interface EQipadGameViewController ()

@end

@implementation EQipadGameViewController



-(CGSize)gameViewSize{
    
    return CGSizeMake(480*1.5,320*1.7);
}
-(CGFloat)checkMarkMargin {
    return 50.0;
}
-(CGFloat)dotsMargin {
    return 90.0;
}
-(CGFloat)dotsPadding {
    return 50.0;
}
-(CGSize)questionViewSize{
    
    UIImage * rightEdgeImage=[UIImage imageNamed:@"container_right.png"];
    
    UIImage * equalImage=[UIImage imageNamed:@"conatiner_equal.png"];
    
    
    return CGSizeMake([self boxSize]*9+[self boxSpace]*8, rightEdgeImage.size.height*2+equalImage.size.height);

}

-(int)boxSize{
    return 72;
}
-(int)boxSpace{
    return 7.5;
}
-(int) leftAndRightViewSpace{
    return 75;
}
-(float)menuButtonsPadding{
    return 1.5;
}
-(CGSize) menuButtonsSize{
    return CGSizeMake(200*1.5, 40*1.5);
}
-(float) containerY{
    return 7*1.5;
}

@end
