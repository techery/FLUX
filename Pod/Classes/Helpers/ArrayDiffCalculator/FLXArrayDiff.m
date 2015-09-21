//
// Created by Anastasiya Gorban on 9/8/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "FLXArrayDiff.h"


@implementation FLXArrayDiff {

}
- (instancetype)initWithInserted:(NSArray *)inserted deleted:(NSArray *)deleted updated:(NSArray *)updated moved:(NSArray *)moved {
    self = [super init];
    if (self) {
        _inserted = inserted;
        _deleted = deleted;
        _updated = updated;
        _moved = moved;
    }

    return self;
}

+ (instancetype)containerWithInserted:(NSArray *)inserted deleted:(NSArray *)deleted updated:(NSArray *)updated moved:(NSArray *)moved {
    return [[self alloc] initWithInserted:inserted deleted:deleted updated:updated moved:moved];
}

@end