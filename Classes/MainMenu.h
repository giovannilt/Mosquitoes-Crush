//
//  MainMenu.h
//  Sparrow_test
//
//  Created by Iviso Malazzi on 3/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SPSprite.h"
#import "Playground.h"

@interface MainMenu : SPSprite {
    SPJuggler* mJuggler;
    Playground* mPlayground;
    SPSprite* mosquitoes;
    SPJuggler* mGameoverJuggler;
    SPButton* start;
    SPButton* help;
    SPButton* credits;
    float y1, y2, y3;
}
-(void) advanceTime:(double) seconds;

- (id)initWithWidth:(float) mW andHeight:(float) mH;
@end
