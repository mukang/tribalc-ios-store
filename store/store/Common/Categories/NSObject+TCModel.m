//
//  NSObject+TCModel.m
//  individual
//
//  Created by 穆康 on 2016/10/20.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "NSObject+TCModel.h"
#import <objc/runtime.h>

@interface NSArray (TCModel)

- (NSArray *)tc_parseArray:(BOOL)recursive;

@end

@interface NSDictionary (TCModel)

- (NSDictionary *)tc_parseDictionary:(BOOL)recursive;

@end

@implementation NSArray (TCModel)

- (NSArray *)tc_parseArray:(BOOL)recursive {
    NSArray *baseClasses = @[
                             [NSNumber class],
                             [NSDate class],
                             [NSString class]
                             ];
    
    NSMutableArray *copied = [NSMutableArray array];
    for (id item in self) {
        BOOL isBaseClass = NO;
        for (Class baseClass in baseClasses) {
            if ([item isKindOfClass:baseClass]) {
                [copied addObject:item];
                isBaseClass = YES;
                break;
            }
        }
        if (isBaseClass) continue;
        
        if ([item isKindOfClass:[NSArray class]]) {
            [copied addObject:[item tc_parseArray:recursive]];
        } else if ([item isKindOfClass:[NSDictionary class]]) {
            [copied addObject:[item tc_parseDictionary:recursive]];
        } else {
            [copied addObject:[item toObjectDictionary:recursive]];
        }
    }
    return [copied copy];
}

@end

@implementation NSDictionary (TCModel)

- (NSDictionary *)tc_parseDictionary:(BOOL)recursive {
    NSArray *baseClasses = @[
                             [NSNumber class],
                             [NSDate class],
                             [NSString class]
                             ];
    
    NSMutableDictionary *copied = [NSMutableDictionary dictionary];
    for (NSString *key in self.allKeys) {
        BOOL isBaseClass = NO;
        id item = [self objectForKey:key];
        for (Class baseClass in baseClasses) {
            if ([item isKindOfClass:baseClass]) {
                [copied setObject:item forKey:key];
                isBaseClass = YES;
                break;
            }
        }
        if (isBaseClass) continue;
        
        if ([item isKindOfClass:[NSArray class]]) {
            [copied setObject:[item tc_parseArray:recursive] forKey:key];
        } else if ([item isKindOfClass:[NSDictionary class]]) {
            [copied setObject:[item tc_parseDictionary:recursive] forKey:key];
        } else {
            [copied setObject:[item toObjectDictionary:recursive] forKey:key];
        }
    }
    return [copied copy];
}

@end

@implementation NSObject (TCModel)

- (NSArray *)allPropertyNames {
    NSMutableArray *names = [NSMutableArray array];
    unsigned int propertyCount;
    objc_property_t *propertyList = class_copyPropertyList([self class], &propertyCount);
    
    for (int i=0; i<propertyCount; i++) {
        objc_property_t property = propertyList[i];
        const char *c_propertyName = property_getName(property);
        NSString *propertyName = [NSString stringWithCString:c_propertyName encoding:[NSString defaultCStringEncoding]];
        [names addObject:propertyName];
    }
    
    free(propertyList);
    return [names copy];
}

