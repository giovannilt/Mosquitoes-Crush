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
#import "MosquitoTouchEvent.h"

int totalWave = 4;
int currentWave = 0;

double waves[][11] = {
    //Time_0, Pacific_1, Lvl1_2, Lvl1WI_3, Lvl1WE_4, Lvl2_5, Lvl2WI_6, Lvl2WE_7, Lvl3_8, Lvl3WI_9, Lvl3WE_10
    { 20.0  , 0.0      , 7.0  , 0.5     , 1     , 0.0   , 0.0     , 0.0     , 0.0   , 0.0     , 0.0      },
    { 25.0  , 0.0      , 6.0  , 0.5     , 1     , 3.0   , 1.0     , 1.5     , 0.0   , 0.0     , 0.0      },
    { 25.0  , 2.0      , 7.0  , 0.5     , 1     , 3.0   , 2.0     , 1.5     , 0.0   , 0.0     , 0.0      },
    { 30.0  , 3.0      , 6.0  , 0.5     , 1     , 4.0   , 1.0     , 1.5     , 2.0   , 1.5     , 5.0      }
};

@interface MainMenu() {
    int kills;
    int HScore;
    double maxWidth;
    double maxHeight;
    SPTextField* HScoreTF;
    SPImage* HelpImg;
    SPSprite* CreditsSprt;
}
-(void) onStart:(SPEvent*) event;
-(float) animateMenuButton:(SPButton*) button targetY:(float) tY delay:(float) delay;
-(void) onHelp:(SPEvent*) event;
-(void) onCredits:(SPEvent*) event;
-(void) gameover:(SPEvent*) event;
-(void) killPlayground;
-(void) createButtons;
-(void) resetButtons;
-(void) animateAllButtons;
-(void) marathon;
-(void) startMarathon;
-(void) countDownValue:(int) val;
-(void) killit:(MosquitoTouchEvent*) event;
-(void) updateHighScore:(double) score;
-(void) nextRound:(SPEvent*) event;
-(void) onHelpTouched:(SPTouchEvent*) event;
-(void) onCreditsTouched:(SPTouchEvent*) event;
@end

@implementation MainMenu

