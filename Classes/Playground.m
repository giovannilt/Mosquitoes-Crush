//
//  Playground.m
//  Sparrow_test
//
//  Created by Iviso Malazzi on 3/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Playground.h"
#import "MosquitoSprite.h"
#import "SuckedEvent.h"
#import "MosquitoTouchEvent.h"
#import "GameOver.h"
#import "Game.h"
#import "GiftSprite.h"

@interface Playground()
-(void) sucked:(SuckedEvent*) event;
-(void) gameover:(SPTouchEvent*) event;
-(void) onHit:(SPEvent*) event;
-(void) onMiss:(SPEvent*) event;
-(void) onTouched:(SPTouchEvent*) event;
-(void) showCombo;
-(void) removeMosquito:(MosquitoSprite*) mosquito;
-(void) placeGiftAtX:(double) x Y:(double) y Width:(double) w andHeight:(double) h;
-(void) onGiftActivated:(SPEvent*) event;
@end

@implementation Playground

@synthesize statsHeight, colors, juggler = mJuggler, canSuck;

- (id)initWithWidth:(float) width andHeight:(float) height
{
    self = [super init];
    if (self) {
        self.canSuck = NO;
        combo = 1;
        gMsg = nil;
        countHit = 0;
        countMiss = 0;
        colors = [[NSArray arrayWithObjects:[NSNumber numberWithInt:0xffffff], [NSNumber numberWithInt:0xff9999], [NSNumber numberWithInt:0xff3333] , nil] retain];
        mJuggler = [[SPJuggler alloc] init];
        mosquitoes = [[NSMutableArray alloc] init];
        gifts = [[NSMutableArray alloc] init];
        
        self.width = width;
        self.height = height;
        
        bckImg = [SPImage imageWithTexture:[Game texture:@"gamebg"]];
        [self addChild:bckImg];
        
        points = [[NumberField alloc] initWithText:@"Kills: "];
        points.value = 0;
        points.fontName = @"MarkerFelt-Thin";
        points.color = SP_BLACK;
        points.hAlign = SPHAlignLeft;
        points.vAlign = SPVAlignTop;
        points.fontSize = 20;
        points.x = 5;
        points.y = 0;
        points.kerning = YES;
        [self addChild:points];

        life = [[NumberField alloc] initWithText:@""];
        life.value = 100;
        life.fontName = @"MarkerFelt-Thin";
        life.fontSize = 20;
        life.hAlign = SPHAlignRight;
        life.vAlign = SPVAlignTop;
        life.color = SP_BLACK;
        life.x = 160;
        life.y = 0;
        life.kerning = YES;
        [self addChild:life];
        
        SPImage* iheart = [SPImage imageWithTexture:[Game texture:@"heart"]];
        iheart.width = 15;
        iheart.height = 15;
        iheart.y = 6;
        iheart.x = 293;
        [self addChild:iheart];
        iheart.pivotX = iheart.width / 2.0;
        iheart.pivotY = iheart.height / 2.0;
        SPTween* beat = [SPTween tweenWithTarget:iheart time:0.2f];
        [beat scaleTo:0.4f];
        [beat moveToX:291 y:4];
        beat.loop = SPLoopTypeReverse;
        [mJuggler addObject:beat];
        
        comboTF = [SPTextField textFieldWithText:@"COMBO x3"];
        comboTF.fontName=@"AmericanTypewriter-Bold";
        comboTF.fontSize = 20;
        comboTF.hAlign = SPHAlignRight;
        comboTF.vAlign = SPVAlignCenter;
        comboTF.color = 0xffc900;
        comboTF.x = 160;
        comboTF.y = 15;
        comboTF.alpha = 0;
        [self addChild:comboTF];
        comboTF.scaleX = 0.7;
        comboTF.scaleY = 0.7;
        
        statsHeight = 20;
        
        stop = NO;
        
        [bckImg addEventListener:@selector(onTouched:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        [self addEventListener:@selector(onMiss:) atObject:self forType:EVENT_INCORRECT_TOUCH];
    }
    
    return self;
}

-(void) launchMosquitoAtX:(double) x andY:(double) y {
    MosquitoSprite* m = [[MosquitoSprite alloc] initWithWidth:60 andHeight:48 speed:0.5 xvariance:50 yvariance:40 flyprob:0.5 life:3 power:1 worth:3 maxW:self.width maxH:self.height maxDisp:100.0 statsH:statsHeight];
    [m addEventListener:@selector(killit:) atObject:self forType:EVENT_TYPE_MOSQUITO_TOUCHED];
    [m addEventListener:@selector(sucked:) atObject:self forType:EVENT_TYPE_MOSQUITO_SUCKED];
    [m addEventListener:@selector(onHit:) atObject:self forType:EVENT_CORRECT_TOUCH];
    [mosquitoes addObject:m];
    [self addChild:m];
    [m initColor];
    m.x = x;
    m.y = y;
    [m fly];
    [m release];
}

-(void) showCombo {
    comboTF.text = [NSString stringWithFormat:@"COMBO x%d", combo];
    SPTween* tween = [SPTween tweenWithTarget:comboTF time:0.7 transition:SP_TRANSITION_EASE_IN_OUT_ELASTIC];
    [tween scaleTo:1];
    [tween animateProperty:@"alpha" targetValue:1];
    [mJuggler addObject:tween];
    tween = [SPTween tweenWithTarget:comboTF time:0.3 transition:SP_TRANSITION_EASE_IN_OUT];
    tween.delay = 0.7;
    [tween scaleTo:0.7];
    [tween animateProperty:@"alpha" targetValue:0];
    [mJuggler addObject:tween];
}

-(void) onHit:(SPEvent *)event {
    if (!stop) {
        countHit++;
        combo++;
        [self showCombo];
    }
}

-(void)onMiss:(SPEvent *)event {
    if (!stop) {
        countMiss++;
        combo = 1;
    }
}

-(void) onTouched:(SPTouchEvent *)event {
    SPTouch *touch = [[event touchesWithTarget:bckImg andPhase:SPTouchPhaseEnded] anyObject];
    if(touch) {
        SPEvent* event = [[SPEvent alloc] initWithType:EVENT_INCORRECT_TOUCH bubbles:NO];
        [self dispatchEvent:event];
        [event release];
    }
}
     
-(void)killit:(MosquitoTouchEvent *)event {
    SPTween* tween = [SPTween tweenWithTarget:points time:0.2f];
    [tween animateProperty:@"value" targetValue:points.value + (event.mosquito.worth * combo)];
    [mJuggler addObject:tween];
    tween = [SPTween tweenWithTarget:event.mosquito time:1];
    [tween animateProperty:@"alpha" targetValue:0];
    [mJuggler addObject:tween];
    [[mJuggler delayInvocationAtTarget:self byTime:1] removeMosquito:event.mosquito];
}

-(void)removeMosquito:(MosquitoSprite *)mosquito {
    mosquito.visible = NO;
    double x = mosquito.x;
    double y = mosquito.y;
    double w = mosquito.width;
    double h = mosquito.height;
    [self removeChild:mosquito];
    [self placeGiftAtX:x Y:y Width:w andHeight:h];
}

-(void)placeGiftAtX:(double)x Y:(double)y Width:(double)w andHeight:(double)h{
    w = w/2.0;
    h = h/2.0;
    x = x + w/2.0;
    y = y + h/2.0;
    GiftSprite* gift = [[GiftSprite alloc] initWithImgName:@"heart" Width:w Height:h];
    gift.x = x;
    gift.y = y;
    [self addChild:gift];
    [gifts addObject:gift];
    [gift addEventListener:@selector(onGiftActivated:) atObject:self forType:EVENT_GIFT_ACTIVATED];
    [gift animate];
    [gift release];
}

-(void)onGiftActivated:(SPEvent *)event {
    GiftSprite* gift = (GiftSprite*) event.target;
    gift.alpha = 0.0;
    [self removeChild:gift];
    SPTween* tween = [SPTween tweenWithTarget:life time:0.2f];
    int newValue = life.value + 10;
    if (newValue > 100) { newValue = 100; }
    [tween animateProperty:@"value" targetValue:newValue];
    [mJuggler addObject:tween];
}

-(void)stopGame {
    @synchronized(self) {
        if (!stop) {
            stop = YES;
            gMsg = [[GameOver alloc] initWithWidth:300 height:162 points:points.value hits:countHit misses:countMiss];
            float x = self.width/2.0 - 150;
            float y = self.height/2.0 -50 - 81;
            gMsg.x = self.width/2.0;
            gMsg.y = self.height/2.0 - 50;
            gMsg.scaleY = 0;
            gMsg.scaleX = 0;
            gMsg.alpha = 0;
            [self addChild:gMsg];
            [gMsg addEventListener:@selector(gameover:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
            SPTween* tween = [SPTween tweenWithTarget:gMsg time:0.1];
            [tween scaleTo:1];
            [tween moveToX:x y:y];
            [tween animateProperty:@"alpha" targetValue:0.95];
            [mJuggler addObject:tween];
            [gMsg release];
        }
    }
}

-(void)gameover:(SPTouchEvent *)event {
    SPTouch *touch = [[event touchesWithTarget:self andPhase:SPTouchPhaseEnded] anyObject];
    if(touch) {
        SPEvent* event = [[SPEvent alloc] initWithType:EVENT_GAMEOVER bubbles:NO];
        [self dispatchEvent:event];
        [event release];
    }
}

-(void)sucked:(SuckedEvent *)event {
    int damage = event.damage;
    if (life.value - damage <= 0) {
        damage = life.value;
        [[mJuggler delayInvocationAtTarget:self byTime:1.0] stopGame];
    }
    SPTween* tween = [SPTween tweenWithTarget:life time:0.2f];
    [tween animateProperty:@"value" targetValue:life.value - damage];
    [mJuggler addObject:tween];
}

-(void) advanceTime:(double) seconds {
    [mJuggler advanceTime:seconds];
    if(!stop) {
        NSArray* copyM = [mosquitoes copy]; 
        for (MosquitoSprite* m in copyM) {
            if (!m.visible) {
                [mosquitoes removeObject:m];
            } else {
                [m advanceTime:seconds]; 
            }
        }
        [copyM release];
        copyM = [gifts copy];
        for (GiftSprite* g in copyM) {
            if (g.alpha == 0.0) {
                [gifts removeObject:g];
            } else {
                [g advanceTime:seconds];
            }
        }
        [copyM release];
    } else if (gMsg) {
        [gMsg advanceTime:seconds];
    }
}

-(void)dealloc {
    [gifts release];
    [comboTF release];
    [mJuggler release];
    [life release];
    [points release];
    [mosquitoes release];
    [super dealloc];
}

@end
