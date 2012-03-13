//
//  NumberField.m
//  Sparrow_test
//
//  Created by Iviso Malazzi on 3/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NumberField.h"

@implementation NumberField

@synthesize value = mValue, prefix, postfix;

-(id) initWithText:(NSString *)text {
    self = [super initWithText:@""];
    if (self) {
        self.value = 0;
        self.prefix = text;
        self.postfix = @"";
    }
    return self;
}

-(void) setValue:(int) value {
    mValue = value;
    self.text = [NSString stringWithFormat:@"%@%d%@", prefix, value, postfix];
}

-(void)dealloc {
    [prefix release];
    [postfix release];
    [super dealloc];
}


@end