- (instancetype)initWithObjectDictionary:(NSDictionary *)dic {
    if (dic == nil) {
        return nil;
    }
    
    self = [self init];
    if (self) {
        unsigned int propertyCount;
        objc_property_t *propertyList = class_copyPropertyList([self class], &propertyCount);
        
        NSDictionary *objectClassInArrayMap = nil;
        if (propertyCount>0 && [[self class] respondsToSelector:@selector(objectClassInArray)]) {
            objectClassInArrayMap = [[self class] performSelector:@selector(objectClassInArray)];
        }
        
        NSDictionary *objectClassInDictionaryMap = nil;
        if (propertyCount>0 && [[self class] respondsToSelector:@selector(objectClassInDictionary)]) {
            objectClassInDictionaryMap = [[self class] performSelector:@selector(objectClassInDictionary)];
        }
        
        for (int i=0; i<propertyCount; i++) {
            objc_property_t property = propertyList[i];
            const char *c_propertyName = property_getName(property);
            NSString *propertyName = [NSString stringWithCString:c_propertyName encoding:[NSString defaultCStringEncoding]];
            
            id value = nil;
            NSDictionary *systemVariablesMap = TCMODEL_SYSTEM_VARIABLES_MAP;
            if ([systemVariablesMap objectForKey:propertyName]) {
                value = [dic objectForKey:[systemVariablesMap objectForKey:propertyName]];
            } else {
                value = [dic objectForKey:propertyName];
            }
            
            if (value && value != [NSNull null]) {
                if ([value isKindOfClass:[NSArray class]]) {
                    Class objectClass = [objectClassInArrayMap objectForKey:propertyName];
                    if (objectClass) {
                        value = [objectClass objectArrayFromObjectDictionaryArray:value];
                    }
                }
                if ([value isKindOfClass:[NSDictionary class]]) {
                    Class objectClass = [objectClassInDictionaryMap objectForKey:propertyName];
                    if (objectClass) {
                        value = [[objectClass alloc] initWithObjectDictionary:value];
                    }
                }
                [self setValue:value forKey:propertyName];
            }
        }
        free(propertyList);
    }
    return self;
}

+ (NSArray *)objectArrayFromObjectDictionaryArray:(NSArray *)array {
    NSMutableArray *objectArray = [NSMutableArray array];
    for (id object in array) {
        if ([object isKindOfClass:[NSDictionary class]]) {
            [objectArray addObject:[[self alloc] initWithObjectDictionary:object]];
        }
    }
    return objectArray;
}

- (NSDictionary *)toObjectDictionary {
    return [self toObjectDictionary:NO];
}

- (NSDictionary *)toObjectDictionary:(BOOL)recursive {
    NSArray *baseClasses = @[
                             [NSNumber class],
                             [NSDate class],
                             [NSString class],
                             [NSArray class],
                             [NSDictionary class]
                             ];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    unsigned int propertyCount;
    objc_property_t *propertyList = class_copyPropertyList([self class], &propertyCount);
    for (int i=0; i<propertyCount; i++) {
        objc_property_t property = propertyList[i];
        const char *c_propertyName = property_getName(property);
        NSString *propertyName = [NSString stringWithCString:c_propertyName encoding:[NSString defaultCStringEncoding]];
        id value = [self valueForKey:propertyName];
        if (value != nil) {
            BOOL isBaseClass = NO;
            for (Class baseClass in baseClasses) {
                if ([value isKindOfClass:baseClass]) {
                    isBaseClass = YES;
                    break;
                }
            }
            if (!isBaseClass) {
                value = [value toObjectDictionary:recursive];
            }
            if (recursive) {
                if ([value isKindOfClass:[NSArray class]]) {
                    value = [(NSArray *)value tc_parseArray:recursive];
                }
                if ([value isKindOfClass:[NSDictionary class]]) {
                    value = [(NSDictionary *)value tc_parseDictionary:recursive];
                }
            }
            
            NSDictionary *systemVariablesMap = TCMODEL_SYSTEM_VARIABLES_MAP;
            if ([systemVariablesMap objectForKey:propertyName]) {
                [dic setObject:value forKey:[systemVariablesMap objectForKey:propertyName]];
            } else {
                [dic setObject:value forKey:propertyName];
            }
        }
    }
    
    free(propertyList);
    return [dic copy];
}

+ (NSDictionary *)objectClassInArray {
    return nil;
}

+ (NSDictionary *)objectClassInDictionary {
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    NSArray *propertyNames = [self allPropertyNames];
    for (NSString *key in propertyNames) {
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        NSArray *propertyNames = [self allPropertyNames];
        for (NSString *key in propertyNames) {
            if ([aDecoder containsValueForKey:key]) {
                id value = [aDecoder decodeObjectForKey:key];
                [self setValue:value forKey:key];
            }
        }
    }
    return self;
}

@end
