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
#import "Vector2D.h"

@interface MosquitoSprite() {
    BOOL onColorTRansformation;
    Vector2D* velocity;
    int circleRadius;
    double wanderAngle;
    double wanderChange;
    double changeDistance;
    double currDistance;
    BOOL lcanSuck;
}
-(void) suck;
-(void) animOver:(SPEvent*) event;
-(void) splash;
-(void) burn;
-(void) onSplashCompleted:(SPEvent*) event;
-(void) setOnColorTransformation:(BOOL) val;
-(void) moveWithSeconds:(double) seconds;
-(void) changeVelocity;
@end

@implementation MosquitoSprite

@synthesize worth, mWidth, mHeight;

- (id)initWithWidth:(double) width andHeight:(double) height speed:(float) pspeed flyprob:(double) fp life:(int)l power:(int)p worth:(int)w maxW:(float)maxW maxH:(float)maxH statsH:(float) statsH
{
    self = [super init];
    if (self) {
        lcanSuck = YES;
        circleRadius = 30;
        changeDistance = 300 + (arc4random()%1000/1000.0)*300 - 150;
        currDistance = 0;
        wanderAngle = 2*PI*(arc4random()%100/100.0);
        wanderChange = 3;
        velocity = [[Vector2D alloc] initWithX:(arc4random()%100/100.0)*pspeed - pspeed/2.0 andY:(arc4random()%100/100.0)*pspeed - pspeed/2.0];
        onColorTRansformation = NO;
        statsHeight = statsH;
        maxWidth = maxW;
        maxHeight = maxH;
        mWidth = width;
        mHeight = height;
        speed = pspeed;
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
        
        burnClip = [SPMovieClip movieWithFrames:[Game textures:@"burn"] fps:28.0f];
        burnClip.loop = NO;
        burnClip.width = mWidth;
        burnClip.height = mHeight;
        burnClip.visible = NO;
        [self addChild:burnClip];
        [burnClip addEventListener:@selector(onSplashCompleted:) atObject:self forType:SP_EVENT_TYPE_MOVIE_COMPLETED];

        [self addEventListener:@selector(onTouched:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        flying = YES;
        flyClip.visible = YES;
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

-(void)burn {
    flying = NO;
    flyClip.visible = NO;
    [flyClip pause];
    suckClip.visible = NO;
    [suckClip pause];
    burnClip.visible = YES;
    [burnClip play];
    [mJuggler addObject:burnClip];
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

-(void)moveWithSeconds:(double)seconds {
    [self changeVelocity];
    [velocity truncate:speed];
    double dist = velocity.length*seconds;
    double x = self.x + velocity.x*seconds;
    double y = self.y + velocity.y*seconds;
    if (x < 0 || x + mWidth > maxWidth) { x = self.x + -1*velocity.x*seconds; [velocity reverseX];} 
    if (y < statsHeight + 2 || y + mHeight*2 > maxHeight) { y = self.y + -1*velocity.y*seconds; [velocity reverseY];} 
    self.x = x;
    self.y = y;
    currDistance += dist;
    if (currDistance >= changeDistance) {
        currDistance = 0.0;
        [self animOver:nil];
    }
}

-(void)changeVelocity {
    Vector2D* circleMiddle = [[Vector2D alloc] initWithX:velocity.x andY:velocity.y];
    [[circleMiddle normalize] multiply:circleRadius];
    Vector2D* wanderForce = [[Vector2D alloc] initWithX:0.0 andY:0.0];
    wanderForce.length = 100;
    wanderForce.angle = wanderAngle;
    wanderAngle += (arc4random()%1000/1000.0) * wanderChange - wanderChange*0.5;
    [circleMiddle add:wanderForce.vector];
    [velocity add:circleMiddle.vector];
    [circleMiddle release];
    [wanderForce release];
}

-(void)interruptSucking {
    if (!flying) { 
        flying = YES;
        lcanSuck = NO;
        [self animOver:nil];
    }
}

-(void)animOver:(SPEvent *)event {
    if (!flying) {
        SuckedEvent* event = [[SuckedEvent alloc] initWithType:EVENT_TYPE_MOSQUITO_SUCKED andDamage:power];
        [self dispatchEvent:event];
        [event release];
    }
    Playground* pg = ([self.parent isKindOfClass:[Playground class]]) ? (Playground*)self.parent : nil;
    if ((pg && !pg.canSuck) || !lcanSuck || arc4random()%1000/1000.0 <= flyProb) {
        [suckClip pause];
        lcanSuck = YES;
        [flyClip play];
        suckClip.visible = NO;
        flyClip.visible = YES;
        flying = YES;
    } else {
        [flyClip pause];
        flyClip.visible = NO;
        [self suck];
    }
}

-(void)onTouched:(SPTouchEvent *)event {
    Playground* p = (Playground*)self.parent;
    SPTouch *touch = [[event touchesWithTarget:self andPhase:SPTouchPhaseEnded] anyObject];
    if (!onColorTRansformation && touch && life > 0.0)
    {
        SPEvent* event = [[SPEvent alloc] initWithType:EVENT_CORRECT_TOUCH bubbles:NO];
        [self dispatchEvent:event];
        [event release];
        
        if(life == 1 || p.mustBurn) {
            if (!p.mustBurn) {
                life--;
                [self splash];
            } else {
                life = 0.0;
                [self burn];
            }
        } else {
            life--;
            onColorTRansformation = YES;
            [self interruptSucking];
            SPTween* tween = [SPTween tweenWithTarget:flyClip time:0.4];
            [tween animateProperty:@"color" targetValue:((NSNumber*)[p.colors objectAtIndex:life - 1]).intValue];
            [mJuggler addObject:tween];
            tween = [SPTween tweenWithTarget:suckClip time:0.4];
            [tween animateProperty:@"color" targetValue:((NSNumber*)[p.colors objectAtIndex:life - 1]).intValue];
            [mJuggler addObject:tween];
            [[mJuggler delayInvocationAtTarget:self byTime:0.4] setOnColorTransformation:NO];
        }
    } else if (onColorTRansformation && touch && life > 0.0) {
        SPEvent* event = [[SPEvent alloc] initWithType:EVENT_INCORRECT_TOUCH bubbles:NO];
        [p dispatchEvent:event];
        [event release];
    }
}

-(void)setOnColorTransformation:(BOOL)val {
    onColorTRansformation = val;
}

-(void) advanceTime:(double) seconds {
    if (flying) {
        [mFlyJuggler advanceTime:seconds];
        [self moveWithSeconds:seconds];
    } else {
        [mSuckJug advanceTime:seconds];
    }
    [mJuggler advanceTime:seconds];
}

-(void)dealloc {
    [velocity release];
    [mJuggler release];
    [mSuckJug release];
    [mFlyJuggler release];
    [super dealloc];
}

@end
