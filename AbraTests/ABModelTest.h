//
//  ABModelTest.h
//  Abra
//
//  Created by Thomas Ricouard on 12/10/13.
//  Copyright (c) 2013 Thomas Ricouard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABModel.h"
#import "ABModelTestNested.h"

@interface ABModelTest : ABModel

@property (nonatomic, strong) NSNumber *uid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *postedDate;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) ABModelTestNested *nestedModel;
@property (nonatomic, strong) NSArray *nestedModels;

@end
