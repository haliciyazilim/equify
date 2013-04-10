//
//  EQSettingsViewController.m
//  Equify
//
//  Created by Abdullah Karacabey on 15.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#define RESET_STATS_APPROVE_ALERT_TAG 35

#import "EQGameCenterSpecificValues.h"
#import "EQSettingsViewController.h"
#import "EQStatistic.h"
#import "EQScore.h"
#import "StopWatch.h"
#import "MoreGamesView.h"
#import "Flurry.h"
#import "Util.h"

@interface EQSettingsViewController ()

@end

@implementation EQSettingsViewController{
    CGFloat buttonWidth;
    CGFloat buttonHeight;
    CGFloat winWidth;
    CGFloat winHeight;
    UIView * aboutScreenBackground;
    UIScrollView * credits;
    StopWatch * stopWatch;
    int didScrolled;
    BOOL ishowtoPlayOpen;
    UIView * howtoPlayView;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(CGSize)winSize{
    return CGSizeMake([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
}

-(CGSize)buttonSize{
    return CGSizeMake(175.0, 40.0);
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    winWidth = [self winSize].width;
    winHeight = [self winSize].height;
    
    buttonWidth=[self buttonSize].width;
    buttonHeight=[self buttonSize].height;
    
    
    UIView *settingView=[[UIView alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.height-winWidth)/2, ([[UIScreen mainScreen] bounds].size.width-winHeight)/2, winWidth, winHeight)];
//    [settingView setBackgroundColor:[UIColor yellowColor]];
    
    UIImage * imgClose=[UIImage imageNamed:@"close_btn.png"];
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setBackgroundImage:imgClose forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close_btn_pressed.png"] forState:UIControlStateHighlighted];
    [closeButton addTarget:self action:@selector(closeSettings) forControlEvents:UIControlEventTouchUpInside];
    closeButton.frame = CGRectMake(winWidth-45.0, 5.0, imgClose.size.width, imgClose.size.height);
    
    float buttonsViewHeight=buttonHeight*0.4+buttonHeight*4;
    UIView * buttonsView=[[UIView alloc] initWithFrame:CGRectMake((winWidth-buttonWidth)/2, (winHeight-buttonsViewHeight)/2, buttonWidth, buttonsViewHeight)];
//    [buttonsView setBackgroundColor:[UIColor redColor]];
    
    UIImage * imgSeperator=[UIImage imageNamed:@"single_line.png"];
    UIView *seperator1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, 1.0)];
    [seperator1 setBackgroundColor:[UIColor colorWithPatternImage:imgSeperator]];
    
    UIButton * btnReset=[self makeButton:CGRectMake(0, buttonHeight*0.1, buttonWidth, buttonHeight) title:NSLocalizedString(@"RESET", nil)];
    [btnReset addTarget:self action:@selector(resetStatsApprove) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *seperator2 = [[UIView alloc] initWithFrame:CGRectMake(0, buttonHeight*0.1+buttonHeight, buttonWidth, 1.0)];
    [seperator2 setBackgroundColor:[UIColor colorWithPatternImage:imgSeperator]];

    UIButton * btnAbout=[self makeButton:CGRectMake(0, buttonHeight*0.2+buttonHeight, buttonWidth, buttonHeight) title:NSLocalizedString(@"ABOUT", nil)];
    [btnAbout addTarget:self action:@selector(showAboutScreen) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *seperator3 = [[UIView alloc] initWithFrame:CGRectMake(0, buttonHeight*0.2+buttonHeight*2, buttonWidth, 1.0)];
    [seperator3 setBackgroundColor:[UIColor colorWithPatternImage:imgSeperator]];

    UIButton * btnMoreGames=[self makeButton:CGRectMake(0, buttonHeight*0.3+buttonHeight*2, buttonWidth, buttonWidth) title:NSLocalizedString(@"MOREGAMES", nil)];
    
    [btnMoreGames addTarget:self action:@selector(showMoreGames) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *seperator4 = [[UIView alloc] initWithFrame:CGRectMake(0, buttonHeight*0.3+buttonHeight*3, buttonWidth, 1.0)];
    [seperator4 setBackgroundColor:[UIColor colorWithPatternImage:imgSeperator]];
    
    UIButton * btnHowtoPlay=[self makeButton:CGRectMake(0, buttonHeight*0.3+buttonHeight*3, buttonWidth, buttonWidth) title:NSLocalizedString(@"HOWTOPLAY", nil)];
    
    [btnHowtoPlay addTarget:self action:@selector(howtoPlay) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *seperator5 = [[UIView alloc] initWithFrame:CGRectMake(0, buttonHeight*0.3+buttonHeight*4, buttonWidth, 1.0)];
    [seperator5 setBackgroundColor:[UIColor colorWithPatternImage:imgSeperator]];

    [settingView addSubview:closeButton];
    [buttonsView addSubview:seperator1];
    [buttonsView addSubview:btnReset];
    [buttonsView addSubview:seperator2];
    [buttonsView addSubview:btnAbout];
    [buttonsView addSubview:seperator3];
    [buttonsView addSubview:btnMoreGames];
    [buttonsView addSubview:seperator4];
    [buttonsView addSubview:btnHowtoPlay];
    [buttonsView addSubview:seperator5];

    [settingView addSubview:buttonsView];
    [self.view addSubview:settingView];
    [self setBackgrounds];
    ishowtoPlayOpen=NO;
    
}

-(void) howtoPlay{

    NSLog(@"Width: %f, height: %f",[self winSize].width,[self winSize].height);
    NSLog(@"Width: %f, height: %f",[[UIScreen mainScreen]bounds].size.width,[[UIScreen mainScreen]bounds].size.height);

    UIImage * image=[UIImage imageNamed:LocalizedImageName(@"how_to_play", @"jpg")];
//    UIImage * image=[UIImage imageNamed:@"how_to_play-tr.jpg"];
    NSLog(@"image Widht: %f, heigth:%f", image.size.width, image.size.height);

    
    howtoPlayView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.width)];
       UIImageView * htp=[[UIImageView alloc] initWithImage:image];
    [htp setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    [howtoPlayView addSubview:htp];
    [self.view addSubview:howtoPlayView];
    ishowtoPlayOpen=YES;
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(ishowtoPlayOpen==YES){
        ishowtoPlayOpen=NO;
        [howtoPlayView  removeFromSuperview];
        
    }
}

- (void) showMoreGames {
    [Flurry logEvent:kFlurryEventMoreGamesPressed];
    [self.view addSubview:[[MoreGamesView alloc] init]];
}
-(void)resetStatsApprove {
    UIAlertView *resetStatsApprove = [[UIAlertView alloc] initWithTitle:@""
                                                              message:NSLocalizedString(@"RESET_STATS_APPROVE", nil)
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"CANCEL", nil)
                                                    otherButtonTitles:NSLocalizedString(@"OK", nil),nil];
    [resetStatsApprove setTag:RESET_STATS_APPROVE_ALERT_TAG];
    [resetStatsApprove show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == RESET_STATS_APPROVE_ALERT_TAG){
        if (buttonIndex != [alertView cancelButtonIndex]){
            [self resetStats];
        }
    }
}
- (void) resetStats {
    [Flurry logEvent:kFlurryEventStatsReset];
    [EQStatistic resetStatistics];
    [EQScore cleanAllScores];
}
-(void) setBackgrounds{
    if([[UIScreen mainScreen] bounds].size.height == 568){
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg-568h.jpg"]];
    }
    else{
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg.jpg"]];
    }
}

-(UIButton *) makeButton:(CGRect)frame title:(NSString *) title{
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:frame];
    UILabel * lblReset=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, buttonWidth, buttonHeight)];
    UIFont * font=[UIFont fontWithName:@"HelveticaNeue-Light" size:25.0];
    
    [lblReset setText:title];
    [lblReset setFont:font];
    [lblReset setBackgroundColor:[UIColor clearColor]];
    [lblReset setTextColor:[UIColor blackColor]];
    [lblReset setShadowColor:[UIColor colorWithWhite:1.0 alpha:0.7]];
    [lblReset setShadowOffset:CGSizeMake(0.0, 1.0)];
    [lblReset setTextAlignment:NSTextAlignmentCenter];
    [btn addSubview:lblReset];
    
    return btn;
    
}

