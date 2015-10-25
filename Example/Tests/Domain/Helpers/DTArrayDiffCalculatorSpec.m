#import <Kiwi/Kiwi.h>
// Class under test
#import "TEArrayDiffCalculator.h"

#import "TEDiffIndex.h"
#import "TEUnique.h"
#import "TEArrayDiff.h"

@interface TETestUniqueModel : NSObject <TEUnique>
@property (nonatomic, readonly) id identifier;
@property (nonatomic, strong) NSString *name;
- (instancetype)initWithId:(id)identifier;
@end

#define IsEqual(x,y) ((x && [x isEqual:y]) || (!x && !y))

@implementation TETestUniqueModel

- (instancetype)initWithId:(id)identifier {
    self = [super init];
    if (self) {
        _identifier = identifier;
    }

    return self;
}

- (BOOL)isEqual:(TETestUniqueModel *)object {
    if (![self isKindOfClass:[object class]]) return NO;

    return IsEqual(object.identifier, self.identifier) && IsEqual(object.name, self.name);
}

@end

SPEC_BEGIN(TEArrayDiffCalculatorSpec)
describe(@"TEArrayDiffCalculator", ^{
    describe(@"diff calculation", ^{
        __block TEArrayDiffCalculator *calculator = [TEArrayDiffCalculator new];
        __block TEArrayDiff *diffsContainer;
        id (^uniqueObjectMock)(NSNumber *) = ^id (NSNumber *identifier) {
            TETestUniqueModel *model = [[TETestUniqueModel alloc] initWithId:identifier];
            return model;
        };

        context(@"objects were inserted", ^{
            beforeAll(^{
                NSArray *oldArray = @[
                                      uniqueObjectMock(@1),
                                      uniqueObjectMock(@2),
                                      uniqueObjectMock(@3)];
                NSArray *newArray = @[
                                      uniqueObjectMock(@1),
                                      uniqueObjectMock(@4),
                                      uniqueObjectMock(@2),
                                      uniqueObjectMock(@3),
                                      uniqueObjectMock(@5)];
                diffsContainer = [calculator calculateDiffsWithOldArray:oldArray newArray:newArray];
            });
            
            it(@"should return proper inserted indexes", ^{
                NSArray *result = diffsContainer.inserted;
                [[result should] haveCountOf:2];

                TEDiffIndex *diff1 = result[0];
                TEDiffIndex *diff2 = result[1];
                [[theValue(diff1.index) should] equal:theValue(1)];
                [[theValue(diff2.index) should] equal:theValue(4)];
            });
            
            it(@"updated and deleted should be empty", ^{
                [[diffsContainer.updated should] beEmpty];
                [[diffsContainer.deleted should] beEmpty];
            });
        });

        context(@"objects were deleted", ^{
            beforeAll(^{
                NSArray *newArray = @[
                                      uniqueObjectMock(@1),
                                      uniqueObjectMock(@2)];
                NSArray *oldArray = @[
                                      uniqueObjectMock(@1),
                                      uniqueObjectMock(@4),
                                      uniqueObjectMock(@2),
                                      uniqueObjectMock(@3),
                                      uniqueObjectMock(@5)];
                diffsContainer = [calculator calculateDiffsWithOldArray:oldArray newArray:newArray];
            });
            
            it(@"should return proper deleted indexes", ^{
                NSArray *result = diffsContainer.deleted;

                [[result should] haveCountOf:3];

                TEDiffIndex *diff1 = result[0];
                TEDiffIndex *diff2 = result[1];
                TEDiffIndex *diff3 = result[2];

                [[theValue(diff1.index) should] equal:theValue(1)];
                [[theValue(diff2.index) should] equal:theValue(3)];
                [[theValue(diff3.index) should] equal:theValue(4)];
            });
            
            it(@"updated and inserted should be empty", ^{
                [[diffsContainer.updated should] beEmpty];
                [[diffsContainer.inserted should] beEmpty];
            });
            
        });
        
        context(@"objects were updated", ^{
            beforeAll(^{
                TETestUniqueModel *model1 = [[TETestUniqueModel alloc] initWithId:@1];
                model1.name = @"name1";
                TETestUniqueModel *model2 = [[TETestUniqueModel alloc] initWithId:@2];
                model2.name = @"name2";
                TETestUniqueModel *updatedModel1 = [[TETestUniqueModel alloc] initWithId:@1];
                updatedModel1.name = @"name1 updated";
                
                NSArray *oldArray = @[model1, model2];
                NSArray *newArray = @[updatedModel1, model2];

                diffsContainer = [calculator calculateDiffsWithOldArray:oldArray newArray:newArray];
            });
            
            it(@"should return proper deleted indexes", ^{
                NSArray *result = diffsContainer.updated;

                [[result should] haveCountOf:1];
                TEDiffIndex *diff = result[0];
                [[theValue(diff.index) should] equal:theValue(0)];
            });
            
            it(@"deleted and inserted should be empty", ^{
                [[diffsContainer.deleted should] beEmpty];
                [[diffsContainer.inserted should] beEmpty];
            });
        });
        
        context(@"objects were inserted and deleted ", ^{
            beforeAll(^{
                NSArray *oldArray = @[
                                      uniqueObjectMock(@1),
                                      uniqueObjectMock(@2),
                                      uniqueObjectMock(@3)];
                NSArray *newArray = @[
                                      uniqueObjectMock(@1),
                                      uniqueObjectMock(@4),
                                      uniqueObjectMock(@2),
                                      uniqueObjectMock(@5)];
                diffsContainer = [calculator calculateDiffsWithOldArray:oldArray newArray:newArray];
            });
            
            it(@"should return proper inserted and deleted indexes", ^{
                NSArray *inserted = diffsContainer.inserted;
                NSArray *deleted = diffsContainer.deleted;
                [[inserted should] haveCountOf:2];
                [[deleted should] haveCountOf:1];
                
                TEDiffIndex *insertedDiff1 = inserted[0];
                TEDiffIndex *insertedDiff2 = inserted[1];
                [[theValue(insertedDiff1.index) should] equal:theValue(1)];
                [[theValue(insertedDiff2.index) should] equal:theValue(3)];
                
                TEDiffIndex *deletedDiff = deleted[0];
                [[theValue(deletedDiff.index) should] equal:theValue(2)];
            });
            
            it(@"updated should be empty", ^{
                [[diffsContainer.updated should] beEmpty];
            });
        });
        
        context(@"objects were deleted and updated", ^{
            beforeAll(^{
                TETestUniqueModel *model = [[TETestUniqueModel alloc] initWithId:@1];
                model.name = @"name";
                
                TETestUniqueModel *updatedModel = [[TETestUniqueModel alloc] initWithId:@1];
                updatedModel.name = @"name updated";

                
                NSArray *oldArray = @[
                                      uniqueObjectMock(@1),
                                      uniqueObjectMock(@2),
                                      model];
                NSArray *newArray = @[
                                      uniqueObjectMock(@1),
                                      updatedModel];
                diffsContainer = [calculator calculateDiffsWithOldArray:oldArray newArray:newArray];
            });
            
            it(@"should return proper updated and deleted indexes", ^{
                NSArray *updated = diffsContainer.updated;
                NSArray *deleted = diffsContainer.deleted;
                [[updated should] haveCountOf:1];
                [[deleted should] haveCountOf:1];
                
                TEDiffIndex *updatedDiff = updated[0];
                [[theValue(updatedDiff.index) should] equal:theValue(2)];
                
                TEDiffIndex *deletedDiff = deleted[0];
                [[theValue(deletedDiff.index) should] equal:theValue(1)];
            });
            
            it(@"inserted should be empty", ^{
                [[diffsContainer.inserted should] beEmpty];
            });
        });
        
        context(@"objects were inserted and updated", ^{
            beforeAll(^{
                TETestUniqueModel *model = [[TETestUniqueModel alloc] initWithId:@1];
                model.name = @"name";
                
                TETestUniqueModel *updatedModel = [[TETestUniqueModel alloc] initWithId:@1];
                updatedModel.name = @"name updated";
                
                
                NSArray *oldArray = @[
                                      uniqueObjectMock(@1),
                                      uniqueObjectMock(@2),
                                      model];
                NSArray *newArray = @[
                                      uniqueObjectMock(@1),
                                      uniqueObjectMock(@2),
                                      uniqueObjectMock(@3),
                                      updatedModel];
                diffsContainer = [calculator calculateDiffsWithOldArray:oldArray newArray:newArray];
            });
            
            it(@"should return proper updated and inserted indexes", ^{
                NSArray *updated = diffsContainer.updated;
                NSArray *inserted = diffsContainer.inserted;
                [[updated should] haveCountOf:1];
                [[inserted should] haveCountOf:1];
                
                TEDiffIndex *updatedDiff = updated[0];
                [[theValue(updatedDiff.index) should] equal:theValue(2)];
                
                TEDiffIndex *insertedDiff = inserted[0];
                [[theValue(insertedDiff.index) should] equal:theValue(2)];
            });
            
            it(@"deleted should be empty", ^{
                [[diffsContainer.deleted should] beEmpty];
            });
        });
        
        context(@"objects were moved", ^{
            beforeAll(^{
                NSArray *oldArray = @[
                                      uniqueObjectMock(@1),
                                      uniqueObjectMock(@2),
                                      uniqueObjectMock(@3)];
                NSArray *newArray = @[
                                      uniqueObjectMock(@1),
                                      uniqueObjectMock(@3),
                                      uniqueObjectMock(@2)];
                diffsContainer = [calculator calculateDiffsWithOldArray:oldArray newArray:newArray];
            });
            
            it(@"should return valid moved indexes", ^{
                NSArray *moved = diffsContainer.moved;
                [[moved should] haveCountOf:1];

                TEDiffIndex *diff1 = moved[0];
                [[theValue(diff1.index) should] equal:theValue(1)];
                [[theValue(diff1.fromIndex) should] equal:theValue(2)];                
            });
        });
        
        context(@"objects were deleted, inseted, updated and moved", ^{
            beforeAll(^{
                TETestUniqueModel *model = [[TETestUniqueModel alloc] initWithId:@6];
                model.name = @"name";
                
                TETestUniqueModel *updatedModel = [[TETestUniqueModel alloc] initWithId:@6];
                updatedModel.name = @"name updated";
                
                NSArray *oldArray = @[
                                      uniqueObjectMock(@1),
                                      uniqueObjectMock(@2),
                                      uniqueObjectMock(@3),
                                      uniqueObjectMock(@4),
                                      uniqueObjectMock(@5),
                                      model];
                NSArray *newArray = @[
                                      uniqueObjectMock(@8),
                                      uniqueObjectMock(@1),
                                      uniqueObjectMock(@7),
                                      updatedModel,
                                      uniqueObjectMock(@5),
                                      uniqueObjectMock(@3)];
                diffsContainer = [calculator calculateDiffsWithOldArray:oldArray newArray:newArray];
            });
            
            it(@"should return valid deleted indexes", ^{
                
                NSArray *deleted = diffsContainer.deleted;
                [[deleted should] haveCountOf:2];
                
                TEDiffIndex *diff1 = deleted[0];
                [[theValue(diff1.index) should] equal:theValue(1)];
                
                TEDiffIndex *diff2 = deleted[1];
                [[theValue(diff2.index) should] equal:theValue(3)];
            });
            
            it(@"should return valid inserted indexes", ^{
                NSArray *inserted = diffsContainer.inserted;
                [[inserted should] haveCountOf:2];
                
                TEDiffIndex *diff1 = inserted[0];
                [[theValue(diff1.index) should] equal:theValue(0)];
                
                TEDiffIndex *diff2 = inserted[1];
                [[theValue(diff2.index) should] equal:theValue(2)];
            });

            it(@"should return valid updated indexes", ^{
                NSArray *updated = diffsContainer.updated;
                [[updated should] haveCountOf:1];
                TEDiffIndex *diff = updated[0];
                [[theValue(diff.index) should] equal:theValue(5)];
            });

            it(@"should return valid moved indexes", ^{
                NSArray *moved = diffsContainer.moved;
                [[moved should] haveCountOf:1];
            });
        });
        
    });
});

SPEC_END
