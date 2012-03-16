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
#import "MosquitoTouchEvent.h"

#define EVENT_GAMEOVER @"playgroundgamoeover"
#define EVENT_INCORRECT_TOUCH @"incorrecttouch"
#define EVENT_CLOCK_ENDED @"clockended"

@interface Playground : SPSprite {
    SPJuggler* mJuggler;
    SPJuggler* mClockJuggler;
    SPMovieClip* clockClip;
    NSMutableArray* mosquitoes;
    double statsHeight;
    NumberField* points;
    NumberField* life;
    BOOL stop;
    NSArray* colors;
    int countHit;
    int countMiss;
    SPImage* bckImg;
    SPImage* spraybckImg;
    GameOver* gMsg;
    int combo;
    SPTextField* comboTF;
    NSMutableArray* gifts;
}

@property(nonatomic, assign) double TOTAL;
@property(nonatomic, assign) double statsHeight;
@property(nonatomic, retain) NSArray* colors;
@property(nonatomic, retain) SPJuggler* juggler;
@property(nonatomic, assign) BOOL canSuck;
@property(nonatomic, retain) NumberField* life;
@property(nonatomic, assign) BOOL mustBurn;
@property(nonatomic, readonly) NSMutableArray* gifts;
@property(nonatomic, readonly) BOOL stop;

- (id)initWithWidth:(float) width andHeight:(float) height;

-(void) advanceTime:(double) seconds;

-(void) removeAllPacific;

-(void) killit:(MosquitoTouchEvent*) event;

-(void) launchMosquitoAtX:(double) x Y:(double) y FlyProb:(double) fp Life:(double) lif Power:(double) pow  Worth:(double) worth;

-(void) launchPacificAtX:(double) x Y:(double) y;

-(void) stopGame;

-(void) interruptSucking;

-(void) swapBGtoNormal;

-(void) swapBGToCream;

-(void) showClock:(double) time;
@end
