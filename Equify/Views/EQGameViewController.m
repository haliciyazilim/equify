//
//  EQGameViewController.m
//  Equify
//
//  Created by Alperen Kavun on 12.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "EQGameViewController.h"

@interface EQGameViewController ()

@end

@implementation EQGameViewController{
    
    UIView * gameView;
    UIView * questionView;
    UIView * questionViewLeftSide;
    UIView * questionViewRightSide;
    UIView * menu;
    
    UIButton * btnControl;
    UIButton *btnSkip;
    UIButton *btnMenu;
    NSMutableArray *counterImages;
    int moveCount;
    int deleteCount;
    
    CGFloat winWidth;
    CGFloat winHeight;
    
    UIImageView* answerFrame;
    BOOL isSolutionCorrect;
}

-(CGSize)gameViewSize{
    
    return CGSizeMake([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
}

-(CGSize)questionViewSize{
    
    UIImage * rightEdgeImage=[UIImage imageNamed:@"container_right.png"];
    
    UIImage * equalImage=[UIImage imageNamed:@"conatiner_equal.png"];

    
    return CGSizeMake([self boxSize]*9+[self boxSpace]*8, rightEdgeImage.size.height*2+equalImage.size.height);
}

-(int)boxSize{
    return 48;
}
-(int)boxSpace{
    return 5;
}
-(int) leftAndRightViewSpace{
    return 50;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


-(void) setBackground{
    if([[UIScreen mainScreen] bounds].size.height == 568){
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg-568h.jpg"]];
    }
    else{
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg.jpg"]];
    }
}

-(float) buttonSize{
    return [UIImage imageNamed:@"main_btn.png"].size.width;
}

-(float) containerY{
    return 7;
}
- (void)viewDidLoad
{
    isSolutionCorrect = NO;
    [self setBackground];
    
    [self.stopWatchLabel setText:@"00:00"];
    [self.stopWatchLabel setTextColor:[UIColor colorWithRed:0.403 green:0.403 blue:0.403 alpha:1.0]];
    
    [self.stopWatchLabelMS setText:@".0"];
    [self.stopWatchLabelMS setTextColor:[UIColor colorWithRed:0.403 green:0.403 blue:0.403 alpha:1.0]];
    
    self.stopWatch = [[StopWatch alloc] init];  
    
    winWidth = [self gameViewSize].width;
    winHeight = [self gameViewSize].height;
    NSLog(@"width: %f, height: %f",winWidth,winHeight);
    
    gameView=[[UIView alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.height-winWidth)/2, ([[UIScreen mainScreen] bounds].size.width-winHeight)/2, winWidth, winHeight)];
//    gameView.backgroundColor=[UIColor cyanColor];
    gameView.clipsToBounds=YES;
    
    questionView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, winWidth, winWidth)];

        
    btnControl=[EQViewController makeButton:CGRectMake((winWidth-[self buttonSize])/2, winHeight-[self buttonSize]*1.7/3, [self buttonSize], [self buttonSize]) title:NSLocalizedString(@"CONTROL", nil)];
    [btnControl addTarget:self action:@selector(control) forControlEvents:UIControlEventTouchUpInside];
    UILabel *lblControl = (UILabel *)[btnControl viewWithTag:1];
    [lblControl setFrame:CGRectMake(0,-10, [self buttonSize], [self buttonSize])];
    
    btnSkip=[EQViewController makeButton:CGRectMake((winWidth-[self buttonSize])/2, 0-[self buttonSize]*1.9/3, [self buttonSize], [self buttonSize]) title:NSLocalizedString(@"SKIP", nil)];
    [btnSkip addTarget:self action:@selector(skipQuestion) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage * imgSkip=[UIImage imageNamed:@"skip_btn.png"];
    UIImageView * imgViewSkip=[[UIImageView alloc] initWithImage:imgSkip];
    [imgViewSkip setFrame:CGRectMake(([self buttonSize]-imgSkip.size.width)/2, [self buttonSize]*2/3, imgSkip.size.width, imgSkip.size.height)];
    [btnSkip addSubview:imgViewSkip];
    
    UIImage * imgMenu=[UIImage imageNamed:@"menu_btn.png"];
    btnMenu=[[UIButton alloc] initWithFrame:CGRectMake(winWidth-imgMenu.size.width-25, 25, imgMenu.size.width, imgMenu.size.height)];
    [btnMenu setBackgroundImage:imgMenu forState:UIControlStateNormal];
    [btnMenu addTarget:self action:@selector(inGameMenu) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImage * imgBtnShadow=[UIImage imageNamed:@"btngolge-ipad.png"];
    
    UIImageView *shadowAbove=[[UIImageView alloc] initWithImage:imgBtnShadow];
    [shadowAbove setFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.height-imgBtnShadow.size.width)/2, gameView.frame.origin.y, imgBtnShadow.size.width, imgBtnShadow.size.height)];
    shadowAbove.transform = CGAffineTransformMakeRotation(M_PI);
    
    UIImageView *shadowBelow=[[UIImageView alloc] initWithImage:imgBtnShadow];
    [shadowBelow setFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.height-imgBtnShadow.size.width)/2, gameView.frame.origin.y+gameView.frame.size.height-shadowBelow.frame.size.height, imgBtnShadow.size.width, imgBtnShadow.size.height)];
    
    
    [gameView addSubview:btnMenu];
    [gameView addSubview:btnControl];
    [gameView addSubview:btnSkip];
    
    
    
    
    [gameView addSubview:questionView];
    [self.view addSubview:gameView];
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [self.view addSubview:shadowAbove];
        [self.view addSubview:shadowBelow];
    }

}

