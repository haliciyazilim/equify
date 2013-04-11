//
//  EQStatsViewController.m
//  Equify
//
//  Created by Alperen Kavun on 14.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "EQStatsViewController.h"
#import "StopWatch.h"
#import "EQScore.h"

@interface EQStatsViewController ()

@end

@implementation EQStatsViewController{
    UILabel *bestTime;
    UILabel *worstTime;
    UILabel *totalSolved;
    UILabel *totalSkipped;
    UILabel *average;
    UILabel *allTimeAverage;
    
    UIButton * btnLevel1;
    UIButton * btnLevel2;
    UIButton * btnLevel3;
    
    UIView *mainView;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (CGSize) getMainViewSize {
    return CGSizeMake(self.view.frame.size.height, self.view.frame.size.width);
//    return self.view.frame.size;
}
- (CGSize) getInnerSize {
    CGSize size = [self getMainViewSize];
    return CGSizeMake(size.height-50.0, size.width-50.0);
}
- (CGFloat) lineHeight {
    return 40.0;
}
-(CGFloat) headerHeight {
    return 45.0;
}
-(CGFloat) headerSingleLineHeight {
    return 2.0;
}
-(CGFloat) headerDoubleLineHeight {
    return 3.0;
}
-(CGFloat) seperatorHeight {
    return 2.0;
}
-(CGFloat) closeButtonHeight {
    return 35.0;
}
-(CGFloat) buttonsTop {
    return 5.0;
}
-(CGFloat) closeButtonsTop {
    return 5.0;
}
-(CGFloat) headerFontSize {
    return 30.0;
}
-(CGFloat) fontSize {
    return 20.0;
}
-(CGFloat) labelWidth {
    return 300.0;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGSize mainSize = [self getMainViewSize];
    CGSize windowSize = [[UIScreen mainScreen] bounds].size;
    
    mainView = [[UIView alloc] initWithFrame:CGRectMake((windowSize.width-mainSize.height)*0.5, (windowSize.height-mainSize.width)*0.5, mainSize.width, mainSize.height)];
    [mainView setBackgroundColor:[UIColor clearColor]];
    
    CGSize mainViewSize = [self getInnerSize];
    UIView *statsMainView = [[UIView alloc] initWithFrame:CGRectMake(25.0, 25.0, mainViewSize.height, mainViewSize.width)];
    [statsMainView setBackgroundColor:[UIColor clearColor]];
    
    UIView *headerSingleLine = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, mainViewSize.height, [self headerSingleLineHeight])];
    [headerSingleLine setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"single_line.png"]]];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, mainViewSize.height-10.0, [self headerHeight])];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [headerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:[self headerFontSize]]];
    [headerLabel setTextColor:[UIColor colorWithRed:0.463 green:0.365 blue:0.227 alpha:1.0]];
    [headerLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
    [headerLabel setShadowColor:[UIColor whiteColor]];
    [headerLabel setText:NSLocalizedString(@"STATS", nil)];
    
    UIView *headerDoubleLine = [[UIView alloc] initWithFrame:CGRectMake(0.0, [self headerHeight], mainViewSize.height, [self headerDoubleLineHeight])];
    [headerDoubleLine setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"double_line.png"]]];
    
    UIView *difficultyButtonsView=[self makeDifficultyButtons];
    [difficultyButtonsView setFrame:CGRectMake(mainViewSize.height-45.0-difficultyButtonsView.frame.size.width, [self buttonsTop], difficultyButtonsView.frame.size.width, difficultyButtonsView.frame.size.height)];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close_btn.png"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close_btn_pressed.png"] forState:UIControlStateHighlighted];
    [closeButton addTarget:self action:@selector(closeStats) forControlEvents:UIControlEventTouchUpInside];
    closeButton.frame = CGRectMake(mainViewSize.height-45.0, [self closeButtonsTop], [self closeButtonHeight], [self closeButtonHeight]);
    
    UILabel *bestTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, [self headerHeight], [self labelWidth], [self lineHeight])];
    [bestTimeLabel setBackgroundColor:[UIColor clearColor]];
    [bestTimeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:[self fontSize]]];
    [bestTimeLabel setTextColor:[UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:1.0]];
    [bestTimeLabel setText:NSLocalizedString(@"BEST_TIME", nil)];
    
    UIView *seperator1 = [[UIView alloc] initWithFrame:CGRectMake(0.0, [self headerHeight]+[self lineHeight], mainViewSize.height, [self seperatorHeight])];
    [seperator1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_border.png"]]];
    
    UILabel *worstTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, [self headerHeight]+[self lineHeight], [self labelWidth], [self lineHeight])];
    [worstTimeLabel setBackgroundColor:[UIColor clearColor]];
    [worstTimeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:[self fontSize]]];
    [worstTimeLabel setTextColor:[UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:1.0]];
    [worstTimeLabel setText:NSLocalizedString(@"WORST_TIME", nil)];
    
    UIView *seperator2 = [[UIView alloc] initWithFrame:CGRectMake(0.0, [self headerHeight]+2*[self lineHeight], mainViewSize.height, [self seperatorHeight])];
    [seperator2 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_border.png"]]];
    UILabel *totalSolvedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, [self headerHeight]+2*[self lineHeight], [self labelWidth], [self lineHeight])];
    [totalSolvedLabel setBackgroundColor:[UIColor clearColor]];
    [totalSolvedLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:[self fontSize]]];
    [totalSolvedLabel setTextColor:[UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:1.0]];
    [totalSolvedLabel setText:NSLocalizedString(@"TOTAL_SOLVED_COUNT", nil)];
    
    UIView *seperator3 = [[UIView alloc] initWithFrame:CGRectMake(0.0, [self headerHeight]+3*[self lineHeight], mainViewSize.height, [self seperatorHeight])];
    [seperator3 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_border.png"]]];
    
    UILabel *totalSkippedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, [self headerHeight]+3*[self lineHeight], [self labelWidth], [self lineHeight])];
    [totalSkippedLabel setBackgroundColor:[UIColor clearColor]];
    [totalSkippedLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:[self fontSize]]];
    [totalSkippedLabel setTextColor:[UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:1.0]];
    [totalSkippedLabel setText:NSLocalizedString(@"TOTAL_SKIP_COUNT", nil)];
    
    UIView *seperator4 = [[UIView alloc] initWithFrame:CGRectMake(0.0, [self headerHeight]+4*[self lineHeight], mainViewSize.height, [self seperatorHeight])];
    [seperator4 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_border.png"]]];
    
    UILabel *averageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, [self headerHeight]+4*[self lineHeight], [self labelWidth], [self lineHeight])];
    [averageLabel setBackgroundColor:[UIColor clearColor]];
    [averageLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:[self fontSize]]];
    [averageLabel setTextColor:[UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:1.0]];
    [averageLabel setText:NSLocalizedString(@"AVERAGE", nil)];
    
    UIView *seperator5 = [[UIView alloc] initWithFrame:CGRectMake(0.0, [self headerHeight]+5*[self lineHeight], mainViewSize.height, [self seperatorHeight])];
    [seperator5 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_border.png"]]];
    
    UILabel *allTimeAverageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, [self headerHeight]+5*[self lineHeight], [self labelWidth], [self lineHeight])];
    [allTimeAverageLabel setBackgroundColor:[UIColor clearColor]];
    [allTimeAverageLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:[self fontSize]]];
    [allTimeAverageLabel setTextColor:[UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:1.0]];
    [allTimeAverageLabel setText:NSLocalizedString(@"ALLTIME_AVERAGE", nil)];
    
    bestTime = [[UILabel alloc] initWithFrame:CGRectMake(mainViewSize.height-25.0-140.0, [self headerHeight], 140.0, [self lineHeight])];
    [bestTime setBackgroundColor:[UIColor clearColor]];
    [bestTime setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:[self fontSize]]];
    [bestTime setTextColor:[UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:1.0]];
    [bestTime setTextAlignment:NSTextAlignmentRight];
    
    worstTime = [[UILabel alloc] initWithFrame:CGRectMake(mainViewSize.height-25.0-140.0, [self headerHeight]+[self lineHeight], 140.0, [self lineHeight])];
    [worstTime setBackgroundColor:[UIColor clearColor]];
    [worstTime setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:[self fontSize]]];
    [worstTime setTextColor:[UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:1.0]];
    [worstTime setTextAlignment:NSTextAlignmentRight];
    
    totalSolved = [[UILabel alloc] initWithFrame:CGRectMake(mainViewSize.height-25.0-140.0, [self headerHeight]+2*[self lineHeight], 140.0, [self lineHeight])];
    [totalSolved setBackgroundColor:[UIColor clearColor]];
    [totalSolved setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:[self fontSize]]];
    [totalSolved setTextColor:[UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:1.0]];
    [totalSolved setTextAlignment:NSTextAlignmentRight];
    
    totalSkipped = [[UILabel alloc] initWithFrame:CGRectMake(mainViewSize.height-25.0-140.0, [self headerHeight]+3*[self lineHeight], 140.0, [self lineHeight])];
    [totalSkipped setBackgroundColor:[UIColor clearColor]];
    [totalSkipped setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:[self fontSize]]];
    [totalSkipped setTextColor:[UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:1.0]];
    [totalSkipped setTextAlignment:NSTextAlignmentRight];
    
    average = [[UILabel alloc] initWithFrame:CGRectMake(mainViewSize.height-25.0-140.0, [self headerHeight]+4*[self lineHeight], 140.0, [self lineHeight])];
    [average setBackgroundColor:[UIColor clearColor]];
    [average setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:[self fontSize]]];
    [average setTextColor:[UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:1.0]];
    [average setTextAlignment:NSTextAlignmentRight];
    
    allTimeAverage = [[UILabel alloc] initWithFrame:CGRectMake(mainViewSize.height-25.0-140.0, [self headerHeight]+5*[self lineHeight], 140.0, [self lineHeight])];
    [allTimeAverage setBackgroundColor:[UIColor clearColor]];
    [allTimeAverage setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:[self fontSize]]];
    [allTimeAverage setTextColor:[UIColor colorWithRed:0.298 green:0.298 blue:0.298 alpha:1.0]];
    [allTimeAverage setTextAlignment:NSTextAlignmentRight];
    
    [statsMainView addSubview:headerSingleLine];
    [statsMainView addSubview:headerLabel];
    [statsMainView addSubview:headerDoubleLine];
    [statsMainView addSubview:difficultyButtonsView];
    [statsMainView addSubview:closeButton];
    [statsMainView addSubview:bestTimeLabel];
    [statsMainView addSubview:seperator1];
    [statsMainView addSubview:worstTimeLabel];
    [statsMainView addSubview:seperator2];
    [statsMainView addSubview:totalSolvedLabel];
    [statsMainView addSubview:seperator3];
    [statsMainView addSubview:totalSkippedLabel];
    [statsMainView addSubview:seperator4];
    [statsMainView addSubview:averageLabel];
    [statsMainView addSubview:seperator5];
    [statsMainView addSubview:allTimeAverageLabel];
    [statsMainView addSubview:bestTime];
    [statsMainView addSubview:worstTime];
    [statsMainView addSubview:totalSolved];
    [statsMainView addSubview:totalSkipped];
    [statsMainView addSubview:average];
    [statsMainView addSubview:allTimeAverage];
    [mainView addSubview:statsMainView];
    [self.view addSubview:mainView];
    
    [self configureViews];
}
- (void) closeStats {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) setCurrentStatistics:(EQStatistic *)currentStatistics {
    _currentStatistics = currentStatistics;
    [self configureViews];
}

