//
//  FLXDomain.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/4/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "FLXDomain.h"
#import "FLXDispatcherProtocol.h"
#import "FLXSerialExecutor.h"
#import "FLXActionsDispatcher.h"

#import "FLXDomainMiddleware.h"

@interface FLXDomain()

@property (nonatomic, strong) FLXActionsDispatcher *dispatcher;

@property (nonatomic, strong) id <FLXExecutor> executor;
@property (nonatomic, strong) NSMutableDictionary *stores;

@property (nonatomic, strong) NSArray *middlewares;

@end

@implementation FLXDomain

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

- (id<FLXExecutor>)createExecutor
{
    return [[FLXSerialExecutor alloc] init];
}

- (FLXActionsDispatcher *)createDispatcher
{
    return [[FLXActionsDispatcher alloc] init];
}

- (NSArray*)createMiddlewares {
    return @[];
}

- (void)setup {
    [NSException raise:@"Not allowed" format:@"-setup method of base class shouldn't be used. Please override it in sublass"];
}

- (void)dispatchAction:(id)action {
    @weakify(self);
    [self.executor execute:^{
        @strongify(self);
        [self sendActionToDispatcher:action];
        [self sendActionToMiddlewares:action];
    }];
}

- (void)sendActionToDispatcher:(id)action
{
    [self.dispatcher dispatchAction:action];
}

- (void)sendActionToMiddlewares:(id)action
{
    [self.middlewares enumerateObjectsUsingBlock:^(id<FLXDomainMiddleware> middleware, NSUInteger idx, BOOL *stop) {
        if([middleware respondsToSelector:@selector(onActionDispatching:)])
        {
            [middleware onActionDispatching:action];
        }
    }];
}

- (void)registerStore:(FLXBaseStore *)store {
    NSParameterAssert(store);
    NSString *storeKey = NSStringFromClass([(NSObject *)store class]);
    [self.stores setObject:store forKey:storeKey];
    
    @weakify(self);
    [self.executor execute:^{
        @strongify(self);
        [self registerStoreInDispatcher:store];
        [self registerStoreInMiddlewares:store];
    }];
}

- (void)registerStoreInDispatcher:(FLXBaseStore *)store {
    [self.dispatcher registerStore:store];
};

- (void)registerStoreInMiddlewares:(FLXBaseStore *)store {
    [self.middlewares enumerateObjectsUsingBlock:^(id<FLXDomainMiddleware> middleware, NSUInteger idx, BOOL *stop) {
        if([middleware respondsToSelector:@selector(onStoreRegistration:)])
        {
            [middleware onStoreRegistration:store];
        }
    }];
}

- (FLXBaseStore *)getStoreByClass:(Class)class {
    return [self.stores objectForKey:NSStringFromClass(class)];
}

@end
