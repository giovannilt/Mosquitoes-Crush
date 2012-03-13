//
//  HeartGift.m
//  Sparrow_test
//
//  Created by Iviso Malazzi on 3/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HeartGift.h"
#import "Playground.h"

@interface HeartGift()
-(void) onActivated:(SPEvent*) event;
-(void) onEffectEnded:(SPEvent*) event;
@end

@implementation HeartGift

- (id)initWithWidth:(double) w Height:(double) h {
    self = [super initWithImgName:@"heart" Width:w Height:h];
    if (self) {
        [self addEventListener:@selector(onActivated:) atObject:self forType:EVENT_GIFT_ACTIVATED];
    }
    
    return self;
}

-(void)onActivated:(SPEvent *)event {
    Playground* pg = (Playground*)self.parent;
    [mJuggler removeAllObjects];
    self.alpha = 1.0;
    SPTween* tween = [SPTween tweenWithTarget:pg.life time:0.2f];
    int newValue = pg.life.value + 10;
    if (newValue > 100) { newValue = 100; }
    [tween animateProperty:@"value" targetValue:newValue];
    [pg.juggler addObject:tween];
    tween = [SPTween tweenWithTarget:self time:0.5 transition:SP_TRANSITION_EASE_IN_OUT];
    [tween moveToX:290 y:20];
    [tween animateProperty:@"alpha" targetValue:0.01];
    [tween addEventListener:@selector(onEffectEnded:) atObject:self forType:SP_EVENT_TYPE_TWEEN_COMPLETED];
    [mJuggler addObject:tween];
}

-(void)onEffectEnded:(SPEvent *)event {
    self.alpha = 0.0;
    [self removeFromParent];
    
}

@end
