//
//  NSObject+TCModel.h
//  individual
//
//  Created by 穆康 on 2016/10/20.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef TCMODEL_SYSTEM_VARIABLES_MAP
#define TCMODEL_SYSTEM_VARIABLES_MAP @{@"ID":@"id"}
#endif

@interface NSObject (TCModel)

- (NSArray *)allPropertyNames;

- (instancetype)initWithObjectDictionary:(NSDictionary *)dic;

+ (NSArray *)objectArrayFromObjectDictionaryArray:(NSArray *)array;

- (NSDictionary *)toObjectDictionary;
- (NSDictionary *)toObjectDictionary:(BOOL)recursive;

+ (NSDictionary *)objectClassInArray;
+ (NSDictionary *)objectClassInDictionary;

- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;

@end
