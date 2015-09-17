//
// Created by Anastasiya Gorban on 9/7/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLXDiffIndex : NSObject

@property (nonatomic, readonly) NSUInteger index;
@property (nonatomic, readonly) NSUInteger fromIndex;

- (instancetype)initWithIndex:(NSUInteger)index;
+ (instancetype)diffWithIndex:(NSUInteger)index;

- (instancetype)initWithFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
+ (instancetype)diffWithFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

@end