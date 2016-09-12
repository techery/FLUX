//
//  TEBaseDomainSpec.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/8/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TEDomain.h"
#import "TEBaseStore.h"
#import "TEActionsDispatcher.h"
#import "TESerialExecutor.h"
#import "TEBaseAction.h"
#import "TEFakeDomainMiddlewares.h"

@interface TEDomain (Testing)

@property (nonatomic, strong, readwrite) TEActionsDispatcher *dispatcher;
@property (nonatomic, strong) id <TEExecutor> executor;
@property (nonatomic, strong) NSMutableDictionary *stores;
@property (nonatomic, strong) NSArray *middlewares;

- (void)setup;
- (TESerialExecutor *)createExecutor;
- (TEActionsDispatcher *)createDispatcher;
- (NSArray*)createMiddlewares;

- (void)subscribeStoreToEvents:(TEBaseStore *)store;

- (void)registerStoreInDispatcher:(TEBaseStore *)store;
- (void)registerStoreInMiddlewares:(TEBaseStore *)store;

@end

@interface TEDomain (InitTesting)

- (instancetype)initForTesting;

@end

@implementation TEDomain (InitTesting)

- (instancetype)initForTesting
{
    return [super init];
}

@end

SPEC_BEGIN(TEDomainSpec)

let(sut, ^TEDomain *{
    return [[TEDomain alloc] initForTesting];
});

describe(@"initialization", ^{

    it(@"should conform domain protocol", ^{
        [[sut should] conformToProtocol:@protocol(TEDomainProtocol)];
    });
    
    it(@"should perform default setup", ^{
        id executorMock = [KWMock mockForClass:[TESerialExecutor class]];
        [[sut should] receive:@selector(createExecutor) andReturn:executorMock];
        
        id dispatcherMock = [KWMock mockForClass:[TEActionsDispatcher class]];
        [[sut should] receive:@selector(createDispatcher) andReturn:dispatcherMock];
        
        id middlewaresMock = @[];
        [[sut should] receive:@selector(createMiddlewares) andReturn:middlewaresMock];
        
        [[sut should] receive:@selector(setup)];
        
        sut = [sut init];
        
        [[sut.stores shouldNot] beNil];
        [[sut.dispatcher should] equal:dispatcherMock];
        [[sut.middlewares should] equal:middlewaresMock];
        [[(NSObject *)sut.executor should] equal:executorMock];
    });
});

describe(@"setup", ^{
    
    it(@"shoud throw exception on setup", ^{
        [[theBlock(^{
            [sut setup];
        }) should] raise];
    });
    
    it(@"should return serial executor", ^{
        id executor = [sut createExecutor];
        [[executor shouldNot] beNil];
        [[executor should] beKindOfClass:[TESerialExecutor class]];
    });
    
    it(@"should return actions dispatcher", ^{
        id dispatcher = [sut createDispatcher];
        [[dispatcher shouldNot] beNil];
        [[dispatcher should] beKindOfClass:[TEActionsDispatcher class]];
    });
});

describe(@"middlewares", ^{
    it(@"should return emtpy array", ^{
        NSArray *array = [sut createMiddlewares];
        [[array should] beEmpty];
    });
});

describe(@"Action dispatching", ^{
    let(actionMock, ^id{
        return [TEBaseAction mock];
    });
    
    let(executorMock, ^id{
        return [KWMock mockForProtocol:@protocol(TEExecutor)];
    });
    
    let(actionDispatcherMock, ^{
        return [TEActionsDispatcher mock];
    });
    
    let(actionMiddleware, ^TEFakeActionMiddleware *{
        return [TEFakeActionMiddleware new];
    });
    
    let(storeMiddleware, ^TEFakeStoreMiddleware *{
        return [TEFakeStoreMiddleware new];
    });
    
    beforeEach(^{
        sut.executor = executorMock;
        sut.dispatcher = actionDispatcherMock;
        sut.middlewares = @[actionMiddleware, storeMiddleware];
    });
    
    it(@"Can dispatch action asynchroniously", ^{
        [[actionDispatcherMock shouldEventually] receive:@selector(dispatchAction:) withArguments:actionMock];
        [[actionMiddleware shouldEventually] receive:@selector(onActionDispatching:) withArguments:actionMock];
        
        KWCaptureSpy *executionSpy = [executorMock captureArgument:@selector(executeAndWait:) atIndex:0];
        [sut dispatchActionAndWait:actionMock];
        
        TEExecutorEmptyBlock executionBlock = (TEExecutorEmptyBlock)executionSpy.argument;
        if(executionBlock) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), executionBlock);
        }
    });
    
    it(@"Can dispatch action synchroniously", ^{
        [[actionDispatcherMock should] receive:@selector(dispatchAction:) withArguments:actionMock];
        [[actionMiddleware should] receive:@selector(onActionDispatching:) withArguments:actionMock];
        
        KWCaptureSpy *executionSpy = [executorMock captureArgument:@selector(executeAndWait:) atIndex:0];
        [sut dispatchActionAndWait:actionMock];
        
        TEExecutorEmptyBlock executionBlock = (TEExecutorEmptyBlock)executionSpy.argument;
        if(executionBlock) {
            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), executionBlock);
        }
    });
});