-(void) viewWillAppear:(BOOL)animated{
    [self configureViews];
    [self.stopWatch startTimerWithRepeatBlock:^{
        [self.stopWatchLabel setText:[self.stopWatch toStringWithoutMiliseconds]];
        [self.stopWatchLabelMS setText:[self.stopWatch toStringMiliseconds]];
    }];
    
    }
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) setCurrentQuestion:(EQQuestion *)currentQuestion{
    _currentQuestion=currentQuestion;
    [_currentQuestion createQuestionArray];
}

-(void) configureViews{
    
    if(questionViewLeftSide==nil){
        questionViewLeftSide=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, [self boxSize])];
    
        questionViewRightSide=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, [self boxSize])];

        [questionView addSubview:questionViewLeftSide];
        [questionView addSubview:questionViewRightSide];
    }
    else{
        [questionViewLeftSide removeFromSuperview];
        [questionViewRightSide removeFromSuperview];
        questionViewLeftSide=nil;
        questionViewRightSide=nil;
        
        questionViewLeftSide=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, [self boxSize])];
        
        questionViewRightSide=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, [self boxSize])];
        
        [questionView addSubview:questionViewLeftSide];
        [questionView addSubview:questionViewRightSide];
    }
//    questionViewLeftSide.backgroundColor=[UIColor yellowColor];
//    questionViewRightSide.backgroundColor=[UIColor redColor];

    
    [self placingBoxes];
    
    [self placingCounters];
}

-(UIImageView *)makeContainer:(CGRect) frame image:(UIImage *)image {
    UIImageView * imageView=[[UIImageView alloc] initWithImage:image];
    imageView.frame=frame;
    
    return imageView;
}