-(float) screenWidth{
    return [[UIScreen mainScreen] bounds].size.height;
}

-(UIView *) makeDifficultyButtons{
    
    float btnWidth=[UIImage imageNamed:@"level_01.png"].size.width;
    float btnHeight=[UIImage imageNamed:@"level_01.png"].size.height;
    
    btnLevel1=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLevel1 setBackgroundImage:[UIImage imageNamed:@"level_01.png"] forState:UIControlStateNormal];
    [btnLevel1 setBackgroundImage:[UIImage imageNamed:@"level_01_selected.png"] forState:UIControlStateHighlighted];
    [btnLevel1 setBackgroundImage:[UIImage imageNamed:@"level_01_selected.png"] forState:UIControlStateSelected];
    [btnLevel1 setBackgroundImage:[UIImage imageNamed:@"level_01_selected.png"] forState:UIControlStateSelected|UIControlStateHighlighted];
    [btnLevel1 addTarget:self action:@selector(selectDifficulty:) forControlEvents:UIControlEventTouchUpInside];
    [btnLevel1 setFrame:CGRectMake(0, 0, btnWidth, btnHeight)];
    [btnLevel1 setTag:1];
    
    btnLevel2=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLevel2 setBackgroundImage:[UIImage imageNamed:@"level_02.png"] forState:UIControlStateNormal];
    [btnLevel2 setBackgroundImage:[UIImage imageNamed:@"level_02_selected.png"] forState:UIControlStateHighlighted];
    [btnLevel2 setBackgroundImage:[UIImage imageNamed:@"level_02_selected.png"] forState:UIControlStateSelected];
    [btnLevel2 setBackgroundImage:[UIImage imageNamed:@"level_02_selected.png"] forState:UIControlStateSelected|UIControlStateHighlighted];
    [btnLevel2 addTarget:self action:@selector(selectDifficulty:) forControlEvents:UIControlEventTouchUpInside];
    [btnLevel2 setFrame:CGRectMake(btnWidth, 0, btnWidth, btnHeight)];
    [btnLevel2 setTag:2];
    
    btnLevel3=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLevel3 setBackgroundImage:[UIImage imageNamed:@"level_03.png"] forState:UIControlStateNormal];
    [btnLevel3 setBackgroundImage:[UIImage imageNamed:@"level_03_selected.png"] forState:UIControlStateHighlighted];
    [btnLevel3 setBackgroundImage:[UIImage imageNamed:@"level_03_selected.png"] forState:UIControlStateSelected];
    [btnLevel3 setBackgroundImage:[UIImage imageNamed:@"level_03_selected.png"] forState:UIControlStateSelected|UIControlStateHighlighted];
    [btnLevel3 addTarget:self action:@selector(selectDifficulty:) forControlEvents:UIControlEventTouchUpInside];
    [btnLevel3 setFrame:CGRectMake(btnWidth*2, 0, btnWidth, btnHeight)];
    [btnLevel3 setTag:3];
    
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, btnWidth*3, btnHeight)];
    [view addSubview:btnLevel1];
    [view addSubview:btnLevel2];
    [view addSubview:btnLevel3];
    
    return view;
    
}
-(void)setDifficulty:(int)difficulty {
    _difficulty = difficulty;
    [self selectDifficulty:(UIButton *)[self.view viewWithTag:_difficulty]];
}

