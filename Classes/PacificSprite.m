//
//  PacificSprite.m
//  Sparrow_test
//
//  Created by Iviso Malazzi on 3/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PacificSprite.h"

@implementation PacificSprite

- (id)initWithMaxWidth:(double) maxW MaxHeight:(double) maxH StatsHeight:(double) sH
{
    self = [super initWithWidth:60*0.7 andHeight:48*0.7 speed:70.0 flyprob:1.0 life:1 power:1 worth:1 maxW:maxW maxH:maxH statsH:sH];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)initPacificColor {
    flyClip.color = 0x0000ff;
}
@end
