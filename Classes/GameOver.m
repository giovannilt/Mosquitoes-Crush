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
    
        SPTextField* points = [SPTextField textFieldWithText:@"score:"];
        points.x = 80;
        points.y = 10;
        points.fontName = @"MarkerFelt-Thin";
        points.color = 0xff0000;
        points.hAlign = SPHAlignRight;
        points.vAlign = SPVAlignCenter;
        points.fontSize = 15;
        points.kerning = YES;
        [self addChild:points];    
        
        NumberField* pointsN = [[NumberField alloc] initWithText:@""];
        pointsN.value = 0;
        pointsN.x = 210;
        pointsN.y = 10;
        pointsN.fontName = @"MarkerFelt-Thin";
        pointsN.color = 0xff0000;
        pointsN.hAlign = SPHAlignLeft;
        pointsN.vAlign = SPVAlignCenter;
        pointsN.fontSize = 15;
        pointsN.kerning = YES;
        [self addChild:pointsN];
        SPTween* tween = [SPTween tweenWithTarget:pointsN time:0.8];
        [tween animateProperty:@"value" targetValue:p];
        [mJuggler addObject:tween];
        [pointsN release];
        
        SPTextField* acc = [SPTextField textFieldWithText:@"accuracy:"];
        acc.x = 80;
        acc.y = 24;
        acc.fontName = @"MarkerFelt-Thin";
        acc.color = 0xff0000;
        acc.hAlign = SPHAlignRight;
        acc.vAlign = SPVAlignCenter;
        acc.fontSize = 15;
        acc.kerning = YES;
        [self addChild:acc];    
    
        NumberField* accN = [[NumberField alloc] initWithText:@""];
        accN.postfix = @" %";
        accN.value = 0;
        int val = 0;
        if (hits + miss > 0) {
            val = (hits*1.0 / (hits + miss)) * 100; 
        }
        accN.x = 210;
        accN.y = 24;
        accN.fontName = @"MarkerFelt-Thin";
        accN.color = 0xff0000;
        accN.hAlign = SPHAlignLeft;
        accN.vAlign = SPVAlignCenter;
        accN.fontSize = 15;
        accN.kerning = YES;
        [self addChild:accN];
        tween = [SPTween tweenWithTarget:accN time:0.8];
        tween.delay = 0.8;
        [tween animateProperty:@"value" targetValue:val];
        [mJuggler addObject:tween];
        [accN release];

        SPTextField* lgc = [SPTextField textFieldWithText:@"longest combo:"];
        lgc.x = 80;
        lgc.y = 38;
        lgc.fontName = @"MarkerFelt-Thin";
        lgc.color = 0xff0000;
        lgc.hAlign = SPHAlignRight;
        lgc.vAlign = SPVAlignCenter;
        lgc.fontSize = 15;
        lgc.kerning = YES;
        [self addChild:lgc];    
        
        NumberField* lgcN = [[NumberField alloc] initWithText:@""];
        lgcN.value = 0;
        lgcN.x = 210;
        lgcN.y = 38;
        lgcN.fontName = @"MarkerFelt-Thin";
        lgcN.color = 0xff0000;
        lgcN.hAlign = SPHAlignLeft;
        lgcN.vAlign = SPVAlignCenter;
        lgcN.fontSize = 15;
        lgcN.kerning = YES;
        [self addChild:lgcN];
        tween = [SPTween tweenWithTarget:lgcN time:0.8];
        tween.delay = 1.6;
        [tween animateProperty:@"value" targetValue:lc];
        [mJuggler addObject:tween];
        [lgcN release];
        
        SPTextField* total = [SPTextField textFieldWithText:@"TOTAL:"];
        total.x = 80;
        total.y = 60;
        total.fontName = @"MarkerFelt-Thin";
        total.color = 0xff0000;
        total.hAlign = SPHAlignRight;
        total.vAlign = SPVAlignCenter;
        total.fontSize = 17;
        total.kerning = YES;
        [self addChild:total];    
        
        NumberField* totalN = [[NumberField alloc] initWithText:@""];
        totalN.value = 0;
        totalN.x = 210;
        totalN.y = 60;
        totalN.fontName = @"MarkerFelt-Thin";
        totalN.color = 0xff0000;
        totalN.hAlign = SPHAlignLeft;
        totalN.vAlign = SPVAlignCenter;
        totalN.fontSize = 17;
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
        return points * ((hits*1.0)/(hits + misses)) + lg * 7; 
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
