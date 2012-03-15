//
//  MosquitoTouchEvent.h
//  Sparrow_test
//
//  Created by Iviso Malazzi on 3/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SPEvent.h"
#import "MosquitoSprite.h"

#define EVENT_TYPE_MOSQUITO_TOUCHED @"mosquitoTouched"

@interface MosquitoTouchEvent : SPEvent {
    MosquitoSprite* mosquito;
    SPPoint* mpoint;
}

@property (nonatomic, retain) MosquitoSprite* mosquito;
@property (nonatomic, retain) SPPoint* mpoint;
@property (nonatomic, assign) BOOL transformPacific;

- (id)initWithType:(NSString *)type mosquito:(MosquitoSprite*) mosquito point:(SPPoint*)point;

@end
