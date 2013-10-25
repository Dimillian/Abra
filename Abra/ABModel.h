//
//  ABModel.h
//  Abra
//
//  Created by Thomas Ricouard on 04/10/13.
//  Copyright (c) 2013 Thomas Ricouard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>
#import <Mantle/MTLJSONAdapter.h>

@interface ABModel : MTLModel <MTLJSONSerializing>

+ (Class)classForArrayNamed:(NSString *)arrayName;

@end
