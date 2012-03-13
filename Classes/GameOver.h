//
//  GameOver.h
//  Sparrow_test
//
//  Created by Iviso Malazzi on 3/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SPSprite.h"

@interface GameOver : SPSprite {
    SPJuggler* mJuggler;
}
- (id)initWithWidth:(double) w height:(double) h points:(int) p hits:(int) hits misses:(int) miss;
-(void) advanceTime:(double) seconds;
@end
