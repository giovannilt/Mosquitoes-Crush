//
//  GiftSprite.h
//  Sparrow_test
//
//  Created by Iviso Malazzi on 3/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SPSprite.h"

#define EVENT_GIFT_DISAPEARS @"giftdisapears"
#define EVENT_GIFT_ACTIVATED @"giftactivated"

@interface GiftSprite : SPSprite {
    NSString* imgName;
    SPJuggler* mJuggler;
}

- (id)initWithImgName:(NSString*) iname Width:(double) w Height:(double) h;

- (void) animate;

- (void) advanceTime:(double) seconds;

- (void) onAnimationCompleted:(SPEvent*) event;

- (void) onTouch:(SPTouchEvent*) event;

- (BOOL) terminateGiftSameClass;

- (void) terminate;
@end
