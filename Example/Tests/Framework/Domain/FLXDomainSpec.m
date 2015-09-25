//
//  FLXBaseDomainSpec.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/8/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FLXDomain.h"
#import "FLXBaseStore.h"
#import "FLXActionsDispatcher.h"
#import "FLXSerialExecutor.h"
#import "FLXBaseAction.h"
#import "FLXFakeDomainMiddlewares.h"

@interface FLXDomain (Testing)

@property (nonatomic, strong, readwrite) FLXActionsDispatcher *dispatcher;
@property (nonatomic, strong) id <FLXExecutor> executor;
@property (nonatomic, strong) NSMutableDictionary *stores;
@property (nonatomic, strong) NSArray *middlewares;

- (void)setup;
- (FLXSerialExecutor *)createExecutor;
- (FLXActionsDispatcher *)createDispatcher;
- (NSArray*)createMiddlewares;

- (void)sendActionToDispatcher:(FLXBaseAction *)action;
- (void)sendActionToMiddlewares:(FLXBaseAction *)action;


- (void)registerStoreInDispatcher:(FLXBaseStore *)store;
- (void)registerStoreInMiddlewares:(FLXBaseStore *)store;

@end

@interface FLXDomain (InitTesting)

- (instancetype)initForTesting;

@end

@implementation FLXDomain (InitTesting)

- (instancetype)initForTesting
{
    return [super init];
}

@end

SPEC_BEGIN(FLXDomainSpec)

FLXDomain __block *sut;

beforeEach(^{
    sut = [[FLXDomain alloc] initForTesting];
});

afterEach(^{
    sut = nil;
});

describe(@"initialization", ^{

    it(@"should perform default setup", ^{
        
        id executorMock = [KWMock mockForClass:[FLXSerialExecutor class]];
        [[sut should] receive:@selector(createExecutor) andReturn:executorMock];
        
        id dispatcherMock = [KWMock mockForClass:[FLXActionsDispatcher class]];
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
        [[executor should] beKindOfClass:[FLXSerialExecutor class]];
    });
    
    it(@"should return actions dispatcher", ^{
        id dispatcher = [sut createDispatcher];
        [[dispatcher shouldNot] beNil];
        [[dispatcher should] beKindOfClass:[FLXActionsDispatcher class]];
    });
});

describe(@"middlewares", ^{
    it(@"should return emtpy array", ^{
        NSArray *array = [sut createMiddlewares];
        [[array should] beEmpty];
    });
});

describe(@"actions dispatching", ^{
    
    id __block actionMock;
    
    beforeEach(^{
        actionMock = [KWMock mockForClass:[FLXBaseAction class]];
        sut.executor = [KWMock mockForClass:[FLXSerialExecutor class]];
        sut.dispatcher = [KWMock mockForClass:[FLXActionsDispatcher class]];
    });

    it(@"must wrap dispatching to executor", ^{
        [[sut shouldNot] receive:@selector(sendActionToDispatcher:)];
        [[sut shouldNot] receive:@selector(sendActionToMiddlewares:)];
        [(NSObject *)sut.executor stub:@selector(execute:)];
        [sut dispatchAction:actionMock];
    });
    
    it(@"should dispatch action", ^{
        [[sut should] receive:@selector(sendActionToDispatcher:) withArguments:actionMock];
        
        [[sut should] receive:@selector(sendActionToMiddlewares:) withArguments:actionMock];
        
        [(NSObject *)sut.executor stub:@selector(execute:) withBlock:^id(NSArray *params) {
            void (^executorBlock)() = params[0];
            executorBlock();
            return nil;
        }];
        
        [sut dispatchAction:actionMock];
    });
    
    it(@"should send action to dispatcher", ^{
        [[sut.dispatcher should] receive:@selector(dispatchAction:) withArguments:actionMock];
        [sut sendActionToDispatcher:actionMock];
    });
    
    it(@"should send action to middlewares that implement onActionsDispatching", ^{
        FLXFakeActionMiddleware *actionMw = [FLXFakeActionMiddleware new];
        [[actionMw should] receive:@selector(onActionDispatching:) withArguments:actionMock];
        
        FLXFakeStoreMiddleware *storeMw = [FLXFakeStoreMiddleware new];
        
        [sut stub:@selector(middlewares) andReturn:@[actionMw, storeMw]];
        
        [sut sendActionToMiddlewares:actionMock];
    });
});

describe(@"action registrator", ^{
    
    id __block storeMock;
    
    beforeEach(^{
        storeMock = [KWMock mockForClass:[FLXBaseStore class]];
        sut.executor = [KWMock mockForClass:[FLXSerialExecutor class]];
        sut.dispatcher = [KWMock mockForClass:[FLXActionsDispatcher class]];
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
        
        [[sut should] receive:@selector(registerStoreInDispatcher:) withArguments:storeMock];
        [[sut should] receive:@selector(registerStoreInMiddlewares:) withArguments:storeMock];
        
        [(NSObject *)sut.executor stub:@selector(execute:) withBlock:^id(NSArray *params) {
            void (^executorBlock)() = params[0];
            executorBlock();
            return nil;
        }];
        
        [sut registerStore:storeMock];
    });
    
    it(@"should register store in dispatcher", ^{
        [[sut.dispatcher should] receive:@selector(registerStore:) withArguments:storeMock];
        [sut registerStoreInDispatcher:storeMock];
    });
    
    it(@"should register store in middlewares that implement onStoreRegistration", ^{
        FLXFakeActionMiddleware *actionMw = [FLXFakeActionMiddleware new];
        
        FLXFakeStoreMiddleware *storeMw = [FLXFakeStoreMiddleware new];
        [[storeMw should] receive:@selector(onStoreRegistration:) withArguments:storeMock];
        
        [sut stub:@selector(middlewares) andReturn:@[actionMw, storeMw]];
        
        [sut registerStoreInMiddlewares:storeMock];
    });
});

describe(@"getting store by class", ^{
    
    id __block storeMock;
    
    beforeEach(^{
        storeMock = [KWMock mockForClass:[FLXBaseStore class]];
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