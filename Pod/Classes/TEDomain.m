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
#import "TEBaseStore.h"
#import "TEDomainMiddleware.h"

@interface TEDomain()

@property (nonatomic, strong) TEActionsDispatcher *dispatcher;
@property (nonatomic, strong) id <TEExecutor> executor;

@property (nonatomic, strong) NSMutableDictionary <NSString *, TEBaseStore *>*storeRegistry;
@property (nonatomic, strong) NSArray <id<TEDomainMiddleware>> *middlewares;

@end

@implementation TEDomain

- (instancetype)init {
    return [self initWithExecutor:[TESerialExecutor new]
                      middlewares:@[]
                           stores:@[]];
}

- (instancetype)initWithExecutor:(id<TEExecutor>)executor
                     middlewares:(NSArray <id<TEDomainMiddleware>> *)middlewares
                          stores:(NSArray <TEBaseStore *>*)stores {
    self = [super init];
    if(self) {
        self.executor = executor;
        self.middlewares = middlewares;
        self.dispatcher = [TEActionsDispatcher dispatcherWithMiddlewares:self.middlewares];
        [self registerStores:stores];
    }
    return self;
}

#pragma mark - Stores registration

- (void)registerStores:(NSArray <TEBaseStore *>*)storesArray {
    self.storeRegistry = [NSMutableDictionary new];
    for(TEBaseStore *store in storesArray) {
        [self registerStore:store];
    }
}

- (void)registerStore:(TEBaseStore *)store {
    NSParameterAssert(store);
    NSString *storeKey = NSStringFromClass([store class]);
    [self.storeRegistry setObject:store forKey:storeKey];
    [self subscribeStoreToEvents:store];
}

- (void)subscribeStoreToEvents:(TEBaseStore *)store {
    __weak typeof(self) weakSelf = self;
    [self.executor execute:^{
        [weakSelf.dispatcher registerStore:store];
    }];
}

#pragma mark - Action dispatching

- (void)dispatchAction:(TEBaseAction *)action {
    __weak typeof(self) weakSelf = self;
    [self.executor execute:^{
        [weakSelf.dispatcher dispatchAction:action];
    }];
}

- (void)dispatchActionAndWait:(TEBaseAction *)action {
    __weak typeof(self) weakSelf = self;
    [self.executor executeAndWait:^{
        [weakSelf.dispatcher dispatchAction:action];
    }];
}

#pragma mark - Store accessors

- (TEBaseStore *)getStoreByClass:(Class)class {
    return [self.storeRegistry objectForKey:NSStringFromClass(class)];
}

- (TEBaseStore *)createTemporaryStoreByClass:(Class)storeClass {
    id instance = [[storeClass alloc] init];
    if([instance isKindOfClass:[TEBaseStore class]]) {
        TEBaseStore *store = (TEBaseStore *)instance;
        [self subscribeStoreToEvents:store];
        return store;
    }
    return nil;
}

@end
