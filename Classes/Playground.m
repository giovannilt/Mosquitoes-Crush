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
#import "HeartGift.h"
#import "SprayGift.h"
#import "LightningGift.h"
#import "PacificSprite.h"

@interface Playground() {
    int longestCombo;
    BOOL showResults;
}
-(void) sucked:(SuckedEvent*) event;
-(void) gameover:(SPTouchEvent*) event;
-(void) onHit:(SPEvent*) event;
-(void) onMiss:(SPEvent*) event;
-(void) onTouched:(SPTouchEvent*) event;
-(void) showCombo;
-(void) removeMosquito:(MosquitoSprite*) mosquito;
-(void) placeGiftAtX:(double) x Y:(double) y Width:(double) w andHeight:(double) h;
-(GiftSprite*) selectGiftWithWidth:(double)w Height:(double) h;
-(void) setComboText:(NSString*) text;
-(void) killPacific:(MosquitoTouchEvent*) event;
-(void) hitPacific:(SPEvent*) event;
-(void) removePacific:(PacificSprite*) pacific Transform:(BOOL) trans;
-(void) stopClock;
-(void) onClockTouched:(SPTouchEvent*) event;
-(void) onClockEnded:(SPEvent*) event;
@end

@implementation Playground

@synthesize statsHeight, colors, juggler = mJuggler, canSuck, life, TOTAL, mustBurn, gifts, stop;

