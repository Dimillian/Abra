//
//  ABModel.m
//  Abra
//
//  Created by Thomas Ricouard on 04/10/13.
//  Copyright (c) 2013 Thomas Ricouard. All rights reserved.
//

#import "ABModel.h"
#import <Mantle/MTLReflection.h>
#import <objc/objc-runtime.h>

@implementation ABModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{};
}

+ (BOOL)resolveClassMethod:(SEL)sel
{
    NSString *selectorName = NSStringFromSelector(sel);
    if ([selectorName hasSuffix:@"JSONTransformer"]) {
        NSString *propertyName = [selectorName stringByReplacingOccurrencesOfString:@"JSONTransformer"
                                                                                      withString:@""];
        Class class = [self classForPropertyName:propertyName ofClass:self.class];
        if ([class isSubclassOfClass:[ABModel class]] || class == [NSURL class] || class == [NSArray class]) {
            SEL selector = MTLSelectorWithKeyPattern(propertyName, "JSONTransformer");
            NSString *classname = NSStringFromClass([self class]);
            Class class = object_getClass(NSClassFromString(classname));
            class_addMethod(class,
                            selector,
                            (IMP)JSONValueTransformer,
                            "@@:");
        }
        return YES;
    }
    return NO;
}

+ (Class)classForPropertyName:(NSString *)propertyName ofClass:(Class)class
{
    if (class && propertyName) {
        objc_property_t property = class_getProperty(objc_getClass([NSStringFromClass(class) UTF8String]),
                                                     [propertyName UTF8String]);
        NSString *type = [NSString stringWithFormat:@"%s", property_getAttributes(property)];
        NSArray *attributes = [type componentsSeparatedByString:@","];
        NSString * typeAttribute = [attributes objectAtIndex:0];
        if ([typeAttribute hasPrefix:@"T@"] && [typeAttribute length] > 1) {
            NSString * typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)];
            return NSClassFromString(typeClassName);
        }
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
        Class arrayClass = [ABModel classForArrayNamed:propertyName];
        if (arrayClass) {
            return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:arrayClass];
        }
    }
    return nil;
}

@end
