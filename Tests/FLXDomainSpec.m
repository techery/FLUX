//
//  TEBaseDomainSpec.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/8/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FLXDomain.h"
#import "FLXStore.h"

#import "FLXDispatcher.h"
#import "FLXMiddleware.h"

#import "FLXTestModels.h"
#import "FLXTestExecutor.h"

SPEC_BEGIN(FLXDomainSpec)

__block FLXDispatcher *dispatcherMock;
__block FLXTestExecutor *testExecutor;
__block FLXTestStore *testStoreMock;
__block FLXFakeStore *fakeStoreMock;

beforeEach(^{
    dispatcherMock = [FLXDispatcher mock];
    testExecutor = [FLXTestExecutor new];
    testStoreMock = [FLXTestStore new];
    fakeStoreMock = [FLXFakeStore new];
});

describe(@"Initialization", ^{
    __block id<FLXMiddleware> middlewareMock;
    
    it(@"Should create dispatcher and register stores", ^{
        middlewareMock = [KWMock mockForProtocol:@protocol(FLXMiddleware)];
        
        [[FLXDispatcher should] receive:@selector(dispatcherWithMiddlewares:)
                                    andReturn:dispatcherMock
                                withArguments:@[middlewareMock]];
        
        [[dispatcherMock should] receive:@selector(registerStore:) withArguments:fakeStoreMock];
        [[dispatcherMock should] receive:@selector(registerStore:) withArguments:testStoreMock];
        
        __unused FLXDomain *localSut = [[FLXDomain alloc] initWithExecutor:[FLXTestExecutor new]
                                                             middlewares:@[middlewareMock]
                                                                  stores:@[fakeStoreMock, testStoreMock]];
        
        [[localSut shouldNot] beNil];
        [[localSut should] conformToProtocol:@protocol(FLXDomainProtocol)];
    });
});

describe(@"Actions", ^{
    __block FLXDomain *sut;
    
    beforeEach(^{
        [FLXDispatcher stub:@selector(dispatcherWithMiddlewares:)
                        andReturn:dispatcherMock];
        sut = [[FLXDomain alloc] initWithExecutor:testExecutor
                                     middlewares:@[]
                                          stores:@[]];
    });
    
    it(@"Should dispatch asynchronously", ^{
        KWCaptureSpy *spy = [testExecutor captureArgument:@selector(execute:) atIndex:0];
        
        id actionMock = [NSObject new];
        [[dispatcherMock should] receive:@selector(dispatchAction:) withArguments:actionMock];
        
        [sut dispatchAction:actionMock];

        [[spy.argument shouldNot] beNil];
    });
    
    it(@"Should dispatch synchronously", ^{
        KWCaptureSpy *spy = [testExecutor captureArgument:@selector(executeAndWait:) atIndex:0];
        
        id actionMock = [NSObject new];
        [[dispatcherMock should] receive:@selector(dispatchAction:) withArguments:actionMock];
        
        [sut dispatchActionAndWait:actionMock];
        [[spy.argument shouldNot] beNil];
    });
});

describe(@"Persistent stores", ^{
    __block FLXDomain *sut;
    
    beforeEach(^{
        [dispatcherMock stub:@selector(registerStore:)];
        [FLXDispatcher stub:@selector(dispatcherWithMiddlewares:)
                        andReturn:dispatcherMock];
        sut = [[FLXDomain alloc] initWithExecutor:[FLXTestExecutor new]
                                     middlewares:@[]
                                          stores:@[fakeStoreMock]];
    });
    
    it(@"Returns store if registered", ^{
        id fakeStore = [sut storeByClass:[FLXFakeStore class]];
        [[fakeStore should] equal:fakeStoreMock];
    });
    
    it(@"Returns nil if not registered", ^{
        id result = [sut storeByClass:[FLXTestStore class]];
        [[result should] beNil];
    });
    
    it(@"Returns nil if requested class is not a store", ^{
        id result = [sut storeByClass:[NSObject class]];
        [[result should] beNil];
    });
    
    it(@"Can be registered afterwards", ^{
        [sut registerStores:@[testStoreMock]];
        id result = [sut storeByClass:[FLXTestStore class]];
        [[result should] equal:testStoreMock];
    });
});

describe(@"Temporary store", ^{
    __block FLXDomain *sut;
    
    beforeEach(^{
        [FLXDispatcher stub:@selector(dispatcherWithMiddlewares:)
                        andReturn:dispatcherMock];
        sut = [[FLXDomain alloc] initWithExecutor:[FLXTestExecutor new]
                                     middlewares:@[]
                                          stores:@[]];
    });
    
    it(@"Creates and registers new store", ^{
        KWCaptureSpy *spy = [dispatcherMock captureArgument:@selector(registerStore:) atIndex:0];
        id result = [sut temporaryStoreOfClass:[FLXFakeStore class]];
        
        [[result shouldNot] beNil];
        [[result should] beKindOfClass:[FLXFakeStore class]];
        [[spy.argument should] equal:result];
    });
    
    it(@"Can register instance of temporary store", ^{
        id fakeStore = [FLXFakeStore class];
        KWCaptureSpy *spy = [dispatcherMock captureArgument:@selector(registerStore:) atIndex:0];
        [sut registerTemporaryStore:fakeStore];
        [[spy.argument should] equal:fakeStore];
        [[[sut storeByClass:[FLXFakeStore class]] should] beNil];
    });
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-repeated-use-of-weak"
    it(@"Is not retained by domain if registered", ^{
        [dispatcherMock stub:@selector(registerStore:)];
        __weak id fakeStore = nil;
        @autoreleasepool {
            id strongStore = [FLXFakeStore new];
            [sut registerTemporaryStore:strongStore];
            fakeStore = strongStore;
        }
        [[fakeStore should] beNil];
    });
    
    it(@"Is not retained by domain if created by class", ^{
        [dispatcherMock stub:@selector(registerStore:)];
        __weak id fakeStore = nil;
        @autoreleasepool {
            [dispatcherMock stub:@selector(registerStore:)];
            id strongStore = [sut temporaryStoreOfClass:[FLXFakeStore class]];
            fakeStore = strongStore;
        }
        [[fakeStore should] beNil];

    });
#pragma clang diagnostic pop
    
    it(@"Returns nil if class is not a store", ^{
        id result = [sut temporaryStoreOfClass:[NSObject class]];
        [[result should] beNil];
    });
});

SPEC_END