-(void) selectDifficulty:(UIButton *)button{
    switch (button.tag) {
        case 1:
            btnLevel1.selected=YES;
            btnLevel2.selected=NO;
            btnLevel3.selected=NO;
            _difficulty=1;
            
            break;
        case 2:
            btnLevel1.selected=NO;
            btnLevel2.selected=YES;
            btnLevel3.selected=NO;
            _difficulty=2;
            break;
        case 3:
            btnLevel1.selected=NO;
            btnLevel2.selected=NO;
            btnLevel3.selected=YES;
            _difficulty=3;
            break;
        default:
            break;
    }
    
   [self setCurrentStatistics:[EQStatistic getStatisticsWithDifficulty:_difficulty]];
}

- (void) configureViews {
    if (self.currentStatistics.minTime == INT32_MAX) {
        [bestTime setText:@"-"];
    } else {
        [bestTime setText:[StopWatch textWithMiliseconds:self.currentStatistics.minTime]];
    }
    if (self.currentStatistics.maxTime == INT32_MIN) {
        [worstTime setText:@"-"];
    } else {
        [worstTime setText:[StopWatch textWithMiliseconds:self.currentStatistics.maxTime]];
    }
    [totalSolved setText:[NSString stringWithFormat:@"%d",self.currentStatistics.totalSolvedQuestion]];
    [totalSkipped setText:[NSString stringWithFormat:@"%d",self.currentStatistics.totalSkippedQuestion]];
    
    int lastAverage = [EQScore getAverageWithDifficulty:_difficulty];

    if (lastAverage == -1) {
        [average setText:@"-"];
    } else {
        [average setText:[StopWatch textWithMiliseconds:lastAverage]];
    }
    
    if (self.currentStatistics.allTimeAverage == 0) {
        [allTimeAverage setText:@"-"];
    } else {
        [allTimeAverage setText:[StopWatch textWithMiliseconds:self.currentStatistics.allTimeAverage]];
    }
}
@end
