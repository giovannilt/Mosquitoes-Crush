//
//  GameOver.m
//  Sparrow_test
//
//  Created by Iviso Malazzi on 3/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameOver.h"
#import "Game.h"
#import "NumberField.h"

@interface GameOver()
-(double) computeTotalFromPoints:(int) points Hits:(int) hits Misses:(int) misses LG:(int) lg;
@end

@implementation GameOver

@synthesize TOTAL;

- (id)initWithWidth:(double) w height:(double) h points:(int) p hits:(int)hits misses:(int)miss longestCombo:(int)lc
{
    self = [super init];
    if (self) {
        mJuggler = [[SPJuggler alloc] init];
        self.width = w;
        self.height = h;
        SPImage* img = [SPImage imageWithTexture:[Game texture:@"bledout"]];
        img.width = w;
        img.height = h;
        [self addChild:img];
    
        SPTextField* points = [SPTextField textFieldWithText:@"points:"];
        points.x = 90;
        points.y = 10;
        points.fontName = [Game fontATWR];
        points.color = 0xff0000;
        points.hAlign = SPHAlignRight;
        points.vAlign = SPVAlignCenter;
        points.fontSize = 13;
        points.kerning = YES;
        [self addChild:points];    
        
        NumberField* pointsN = [[NumberField alloc] initWithText:@""];
        pointsN.value = 0;
        pointsN.x = 220;
        pointsN.y = 10;
        pointsN.fontName = [Game fontATWR];
        pointsN.color = 0xff0000;
        pointsN.hAlign = SPHAlignLeft;
        pointsN.vAlign = SPVAlignCenter;
        pointsN.fontSize = 13;
        pointsN.kerning = YES;
        [self addChild:pointsN];
        SPTween* tween = [SPTween tweenWithTarget:pointsN time:0.8];
        [tween animateProperty:@"value" targetValue:p];
        [mJuggler addObject:tween];
        [pointsN release];
        
        SPTextField* acc = [SPTextField textFieldWithText:@"accuracy:"];
        acc.x = 90;
        acc.y = 24;
        acc.fontName = [Game fontATWR];
        acc.color = 0xff0000;
        acc.hAlign = SPHAlignRight;
        acc.vAlign = SPVAlignCenter;
        acc.fontSize = 13;
        acc.kerning = YES;
        [self addChild:acc];    
    
        NumberField* accN = [[NumberField alloc] initWithText:@""];
        accN.postfix = @" %";
        accN.value = 0;
        int val = 0;
        if (hits + miss > 0) {
            val = (hits*1.0 / (hits + miss)) * 100; 
        }
        accN.x = 220;
        accN.y = 24;
        accN.fontName = [Game fontATWR];
        accN.color = 0xff0000;
        accN.hAlign = SPHAlignLeft;
        accN.vAlign = SPVAlignCenter;
        accN.fontSize = 13;
        accN.kerning = YES;
        [self addChild:accN];
        tween = [SPTween tweenWithTarget:accN time:0.8];
        tween.delay = 0.8;
        [tween animateProperty:@"value" targetValue:val];
        [mJuggler addObject:tween];
        [accN release];

        SPTextField* lgc = [SPTextField textFieldWithText:@"longest combo:"];
        lgc.x = 90;
        lgc.y = 38;
        lgc.fontName = [Game fontATWR];
        lgc.color = 0xff0000;
        lgc.hAlign = SPHAlignRight;
        lgc.vAlign = SPVAlignCenter;
        lgc.fontSize = 13;
        lgc.kerning = YES;
        [self addChild:lgc];    
        
        NumberField* lgcN = [[NumberField alloc] initWithText:@""];
        lgcN.value = 0;
        lgcN.x = 220;
        lgcN.y = 38;
        lgcN.fontName = [Game fontATWR];
        lgcN.color = 0xff0000;
        lgcN.hAlign = SPHAlignLeft;
        lgcN.vAlign = SPVAlignCenter;
        lgcN.fontSize = 13;
        lgcN.kerning = YES;
        [self addChild:lgcN];
        tween = [SPTween tweenWithTarget:lgcN time:0.8];
        tween.delay = 1.6;
        [tween animateProperty:@"value" targetValue:lc];
        [mJuggler addObject:tween];
        [lgcN release];
        
        SPTextField* total = [SPTextField textFieldWithText:@"TOTAL:"];
        total.x = 90;
        total.y = 60;
        total.fontName = [Game fontATWB];
        total.color = 0xff0000;
        total.hAlign = SPHAlignRight;
        total.vAlign = SPVAlignCenter;
        total.fontSize = 15;
        total.kerning = YES;
        [self addChild:total];    
        
        NumberField* totalN = [[NumberField alloc] initWithText:@""];
        totalN.value = 0;
        totalN.x = 220;
        totalN.y = 60;
        totalN.fontName = [Game fontATWB];
        totalN.color = 0xff0000;
        totalN.hAlign = SPHAlignLeft;
        totalN.vAlign = SPVAlignCenter;
        totalN.fontSize = 22;
        totalN.kerning = YES;
        [self addChild:totalN];
        tween = [SPTween tweenWithTarget:totalN time:0.8];
        tween.delay = 2.4;
        self.TOTAL = [self computeTotalFromPoints:p Hits:hits Misses:miss LG:lc];
        [tween animateProperty:@"value" targetValue:self.TOTAL];
        [mJuggler addObject:tween];
        [totalN release];
    }
    
    return self;
}

-(double)computeTotalFromPoints:(int)points Hits:(int)hits Misses:(int)misses LG:(int)lg {
    if (hits + misses > 0) {
        return points + points * 0.4 * ((hits*1.0)/(hits + misses)) * lg; 
    } else {
        return 0.0;
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
