//
//  TEFileSystemPersistentProvider.m
//  MasterApp
//
//  Created by Dmitry on 15.09.15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TEFileSystemPersistentProvider.h"
#import "TEFakeState.h"
#import "TEPersistentStoreMock.h"

@interface TEFileSystemPersistentProvider (Testing)
@property (nonatomic, strong) dispatch_queue_t storeQueue;
- (NSString *)pathForStore:(TEBaseStore <TEPersistentStoreProtocol> *)store;
- (NSString *)serviceId;
@end

SPEC_BEGIN(TEFileSystemPersistentProviderSpec)

TEFileSystemPersistentProvider __block *sut;

beforeEach(^{
    sut = [[TEFileSystemPersistentProvider alloc] init];
});

afterEach(^{
    sut = nil;
});

describe(@"init", ^{
    it(@"should init", ^{
        [[sut.storeQueue shouldNot] beNil];
    });
});

describe(@"File access", ^{
    it(@"should return correct path for state", ^{
        TEPersistentStoreMock *storeMock = (TEPersistentStoreMock *)[KWMock mockForClass:[TEPersistentStoreMock class]];
        NSString *storeName = NSStringFromClass([storeMock class]);
        NSString *rightPath = [NSString stringWithFormat:@"%@%@.savedstate", NSTemporaryDirectory(), storeName];
        NSString *path = [sut pathForStore:storeMock];
        [[path should] equal:rightPath];
    });

    it(@"should archive state with NSKeyedArchiver", ^{
        TEPersistentStoreMock *storeMock = (TEPersistentStoreMock *)[KWMock mockForClass:[TEPersistentStoreMock class]];
        TEFakeState *stateMock = (TEFakeState *)[KWMock mockForClass:[TEFakeState class]];
        NSString *path = [NSString stringWithFormat:@"%@%@.savedstate", NSTemporaryDirectory(), NSStringFromClass([storeMock class])];

        [[sut shouldEventually] receive:@selector(pathForStore:) andReturn:path withArguments:storeMock, nil];
        [[NSKeyedArchiver shouldEventually] receive:@selector(archiveRootObject:toFile:) withArguments:stateMock, path, nil];

        [sut saveState:stateMock forStore:storeMock];
    });

    it(@"should restore state with NSKeyedArchiver", ^{
        TEPersistentStoreMock *storeMock = (TEPersistentStoreMock *)[KWMock mockForClass:[TEPersistentStoreMock class]];
        NSString *path = [NSString stringWithFormat:@"%@%@.savedstate", NSTemporaryDirectory(), NSStringFromClass([storeMock class])];

        [[sut should] receive:@selector(pathForStore:) andReturn:path withArguments:storeMock, nil];
        [[NSKeyedUnarchiver should] receive:@selector(unarchiveObjectWithFile:) withArguments:path, nil];

        [sut stateForStore:storeMock];
    });
});

SPEC_END