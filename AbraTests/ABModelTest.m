//
//  ABModelTest.m
//  Abra
//
//  Created by Thomas Ricouard on 12/10/13.
//  Copyright (c) 2013 Thomas Ricouard. All rights reserved.
//

#import "ABModelTest.h"

@implementation ABModelTest

+ (Class)classForArrayNamed:(NSString *)arrayName
{
    if ([arrayName isEqualToString:@"nestedModels"]) {
        return ABModelTestNested.class;
    }
    return nil;
}

@end