-(void)placingBoxes{
    
    [EQBox cleanInstances];
    BOOL isRightSide=NO;
    NSArray * questionLeftAndRightSide=[_currentQuestion.wholeQuestion componentsSeparatedByString:@"="];
    int leftSideLength=((NSString *)questionLeftAndRightSide[0]).length;
    int rightSideLength=((NSString *)questionLeftAndRightSide[1]).length;

    UIImage * leftEdgeImage=[UIImage imageNamed:@"container_left.png"];
    UIImage * innerImage=[UIImage imageNamed:@"container_tile.png"];
    UIImage * rightEdgeImage=[UIImage imageNamed:@"container_right.png"];
    
    UIImage * equalImage=[UIImage imageNamed:@"conatiner_equal.png"];
    
    questionViewLeftSide.frame=CGRectMake((([self questionViewSize].width-([self boxSize]+[self boxSpace])*leftSideLength)+[self boxSpace])/2, 0, ([self boxSize]+[self boxSpace])*leftSideLength-[self boxSpace], [self boxSize]);
    
    for (int i=0; i<_currentQuestion.questionArray.count; i++) {
        
        
        if([[_currentQuestion.questionArray objectAtIndex:i] isEqual:@"="]){
            isRightSide=YES;
            continue;
        }
        if (!isRightSide) {
            if(i==0){
                UIImageView * leftEdgeContainerAbove=[self makeContainer:CGRectMake(0-leftEdgeImage.size.width/2, 0-[self containerY], leftEdgeImage.size.width, leftEdgeImage.size.height) image:leftEdgeImage];
                UIImageView * innerContainerAbove=[self makeContainer:CGRectMake(leftEdgeImage.size.width/2,0-[self containerY], ([self boxSize]+[self boxSpace])*leftSideLength-[self boxSpace]-leftEdgeImage.size.width, innerImage.size.height) image:innerImage];
                UIImageView * rightEdgeContainerAbove=[self makeContainer:CGRectMake(([self boxSize]+[self boxSpace])*leftSideLength-leftEdgeImage.size.width/2-[self boxSpace], 0-[self containerY], rightEdgeImage.size.width, rightEdgeImage.size.height) image:rightEdgeImage];
                
                UIImageView * containerEqual=[self makeContainer:CGRectMake((questionViewLeftSide.frame.size.width-equalImage.size.width)/2, questionViewLeftSide.frame.size.height+[self containerY], equalImage.size.width, equalImage.size.height) image:equalImage];
                
                
                UIImageView * leftEdgeContainerBelow=[self makeContainer:CGRectMake(0-leftEdgeImage.size.width/2, 0-[self containerY], leftEdgeImage.size.width, leftEdgeImage.size.height) image:leftEdgeImage];
                UIImageView * innerContainerBelow=[self makeContainer:CGRectMake(leftEdgeImage.size.width/2, 0-[self containerY], ([self boxSize]+[self boxSpace])*rightSideLength-[self boxSpace]-leftEdgeImage.size.width, innerImage.size.height) image:innerImage];
                UIImageView * rightEdgeContainerBelow=[self makeContainer:CGRectMake(([self boxSize]+[self boxSpace])*rightSideLength-leftEdgeImage.size.width/2-[self boxSpace], 0-[self containerY], rightEdgeImage.size.width, rightEdgeImage.size.height) image:rightEdgeImage];
                
                [questionViewLeftSide addSubview:leftEdgeContainerAbove];
                [questionViewLeftSide addSubview:innerContainerAbove];
                [questionViewLeftSide addSubview:rightEdgeContainerAbove];
                [questionViewLeftSide  addSubview:containerEqual];
                [questionViewRightSide addSubview:leftEdgeContainerBelow];
                [questionViewRightSide addSubview:innerContainerBelow];
                [questionViewRightSide addSubview:rightEdgeContainerBelow];
            }
            
            EQBox * box=[EQBox BoxWithFrame:CGRectMake(([self boxSize]+[self boxSpace])*i, 0, [self boxSize], [self boxSize]) andTitle:[_currentQuestion.questionArray objectAtIndex:i]];
            box.caller=self;
            [questionViewLeftSide addSubview:box.boxButton];
        }
        else if(isRightSide){
            EQBox * box=[EQBox BoxWithFrame:CGRectMake(([self boxSize]+[self boxSpace])*(i-leftSideLength-1), 0, [self boxSize], [self boxSize]) andTitle:[_currentQuestion.questionArray objectAtIndex:i]];
            box.caller=self;
            [questionViewRightSide addSubview:box.boxButton];
            
            if(_currentQuestion.questionArray.count-1==i){
                questionViewRightSide.frame=CGRectMake((([self questionViewSize].width-([self boxSize]+[self boxSpace])*(i-leftSideLength)+[self boxSpace]))/2, questionViewLeftSide.frame.size.height+equalImage.size.height+[self containerY]*2, ([self boxSize]+[self boxSpace])*(i-leftSideLength)-[self boxSpace], [self boxSize]);
            }
        }
    }
    

  
//    NSLog(@"LeftWidth: %f, rightWidth: %f",questionViewLeftSide.frame.size.width, questionViewRightSide.frame.size.width);
//    float questionViewWidth=questionViewLeftSide.frame.size.width>questionViewRightSide.frame.size.width?questionViewLeftSide.frame.size.width:questionViewRightSide.frame.size.width;
    
    questionView.frame=CGRectMake((winWidth-[self questionViewSize].width)/2, (winHeight-[self questionViewSize].height)/2,[self questionViewSize].width , [self questionViewSize].height);


//    questionView.backgroundColor=[UIColor magentaColor];
}

