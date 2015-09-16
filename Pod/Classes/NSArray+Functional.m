//
// Created by Anastasiya Gorban on 8/19/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "NSArray+Functional.h"


@implementation NSArray(Functional)

- (NSArray *)map:(id (^)(id))mapBlock {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [result addObject:mapBlock(obj)];
    }];
    
    return result;
}

- (NSArray *)filter:(BOOL (^)(id))filterBlock {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (filterBlock(obj)) {
            [result addObject:obj];
        }
    }];
    
    return result;
}

@end