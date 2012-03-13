//
//  SuckedEvent.h
//  Sparrow_test
//
//  Created by Iviso Malazzi on 3/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SPEvent.h"

#define EVENT_TYPE_MOSQUITO_SUCKED @"mosquitoSucked"

@interface SuckedEvent : SPEvent {
    int mDamage;
}

@property(nonatomic, assign) int damage;

- (id)initWithType:(NSString *)type andDamage:(int) d;

@end