-(void)placingCounters{
    
    deleteCount = 0;
    moveCount = [[self.currentQuestion wholeQuestion] length] - [[self.currentQuestion answer] length];
    
    UIImage * image=[UIImage imageNamed:@"delete_counter.png"];
    UIView * counterView=[[UIView alloc] initWithFrame:CGRectMake((btnControl.frame.size.width-6.0*moveCount)/2, 20, 6.0*moveCount, image.size.height)];
    
    if (!counterImages) {
        counterImages = [[NSMutableArray alloc] initWithCapacity:3];
        for (int i = 0; i < moveCount; i++) {
            
            UIImageView *count = [[UIImageView alloc] initWithImage:image];
            count.frame = CGRectMake(6.0*i, 0, image.size.width, image.size.height);
            [counterImages addObject:count];
            [counterView addSubview:count];
        }
    }
    [btnControl addSubview:counterView];
}

-(void)animateBox:(UIButton *)button {
    EQBox* box = [EQBox boxByOrder:button.tag];
    
    if(!box.isDeleted){
        if (deleteCount != moveCount) {
            [box deleteBox];
            [[counterImages objectAtIndex:[counterImages count]-1-deleteCount] setAlpha:0.0];
            deleteCount++;
        }
    }
    else{
        [box resetBox];
        [[counterImages objectAtIndex:[counterImages count]-deleteCount] setAlpha:1.0];
        deleteCount--;
    }
    
}

-(void)control{
    
    if (answerFrame) {
        [answerFrame removeFromSuperview];
        answerFrame = nil;
    }
    
    NSMutableString * answer=[[NSMutableString alloc] initWithString:@""];
    NSMutableString * answerLeftSide=[[NSMutableString alloc] initWithString:@""];
    NSMutableString * answerRightSide=[[NSMutableString alloc] initWithString:@""];
    BOOL isLeftSide=YES;
    for (int i=0; i<self.currentQuestion.questionArray.count-1; i++) {
        if ([[_currentQuestion.questionArray objectAtIndex:i] isEqual:@"="]) {
            isLeftSide=NO;
        }
        
        EQBox * box=[EQBox boxByOrder:i];

        if (isLeftSide) {
            if(!box.isDeleted)
                [answerLeftSide appendString:box.title];
        }
        else if(!isLeftSide) {
            if(!box.isDeleted)
                [answerRightSide appendString:box.title];
        }
    }
    
    [answer appendString:answerLeftSide];
    [answer appendString:@"="];
    [answer appendString:answerRightSide];
    
    if([self.currentQuestion isCorrect:answer]){
        UIImage *frameImage;
        if([[UIScreen mainScreen] bounds].size.height == 568){
            frameImage = [UIImage imageNamed:@"frame_correct-568h.png"];
        }
        else{
            frameImage = [UIImage imageNamed:@"frame_correct.png"];
        }

        answerFrame = [[UIImageView alloc] initWithImage:frameImage];
        [self.view addSubview:answerFrame];
        isSolutionCorrect = YES;
        [self fadeOutAnswerFrames];
    }
    else{
        
//        UIImage *frameImage;
//        if([[UIScreen mainScreen] bounds].size.height == 568){
//            frameImage = [UIImage imageNamed:@"frame_false-568h.png"];
//        }
//        else{
//            frameImage = [UIImage imageNamed:@"frame_false.png"];
//        }
//        
//        answerFrame = [[UIImageView alloc] initWithImage:frameImage];
//        [self.view addSubview:answerFrame];
//        isSolutionCorrect = NO;
//        [self fadeOutAnswerFrames];
        
        [self shakeView:self.view];
        
    }
}

- (void)shakeView:(UIView *)viewToShake
{
    CGFloat t = 10.0;
    CGAffineTransform translateRight  = CGAffineTransformTranslate(CGAffineTransformIdentity, t, 0.0);
    CGAffineTransform translateLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, 0.0);
    
    viewToShake.transform = translateLeft;
    
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:3.0];
        viewToShake.transform = translateRight;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform = CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}

