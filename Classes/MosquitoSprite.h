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
    float speed;
    BOOL flying;
    int life;
    int power;
    double worth;
    SPMovieClip* flyClip;
    SPMovieClip* suckClip;
    SPMovieClip* splashClip;
    SPMovieClip* burnClip;
    float maxWidth;
    float maxHeight;

    float statsHeight;
}

@property (nonatomic, assign) double worth;
@property (nonatomic, assign) double mWidth;
@property (nonatomic, assign) double mHeight;
-(void) advanceTime:(double) seconds;
-(void)onTouched:(SPTouchEvent *)event;
- (id)initWithWidth:(double) width andHeight:(double) height speed:(float) pspeed flyprob:(double) fp life:(int) l power:(int) p worth:(int) w maxW:(float) maxW maxH:(float) maxH statsH:(float) statsH;
-(void) initColor;
-(void) interruptSucking;
@end
