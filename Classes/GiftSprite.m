//
//  GiftSprite.m
//  Sparrow_test
//
//  Created by Iviso Malazzi on 3/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GiftSprite.h"
#import "Game.h"

@implementation GiftSprite

- (id)initWithImgName:(NSString*) iname Width:(double) w Height:(double) h
{
    self = [super init];
    if (self) {
        mJuggler = [[SPJuggler alloc] init];
        self.width = w;
        self.height = h;
        SPImage* bck = [SPImage imageWithTexture:[Game texture:iname]];
        double ratio = w / bck.width;
        bck.width = w;
        bck.height *= ratio;
        [self addChild:bck];
        [self addEventListener:@selector(onTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
    }
    
    return self;
}

-(void)animate {
    double y = self.y;
    double h = self.height;
    double sY = self.scaleY;
    SPTween* tween = [SPTween tweenWithTarget:self time:0.1 transition:SP_TRANSITION_EASE_OUT];
    [tween animateProperty:@"y" targetValue:y-h*0.3];
    [mJuggler addObject:tween];
    
    tween = [SPTween tweenWithTarget:self time:0.1  transition:SP_TRANSITION_EASE_IN];
    tween.delay = 0.1;
    [tween animateProperty:@"y" targetValue:y];
    [mJuggler addObject:tween];
    
    tween = [SPTween tweenWithTarget:self time:0.05];
    tween.delay = 0.2;
    [tween animateProperty:@"scaleY" targetValue:sY - 0.2];
    [tween animateProperty:@"y" targetValue:y+h*0.2];
    [mJuggler addObject:tween];
    
    tween = [SPTween tweenWithTarget:self time:0.05];
    tween.delay = 0.25;
    [tween animateProperty:@"scaleY" targetValue:sY];
    [tween animateProperty:@"y" targetValue:y];
    [mJuggler addObject:tween];
    
    tween = [SPTween tweenWithTarget:self time:2.3];
    tween.delay = 0.30;
    [tween animateProperty:@"alpha" targetValue:0];
    [mJuggler addObject:tween];
    
    [tween addEventListener:@selector(onAnimationCompleted:) atObject:self forType:SP_EVENT_TYPE_TWEEN_COMPLETED];
}

-(BOOL)terminateGiftSameClass {
    Playground* p = (Playground*)self.parent;
    BOOL someoneGone = NO;
    if (p) {
        for (GiftSprite* g in p.gifts) {
            if (g != self && [g isKindOfClass:[self class]]) {
                [g terminate];
                someoneGone = YES;
            }
        }
    }
    return someoneGone;
}

-(void)terminate {
    [mJuggler removeAllObjects];
    self.alpha = 0.0;
    [self removeFromParent];
}

- (void)onAnimationCompleted:(SPEvent *)event {
    SPEvent* event1 = [[SPEvent alloc] initWithType:EVENT_GIFT_DISAPEARS bubbles:NO];
    [self dispatchEvent:event1];
    [event1 release];
    [self removeFromParent];
}

- (void)onTouch:(SPTouchEvent *)event {
    SPTouch* touch = [[event touchesWithTarget:self andPhase:SPTouchPhaseEnded] anyObject];
    if (touch) {
        SPEvent* event1 = [[SPEvent alloc] initWithType:EVENT_GIFT_ACTIVATED bubbles:NO];
        [self dispatchEvent:event1];
        [event1 release];
    }
}

-(void)advanceTime:(double)seconds {
    [mJuggler advanceTime:seconds];
}

-(void)dealloc {
    [mJuggler release];
    [super dealloc];
}
@end
