//
//  TypeDefs.m
//  Equify
//
//  Created by Alperen Kavun on 29.03.2013.
//  Copyright (c) 2013 Halıcı. All rights reserved.
//

#import "TypeDefs.h"

static GAME_STATE CURRENT_GAME_STATE = GAME_STATE_STOPPED;

GAME_STATE getCurrentGameState(){
    return CURRENT_GAME_STATE;
}

void setCurrentGameState(GAME_STATE state){
    CURRENT_GAME_STATE = state;
}
