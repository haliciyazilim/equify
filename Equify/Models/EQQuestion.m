//
//  EQQuestionWD.m
//  Equify
//
//  Created by Alperen Kavun on 18.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "EQQuestion.h"
#import "EQMetadata.h"

@implementation EQQuestion

static NSMutableDictionary* allQuestions = nil;

+(NSMutableArray *)getAllQuestionsWithDifficulty:(int)difficulty {
    return [allQuestions objectForKey:[NSString stringWithFormat:@"%d",difficulty]];
}

-(void)addQuestionToAllQuestions:(EQQuestion*)question {
    if (!allQuestions) {
        allQuestions = [[NSMutableDictionary alloc] initWithCapacity:3];
        [allQuestions setObject:[NSMutableArray arrayWithCapacity:100] forKey:@"1"];
        [allQuestions setObject:[NSMutableArray arrayWithCapacity:100] forKey:@"2"];
        [allQuestions setObject:[NSMutableArray arrayWithCapacity:100] forKey:@"3"];
    }
    [[allQuestions objectForKey:[NSString stringWithFormat:@"%d",question.difficulty]] addObject:question];
}


+(EQQuestion*)EQQuestionWithWholeQuestion:(NSString*)wholeQuestion andAnswer:(NSString*)answer andId:(int)questionId andDifficulty:(int)difficulty {
    return [[EQQuestion alloc] initWithWholeQuestion:wholeQuestion andAnswer:answer andId:questionId andDifficulty:difficulty];
}

- (id)initWithWholeQuestion:(NSString*)wholeQuestion andAnswer:(NSString*)answer andId:(int)questionId andDifficulty:(int)difficulty {
    if (self = [super init]) {
        _wholeQuestion = wholeQuestion;
        _answer = answer;
        _questionId = questionId;
        _difficulty = difficulty;
        [self addQuestionToAllQuestions:self];
    }
    return self;
}
+(EQQuestion*)getNextQuestionWithDifficulty:(int)difficulty {
    int questionId = [EQMetadata getCurrentQuestionWithDifficulty:difficulty];
    return [[allQuestions objectForKey:[NSString stringWithFormat:@"%d",difficulty]] objectAtIndex:questionId];
}

- (void) createQuestionArray {
    self.questionArray = [NSMutableArray arrayWithCapacity:[self.wholeQuestion length]];
    for (int i = 0; i < [self.wholeQuestion length]; i++) {
        [self.questionArray addObject:[NSString stringWithFormat:@"%c",[self.wholeQuestion characterAtIndex:i]]];
    }
}

+ (BOOL) isLeftHandsideEqual:(NSString *)leftHandside toRightHandside:(NSString *)rightHandside {
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^-?\\d+([+-\\/x]\\d+)*$" options:NSRegularExpressionCaseInsensitive error:nil];
    
    if ([regex numberOfMatchesInString:leftHandside options:NSMatchingReportCompletion range:NSMakeRange(0, [leftHandside length])] && [regex numberOfMatchesInString:rightHandside options:NSMatchingReportCompletion range:NSMakeRange(0, [rightHandside length])]) {

        NSString *str1 = [leftHandside stringByReplacingOccurrencesOfString:@"x" withString:@"*"];
        NSString *str2 = [rightHandside stringByReplacingOccurrencesOfString:@"x" withString:@"*"];
        
        NSExpression *myExp = [NSExpression expressionWithFormat:str1];
        double result = [[myExp expressionValueWithObject:nil context:nil] floatValue];
        
        NSExpression *myExp2 = [NSExpression expressionWithFormat:str2];
        double result2 = [[myExp2 expressionValueWithObject:nil context:nil] floatValue];
        
        return (result == result2);
    } else {
        return NO;
    }
    
}

@end
