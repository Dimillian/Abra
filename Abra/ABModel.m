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

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{};
}


- (id)init
{
    self = [super init];
    if (self) {
        [self.class generateMethods];
    }
    return self;
}

+ (void)generateMethods
{
    NSSet *properties = [self.class propertyKeys];
    [properties enumerateObjectsUsingBlock:^(NSString *obj, BOOL *stop) {
        Class class = [self.class classForPropertyName:obj ofClass:self.class];
        if (class) {
            if ([class isSubclassOfClass:[ABModel class]] || class == [NSURL class] || class == [NSArray class]) {
                SEL selector = MTLSelectorWithKeyPattern(obj, "JSONTransformer");
                if (![[self class]respondsToSelector:selector]) {
                    class_addMethod(objc_getClass([NSStringFromClass(self.class) UTF8String]),
                                    selector,
                                    (IMP)JSONValueTransformer,
                                    "@@:");
                }
            }
        }
    }];
}

+ (Class)classForPropertyName:(NSString *)propertyName ofClass:(Class)class
{
    objc_property_t property = class_getProperty(class, [propertyName UTF8String]);
    NSString *type = [NSString stringWithFormat:@"%s", property_getAttributes(property)];
    NSArray *attributes = [type componentsSeparatedByString:@","];
    NSString * typeAttribute = [attributes objectAtIndex:0];
    if ([typeAttribute hasPrefix:@"T@"] && [typeAttribute length] > 1) {
        NSString * typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)];
        return NSClassFromString(typeClassName);
    }
    return nil;
}

+ (Class)classForArrayNamed:(NSString *)arrayName
{
    return nil;
}

id JSONValueTransformer(id self, SEL _cmd)
{
    NSString *propertyName = [NSStringFromSelector(_cmd) stringByReplacingOccurrencesOfString:@"JSONTransformer"
                                                                                   withString:@""];
    return [ABModel dynamicValueTransformer:propertyName forClass:[self class]];
}

+ (NSValueTransformer *)dynamicValueTransformer:(NSString *)propertyName forClass:(Class)class
{
    Class properyClass = [ABModel classForPropertyName:propertyName ofClass:class];
    if ([properyClass isSubclassOfClass:[ABModel class]]) {
        return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[self classForPropertyName:propertyName
                                                                                                  ofClass:class]];
    }
    else if (properyClass == [NSURL class]) {
        return [NSValueTransformer valueTransformerForName:@"MTLURLValueTransformerName"];
    }
    else if (properyClass == [NSArray class]) {
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[ABModel classForArrayNamed:propertyName]];
    }
    return nil;
}

@end
