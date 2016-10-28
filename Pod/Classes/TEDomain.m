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

@property (nonatomic, strong) NSMutableDictionary <NSString *, TEBaseStore *>*stores;
@property (nonatomic, strong) NSArray <id<TEDomainMiddleware>> *middlewares;

@end

@implementation TEDomain

- (instancetype)init {
    return [self initWithExecutor:[self createExecutor] middlewares:[self createMiddlewares]];
}

- (instancetype)initWithExecutor:(id<TEExecutor>)executor
                     middlewares:(NSArray <id<TEDomainMiddleware>> *)middlewares {
    self = [super init];
    if(self) {
        self.executor = executor;
        self.middlewares = middlewares;
        self.dispatcher = [TEActionsDispatcher dispatcherWithMiddlewares:self.middlewares];
        self.stores = [@{} mutableCopy];
        [self setup];
    }
    return self;
}

- (id<TEExecutor>)createExecutor {
    return [[TESerialExecutor alloc] init];
}

- (NSArray*)createMiddlewares {
    return @[];
}

- (void)setup {
    [NSException raise:@"Not allowed" format:@"-setup method of base class shouldn't be used. Please override it in sublass"];
}

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
    __weak typeof(self) weakSelf = self;
    [self.executor execute:^{
        [weakSelf.dispatcher registerStore:store];
    }];
}

- (TEBaseStore *)getStoreByClass:(Class)class {
    return [self.stores objectForKey:NSStringFromClass(class)];
}

@end