-(void)fadeOutAnswerFrames {
//    [self pauseGame];
    if (answerFrame) {
        [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            answerFrame.alpha = 0.0;
        } completion:^(BOOL finished) {
            [answerFrame removeFromSuperview];
            answerFrame = nil;
            if (isSolutionCorrect) {
                [self onCorrectAnswer];
            } else {
                [self resumeGame];
            }
        }];
    }
}
-(void)pauseGame{
    [self.stopWatch pauseTimer];
    [self.view setUserInteractionEnabled:NO];
}
-(void)resumeGame{
    [self.stopWatch resumeTimer];
    [self.view setUserInteractionEnabled:YES];
}
-(void)onCorrectAnswer{
    
    [_stopWatch stopTimer];
    [EQScore addScore:[_stopWatch getElapsedMiliseconds] withDifficulty:_difficulty];
    [EQStatistic updateStatisticsWithTime:[_stopWatch getElapsedMiliseconds] andDifficulty:_difficulty];
    
    EQStatistic *currentStats = [EQStatistic getStatisticsWithDifficulty:_difficulty];
    
    if ([currentStats minTime] < INT32_MAX) {
        [[GameCenterManager sharedInstance] submitScore:[currentStats minTime]*0.1 category:[NSString stringWithFormat:@"com.halici.Equify.leaderboards.bestTime%d", _difficulty]];
    }
    if ([currentStats totalSolvedQuestion] > 0) {
        [[GameCenterManager sharedInstance] submitScore:[currentStats totalSolvedQuestion] category:[NSString stringWithFormat:@"com.halici.Equify.leaderboards.totalSolvedQuestion%d", _difficulty]];
    }
    int average = [EQScore getAverageWithDifficulty:_difficulty];
    if (average != -1) {
        [[GameCenterManager sharedInstance] submitScore:average*0.1 category:[NSString stringWithFormat:@"com.halici.Equify.leaderboards.bestFifteen%d", _difficulty]];
    }
    
    [self setCurrentQuestion:[EQQuestion getNextQuestionWithDifficulty:_difficulty]];
    [self configureViews];
    [self.stopWatch resetTimer];
    [self.view setUserInteractionEnabled:YES];
    
}

-(void)skipQuestion{
    [EQStatistic updateStatisticsWithSkippedGameAndDifficulty:_difficulty];
    [self setCurrentQuestion:[EQQuestion getNextQuestionWithDifficulty:_difficulty]];
    [self.stopWatch resetTimer];
    [self configureViews];
}

-(void)inGameMenu{
    
    [self.stopWatch pauseTimer];
    menu=[[UIView alloc] initWithFrame:CGRectMake(0, 0, winWidth, winHeight)];
    
    if([[UIScreen mainScreen] bounds].size.height == 568){
        menu.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg-568h.jpg"]];
    }
    else{
        menu.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg.jpg"]];
    }

    
    UIView *seperator1 = [[UIView alloc] initWithFrame:CGRectMake((winWidth-175)/2, (winHeight-40)/2-30, 175, 2.0)];
    [seperator1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"single_line.png"]]];

    UIButton * btnResume=[self makeMenuButton:CGRectMake((winWidth-175)/2, (winHeight-40)/2-25, 175, 40) title:NSLocalizedString(@"RESUME", nil)];
    
    [btnResume addTarget:self action:@selector(btnResumeGame) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *seperator2 = [[UIView alloc] initWithFrame:CGRectMake((winWidth-175)/2, (winHeight-40)/2+20, 175, 2.0)];
    [seperator2 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"single_line.png"]]];
    
    UIButton * btnMainMenu=[self makeMenuButton:CGRectMake((winWidth-175)/2, (winHeight-40)/2+25, 175, 40) title:NSLocalizedString(@"MAINMENU", nil)];
    [btnMainMenu addTarget:self action:@selector(openMainMenu) forControlEvents:UIControlEventTouchUpInside];

    UIView *seperator3 = [[UIView alloc] initWithFrame:CGRectMake((winWidth-175)/2, (winHeight-40)/2+75, 175, 2.0)];
    [seperator3 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"single_line.png"]]];
    
    [menu addSubview:seperator1];
    [menu addSubview:btnResume];
    [menu addSubview:seperator2];
    [menu addSubview:btnMainMenu];
    [menu addSubview:seperator3];
    
    [self.view addSubview:menu];

}

-(UIButton *) makeMenuButton:(CGRect)frame title:(NSString *) title{
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:frame];
    UILabel * lblReset=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, btn.frame.size.width, btn.frame.size.height)];
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

- (void) openMainMenu {
    [self.navigationController popViewControllerAnimated:YES];
    [self.stopWatch stopTimer];
    [EQStatistic updateStatisticsWithSkippedGameAndDifficulty:_difficulty];
}

- (void) btnResumeGame {
    [menu removeFromSuperview];
    [self.stopWatch resumeTimer];
}

- (void)viewDidUnload {
    [self setStopWatchLabel:nil];
    [self setQuestionView:nil];
    [self setStopWatchLabelMS:nil];
    [super viewDidUnload];
}
@end
