//
//  Vector2D.m
//  Sparrow_test
//
//  Created by Iviso Malazzi on 3/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Vector2D.h"

@interface Vector2D()
-(double) lengthSquare;
@end

@implementation Vector2D

@dynamic length, angle, x, y;
@synthesize vector;

-(id)initWithX:(double)x andY:(double)y {
    self = [super init];
    if (self) {
        vector = CGPointMake(x, y);
    }
    return self;
}

-(void) setLength:(double) value {
    double ang = self.angle;
    vector.x = cos(ang) * value;
    vector.y = sin(ang) * value;
    if (ABS(vector.x) < 0.0000001) { vector.x = 0.0; }
    if (ABS(vector.y) < 0.0000001) { vector.y = 0.0; }
}

-(double) length {
    return sqrt([self lengthSquare]);
}

-(double)lengthSquare {
    return vector.x*vector.x + vector.y*vector.y;
}

-(void) setAngle:(double)angle {
    double len = self.length;
    vector.x = cos(angle) * len;
    vector.y = sin(angle) * len;
}

-(double)angle {
    return atan2(vector.y, vector.x);
}

-(Vector2D*)normalize {
    if (self.length == 0.0) {
        vector.x = 1;
        return self;
    }
    double len = self.length;
    vector.x /= len;
    vector.y /= len;
    return self;
}

-(Vector2D *)add:(CGPoint)v {
    vector.x += v.x;
    vector.y += v.y;
    return self;
}

-(Vector2D *)multiply:(double)scalar {
    vector.x *= scalar;
    vector.y *= scalar;
    return self;
}

-(double)x {
    return vector.x;
}

-(double)y {
    return vector.y;
}

-(void)truncate:(double)max {
    self.length = MIN(max, self.length);
}

-(void)reverseX {
    vector.x *= -1;
}

-(void)reverseY {
    vector.y *= -1;
}

@end
