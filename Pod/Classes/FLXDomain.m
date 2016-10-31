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
#import "FLXDispatcher.h"
#import "FLXStore.h"
#import "FLXMiddleware.h"

@interface FLXDomain()

@property (nonatomic, strong) FLXDispatcher *dispatcher;
@property (nonatomic, strong) id <FLXExecutor> executor;

@property (nonatomic, strong) NSMutableDictionary <NSString *, FLXStore *>*storeRegistry;
@property (nonatomic, strong) NSArray <id<FLXMiddleware>> *middlewares;

@end

@implementation FLXDomain

- (instancetype)init {
    return [self initWithExecutor:[FLXSerialExecutor new]
                      middlewares:@[]
                           stores:@[]];
}

- (instancetype)initWithExecutor:(id<FLXExecutor>)executor
                     middlewares:(NSArray <id<FLXMiddleware>> *)middlewares
                          stores:(NSArray <FLXStore *>*)stores {
    self = [super init];
    if(self) {
        self.executor = executor;
        self.middlewares = middlewares;
        self.dispatcher = [FLXDispatcher dispatcherWithMiddlewares:self.middlewares];
        [self registerStores:stores];
    }
    return self;
}

#pragma mark - Stores registration

- (void)registerStores:(NSArray <FLXStore *>*)storesArray {
    self.storeRegistry = [NSMutableDictionary new];
    for(FLXStore *store in storesArray) {
        [self registerStore:store];
    }
}

- (void)registerStore:(FLXStore *)store {
    NSParameterAssert(store);
    NSString *storeKey = NSStringFromClass([store class]);
    [self.storeRegistry setObject:store forKey:storeKey];
    [self subscribeStoreToEvents:store];
}

- (void)subscribeStoreToEvents:(FLXStore *)store {
    __weak typeof(self) weakSelf = self;
    [self.executor execute:^{
        [weakSelf.dispatcher registerStore:store];
    }];
}

#pragma mark - Action dispatching

- (void)dispatchAction:(id)action {
    __weak typeof(self) weakSelf = self;
    [self.executor execute:^{
        [weakSelf.dispatcher dispatchAction:action];
    }];
}

- (void)dispatchActionAndWait:(id)action {
    __weak typeof(self) weakSelf = self;
    [self.executor executeAndWait:^{
        [weakSelf.dispatcher dispatchAction:action];
    }];
}

#pragma mark - Store accessors

- (FLXStore *)storeByClass:(Class)class {
    return [self.storeRegistry objectForKey:NSStringFromClass(class)];
}

- (FLXStore *)temporaryStoreOfClass:(Class)storeClass {
    id instance = [[storeClass alloc] init];
    if([instance isKindOfClass:[FLXStore class]]) {
        FLXStore *store = (FLXStore *)instance;
        [self subscribeStoreToEvents:store];
        return store;
    }
    return nil;
}

@end
