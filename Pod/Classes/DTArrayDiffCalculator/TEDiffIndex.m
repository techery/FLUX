//
// Created by Anastasiya Gorban on 9/7/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "TEDiffIndex.h"


@implementation TEDiffIndex {

}
- (instancetype)initWithFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    self = [super init];
    if (self) {
        _index = toIndex;
        _fromIndex = fromIndex;
    }

    return self;
}

+ (instancetype)diffWithFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    return [[self alloc] initWithFromIndex:fromIndex toIndex:toIndex];
}

- (instancetype)initWithIndex:(NSUInteger)index {
    return [self initWithFromIndex:0 toIndex:index];;
}

+ (instancetype)diffWithIndex:(NSUInteger)index {
    return [[self alloc] initWithIndex:index];
}

@end