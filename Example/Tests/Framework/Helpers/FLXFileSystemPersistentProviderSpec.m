//
//  FLXFileSystemPersistentProvider.m
//  MasterApp
//
//  Created by Dmitry on 15.09.15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FLXFileSystemPersistentProvider.h"
#import "FLXFakeState.h"
#import "FLXPersistentStoreMock.h"

@interface FLXFileSystemPersistentProvider (Testing)
@property (nonatomic, strong) dispatch_queue_t storeQueue;
- (NSString *)pathForStore:(FLXBaseStore <FLXPersistentStoreProtocol> *)store;
- (NSString *)serviceId;
@end

SPEC_BEGIN(FLXFileSystemPersistentProviderSpec)

FLXFileSystemPersistentProvider __block *sut;

beforeEach(^{
    sut = [[FLXFileSystemPersistentProvider alloc] init];
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
        FLXPersistentStoreMock *storeMock = (FLXPersistentStoreMock *)[KWMock mockForClass:[FLXPersistentStoreMock class]];
        NSString *storeName = NSStringFromClass([storeMock class]);
        NSString *rightPath = [NSString stringWithFormat:@"%@%@.savedstate", NSTemporaryDirectory(), storeName];
        NSString *path = [sut pathForStore:storeMock];
        [[path should] equal:rightPath];
    });

    it(@"should archive state with NSKeyedArchiver", ^{
        FLXPersistentStoreMock *storeMock = (FLXPersistentStoreMock *)[KWMock mockForClass:[FLXPersistentStoreMock class]];
        FLXFakeState *stateMock = (FLXFakeState *)[KWMock mockForClass:[FLXFakeState class]];
        NSString *path = [NSString stringWithFormat:@"%@%@.savedstate", NSTemporaryDirectory(), NSStringFromClass([storeMock class])];

        [[sut shouldEventually] receive:@selector(pathForStore:) andReturn:path withArguments:storeMock, nil];
        [[NSKeyedArchiver shouldEventually] receive:@selector(archiveRootObject:toFile:) withArguments:stateMock, path, nil];

        [sut saveState:stateMock forStore:storeMock];
    });

    it(@"should restore state with NSKeyedArchiver", ^{
        FLXPersistentStoreMock *storeMock = (FLXPersistentStoreMock *)[KWMock mockForClass:[FLXPersistentStoreMock class]];
        NSString *path = [NSString stringWithFormat:@"%@%@.savedstate", NSTemporaryDirectory(), NSStringFromClass([storeMock class])];

        [[sut should] receive:@selector(pathForStore:) andReturn:path withArguments:storeMock, nil];
        [[NSKeyedUnarchiver should] receive:@selector(unarchiveObjectWithFile:) withArguments:path, nil];

        [sut stateForStore:storeMock];
    });
});

SPEC_END