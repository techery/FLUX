//
//  FLXStatePersistenceSpec.m
//  MasterApp
//
//  Created by Dmitry on 10.09.15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FLXStatePersistence.h"
#import "FLXFileSystemPersistentProvider.h"
#import "FLXFakeStore.h"
#import "FLXPersistentStoreMock.h"

@interface FLXStatePersistence (Testing)

@property (nonatomic, strong) FLXFileSystemPersistentProvider *persistence;
- (void)setupStore:(FLXBaseStore *)store;
- (void)restoreState:(id)state ofStore:(FLXBaseStore <FLXPersistentStoreProtocol> *)store;

@end

SPEC_BEGIN(FLXStatePersistenceSpec)

    FLXStatePersistence __block *sut;

beforeEach(^{
    sut = [[FLXStatePersistence alloc] init];
});

afterEach(^{
    sut = nil;
});

describe(@"init", ^{
    it(@"should init", ^{
        [[sut.persistence shouldNot] beNil];
        [[sut.persistence should] conformToProtocol:@protocol(FLXPersistenceProtocol)];
    });
});

describe(@"register store", ^{
    it(@"shouldObserveStore: should return YES for correct store", ^{
        id storeMock = [KWMock mockForProtocol:@protocol(FLXPersistentStoreProtocol)];
        BOOL result = [sut shouldObserveStore:storeMock];
        [[theValue(result) should] beTrue];
    });

    it(@"shouldObserveStore: should return NO for incorrect store", ^{
        id storeMock = [KWMock mockForClass:[FLXFakeStore class]];
        BOOL result = [sut shouldObserveStore:storeMock];
        [[theValue(result) should] beFalse];
    });

    it(@"should try to restore state", ^{
        id storeMock = [KWMock mockForClass:[FLXPersistentStoreMock class]];
        id stateMock = [KWMock mockForClass:[FLXBaseState class]];
        sut.persistence = (FLXFileSystemPersistentProvider *)[KWMock mockForClass:[FLXFileSystemPersistentProvider class]];

        [storeMock stub:@selector(shouldRestoreState:) andReturn:theValue(YES)];
        [sut.persistence stub:@selector(stateForStore:) andReturn:stateMock];

        [[sut.persistence should] receive:@selector(stateForStore:)
                            withArguments:storeMock, nil];
        [storeMock stub:@selector(shouldRestoreState:)
              andReturn:theValue(YES)
          withArguments:stateMock, nil];
        [[sut should] receive:@selector(restoreState:ofStore:)
                withArguments:stateMock, storeMock, nil];

        [sut setupStore:storeMock];
    });
});

SPEC_END