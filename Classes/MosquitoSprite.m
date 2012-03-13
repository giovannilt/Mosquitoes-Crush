//
//  MosquitoSprite.m
//  Sparrow_test
//
//  Created by Iviso Malazzi on 3/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MosquitoSprite.h"
#import "MosquitoTouchEvent.h"
#import "Playground.h"
#import "SuckedEvent.h"
#import "Game.h"

@interface MosquitoSprite()
-(void) suck;
-(void) animOver:(SPEvent*) event;
-(void) splash;
-(void) onSplashCompleted:(SPEvent*) event;
@end

@implementation MosquitoSprite

@synthesize worth, mWidth, mHeight;

- (id)initWithWidth:(double) width andHeight:(double) height speed:(float) pspeed xvariance:(int) xv yvariance:(int) yv flyprob:(double) fp life:(int)l power:(int)p worth:(int)w maxW:(float)maxW maxH:(float)maxH maxDisp:(float)maxDisp statsH:(float) statsH
{
    self = [super init];
    if (self) {
        statsHeight = statsH;
        maxDisplacement = maxDisp;
        maxWidth = maxW;
        maxHeight = maxH;
        mWidth = width;
        mHeight = height;
        speed = pspeed;
        xvariance = xv;
        yvariance = yv;
        flyProb = fp;
        power = p;
        worth = w;
        mJuggler = [[SPJuggler alloc] init];
        mFlyJuggler = [[SPJuggler alloc] init];
        mSuckJug = [[SPJuggler alloc] init];
        NSMutableArray* texturesfly = [NSMutableArray arrayWithObjects:[Game texture:@"defpos"], [Game texture:@"fly1"], [Game texture:@"fly2"], [Game texture:@"fly3"], [Game texture:@"fly4"], [Game texture:@"fly3"], [Game texture:@"fly2"], [Game texture:@"fly1"], nil];
        flyClip = [SPMovieClip movieWithFrames:texturesfly fps:50.0f];
        flyClip.loop = YES;
        flyClip.width = mWidth;
        flyClip.height = mHeight;
        flyClip.visible = NO;
        [self addChild:flyClip];
        [mFlyJuggler addObject:flyClip];
        
        NSMutableArray* texturesuck = [NSMutableArray arrayWithArray:[Game textures:@"suck"]];
        [texturesuck addObject:[Game texture:@"defpos"]];
        suckClip = [SPMovieClip movieWithFrames:texturesuck fps:3.0f];
        suckClip.loop = NO;
        suckClip.width = mWidth;
        suckClip.height = mHeight;
        suckClip.visible = NO;
        [self addChild:suckClip];
        [mSuckJug addObject:suckClip];
        [suckClip addEventListener:@selector(animOver:) atObject:self forType:SP_EVENT_TYPE_MOVIE_COMPLETED];
        
        splashClip = [SPMovieClip movieWithFrames:[Game textures:@"splash"] fps:30.0f];
        splashClip.loop = NO;
        splashClip.width = mWidth;
        splashClip.height = mHeight;
        splashClip.visible = NO;
        [self addChild:splashClip];
        [splashClip addEventListener:@selector(onSplashCompleted:) atObject:self forType:SP_EVENT_TYPE_MOVIE_COMPLETED];
        
        [self addEventListener:@selector(onTouched:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        flying = NO;
        life = l;
    }
    
    return self;
}

-(void)initColor {
    Playground* p = (Playground*)self.parent;
    flyClip.color = ((NSNumber*)[p.colors objectAtIndex:life - 1]).intValue;
    suckClip.color = ((NSNumber*)[p.colors objectAtIndex:life - 1]).intValue;
}

-(void)splash {
    flying = NO;
    flyClip.visible = NO;
    [flyClip pause];
    suckClip.visible = NO;
    [suckClip pause];
    splashClip.visible = YES;
    [splashClip play];
    [mJuggler addObject:splashClip];
}

-(void)onSplashCompleted:(SPEvent *)event {
    //[mJuggler removeAllObjects];
    //[self removeAllChildren];
    SPPoint* p = [SPPoint pointWithX:self.x+mWidth/2.0 y:self.y+mHeight/2.0];
    MosquitoTouchEvent* mte = [[MosquitoTouchEvent alloc] initWithType:EVENT_TYPE_MOSQUITO_TOUCHED mosquito:self point:p];
    [self dispatchEvent:mte];
    [mte release];
}

-(void)suck {
    flying = NO;
    suckClip.visible = YES;
    [suckClip setCurrentFrame:0];
    [suckClip play];
}

-(void)fly {
    flying = YES;
    flyClip.visible = YES;
    SPTween* flyTween = [SPTween tweenWithTarget:self time:speed transition:SP_TRANSITION_LINEAR];
    double xdist = maxDisplacement - arc4random()%xvariance;
    double ydist = maxDisplacement - arc4random()%yvariance;
    double xrand = arc4random()%99;
    double yrand = arc4random()%99;
    double xdir = (xrand > 33) ? ((xrand > 66) ? 0 : 1) : -1;
    double ydir = (yrand > 33) ? ((yrand > 66) ? 0 : 1) : -1;
    double pHeight = statsHeight;
    if (xdir == 0 && ydir == 0) {
        ydir = (yrand > 48.5) ? 1 : -1;
    }
    double nx = self.x + xdir*xdist;
    double ny = self.y + ydir*ydist;
    if (nx + mWidth > maxWidth || nx < 0) {
        nx = self.x + -1*xdir*xdist;
    }
    if (ny + mHeight > maxHeight || ny < pHeight+2) {
        ny = self.y + -1*ydir*ydist;
    }
    [flyTween animateProperty:@"x" targetValue:nx];
    [flyTween animateProperty:@"y" targetValue:ny];
    [flyTween addEventListener:@selector(animOver:) atObject:self forType:SP_EVENT_TYPE_TWEEN_COMPLETED];
    [mFlyJuggler addObject:flyTween];
}

-(void)animOver:(SPEvent *)event {
    if (!flying) {
        SuckedEvent* event = [[SuckedEvent alloc] initWithType:EVENT_TYPE_MOSQUITO_SUCKED andDamage:power];
        [self dispatchEvent:event];
        [event release];
    }
    Playground* pg = ([self.parent isKindOfClass:[Playground class]]) ? (Playground*)self.parent : nil;
    if ((pg && !pg.canSuck) || arc4random()%1000/1000.0 <= flyProb) {
        [suckClip pause];
        [flyClip play];
        suckClip.visible = NO;
        [self fly];
    } else {
        [flyClip pause];
        flyClip.visible = NO;
        [self suck];
    }
}

-(void)onTouched:(SPTouchEvent *)event {
    SPTouch *touch = [[event touchesWithTarget:self andPhase:SPTouchPhaseEnded] anyObject];
    if (touch && life > 0.0)
    {
        SPEvent* event = [[SPEvent alloc] initWithType:EVENT_CORRECT_TOUCH bubbles:NO];
        [self dispatchEvent:event];
        [event release];
        
        if(life == 1) {
            life--;
            [self splash];
        } else {
            life--;
            Playground* p = (Playground*)self.parent;
            SPTween* tween = [SPTween tweenWithTarget:flyClip time:0.4];
            [tween animateProperty:@"color" targetValue:((NSNumber*)[p.colors objectAtIndex:life - 1]).intValue];
            [mJuggler addObject:tween];
            tween = [SPTween tweenWithTarget:suckClip time:0.4];
            [tween animateProperty:@"color" targetValue:((NSNumber*)[p.colors objectAtIndex:life - 1]).intValue];
            [mJuggler addObject:tween];
        }
    }    
}

-(void) advanceTime:(double) seconds {
    if (flying) {
        [mFlyJuggler advanceTime:seconds];
    } else {
        [mSuckJug advanceTime:seconds];
    }
    [mJuggler advanceTime:seconds];
}

-(void)dealloc {
    [mJuggler release];
    [mSuckJug release];
    [mFlyJuggler release];
    [super dealloc];
}

@end