- (void) closeSettings {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) closeAbout {
    [aboutScreenBackground removeFromSuperview];
}

-(float)buttonFontSize{
    return 25.0;
}
-(float)headerFontSize{
    return 25.0;
}

-(float)creditsLFontSize{
    return 22.0;
}
-(float)creditsMFontSize{
    return 20.0;
}
-(CGSize)creditsContentSize{
    return CGSizeMake([self winSize].width-40, 800);
}
-(float)creditsPaddingTop{
    return 80.0;
}

-(void) showAboutScreen{
    [Flurry logEvent:kFlurryEventAboutUsPressed];
    aboutScreenBackground=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width)];
    
    UIView *aboutScreen=[[UIView alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.height-winWidth)/2, ([[UIScreen mainScreen] bounds].size.width-winHeight)/2, winWidth, winHeight)];
    
    if([[UIScreen mainScreen] bounds].size.height == 568){
        aboutScreenBackground.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg-568h.jpg"]];
    }
    else{
        aboutScreenBackground.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg.jpg"]];
    }
    
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake((winWidth-(winWidth-35.0))/2, 0.0, winWidth-35.0, 45.0)];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [headerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:[self headerFontSize]]];
    [headerLabel setTextColor:[UIColor colorWithRed:0.463 green:0.365 blue:0.227 alpha:1.0]];
    [headerLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
    [headerLabel setShadowColor:[UIColor whiteColor]];
    [headerLabel setTextAlignment:NSTextAlignmentCenter];
    [headerLabel setText:NSLocalizedString(@"ABOUT", nil)];
    
    UIView *headerDoubleLine = [[UIView alloc] initWithFrame:CGRectMake((winWidth-(winWidth/3))/2, 45.0, winWidth/3, 3.0)];
    [headerDoubleLine setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"double_line.png"]]];
    
    UIImage * imgClose=[UIImage imageNamed:@"close_btn.png"];
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setBackgroundImage:imgClose forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close_btn_pressed.png"] forState:UIControlStateHighlighted];
    [closeButton addTarget:self action:@selector(closeAbout) forControlEvents:UIControlEventTouchUpInside];
    closeButton.frame = CGRectMake(winWidth-45.0, 5.0, imgClose.size.width, imgClose.size.height);
    
    UIView * mask=[[UIView alloc]initWithFrame:CGRectMake(20, 60, winWidth-40, winHeight-60)];
    [mask setBackgroundColor:[UIColor clearColor]];
    mask.clipsToBounds=YES;
    
    credits=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, winWidth, winHeight-60)];
    [credits setBackgroundColor:[UIColor clearColor]];
    //    [credits setUserInteractionEnabled:NO];
    [credits setContentSize:[self creditsContentSize]];
    [credits setShowsHorizontalScrollIndicator:NO];
    [credits setShowsVerticalScrollIndicator:NO];
    
    float fontSizeL = [self creditsLFontSize];
    float fontSizeM = [self creditsMFontSize];
    NSString *fontHeader = @"HelveticaNeue-Medium";
    NSString *font = @"HelveticaNeue-Light";
    UIColor *color = [UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:1.0];
    
    // Company Name
    UILabel * cName=[[UILabel alloc] initWithFrame:CGRectMake(0.0, fontSizeL/1.81+[self creditsPaddingTop], mask.frame.size.width, fontSizeL)];
    [cName setFont:[UIFont fontWithName:fontHeader size:fontSizeL]];
    [cName setTextColor:color];
    [cName setTextAlignment:NSTextAlignmentCenter];
    [cName setBackgroundColor:[UIColor clearColor]];
    [cName setText:@"HALICI BİLGİ İŞLEM A.Ş."];
    
    // Adress
    UILabel * cAdress=[[UILabel alloc] initWithFrame:CGRectMake(0.0, fontSizeM/2.5+[self creditsPaddingTop], mask.frame.size.width, fontSizeM/0.16)];
    [cAdress setFont:[UIFont fontWithName:font size:fontSizeM]];
    [cAdress setTextColor:color];
    [cAdress setTextAlignment:NSTextAlignmentCenter];
    [cAdress setBackgroundColor:[UIColor clearColor]];
    [cAdress setNumberOfLines:3];
    [cAdress setText:@"ODTÜ-Halıcı Yazılımevi \nİnönü Bulvarı 06531 \nODTÜ-Teknokent/ANKARA"];
    
    // Mail
    UILabel * cMail=[[UILabel alloc] initWithFrame:CGRectMake(0.0, fontSizeM/0.13+[self creditsPaddingTop], mask.frame.size.width, fontSizeM/0.5)];
    [cMail setFont:[UIFont fontWithName:font size:fontSizeM]];
    [cMail setTextColor:color];
    [cMail setTextAlignment:NSTextAlignmentCenter];
    [cMail setBackgroundColor:[UIColor clearColor]];
    [cMail setText:@"iletisim@halici.com.tr"];
    
    
    // Programming
    UILabel * cProgramming=[[UILabel alloc] initWithFrame:CGRectMake(0.0, fontSizeL/0.11+[self creditsPaddingTop], mask.frame.size.width, fontSizeL/0.55)];
    [cProgramming setFont:[UIFont fontWithName:fontHeader size:fontSizeL]];
    [cProgramming setTextColor:color];
    [cProgramming setTextAlignment:NSTextAlignmentCenter];
    [cProgramming setBackgroundColor:[UIColor clearColor]];
    [cProgramming setText:NSLocalizedString(@"PROGRAMMING",nil)];
    
    
    // Names
    NSArray * names=[[NSArray alloc] initWithObjects:@"Eren HALICI",@"Yunus Eren GÜZEL", @"Abdullah KARACABEY",@"Alperen KAVUN", nil];
    for(int i=0; i<names.count;i++){
        UILabel * cName=[[UILabel alloc] initWithFrame:CGRectMake(0.0, fontSizeM/0.087+i*fontSizeM/0.66+[self creditsPaddingTop], mask.frame.size.width, fontSizeM/0.5)];
        [cName setFont:[UIFont fontWithName:font size:fontSizeM]];
        [cName setTextColor:color];
        [cName setTextAlignment:NSTextAlignmentCenter];
        [cName setBackgroundColor:[UIColor clearColor]];
        [cName setNumberOfLines:2];
        [cName setText:names[i]];
        [credits addSubview:cName];
    }
    
    
    // Art
    UILabel * cArt=[[UILabel alloc] initWithFrame:CGRectMake(0.0, fontSizeL/0.059+[self creditsPaddingTop], mask.frame.size.width, fontSizeL/0.55)];
    [cArt setFont:[UIFont fontWithName:fontHeader size:fontSizeL]];
    [cArt setTextColor:color];
    [cArt setTextAlignment:NSTextAlignmentCenter];
    [cArt setBackgroundColor:[UIColor clearColor]];
    [cArt setText:NSLocalizedString(@"ART", nil)];
    
    UILabel * cArtName=[[UILabel alloc] initWithFrame:CGRectMake(0.0, fontSizeM/0.05+[self creditsPaddingTop], mask.frame.size.width, fontSizeM/0.5)];
    [cArtName setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:fontSizeM]];
    [cArtName setTextColor:color];
    [cArtName setTextAlignment:NSTextAlignmentCenter];
    [cArtName setBackgroundColor:[UIColor clearColor]];
    [cArtName setNumberOfLines:2];
    [cArtName setText:@"Ebuzer Egemen DURSUN"];
    
    
    // Copyright
    UILabel * cCRight=[[UILabel alloc] initWithFrame:CGRectMake(0.0, fontSizeL/0.037+[self creditsPaddingTop], mask.frame.size.width, fontSizeL/0.55)];
    [cCRight setFont:[UIFont fontWithName:font size:fontSizeL]];
    [cCRight setTextColor:color];
    [cCRight setTextAlignment:NSTextAlignmentCenter];
    [cCRight setBackgroundColor:[UIColor clearColor]];
    [cCRight setText:@"Copyright © 2013"];
    
    // BrainQuire
    UILabel * cBrainQuire=[[UILabel alloc] initWithFrame:CGRectMake(0.0, fontSizeL/0.035+[self creditsPaddingTop], mask.frame.size.width, fontSizeL/0.55)];
    [cBrainQuire setFont:[UIFont fontWithName:font size:fontSizeL]];
    [cBrainQuire setTextColor:color];
    [cBrainQuire setTextAlignment:NSTextAlignmentCenter];
    [cBrainQuire setBackgroundColor:[UIColor clearColor]];
    [cBrainQuire setText:@"www.brainquire.com"];
    
    
    
    
    [credits addSubview:cName];
    [credits addSubview:cAdress];
    [credits addSubview:cMail];
    [credits addSubview:cProgramming];
    [credits addSubview:cArt];
    [credits addSubview:cArtName];
    [credits addSubview:cCRight];
    [credits addSubview:cBrainQuire];
    [mask addSubview:credits];
    [aboutScreen addSubview:headerLabel];
    [aboutScreen addSubview:headerDoubleLine];
    [aboutScreen addSubview:closeButton];
    [aboutScreen addSubview:mask];
    
    [aboutScreenBackground addSubview:aboutScreen];
    [self.view addSubview:aboutScreenBackground];
    
    stopWatch = [[StopWatch alloc] init];
    [stopWatch startTimerWithRepeatBlock:^{
        
    }];
    [credits setUserInteractionEnabled:YES];
    [UIScrollView beginAnimations:nil context:NULL];
    [UIScrollView setAnimationDuration:25.0f];
    [UIScrollView setAnimationCurve:UIViewAnimationCurveLinear];
    [credits setDelegate:self];
    [credits setContentOffset:CGPointMake(0, [self creditsContentSize].height-credits.frame.size.height)];
    [UIScrollView commitAnimations];
    didScrolled=0;
    
    
    
}- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    didScrolled++;
    
    if(didScrolled==2)
        [self scrollViewTap];
}

-(void) scrollViewTap
{
    [credits.layer removeAllAnimations];
    [stopWatch pauseTimer];
    float timer=[stopWatch getElapsedMiliseconds]/1000.0;
    [credits.layer removeAllAnimations];
    [credits setContentOffset:CGPointMake(0, (700.0-credits.frame.size.height)*timer/30.0)];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
