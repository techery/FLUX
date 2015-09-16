//
// Created by Anastasiya Gorban on 8/19/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Functional)

- (NSArray *)map:(id (^)(id))mapBlock;
- (NSArray *)filter:(BOOL (^)(id))filterBlock;

@end

