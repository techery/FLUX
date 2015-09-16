//
// Created by Anastasiya Gorban on 9/8/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TEArrayDiff : NSObject

@property(nonatomic, readonly) NSArray *inserted;
@property(nonatomic, readonly) NSArray *deleted;
@property(nonatomic, readonly) NSArray *updated;
@property(nonatomic, readonly) NSArray *moved;

- (instancetype)initWithInserted:(NSArray *)inserted
                         deleted:(NSArray *)deleted
                         updated:(NSArray *)updated
                           moved:(NSArray *)moved;

+ (instancetype)containerWithInserted:(NSArray *)inserted
                              deleted:(NSArray *)deleted
                              updated:(NSArray *)updated
                                moved:(NSArray *)moved;

@end