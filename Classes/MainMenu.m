//
//  MainMenu.m
//  Sparrow_test
//
//  Created by Iviso Malazzi on 3/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMenu.h"
#import "Game.h"
#import "MosquitoSprite.h"

@interface MainMenu()
-(void) onStart:(SPEvent*) event;
-(float) animateMenuButton:(SPButton*) button targetY:(float) tY delay:(float) delay;
-(void) onHelp:(SPEvent*) event;
-(void) onCredits:(SPEvent*) event;
-(void) gameover:(SPEvent*) event;
-(void) killPlayground;
-(void) createButtons;
-(void) resetButtons;
-(void) animateAllButtons;
@end

@implementation MainMenu

- (id)initWithWidth:(float) mW andHeight:(float) mH
{
    self = [super init];
    if (self) {
        mJuggler = [[SPJuggler alloc] init];
        mGameoverJuggler = [[SPJuggler alloc] init];
        
        SPImage* bck = [SPImage imageWithTexture:[Game texture:@"main"]];
        [self addChild:bck];
        self.width = mW;
        self.height = mH;
    
        [self createButtons];
        [self resetButtons];
        [self animateAllButtons];
        
        mosquitoes = [SPSprite sprite];
        int width = 200;
        int height = 100;
        mosquitoes.width = width;
        mosquitoes.height = height;
        mosquitoes.x = 30;
        mosquitoes.y = 350;
     //   SPQuad* q = [SPQuad quadWithWidth:width height:height color:0xffffff];
     //   [mosquitoes addChild:q];
        for(int i =0; i < 5; i++) {
            MosquitoSprite* m1 = [[MosquitoSprite alloc] initWithWidth:20 andHeight:17 speed:0.2 xvariance:10 yvariance:5 flyprob:1.0 life:0.0 power:0 worth:0 maxW:width maxH:height maxDisp:20 statsH:0.0];
            m1.x = width/2.0;
            m1.y = height/2.0;
            [mosquitoes addChild:m1];
            [m1 release];
        }
        [self addChild:mosquitoes];
    }
    
    return self;
}

-(void)resetButtons {
    int width = 150;
    int height = 71;
    float x = (self.width - width) / 2.0;
    y1 = 180;
    start.width = width;
    start.height = height;
    start.alpha = 0;
    start.x = x;
    start.y = 140;
    start.scaleY = 0;

    width = 120;
    height = 56;
    x = (self.width - width) / 2.0;
    y2 = 245;
    help.width = width;
    help.height = height;
    help.alpha = 0;
    help.x = x;
    help.y = 222;
    help.scaleY = 0;

    width = 90;
    height = 42;
    x = (self.width - width) / 2.0;
    y3 = 295;
    credits.width = width;
    credits.height = height;
    credits.alpha = 0;
    credits.x = x;
    credits.y = 277;
    credits.scaleY = 0;
}

-(void)animateAllButtons {
    float time = [self animateMenuButton:start targetY:y1 delay:0];
    time = [self animateMenuButton:help targetY:y2 delay:time/2.0];
    [self animateMenuButton:credits targetY:y3 delay:time/2.0];    
}

-(void)createButtons {
    start = [SPButton buttonWithUpState:[Game texture:@"start"]];
    [self addChild:start];
    [start addEventListener:@selector(onStart:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    
    help = [SPButton buttonWithUpState:[Game texture:@"help"]];
    [self addChild:help];
    [help addEventListener:@selector(onHelp:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    
    credits = [SPButton buttonWithUpState:[Game texture:@"credits"]];
    [self addChild:credits];
    [credits addEventListener:@selector(onCredits:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
}

-(float)animateMenuButton:(SPButton *)button targetY:(float)tY delay:(float)delay {
    SPTween* stween = [SPTween tweenWithTarget:button time:0.5 transition:SP_TRANSITION_EASE_IN];
    [stween animateProperty:@"scaleY" targetValue:1.0];
    [stween animateProperty:@"y" targetValue:tY];
    [stween animateProperty:@"alpha" targetValue:1.0];
    stween.delay = delay;
    [mJuggler addObject:stween];
    SPTween* stween1 = [SPTween tweenWithTarget:button time:0.1];
    stween1.delay = delay + stween.time;
    [stween1 animateProperty:@"scaleY" targetValue:1.1];
    [stween1 animateProperty:@"y" targetValue:tY + 0.1*button.height];
    [mJuggler addObject:stween1];
    SPTween* stween2 = [SPTween tweenWithTarget:button time:stween1.time];
    stween2.delay = delay + stween.time + stween1.time;
    [stween2 animateProperty:@"scaleY" targetValue:1.0];
    [stween2 animateProperty:@"y" targetValue:tY];
    [mJuggler addObject:stween2];
    return delay + stween.time + stween1.time;
}

-(void)onStart:(SPEvent *)event {
    mPlayground = [[Playground alloc] initWithWidth:self.width andHeight:self.height];
    [self addChild:mPlayground];
    [mPlayground addEventListener:@selector(gameover:) atObject:self forType:EVENT_GAMEOVER];
    //[mPlayground release];
    
    for (int i =0; i < 10; i++) {
        [mPlayground launchMosquitoAtX:arc4random()%(int)(self.width-60) andY:arc4random()%(int)(self.height-70)+22];
    }
}

-(void)gameover:(SPEvent *)event {
    [self resetButtons];
    float time = 0.2;
    SPTween* tween = [SPTween tweenWithTarget:mPlayground time:time transition:SP_TRANSITION_EASE_IN_OUT];
    mPlayground = nil;
    [tween animateProperty:@"alpha" targetValue:0];
    [mGameoverJuggler addObject:tween];
    [self animateAllButtons];
    [[mGameoverJuggler delayInvocationAtTarget:self byTime:time] killPlayground];
}

-(void)killPlayground {
    [self removeChildAtIndex:self.numChildren-1];
}

-(void)onHelp:(SPEvent *)event {
    
}

-(void)onCredits:(SPEvent *)event {
    
}

-(void) advanceTime:(double) seconds {
    [mGameoverJuggler advanceTime:seconds];
    if (mPlayground) {
        [mPlayground advanceTime:seconds];
    } else {
        [mJuggler advanceTime:seconds];
        for (int i =0; i < mosquitoes.numChildren; i++) {
            if ([[mosquitoes childAtIndex:i] isKindOfClass:[MosquitoSprite class]]) {
                MosquitoSprite* m = (MosquitoSprite*)[mosquitoes childAtIndex:i];
                [m advanceTime:seconds];
            }
        }
    }

}

-(void)dealloc {
    [mJuggler release];
    [mGameoverJuggler release];
    [self dealloc];
}
@end
