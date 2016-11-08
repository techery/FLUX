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

- (instancetype)initWithExecutor:(id<FLXExecutor>)executor
                     middlewares:(NSArray <id<FLXMiddleware>> *)middlewares
                          stores:(NSArray <FLXStore *>*)stores {
    self = [super init];
    if(self) {
        self.executor = executor;
        self.middlewares = middlewares;
        self.dispatcher = [FLXDispatcher dispatcherWithMiddlewares:self.middlewares];
        self.storeRegistry = [NSMutableDictionary new];
        [self attachStores:stores];
    }
    return self;
}

#pragma mark - Stores registration

- (void)attachStores:(NSArray <FLXStore *>*)storesArray {
    [self.executor execute:^{
        for(FLXStore *store in storesArray) {
            [self registerStore:store];
        }
    }];
}

- (void)attachTemporaryStore:(FLXStore *)temporaryStore {
    NSParameterAssert(temporaryStore);
    [self subscribeStoreToActions:temporaryStore];
}

- (void)registerStore:(FLXStore *)store {
    NSParameterAssert(store);
    NSString *storeKey = NSStringFromClass([store class]);
    [self.storeRegistry setObject:store forKey:storeKey];
    [self subscribeStoreToActions:store];
}

- (void)subscribeStoreToActions:(FLXStore *)store {
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

- (FLXStore *)storeOfClass:(Class)class {
    return [self.storeRegistry objectForKey:NSStringFromClass(class)];
}

- (FLXStore *)temporaryStoreOfClass:(Class)storeClass {
    id instance = [[storeClass alloc] init];
    if([instance isKindOfClass:[FLXStore class]]) {
        FLXStore *store = (FLXStore *)instance;
        [self attachTemporaryStore:store];
        return store;
    }
    return nil;
}

@end
