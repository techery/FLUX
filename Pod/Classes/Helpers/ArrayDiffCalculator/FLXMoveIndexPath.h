//
// Created by Anastasiya Gorban on 9/8/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FLXMoveIndexPath : NSObject

@property (nonatomic, readonly) NSIndexPath *fromIndexPath;
@property (nonatomic, readonly) NSIndexPath *toIndexPath;

- (instancetype)initWithFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

+ (instancetype)pathWithFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;


@end