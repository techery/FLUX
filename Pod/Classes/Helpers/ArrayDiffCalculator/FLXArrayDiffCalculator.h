//
// Created by Anastasiya Gorban on 9/7/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FLXArrayDiff;


@interface FLXArrayDiffCalculator : NSObject

- (FLXArrayDiff *)calculateDiffsWithOldArray:(NSArray *)oldArray newArray:(NSArray *)newArray;

@end