//
//  TEBaseDomainSpec.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/8/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <FLUX/TEDomain.h>
#import <FLUX/TEBaseStore.h>

#import <FLUX/TEActionsDispatcher.h>
#import <FLUX/TEDomainMiddleware.h>

#import "TETestModels.h"
#import "TETestExecutor.h"

SPEC_BEGIN(TEDomainSpec)

__block TEActionsDispatcher *dispatcherMock;
__block TETestExecutor *testExecutor;
__block TETestStore *testStoreMock;
__block TEFakeStore *fakeStoreMock;

beforeEach(^{
    dispatcherMock = [TEActionsDispatcher mock];
    testExecutor = [TETestExecutor new];
    testStoreMock = [TETestStore new];
    fakeStoreMock = [TEFakeStore new];
});

describe(@"Initialization", ^{
    __block id<TEDomainMiddleware> middlewareMock;
    
    it(@"Should create dispatcher and register stores", ^{
        middlewareMock = [KWMock mockForProtocol:@protocol(TEDomainMiddleware)];
        
        [[TEActionsDispatcher should] receive:@selector(dispatcherWithMiddlewares:)
                                    andReturn:dispatcherMock
                                withArguments:@[middlewareMock]];
        
        [[dispatcherMock should] receive:@selector(registerStore:) withArguments:fakeStoreMock];
        [[dispatcherMock should] receive:@selector(registerStore:) withArguments:testStoreMock];
        
        __unused TEDomain *localSut = [[TEDomain alloc] initWithExecutor:[TETestExecutor new]
                                                             middlewares:@[middlewareMock]
                                                                  stores:@[fakeStoreMock, testStoreMock]];
        
        [[localSut shouldNot] beNil];
        [[localSut should] conformToProtocol:@protocol(TEDomainProtocol)];
    });
});

describe(@"Actions", ^{
    __block TEDomain *sut;
    
    beforeEach(^{
        [TEActionsDispatcher stub:@selector(dispatcherWithMiddlewares:)
                        andReturn:dispatcherMock];
        sut = [[TEDomain alloc] initWithExecutor:testExecutor
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
    __block TEDomain *sut;
    
    beforeEach(^{
        [dispatcherMock stub:@selector(registerStore:)];
        [TEActionsDispatcher stub:@selector(dispatcherWithMiddlewares:)
                        andReturn:dispatcherMock];
        sut = [[TEDomain alloc] initWithExecutor:[TETestExecutor new]
                                     middlewares:@[]
                                          stores:@[fakeStoreMock]];
    });
    
    it(@"Returns store if registered", ^{
        id fakeStore = [sut getStoreByClass:[TEFakeStore class]];
        [[fakeStore should] equal:fakeStoreMock];
    });
    
    it(@"Returns nil if not registered", ^{
        id result = [sut getStoreByClass:[TETestStore class]];
        [[result should] beNil];
    });
    
    it(@"Returns nil if requested class is not a store", ^{
        id result = [sut getStoreByClass:[NSObject class]];
        [[result should] beNil];
    });
});

describe(@"Temporary store", ^{
    __block TEDomain *sut;
    
    beforeEach(^{
        [TEActionsDispatcher stub:@selector(dispatcherWithMiddlewares:)
                        andReturn:dispatcherMock];
        sut = [[TEDomain alloc] initWithExecutor:[TETestExecutor new]
                                     middlewares:@[]
                                          stores:@[]];
    });
    
    it(@"Creates and registers new store", ^{
        KWCaptureSpy *spy = [dispatcherMock captureArgument:@selector(registerStore:) atIndex:0];
        id result = [sut createTemporaryStoreByClass:[TEFakeStore class]];
        
        [[result shouldNot] beNil];
        [[result should] beKindOfClass:[TEFakeStore class]];
        [[spy.argument should] equal:result];
    });
    
    it(@"Returns nil if class is not a store", ^{
        id result = [sut createTemporaryStoreByClass:[NSObject class]];
        [[result should] beNil];
    });
});

SPEC_END
