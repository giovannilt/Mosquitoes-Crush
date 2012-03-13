//
//  Playground.h
//  Sparrow_test
//
//  Created by Iviso Malazzi on 3/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SPSprite.h"
#import "NumberField.h"
#import "GameOver.h"

#define EVENT_GAMEOVER @"playgroundgamoeover"
#define EVENT_INCORRECT_TOUCH @"incorrecttouch"

@interface Playground : SPSprite {
    SPJuggler* mJuggler;
    NSMutableArray* mosquitoes;
    double statsHeight;
    NumberField* points;
    NumberField* life;
    BOOL stop;
    NSArray* colors;
    int countHit;
    int countMiss;
    SPImage* bckImg;
    GameOver* gMsg;
    int combo;
    SPTextField* comboTF;
    NSMutableArray* gifts;
}

@property(nonatomic, assign) double statsHeight;
@property(nonatomic, retain) NSArray* colors;
@property(nonatomic, retain) SPJuggler* juggler;
@property(nonatomic, assign) BOOL canSuck;

- (id)initWithWidth:(float) width andHeight:(float) height;

-(void) advanceTime:(double) seconds;

-(void) killit:(SPTouchEvent*) event;

-(void) launchMosquitoAtX:(double) x andY:(double) y;

-(void) stopGame;
@end