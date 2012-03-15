//
//  LightningGift.m
//  Sparrow_test
//
//  Created by Iviso Malazzi on 3/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LightningGift.h"
#import "Playground.h"

@interface LightningGift()
-(void) onActivated:(SPEvent*) event;
-(void) onEffectEnded:(SPEvent*) event;
@end

@implementation LightningGift

- (id)initWithWidth:(double)w Height:(double)h
{
    self = [super initWithImgName:@"lightning" Width:w Height:h];
    if (self) {
        [self addEventListener:@selector(onActivated:) atObject:self forType:EVENT_GIFT_ACTIVATED];
    }
    
    return self;
}

-(void)onActivated:(SPEvent *)event {
    Playground* pg = (Playground*)self.parent;
    [mJuggler removeAllObjects];
    self.alpha = 1.0;
    if (![self terminateGiftSameClass]) {
        pg.mustBurn = YES;
    }
    SPTween* tween = [SPTween tweenWithTarget:self time:0.5 transition:SP_TRANSITION_EASE_IN_OUT];
    [tween moveToX:275 y:25];
    [mJuggler addObject:tween];
    tween = [SPTween tweenWithTarget:self time:5.0 transition:SP_TRANSITION_EASE_OUT_BOUNCE];
    tween.delay = 0.5;
    [tween animateProperty:@"alpha" targetValue:0.1];
    [tween addEventListener:@selector(onEffectEnded:) atObject:self forType:SP_EVENT_TYPE_TWEEN_COMPLETED];
    [mJuggler addObject:tween];
}

-(void)onEffectEnded:(SPEvent *)event {
    Playground* pg = (Playground*)self.parent;
    pg.mustBurn = NO;
    self.alpha = 0.0;
    [self removeFromParent];    
}


@end
