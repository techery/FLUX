//
//  TEStatePersistenceSpec.m
//  MasterApp
//
//  Created by Dmitry on 10.09.15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TEStatePersistence.h"
#import "TEFileSystemPersistentProvider.h"
#import "TEFakeStore.h"
#import "TEPersistentStoreMock.h"

@interface TEStatePersistence (Testing)

@property (nonatomic, strong) TEFileSystemPersistentProvider *persistence;
- (void)setupStore:(TEBaseStore *)store;
- (void)restoreState:(id)state ofStore:(TEBaseStore <TEPersistentStoreProtocol> *)store;

@end

SPEC_BEGIN(TEStatePersistenceSpec)

    TEStatePersistence __block *sut;

beforeEach(^{
    sut = [[TEStatePersistence alloc] init];
});

afterEach(^{
    sut = nil;
});

describe(@"init", ^{
    it(@"should init", ^{
        [[sut.persistence shouldNot] beNil];
        [[sut.persistence should] conformToProtocol:@protocol(TEPersistenceProtocol)];
    });
});

describe(@"register store", ^{
    it(@"shouldObserveStore: should return YES for correct store", ^{
        id storeMock = [KWMock mockForProtocol:@protocol(TEPersistentStoreProtocol)];
        BOOL result = [sut shouldObserveStore:storeMock];
        [[theValue(result) should] beTrue];
    });

    it(@"shouldObserveStore: should return NO for incorrect store", ^{
        id storeMock = [KWMock mockForClass:[TEFakeStore class]];
        BOOL result = [sut shouldObserveStore:storeMock];
        [[theValue(result) should] beFalse];
    });

    it(@"should try to restore state", ^{
        id storeMock = [KWMock mockForClass:[TEPersistentStoreMock class]];
        id stateMock = [KWMock mockForClass:[TEBaseState class]];
        sut.persistence = (TEFileSystemPersistentProvider *)[KWMock mockForClass:[TEFileSystemPersistentProvider class]];

        [storeMock stub:@selector(shouldRestoreState:) andReturn:theValue(YES)];
        [sut.persistence stub:@selector(stateForStore:) andReturn:stateMock];

        [[sut.persistence should] receive:@selector(stateForStore:)
                            withArguments:storeMock, nil];
        [storeMock stub:@selector(shouldRestoreState:)
              andReturn:theValue(YES)
          withArguments:stateMock, nil];
        [[sut should] receive:@selector(restoreState:ofStore:)
                withArguments:stateMock, storeMock, nil];

        [[storeMock should] receive:@selector(setIsLoaded:) withArguments:theValue(YES)];
        [sut setupStore:storeMock];
    });
});

SPEC_END