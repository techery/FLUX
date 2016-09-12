//
//  TEDomain.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/4/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//



#import "TEDomain.h"
#import "TEDispatcherProtocol.h"
#import "TESerialExecutor.h"
#import "TEActionsDispatcher.h"

#import "TEDomainMiddleware.h"

@interface TEDomain()

@property (nonatomic, strong) TEActionsDispatcher *dispatcher;

@property (nonatomic, strong) id <TEExecutor> executor;
@property (nonatomic, strong) NSMutableDictionary *stores;

@property (nonatomic, strong) NSArray *middlewares;

@end

@implementation TEDomain

- (instancetype)init {
    self = [super init];
    if(self) {
        self.stores = [@{} mutableCopy];
        self.executor = [self createExecutor];
        self.dispatcher = [self createDispatcher];
        self.middlewares = [self createMiddlewares];
        [self setup];
    }
    return self;
}

- (id<TEExecutor>)createExecutor
{
    return [[TESerialExecutor alloc] init];
}

- (TEActionsDispatcher *)createDispatcher
{
    return [[TEActionsDispatcher alloc] init];
}

- (NSArray*)createMiddlewares {
    return @[];
}

- (void)setup {
    [NSException raise:@"Not allowed" format:@"-setup method of base class shouldn't be used. Please override it in sublass"];
}

- (void)dispatchAction:(TEBaseAction *)action {
    @weakify(self);
    [self.executor execute:^{
        @strongify(self);
        [self sendActionToHandlers:action];
    }];
}

- (void)dispatchActionAndWait:(TEBaseAction *)action {
    @weakify(self);
    [self.executor executeAndWait:^{
        @strongify(self);
        [self sendActionToHandlers:action];
    }];
}

- (void)sendActionToHandlers:(TEBaseAction *)action {
    [self sendActionToDispatcher:action];
    [self sendActionToMiddlewares:action];
}

- (void)sendActionToDispatcher:(TEBaseAction *)action
{
    [self.dispatcher dispatchAction:action];
}

- (void)sendActionToMiddlewares:(TEBaseAction *)action
{
    [self.middlewares enumerateObjectsUsingBlock:^(id<TEDomainMiddleware> middleware, NSUInteger idx, BOOL *stop) {
        if([middleware respondsToSelector:@selector(onActionDispatching:)])
        {
            [middleware onActionDispatching:action];
        }
    }];
}

- (void)registerTemporaryStore:(TEBaseStore *)store {
    NSParameterAssert(store);
    [self subscribeStoreToEvents:store];
}

- (void)registerStore:(TEBaseStore *)store {
    NSParameterAssert(store);
    NSString *storeKey = NSStringFromClass([(NSObject *)store class]);
    [self.stores setObject:store forKey:storeKey];
    [self subscribeStoreToEvents:store];
}

- (void)subscribeStoreToEvents:(TEBaseStore *)store {
    @weakify(self);
    [self.executor execute:^{
        @strongify(self);
        [self registerStoreInDispatcher:store];
        [self registerStoreInMiddlewares:store];
    }];
}

- (void)registerStoreInDispatcher:(TEBaseStore *)store {
    [self.dispatcher registerStore:store];
};

- (void)registerStoreInMiddlewares:(TEBaseStore *)store {
    [self.middlewares enumerateObjectsUsingBlock:^(id<TEDomainMiddleware> middleware, NSUInteger idx, BOOL *stop) {
        if([middleware respondsToSelector:@selector(onStoreRegistration:)])
        {
            [middleware onStoreRegistration:store];
        }
    }];
}

- (TEBaseStore *)getStoreByClass:(Class)class {
    return [self.stores objectForKey:NSStringFromClass(class)];
}

@end
