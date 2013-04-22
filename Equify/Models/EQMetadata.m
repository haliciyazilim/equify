//
//  EQMetadata.m
//  Equify
//
//  Created by Alperen Kavun on 13.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "EQMetadata.h"
#import "EQDatabaseManager.h"
#import "EQAppConfigValues.h"
#import "EQQuestion.h"

@implementation EQMetadata

@dynamic currentQuestionId;
@dynamic versionNumber;
@dynamic difficulty;

+(void)initializeMetadata{
    for (int i = 1; i < 4; i++) {
        EQMetadata* metadata = (EQMetadata*)[[EQDatabaseManager sharedInstance] createEntity:@"Metadata"];
        metadata.versionNumber = @"1.1";
        metadata.difficulty = i;
        
        int questionCount = [[EQQuestion getAllQuestionsWithDifficulty:i] count];
        
        metadata.currentQuestionId = arc4random() % questionCount + 1;
        
        [[EQDatabaseManager sharedInstance] saveContext];
    }
}

+(void)updateMetadata {
    for (int i = 1; i < 4; i++) {
        
        NSFetchRequest* request = [[NSFetchRequest alloc] init];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                  @"difficulty == %d", i];
        [request setPredicate:predicate];
        
        EQMetadata *currentMeta = (EQMetadata *)[[EQDatabaseManager sharedInstance] entityWithRequest:request forName:@"Metadata"];
        currentMeta.versionNumber = @"1.1";
        
        int questionCount = [[EQQuestion getAllQuestionsWithDifficulty:i] count];
        
        currentMeta.currentQuestionId = arc4random() % questionCount + 1;
        
        [[EQDatabaseManager sharedInstance] saveContext];
    }
}

+(void)incrementQuestionIdWithDifficulty:(int)difficulty{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"difficulty == %d", difficulty];
    [request setPredicate:predicate];
    
    int questionCount = [[EQQuestion getAllQuestionsWithDifficulty:difficulty] count];
    
    EQMetadata *currentMeta = (EQMetadata *)[[EQDatabaseManager sharedInstance] entityWithRequest:request forName:@"Metadata"];
    
    currentMeta.currentQuestionId = (currentMeta.currentQuestionId%questionCount)+1;
    
    [[EQDatabaseManager sharedInstance] saveContext];
    
}
+(int)getCurrentQuestionWithDifficulty:(int)difficulty{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"difficulty == %d", difficulty];
    [request setPredicate:predicate];
    
    EQMetadata *currentMeta = (EQMetadata *)[[EQDatabaseManager sharedInstance] entityWithRequest:request forName:@"Metadata"];
    
    int questionCount = [[EQQuestion getAllQuestionsWithDifficulty:difficulty] count];
    
    return (currentMeta.currentQuestionId)%questionCount;
}
+(NSString *)getCurrentVersion {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"difficulty == %d", 1];
    [request setPredicate:predicate];
    
    EQMetadata *currentMeta = (EQMetadata *)[[EQDatabaseManager sharedInstance] entityWithRequest:request forName:@"Metadata"];
    
    return currentMeta.versionNumber;
}
@end