- (id)initWithWidth:(float) mW andHeight:(float) mH
{
    self = [super init];
    if (self) {
        mJuggler = [[SPJuggler alloc] init];
        mGameoverJuggler = [[SPJuggler alloc] init];
        mInGameJuggler = [[SPJuggler alloc] init];
        
        SPImage* bck = [SPImage imageWithTexture:[Game texture:@"main"]];
        [self addChild:bck];
        self.width = mW;
        self.height = mH;
        maxWidth = mW;
        maxHeight = mH;
        
        HScoreTF = [SPTextField textFieldWithText:@"ZZ Score: "];
        if (HScore == 0) {
            HScoreTF.visible = NO;
        }
        HScoreTF.x = 150;
        HScoreTF.y = 130;
        HScoreTF.fontName = [Game fontMF];
        HScoreTF.color = SP_WHITE;
        HScoreTF.hAlign = SPHAlignLeft;
        HScoreTF.vAlign = SPVAlignTop;
        HScoreTF.fontSize = 18;
        HScoreTF.kerning = YES;
        [self addChild:HScoreTF];
        
        SPImage* sparrow = [SPImage imageWithTexture:[Game texture:@"sparrow"]];
        sparrow.x = 1;
        sparrow.y = maxHeight - 40;
        sparrow.alpha = 0.7;
        [self addChild:sparrow];
    
        [self createButtons];
        [self resetButtons];
        [self animateAllButtons];
        
        mosquitoes = [SPSprite sprite];
        int width = 170;
        int height = 80;
        mosquitoes.width = width;
        mosquitoes.height = height;
        mosquitoes.x = 60;
        mosquitoes.y = 370;
       // SPQuad* q = [SPQuad quadWithWidth:width height:height color:0xffffff];
       // [mosquitoes addChild:q];
        for(int i =0; i < 5; i++) {
            MosquitoSprite* m1 = [[MosquitoSprite alloc] initWithWidth:20 andHeight:17 speed:50.0 flyprob:1.0 life:0.0 power:0 worth:0 maxW:width maxH:height statsH:0.0];
            m1.x = width/2.0;
            m1.y = height/2.0;
            [mosquitoes addChild:m1];
            [m1 release];
        }
        [self addChild:mosquitoes];
        HelpImg = [SPImage imageWithTexture:[Game texture:@"helpbg"]];
        HelpImg.x = mW;
        HelpImg.y = 0;
        HelpImg.width = mW;
        HelpImg.height = mH;
        HelpImg.alpha = 0.0;
        HelpImg.visible = NO;
        [HelpImg addEventListener:@selector(onHelpTouched:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        [self addChild:HelpImg];    
        
        CreditsSprt = [SPSprite sprite];
        CreditsSprt.x = mW;
        CreditsSprt.y = 0;
        CreditsSprt.width = mW;
        CreditsSprt.height = mH;
        CreditsSprt.alpha = 0.0;
        CreditsSprt.visible = NO;
        [CreditsSprt addEventListener:@selector(onCreditsTouched:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        SPQuad* quad = [SPQuad quadWithWidth:mW height:mH];
        quad.color = 0x000000;
        [CreditsSprt addChild:quad];
        SPTextField* txtFld = [SPTextField textFieldWithText:@"CREDITS\n\nDesign & Programming\nLuis Perez Sanchez"];
        txtFld.fontName = @"MarkerFelt-Thin";
        txtFld.color = 0xffffff;
        txtFld.vAlign = SPVAlignTop;
        txtFld.hAlign = SPHAlignLeft;
        txtFld.x = 20;
        txtFld.y = 50;
        txtFld.width = mW - 40;
        txtFld.fontSize = 20;
        [CreditsSprt addChild:txtFld];
        SPImage* spaBig = [SPImage imageWithTexture:[Game texture:@"sparrow"]];
        spaBig.x = 20;
        spaBig.y = 250;
        spaBig.scaleX = 1.1;
        spaBig.scaleY = 1.1;
        [CreditsSprt addChild:spaBig];
        [self addChild:CreditsSprt];
    }
    
    return self;
}

-(void)resetButtons {
    int width = 150;
    int height = 71;
    float x = (maxWidth - width) / 2.0;
    y1 = 180;
    start.width = width;
    start.height = height;
    start.alpha = 0;
    start.x = x;
    start.y = 140;
    start.scaleY = 0;

    width = 120;
    height = 56;
    x = (maxWidth - width) / 2.0;
    y2 = 245;
    help.width = width;
    help.height = height;
    help.alpha = 0;
    help.x = x;
    help.y = 222;
    help.scaleY = 0;

    width = 90;
    height = 42;
    x = (maxWidth - width) / 2.0;
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
    time = [self animateMenuButton:help targetY:y2 delay:time/1.5];
    [self animateMenuButton:credits targetY:y3 delay:time/1.5];    
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
    SPTween* stween = [SPTween tweenWithTarget:button time:0.6 transition:SP_TRANSITION_EASE_OUT_BACK];
    [stween animateProperty:@"scaleY" targetValue:1.0];
    [stween animateProperty:@"y" targetValue:tY];
    [stween animateProperty:@"alpha" targetValue:1.0];
    stween.delay = delay;
    [mJuggler addObject:stween];
    return delay + stween.time;
}

-(void)onStart:(SPEvent *)event {
    mPlayground = [[Playground alloc] initWithWidth:maxWidth andHeight:maxHeight];
    [self addChild:mPlayground];
    [mPlayground addEventListener:@selector(gameover:) atObject:self forType:EVENT_GAMEOVER];
    //[mPlayground release];
    [self marathon];
}

-(void)marathon {
    [self countDownValue:3];
    currentWave = 0;
    //[mPlayground launchMosquitoAtX:160 Y:240 FlyProb:1.0 Life:1 Power:1];
}

-(void) countDownValue:(int)val {
    SPTextField* counter = [SPTextField textFieldWithText:@"3"];
    counter.fontName=@"AmericanTypewriter-Bold";
    counter.fontSize = 60;
  //  counter.border = YES;
    counter.hAlign = SPHAlignCenter;
    counter.vAlign = SPVAlignCenter;
    counter.kerning = YES;
    counter.color = SP_BLACK;
    [self addChild:counter];
    counter.x = (maxWidth - counter.width)/2.0;
    counter.y = 20;     
    if (val > 0) {
        counter.text = [NSString stringWithFormat:@"%d", val];
    } else {
        counter.text = @"GO!";
    }
    SPTween* tween = [SPTween tweenWithTarget:counter time:1.5 transition:SP_TRANSITION_EASE_OUT];
    [tween scaleTo:2.0];
    [tween moveToX:counter.x - counter.width*0.5 y:counter.y - counter.height*0.5];
    [tween animateProperty:@"alpha" targetValue:0.0];
    [mInGameJuggler addObject:tween];
    [[mInGameJuggler delayInvocationAtTarget:counter byTime:1.5] removeFromParent];
    if (val > 0) {
        [[mInGameJuggler delayInvocationAtTarget:self byTime:1.0] countDownValue:val-1];
    } else {
        [[mInGameJuggler delayInvocationAtTarget:self byTime:1.0] startMarathon];
    }
}

-(void)startMarathon {
    [self nextRound:nil];
    //[mPlayground showClock:7.0];
 //   [mPlayground addEventListener:@selector(killit:) atObject:self forType:EVENT_TYPE_MOSQUITO_TOUCHED];
    [mPlayground addEventListener:@selector(nextRound:) atObject:self forType:EVENT_CLOCK_ENDED];
}

-(void)nextRound:(SPEvent *)event {
    double time = 0;
    for (int i = 0; i < waves[currentWave][1]; i++) {
        [mPlayground launchPacificAtX:arc4random()%(int)(maxWidth-90) + 15 Y:arc4random()%(int)(maxHeight-180)+37];
    }
    for (int i =0; i < waves[currentWave][2]; i++) {
        double prob = (arc4random()%1000/1000.0)*(waves[currentWave][4] - waves[currentWave][3]) + waves[currentWave][3];
        time += prob;
        [[mInGameJuggler delayInvocationAtTarget:mPlayground byTime:time] launchMosquitoAtX:arc4random()%(int)(maxWidth-90)+15 Y:arc4random()%(int)(maxHeight-180)+37 FlyProb:0.75 Life:1 Power:1 Worth:1.5];
    }
    time = 0;
    for (int i =0; i < waves[currentWave][5]; i++) {
        double prob = (arc4random()%1000/1000.0)*(waves[currentWave][7] - waves[currentWave][6]) + waves[currentWave][6];
        time += prob;
        [[mInGameJuggler delayInvocationAtTarget:mPlayground byTime:time] launchMosquitoAtX:arc4random()%(int)(maxWidth-90)+15 Y:arc4random()%(int)(maxHeight-180)+37 FlyProb:0.65 Life:2 Power:2 Worth:3];
    }
    time = 0;
    for (int i =0; i < waves[currentWave][8]; i++) {
        double prob = (arc4random()%1000/1000.0)*(waves[currentWave][10] - waves[currentWave][9]) + waves[currentWave][9];
        time += prob;
        [[mInGameJuggler delayInvocationAtTarget:mPlayground byTime:time] launchMosquitoAtX:arc4random()%(int)(maxWidth-90)+15 Y:arc4random()%(int)(maxHeight-180)+37 FlyProb:0.50 Life:3 Power:3 Worth:5.3];
    }
    if (currentWave + 1 < totalWave) {
        currentWave++;
        [[mInGameJuggler delayInvocationAtTarget:mPlayground byTime:2.0] showClock:waves[currentWave-1][0]];
    } else {
        [[mInGameJuggler delayInvocationAtTarget:mPlayground byTime:2.0] showClock:waves[currentWave][0]];
    }
}

-(void)killit:(MosquitoTouchEvent *)event {
}

-(void)gameover:(SPEvent *)event {
    [self resetButtons];
    float time = 0.2;
    SPTween* tween = [SPTween tweenWithTarget:mPlayground time:time transition:SP_TRANSITION_EASE_IN_OUT];
    double TOTAL = mPlayground.TOTAL;
    mPlayground = nil;
    [tween animateProperty:@"alpha" targetValue:0];
    [mGameoverJuggler addObject:tween];
    [self animateAllButtons];
    [[mGameoverJuggler delayInvocationAtTarget:self byTime:time] killPlayground];
    [[mGameoverJuggler delayInvocationAtTarget:self byTime:time] updateHighScore:TOTAL];
}

-(void)updateHighScore:(double)score {
    if ((int)score > HScore) {
        HScore = score;
        HScoreTF.text = [NSString stringWithFormat:@"ZZ Score: %d", HScore];
        HScoreTF.visible = YES;
    }
}

-(void)killPlayground {
    [self removeChildAtIndex:self.numChildren-1];
}

-(void)onHelp:(SPEvent *)event {
    HelpImg.visible = YES;
    SPTween* tween = [SPTween tweenWithTarget:HelpImg time:0.6 transition:SP_TRANSITION_EASE_OUT_BACK];
    [tween moveToX:0 y:0];
    [tween animateProperty:@"alpha" targetValue:1.0];
    [mGameoverJuggler addObject:tween];
}

-(void) onHelpTouched:(SPTouchEvent *)event {
    SPTouch* touch = [[event touchesWithTarget:HelpImg andPhase:SPTouchPhaseEnded] anyObject];
    if (touch) {
        SPTween* tween = [SPTween tweenWithTarget:HelpImg time:0.4 transition:SP_TRANSITION_EASE_IN_BACK];
        [tween moveToX:maxWidth y:0];
        [tween animateProperty:@"alpha" targetValue:0.0];
        [mGameoverJuggler addObject:tween];
        [[mGameoverJuggler delayInvocationAtTarget:HelpImg byTime:0.4] setVisible:NO];
    }
}

-(void)onCredits:(SPEvent *)event {
    CreditsSprt.visible = YES;
    SPTween* tween = [SPTween tweenWithTarget:CreditsSprt time:0.6 transition:SP_TRANSITION_EASE_OUT_BACK];
    [tween moveToX:0 y:0];
    [tween animateProperty:@"alpha" targetValue:1.0];
    [mGameoverJuggler addObject:tween];    
}

-(void)onCreditsTouched:(SPTouchEvent *)event {
    SPTouch* touch = [[event touchesWithTarget:CreditsSprt andPhase:SPTouchPhaseEnded] anyObject];
    if (touch) {
        SPTween* tween = [SPTween tweenWithTarget:CreditsSprt time:0.4 transition:SP_TRANSITION_EASE_IN_BACK];
        [tween moveToX:maxWidth y:0];
        [tween animateProperty:@"alpha" targetValue:0.0];
        [mGameoverJuggler addObject:tween];
        [[mGameoverJuggler delayInvocationAtTarget:CreditsSprt byTime:0.4] setVisible:NO];
    }
}

-(void) advanceTime:(double) seconds {
    [mGameoverJuggler advanceTime:seconds];
    if (mPlayground) {
        if (!mPlayground.stop) {
            [mInGameJuggler advanceTime:seconds];
        }
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
    [mInGameJuggler release];
    [self dealloc];
}
@end
