//
// Created by Anastasiya Gorban on 9/7/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "TEArrayDiffCalculator.h"
#import "TEDiffIndex.h"
#import "TEUnique.h"
#import "TEArrayDiff.h"
#import "NSArray+Functional.h"


@interface TEArrayDiffCalculator ()
@property(nonatomic, strong) NSArray *inserted;
@property(nonatomic, strong) NSArray *deleted;
@property(nonatomic, strong) NSArray *updated;
@property(nonatomic, strong) NSArray *moved;
@end

@implementation TEArrayDiffCalculator

- (TEArrayDiff *)calculateDiffsWithOldArray:(NSArray *)oldArray newArray:(NSArray *)newArray {
    self.inserted = [self calculateInsertions:oldArray newArray:newArray];
    self.deleted = [self calculateDeletions:oldArray newArray:newArray];
    self.moved = [self calculateMoves:oldArray newArray:newArray];    
    self.updated = [self calculateUpdates:oldArray newArray:newArray];

    return [TEArrayDiff containerWithInserted:[self.inserted copy]
                                      deleted:[self.deleted copy]
                                      updated:[self.updated copy]
                                        moved:[self.moved copy]];
}

#pragma mark - Private

- (NSArray *)substractArray:(NSArray *)new fromArray:(NSArray *)old {
    NSParameterAssert([[new firstObject] conformsToProtocol:@protocol(TEUnique)]);
    NSParameterAssert([[old firstObject] conformsToProtocol:@protocol(TEUnique)]);

    NSMutableArray *substraction = [NSMutableArray new];
    [old enumerateObjectsUsingBlock:^(id <TEUnique> obj, NSUInteger idx, BOOL *stop) {
        id oldObj = [[new filter:^BOOL(id <TEUnique> o) {
            return [o.identifier isEqual:obj.identifier];
        }] firstObject];
        if (!oldObj) {
            [substraction addObject:obj];
        }
    }];

    return [substraction copy];
}

- (NSArray *)calculateDiffIndexesBySubstraction:(NSArray *)newArray from:(NSArray *)oldArray {
    NSArray *substraction = [self substractArray:newArray fromArray:oldArray];
    NSMutableArray *diffIndexes = [NSMutableArray arrayWithCapacity:substraction.count];

    [oldArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([substraction containsObject:obj]) {
            TEDiffIndex *diff = [TEDiffIndex diffWithIndex:idx];
            [diffIndexes addObject:diff];
        }
    }];

    return [diffIndexes copy];
    
}

- (NSArray *)calculateDeletions:(NSArray *)oldArray newArray:(NSArray *)newArray {
    return [self calculateDiffIndexesBySubstraction:newArray from:oldArray];
}

- (NSArray *)calculateInsertions:(NSArray *)oldArray newArray:(NSArray *)newArray {
    return [self calculateDiffIndexesBySubstraction:oldArray from:newArray];
}

- (NSArray *)calculateUpdates:(NSArray *)oldArray newArray:(NSArray *)newArray {
    NSMutableArray *mergedArray = [NSMutableArray arrayWithArray:oldArray];
    
    [self.moved enumerateObjectsUsingBlock:^(TEDiffIndex *obj, NSUInteger idx, BOOL *stop) {
        id o = [mergedArray objectAtIndex:obj.fromIndex];
        [mergedArray replaceObjectAtIndex:obj.fromIndex withObject:[mergedArray objectAtIndex:obj.index]];
        [mergedArray replaceObjectAtIndex:obj.index withObject:o];
    }];
    
    [[[self.deleted reverseObjectEnumerator] allObjects] enumerateObjectsUsingBlock:^(TEDiffIndex *obj, NSUInteger idx, BOOL *stop) {
        [mergedArray removeObjectAtIndex:obj.index];
    }];
    
    [self.inserted enumerateObjectsUsingBlock:^(TEDiffIndex *obj, NSUInteger idx, BOOL *stop) {
        [mergedArray insertObject:newArray[obj.index] atIndex:obj.index];
    }];
    
    NSMutableArray *updatedDiffs = [NSMutableArray new];
    [mergedArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![newArray[idx] isEqual:obj]) {
            TEDiffIndex *diff = [TEDiffIndex diffWithIndex:[oldArray indexOfObject:obj]];
            [updatedDiffs addObject:diff];
        }
    }];

    return [NSArray arrayWithArray:updatedDiffs];
}

- (NSArray *)calculateMoves:(NSArray *)oldArray newArray:(NSArray *)newArray {
    __block NSInteger delta = 0;
    NSMutableArray *result = [NSMutableArray array];
    NSArray *deletedObjects = [self substractArray:newArray fromArray:oldArray];
    NSArray *insertedObjects = [self substractArray:oldArray fromArray:newArray];
    [oldArray enumerateObjectsUsingBlock:^(id leftObj, NSUInteger leftIdx, BOOL *stop) {
        if ([deletedObjects containsObject:leftObj]) {
            delta++;
            return;
        }
        NSUInteger localDelta = delta;
        for (NSUInteger rightIdx = 0; rightIdx < newArray.count; ++rightIdx) {
            id rightObj = newArray[rightIdx];
            if ([insertedObjects containsObject:rightObj]) {
                localDelta--;
                continue;
            }
            if (![rightObj isEqual:leftObj]) {
                continue;
            }
            NSInteger adjustedRightIdx = rightIdx + localDelta;
            if (leftIdx != rightIdx && adjustedRightIdx != leftIdx) {
                [result addObject:[TEDiffIndex diffWithFromIndex:leftIdx toIndex:rightIdx]];
            }
            return;
        }
    }];
    
    // remove duplications
    NSMutableArray *filteredResult = [NSMutableArray arrayWithArray:result];
    [result enumerateObjectsUsingBlock:^(TEDiffIndex *obj, NSUInteger idx, BOOL *stop) {
        NSArray *array = [filteredResult filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"index = %@ AND fromIndex = %@", @(obj.fromIndex), @(obj.index)]];
        if (array.count) {
            [filteredResult removeObject:obj];
        }
    }];
    
    return [filteredResult copy];
}

@end
