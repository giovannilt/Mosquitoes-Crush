//
//  MosquitoTouchEvent.m
//  Sparrow_test
//
//  Created by Iviso Malazzi on 3/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MosquitoTouchEvent.h"

@implementation MosquitoTouchEvent

@synthesize mosquito, mpoint;

- (id)initWithType:(NSString *)type mosquito:(MosquitoSprite*) pmosquito point:(SPPoint *)point
{
    self = [super initWithType:type bubbles:NO];
    if (self) {
        self.mosquito = pmosquito;
        self.mpoint = point;
    }
    
    return self;
}

- (void)dealloc {
    [mosquito release];
    [mpoint release];
    [super dealloc];
}

@end
