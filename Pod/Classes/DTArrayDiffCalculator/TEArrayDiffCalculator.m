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
    NSMutableArray *substraction = [NSMutableArray new];
    if (new.count > 0) {
        NSParameterAssert([[new firstObject] conformsToProtocol:@protocol(TEUnique)]);
        
        if (old.count > 0) {
            // In case if both arrays have at least one object - do substraction in default way
            
            NSParameterAssert([[old firstObject] conformsToProtocol:@protocol(TEUnique)]);
            
            [old enumerateObjectsUsingBlock:^(id <TEUnique> obj, NSUInteger idx, BOOL *stop) {
                id oldObj = [[new filter:^BOOL(id <TEUnique> o) {
                    return [o.identifier isEqual:obj.identifier];
                }] firstObject];
                if (!oldObj) {
                    [substraction addObject:obj];
                }
            }];
        }
        
        // In case if array "new" contains some items and "old" doesn't - leave array "substraction" empty
    }
    else {
        if (old.count > 0) {
            // In case if array "old" contains some items and "new" doesn't - add all objects from "old" to "substraction"
            
            NSParameterAssert([[old firstObject] conformsToProtocol:@protocol(TEUnique)]);
            
            for (id oldObj in old) {
                [substraction addObject:oldObj];
            }
        }
        
        // In case if both arrays are empty - leave array "substraction" empty
    }
    
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
    
    [self.moved enumerateObjectsUsingBlock:^(TEDiffIndex *diffIndex, NSUInteger idx, BOOL *stop) {
        id object = mergedArray[diffIndex.fromIndex];
        [mergedArray removeObject:object];
        [mergedArray insertObject:object atIndex:diffIndex.index];
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
    [oldArray enumerateObjectsUsingBlock:^(id<TEUnique> leftObj, NSUInteger leftIdx, BOOL *stop) {
        NSMutableArray *adjustedOldArray = [oldArray mutableCopy];
        [result enumerateObjectsUsingBlock:^(TEDiffIndex *diffIndex, NSUInteger idx, BOOL * _Nonnull stop) {
            id object = adjustedOldArray[diffIndex.fromIndex];
            [adjustedOldArray removeObject:object];
            [adjustedOldArray insertObject:object atIndex:diffIndex.index];
        }];
        
        id adjustedLeftObject = adjustedOldArray[leftIdx];
        
        if ([deletedObjects containsObject:adjustedLeftObject]) {
            delta++;
            return;
        }
        NSUInteger localDelta = delta;
        for (NSUInteger rightIdx = 0; rightIdx < newArray.count; ++rightIdx) {
            id<TEUnique> rightObj = newArray[rightIdx];
            if ([insertedObjects containsObject:rightObj]) {
                localDelta--;
                continue;
            }
            if (![[rightObj identifier] isEqual:[adjustedLeftObject identifier]]) {
                continue;
            }
            NSInteger adjustedRightIdx = rightIdx + localDelta;
            if (leftIdx != rightIdx && adjustedRightIdx != leftIdx) {
                if (rightIdx - leftIdx == 1) {
                    NSInteger indexInOld = [adjustedOldArray indexOfObject:newArray[rightIdx - 1]];
                    [result addObject:[TEDiffIndex diffWithFromIndex:indexInOld toIndex:rightIdx - 1]];
                } else {
                    [result addObject:[TEDiffIndex diffWithFromIndex:leftIdx toIndex:rightIdx]];
                }
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
