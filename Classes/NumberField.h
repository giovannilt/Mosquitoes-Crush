//
//  NumberField.h
//  Sparrow_test
//
//  Created by Iviso Malazzi on 3/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SPTextField.h"

@interface NumberField : SPTextField {
    int mValue;
    NSString* prefix;
    NSString* postfix;
}

@property (nonatomic, assign) int value;
@property (nonatomic, retain) NSString* prefix;
@property (nonatomic, retain) NSString* postfix;

@end
