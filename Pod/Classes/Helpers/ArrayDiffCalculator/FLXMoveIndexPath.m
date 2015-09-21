//
// Created by Anastasiya Gorban on 9/8/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "FLXMoveIndexPath.h"


@implementation FLXMoveIndexPath {

}
- (instancetype)initWithFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    self = [super init];
    if (self) {
        _fromIndexPath = fromIndexPath;
        _toIndexPath = toIndexPath;
    }

    return self;
}

+ (instancetype)pathWithFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    return [[self alloc] initWithFromIndexPath:fromIndexPath toIndexPath:toIndexPath];
}

@end