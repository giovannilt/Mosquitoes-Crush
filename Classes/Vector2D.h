//
//  Vector2D.h
//  Sparrow_test
//
//  Created by Iviso Malazzi on 3/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vector2D : NSObject {
    CGPoint vector;
}

@property (nonatomic, assign) double length;
@property (nonatomic, assign) double angle;
@property (nonatomic, assign) CGPoint vector;
@property (readonly) double x;
@property (readonly) double y;

-(id) initWithX:(double) x andY:(double) y;

-(Vector2D*) normalize;
-(Vector2D*) add:(CGPoint) v;
-(Vector2D*) multiply:(double) scalar;
-(void) truncate:(double) max;

-(void) reverseX;
-(void) reverseY;
@end