- (id)initWithWidth:(float) width andHeight:(float) height
{
    self = [super init];
    if (self) {
        mustBurn = NO;
        showResults = YES;
        self.canSuck = YES;
        longestCombo = 0;
        combo = 1;
        gMsg = nil;
        countHit = 0;
        countMiss = 0;
        colors = [[NSArray arrayWithObjects:[NSNumber numberWithInt:0xffffff], [NSNumber numberWithInt:0xff9999], [NSNumber numberWithInt:0xff3333] , nil] retain];
        mJuggler = [[SPJuggler alloc] init];
        mClockJuggler = [[SPJuggler alloc] init];
        mosquitoes = [[NSMutableArray alloc] init];
        gifts = [[NSMutableArray alloc] init];
        
        self.width = width;
        self.height = height;
        
        
        spraybckImg = [SPImage imageWithTexture:[Game texture:@"spraygamebg"]];
        [self addChild:spraybckImg];

        bckImg = [SPImage imageWithTexture:[Game texture:@"gamebg"]];
        [self addChild:bckImg];
        
        points = [[NumberField alloc] initWithText:@"Points: "];
        points.value = 0;
        points.fontName = @"MarkerFelt-Thin";
        points.color = SP_WHITE;// 0x11aa44;
        points.hAlign = SPHAlignLeft;
        points.vAlign = SPVAlignTop;
        points.fontSize = 20;
        points.outline = YES;
        points.shadow = YES;
        points.shadowX = 1.5;
        points.shadowY = 1.5;
        points.shadowBlur = 1.0;
        points.shadowColor = 0x333333;
        points.outlineColor = 0x000000;
        points.outlineWidth = 0.4;
        points.x = 5;
        points.y = 1.5;
        [self addChild:points];

        life = [[NumberField alloc] initWithText:@""];
        life.value = 100;
        life.fontName = @"MarkerFelt-Thin";
        life.fontSize = 20;
        life.hAlign = SPHAlignRight;
        life.vAlign = SPVAlignTop;
        life.color = SP_WHITE;// 0xff4444;
        life.shadow = YES;
        life.shadowColor = 0x000000;
        life.shadowX = 1.5;
        life.shadowY = 1.5;
        life.shadowBlur = 1.0;
        life.outline = YES;
        life.outlineColor = 0x000000;
        life.outlineWidth = 0.4;
        life.x = 160;
        life.y = 1.5;
        life.kerning = YES;
        [self addChild:life];
        
        clockClip = [SPMovieClip movieWithFrames:[Game textures:@"clock"] fps:10.0];
        clockClip.visible = NO;
        clockClip.loop = NO;
        clockClip.width = clockClip.width*0.7;
        clockClip.height = clockClip.height*0.7;
        clockClip.x = self.width/2.0 - clockClip.width/2.0;
        [clockClip pause];
        clockClip.y = 1;
        [self addChild:clockClip];
        [mClockJuggler addObject:clockClip];
        [clockClip addEventListener:@selector(onClockEnded:) atObject:self forType:SP_EVENT_TYPE_MOVIE_COMPLETED];
        [clockClip addEventListener:@selector(onClockTouched:) atObject:self forType:SP_EVENT_TYPE_TOUCH];

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
        
        comboTF = [SPTextField textFieldWithText:@"COMBO x1"];
        comboTF.fontName = @"AmericanTypewriter-Bold";
        comboTF.fontSize = 22;
        comboTF.hAlign = SPHAlignLeft;
        comboTF.vAlign = SPVAlignTop;
        comboTF.color = 0xff9900;
        comboTF.x = 1;
        comboTF.y = 20;
        comboTF.shadow = YES;
        comboTF.shadowBlur = 2.0;
        comboTF.shadowColor = 0x000000;
        comboTF.shadowX = 2.0;
        comboTF.shadowY = 2.0;
        comboTF.outline = YES;
        comboTF.outlineColor = 0xcc6600;
        comboTF.outlineWidth = 0.7;
        comboTF.alpha = 0;
        comboTF.kerning = YES;
        [self addChild:comboTF];
        comboTF.width = 150;
        
        statsHeight = 20;
        
        stop = NO;
        
        [bckImg addEventListener:@selector(onTouched:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        [self addEventListener:@selector(onMiss:) atObject:self forType:EVENT_INCORRECT_TOUCH];
    }
    
    return self;
}

-(void)showClock:(double)time {
    double fps = 7.0 / time;
    clockClip.fps = fps;
    clockClip.visible = YES;
    SPTween* tween = [SPTween tweenWithTarget:clockClip time:0.2];
    [tween animateProperty:@"alpha" targetValue:1];
    [mClockJuggler addObject:tween];
    [clockClip setCurrentFrame:0];
    [clockClip play];
}

-(void) stopClock {
    [clockClip pause];
    SPTween* tween = [SPTween tweenWithTarget:clockClip time:0.2];
    [tween animateProperty:@"alpha" targetValue:0.0];
    [mClockJuggler addObject:tween];
    SPEvent* event = [[SPEvent alloc] initWithType:EVENT_CLOCK_ENDED bubbles:NO];
    [self dispatchEvent:event];
    [event release];
}

-(void)onClockTouched:(SPTouchEvent *)event {
    SPTouch *touch = [[event touchesWithTarget:clockClip andPhase:SPTouchPhaseEnded] anyObject];
    if(touch) {
        [self stopClock];
        SPTween* tween = [SPTween tweenWithTarget:points time:0.2f];
        [tween animateProperty:@"value" targetValue:points.value + 10];
        [mJuggler addObject:tween];
    }
}

-(void)onClockEnded:(SPEvent *)event {
    [self stopClock];
}

-(void) swapBGtoNormal {
    SPTween* tween = [SPTween tweenWithTarget:bckImg time:0.3];
    [tween animateProperty:@"alpha" targetValue:1];
    [mJuggler addObject:tween];    
}

-(void)swapBGToCream {
    SPTween* tween = [SPTween tweenWithTarget:bckImg time:0.3];
    [tween animateProperty:@"alpha" targetValue:0];
    [mJuggler addObject:tween];    
}

-(void) launchMosquitoAtX:(double) x Y:(double) y FlyProb:(double) fp Life:(double) lif Power:(double) pow Worth:(double) worth {
    MosquitoSprite* m = [[MosquitoSprite alloc] initWithWidth:60 andHeight:48 speed:150.0 flyprob:fp life:lif power:pow worth:lif maxW:self.width maxH:self.height statsH:statsHeight];
    [m addEventListener:@selector(killit:) atObject:self forType:EVENT_TYPE_MOSQUITO_TOUCHED];
    [m addEventListener:@selector(sucked:) atObject:self forType:EVENT_TYPE_MOSQUITO_SUCKED];
    [m addEventListener:@selector(onHit:) atObject:self forType:EVENT_CORRECT_TOUCH];
    [mosquitoes addObject:m];
    [self addChild:m];
    [m initColor];
    m.x = x;
    m.y = y;
    [m release];
}

- (void)launchPacificAtX:(double)x Y:(double)y {
    PacificSprite* m = [[PacificSprite alloc] initWithMaxWidth:self.width MaxHeight:self.height StatsHeight:statsHeight];
    [m addEventListener:@selector(killPacific:) atObject:self forType:EVENT_TYPE_MOSQUITO_TOUCHED];
    [m addEventListener:@selector(hitPacific:) atObject:self forType:EVENT_CORRECT_TOUCH];  
    [mosquitoes addObject:m];
    [self addChild:m];
    [m initPacificColor];
    m.x = x;
    m.y = y;
    [m release];
}

-(void)removeAllPacific {
    for (MosquitoSprite* m in mosquitoes) {
        if ([m isKindOfClass:[PacificSprite class]]) {
            MosquitoTouchEvent* event = [[MosquitoTouchEvent alloc] initWithType:EVENT_TYPE_MOSQUITO_TOUCHED mosquito:m point:nil];
            event.transformPacific = NO;
            [self killPacific:event];
            [event release];
        }
    }
}

-(void) showCombo {
    SPTween* tween = [SPTween tweenWithTarget:comboTF time:0.7 transition:SP_TRANSITION_EASE_IN_OUT_ELASTIC];
    [tween scaleTo:1.2];
    [tween animateProperty:@"alpha" targetValue:1];
    [mJuggler addObject:tween];
    [[mJuggler delayInvocationAtTarget:self byTime:0.3] setComboText:[NSString stringWithFormat:@"COMBO x%d", combo]];
    tween = [SPTween tweenWithTarget:comboTF time:0.3 transition:SP_TRANSITION_EASE_IN_OUT];
    tween.delay = 0.7;
    [tween scaleTo:1];
    [tween animateProperty:@"alpha" targetValue:0.5];
    [mJuggler addObject:tween];
}

-(void)setComboText:(NSString *)text {
    comboTF.text = text;
}

-(void)hitPacific:(SPEvent *)event {
    if (!stop) {
        countMiss++;
        combo = 1;
        comboTF.alpha = 0;
    }
}

-(void)killPacific:(MosquitoTouchEvent *)event {
    SPTween* tween = [SPTween tweenWithTarget:event.mosquito time:1];
    [tween animateProperty:@"alpha" targetValue:0];
    [mJuggler addObject:tween];
    [[mJuggler delayInvocationAtTarget:self byTime:1] removePacific:(PacificSprite*)event.mosquito Transform:event.transformPacific];    
}

-(void)removePacific:(PacificSprite *)pacific Transform:(BOOL)trans {
    pacific.visible = NO;
    double x = pacific.x;
    double y = pacific.y;
    [self removeChild:pacific];
    if (trans) {
        [self launchMosquitoAtX:x Y:y FlyProb:0.50 Life:3 Power:3 Worth:5.3];
    }
}

-(void) onHit:(SPEvent *)event {
    if (!stop) {
        countHit++;
        combo++;
        if (longestCombo < combo) { longestCombo = combo; }
        [self showCombo];
    }
}

-(void)onMiss:(SPEvent *)event {
    if (!stop) {
        countMiss++;
        combo = 1;
        comboTF.alpha = 0;
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

-(GiftSprite*)selectGiftWithWidth:(double)w Height:(double)h {
    double probKind = arc4random()%1000/1000.0;
    double s = 0;
    NSString* arr[] = {@"HeartGift", @"LightningGift", @"SprayGift"};
    double dist[] = {0.7, 0.25, 0.05};
    int tot = 3;
    for (int i =0; i < tot; i++) {
        s += dist[i];
        if (s >= probKind) {
            return [[NSClassFromString(arr[i]) alloc] initWithWidth:w Height:h];
        }
    }
    return [[HeartGift alloc] initWithWidth:w Height:h];
}

-(void)placeGiftAtX:(double)x Y:(double)y Width:(double)w andHeight:(double)h{
    double probGift = arc4random()%1000/1000.0;
    if (probGift <= 0.25) {
        double oW = w, oH = h;
        w = w*0.6;
        h = h*0.6;
        x = x + (oW - w)/2.0;
        y = y + (oH - h)/2.0;
        GiftSprite* gift = [self selectGiftWithWidth:w Height:h];
        gift.x = x;
        gift.y = y;
        [self addChild:gift];
        [gifts addObject:gift];
        [gift animate];
        [gift release];
    }
}

- (void)interruptSucking {
    for (MosquitoSprite*m in mosquitoes) {
        if (m.visible) {
            [m interruptSucking];
        }
    }
}

-(void)stopGame {
    @synchronized(self) {
        if (showResults) {
            showResults = NO;
            gMsg = [[GameOver alloc] initWithWidth:300 height:162 points:points.value hits:countHit misses:countMiss longestCombo:longestCombo];
            float x = self.width/2.0 - 150;
            float y = self.height/2.0 -50 - 81;
            gMsg.x = self.width/2.0;
            gMsg.y = self.height/2.0 - 50;
            gMsg.scaleY = 0;
            gMsg.scaleX = 0;
            gMsg.alpha = 0;
            [self addChild:gMsg];
            [[mJuggler delayInvocationAtTarget:gMsg byTime:3.5] addEventListener:@selector(gameover:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
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
        self.TOTAL = gMsg.TOTAL;
        SPEvent* event = [[SPEvent alloc] initWithType:EVENT_GAMEOVER bubbles:NO];
        [self dispatchEvent:event];
        [event release];
    }
}

-(void)sucked:(SuckedEvent *)event {
    int damage = event.damage;
    if (life.value - damage <= 0) {
        damage = life.value;
        stop = YES;
        [[mJuggler delayInvocationAtTarget:self byTime:1.5] stopGame];
    }
    SPTween* tween = [SPTween tweenWithTarget:life time:0.2f];
    [tween animateProperty:@"value" targetValue:life.value - damage];
    [mJuggler addObject:tween];
}

-(void) advanceTime:(double) seconds {
    [mJuggler advanceTime:seconds];
    if(!stop) {
        [mClockJuggler advanceTime:seconds];
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
    [mClockJuggler release];
    [life release];
    [points release];
    [mosquitoes release];
    [super dealloc];
}

@end