describe(@"action registrator", ^{
    
    id __block storeMock;
    
    beforeEach(^{
        storeMock = [KWMock mockForClass:[TEBaseStore class]];
        sut.executor = [KWMock mockForClass:[TESerialExecutor class]];
        sut.dispatcher = [KWMock mockForClass:[TEActionsDispatcher class]];
        sut.stores = [@{} mutableCopy];
    });
    
    it(@"should save store in domain and wrap other in executor", ^{
        [[sut shouldNot] receive:@selector(registerStoreInDispatcher:)];
        [[sut shouldNot] receive:@selector(registerStoreInMiddlewares:)];
        
        [(NSObject *)sut.executor stub:@selector(execute:)];
        
        [sut registerStore:storeMock];
        [[[sut.stores objectForKey:NSStringFromClass([storeMock class])] should] equal:storeMock];
    });
    
    it(@"should call registration methods", ^{
        [[sut should] receive:@selector(subscribeStoreToEvents:) withArguments:storeMock];
        [sut registerStore:storeMock];
    });
    
    it(@"should register store in dispatcher", ^{
        [[sut.dispatcher should] receive:@selector(registerStore:) withArguments:storeMock];
        [sut registerStoreInDispatcher:storeMock];
    });
    
    it(@"should register store in middlewares that implement onStoreRegistration", ^{
        TEFakeActionMiddleware *actionMw = [TEFakeActionMiddleware new];
        
        TEFakeStoreMiddleware *storeMw = [TEFakeStoreMiddleware new];
        [[storeMw should] receive:@selector(onStoreRegistration:) withArguments:storeMock];
        
        [sut stub:@selector(middlewares) andReturn:@[actionMw, storeMw]];
        
        [sut registerStoreInMiddlewares:storeMock];
    });
    
    it(@"should register temporary store in dispatcher without saving", ^{
        [(NSObject *)sut.executor stub:@selector(execute:)];

        [sut registerTemporaryStore:storeMock];
        [[[sut.stores objectForKey:NSStringFromClass([storeMock class])] should] beNil];
    });
    
    it(@"should call registration methods for temporary store", ^{
        [[sut should] receive:@selector(subscribeStoreToEvents:) withArguments:storeMock];
        [sut registerTemporaryStore:storeMock];
    });
    
    it(@"should register store in dispatcher and middlewares", ^{
        [[sut should] receive:@selector(registerStoreInDispatcher:) withArguments:storeMock];
        [[sut should] receive:@selector(registerStoreInMiddlewares:) withArguments:storeMock];
        
        [(NSObject *)sut.executor stub:@selector(execute:) withBlock:^id(NSArray *params) {
            void (^executorBlock)() = params[0];
            executorBlock();
            return nil;
        }];
        [sut subscribeStoreToEvents:storeMock];
    });
});

describe(@"getting store by class", ^{
    
    id __block storeMock;
    
    beforeEach(^{
        storeMock = [KWMock mockForClass:[TEBaseStore class]];
        sut.stores = [@{NSStringFromClass([storeMock class]) : storeMock} mutableCopy];
    });
    
    it(@"should return store by class key", ^{
        id store = [sut getStoreByClass:[storeMock class]];
        [[store should] equal:storeMock];
    });
    
    it(@"should return nil if not found", ^{
        id store = [sut getStoreByClass:[NSObject class]];
        [[store should] beNil];
    });
});

SPEC_END