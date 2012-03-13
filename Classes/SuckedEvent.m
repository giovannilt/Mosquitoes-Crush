//
//  SuckedEvent.m
//  Sparrow_test
//
//  Created by Iviso Malazzi on 3/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SuckedEvent.h"

@implementation SuckedEvent

@synthesize damage = mDamage;

- (id)initWithType:(NSString *)type andDamage:(int) d
{
    self = [super initWithType:type bubbles:NO];
    if (self) {
        mDamage = d;
    }
    
    return self;
}

@end
