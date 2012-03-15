//
//  MosquitoSprite.h
//  Sparrow_test
//
//  Created by Iviso Malazzi on 3/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SPSprite.h"

#define EVENT_CORRECT_TOUCH @"correcttouch"

@interface MosquitoSprite : SPSprite {
    SPJuggler* mJuggler;
    SPJuggler* mFlyJuggler;
    SPJuggler* mSuckJug;
    double mWidth;
    double mHeight;
    double flyProb;
    int xvariance;
    int yvariance;
    float speed;
    BOOL flying;
    int life;
    int power;
    int worth;
    SPMovieClip* flyClip;
    SPMovieClip* suckClip;
    SPMovieClip* splashClip;
    float maxWidth;
    float maxHeight;
    float maxDisplacement;
    float statsHeight;
}

@property (nonatomic, assign) int worth;
@property (nonatomic, assign) double mWidth;
@property (nonatomic, assign) double mHeight;
-(void) advanceTime:(double) seconds;
-(void)onTouched:(SPTouchEvent *)event;
- (id)initWithWidth:(double) width andHeight:(double) height speed:(float) pspeed xvariance:(int) xv yvariance:(int) yv flyprob:(double) fp life:(int) l power:(int) p worth:(int) w maxW:(float) maxW maxH:(float) maxH maxDisp:(float) maxDisp statsH:(float) statsH;
-(void) initColor;
-(void) interruptSucking;
@end
