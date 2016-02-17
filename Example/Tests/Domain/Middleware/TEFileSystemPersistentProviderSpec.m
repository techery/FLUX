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
- (void)createWorkingDirectoryIfNeeded;
- (NSString *)pathToWorkingDirectory;
- (NSString *)serviceId;
@end

SPEC_BEGIN(TEFileSystemPersistentProviderSpec)

TEFileSystemPersistentProvider __block *sut;
id __block fileManagerMock;

NSString __block *pathToSavedState;
NSString __block *pathToDirectory;

beforeEach(^{
    pathToDirectory = @"file://directory/FLUX";
    pathToSavedState = @"file://directory/FLUX/KWMock.savedstate";
    
    fileManagerMock = [KWMock nullMockForClass:[NSFileManager class]];
    sut = [[TEFileSystemPersistentProvider alloc] initWithFileManager:fileManagerMock];
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
        [sut stub:@selector(pathToWorkingDirectory) andReturn:pathToDirectory];
        TEPersistentStoreMock *storeMock = (TEPersistentStoreMock *)[KWMock mockForClass:[TEPersistentStoreMock class]];
        NSString *path = [sut pathForStore:storeMock];
        
        [[path should] equal:pathToSavedState];
    });

    it(@"should archive state with NSKeyedArchiver", ^{
        [sut stub:@selector(pathToWorkingDirectory) andReturn:pathToDirectory];
        TEPersistentStoreMock *storeMock = (TEPersistentStoreMock *)[KWMock mockForClass:[TEPersistentStoreMock class]];
        TEFakeState *stateMock = (TEFakeState *)[KWMock mockForClass:[TEFakeState class]];
        NSString *path = pathToSavedState;

        [[sut shouldEventually] receive:@selector(pathForStore:) andReturn:path withArguments:storeMock, nil];
        [[NSKeyedArchiver shouldEventually] receive:@selector(archiveRootObject:toFile:) withArguments:stateMock, path, nil];

        [sut saveState:stateMock forStore:storeMock];
    });
    
    it(@"should restore state with NSKeyedArchiver", ^{
        TEPersistentStoreMock *storeMock = (TEPersistentStoreMock *)[KWMock mockForClass:[TEPersistentStoreMock class]];
        [sut stub:@selector(pathForStore:) andReturn:pathToSavedState withArguments:storeMock, nil];
        [[NSKeyedUnarchiver should] receive:@selector(unarchiveObjectWithFile:) withArguments:pathToSavedState, nil];

        [sut stateForStore:storeMock];
    });
});

describe(@"creating working directory", ^{
    beforeEach(^{
        [sut stub:@selector(pathToWorkingDirectory) andReturn:pathToDirectory];
    });
    
    context(@"directory not exists", ^{
        it(@"should create new directory", ^{
            [fileManagerMock stub:@selector(fileExistsAtPath:) andReturn:theValue(NO) withArguments:pathToDirectory];
            [[fileManagerMock should] receive:@selector(createDirectoryAtPath:withIntermediateDirectories:attributes:error:)];
            [sut createWorkingDirectoryIfNeeded];
        });
    });
    
    context(@"directory already exists", ^{
        it(@"should not create new directory", ^{
            [fileManagerMock stub:@selector(fileExistsAtPath:) andReturn:theValue(YES) withArguments:pathToDirectory];
            [[fileManagerMock shouldNot] receive:@selector(createDirectoryAtPath:withIntermediateDirectories:attributes:error:)];
            [sut createWorkingDirectoryIfNeeded];
        });
    });
});

SPEC_END