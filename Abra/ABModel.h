//
//  ABModel.h
//  Abra
//
//  Created by Thomas Ricouard on 04/10/13.
//  Copyright (c) 2013 Thomas Ricouard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>

@interface ABModel : MTLModel <MTLJSONSerializing>

- (void)getForPath:(NSString *)path
        completion:(void(^)(BOOL success, BOOL cached, id instanceOrArrayOfInstance))completion;

@end
