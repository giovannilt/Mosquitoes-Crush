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

@implementation GameOver

- (id)initWithWidth:(double) w height:(double) h points:(int) p hits:(int)hits misses:(int)miss
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
    }
    
    return self;
}

-(void)advanceTime:(double)seconds {
    [mJuggler advanceTime:seconds];
}

-(void)dealloc {
    [mJuggler release];
    [super dealloc];
}

@end
