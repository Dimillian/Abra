//
//  ABModel.m
//  Abra
//
//  Created by Thomas Ricouard on 04/10/13.
//  Copyright (c) 2013 Thomas Ricouard. All rights reserved.
//

#import "ABModel.h"
#import <Mantle/MTLJSONAdapter.h>
#import <Mantle/MTLReflection.h>
#import <objc/objc-runtime.h>


@implementation ABModel

- (id)init
{
    self = [super init];
    if (self) {
        NSSet *properties = [self.class propertyKeys];
        [properties enumerateObjectsUsingBlock:^(NSString *obj, BOOL *stop) {
            Class class = [self classForPropertyName:obj];
            if (class) {
                if ([class isSubclassOfClass:[ABModel class]] || class == [NSURL class]) {
                    SEL selector = MTLSelectorWithKeyPattern(obj, "JSONTransformer");
                    if (![self respondsToSelector:selector]) {
                        class_addMethod(objc_getClass([NSStringFromClass(self.class) UTF8String]),
                                        selector,
                                        (IMP)JSONValueTransformer,
                                        "@@:#");
                    }
                }
            }
        }];
    }
    return self;
}

- (Class)classForPropertyName:(NSString *)propertyName
{
    objc_property_t property = class_getProperty(self.class, [propertyName UTF8String]);
    NSString *type = [NSString stringWithFormat:@"%s", property_getAttributes(property)];
    NSArray *attributes = [type componentsSeparatedByString:@","];
    NSString * typeAttribute = [attributes objectAtIndex:0];
    if ([typeAttribute hasPrefix:@"T@"] && [typeAttribute length] > 1) {
        NSString * typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)];
        return NSClassFromString(typeClassName);
    }
    return nil;
}

id JSONValueTransformer(id self, SEL _cmd)
{
    NSString *propertyName = [NSStringFromSelector(_cmd) stringByReplacingOccurrencesOfString:@"JSONTransformer"
                                                                                   withString:@""];
    return [self dynamicValueTransformer:propertyName];
}

- (NSValueTransformer *)dynamicValueTransformer:(NSString *)propertyName
{
    Class class = [self classForPropertyName:propertyName];
    if ([class isSubclassOfClass:[ABModel class]]) {
        return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[self classForPropertyName:propertyName]];
    }
    else if (class == [NSURL class]) {
        return [NSValueTransformer valueTransformerForName:@"MTLURLValueTransformerName"];
    }
    return nil;
}

- (void)getForPath:(NSString *)path completion:(void (^)(BOOL, BOOL, id))completion
{
    
}

@end
