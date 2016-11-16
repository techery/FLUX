//
//  FLXDispatcher.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/4/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "FLXDispatcher.h"
#import "FLXStore.h"
#import "FLXMiddleware.h"

@interface FLXDispatcher ()

@property (nonatomic, strong) NSPointerArray *stores;
@property (nonatomic, strong) NSArray <id<FLXMiddleware>> *middlewares;

@end

@implementation FLXDispatcher

+ (instancetype)dispatcherWithMiddlewares:(NSArray <id<FLXMiddleware>> *)middlewares {
    return [[self alloc] initWithMiddlewares:middlewares];
}

- (instancetype)initWithMiddlewares:(NSArray <id<FLXMiddleware>> *)middlewares {
    self = [super init];
    if(self) {
        self.stores = [NSPointerArray weakObjectsPointerArray];
        self.middlewares = middlewares;
    }
    return self;
}

- (instancetype)init {
    return [self initWithMiddlewares:nil];
}

- (void)registerStore:(FLXStore *)store {
    NSParameterAssert([store isKindOfClass:[FLXStore class]]);
    [self.stores addPointer:(__bridge void *)store];
    [self notifyMiddlewareAboutStoreRegistration:store];
}

- (void)dispatchAction:(id)action {
    [self notifyMiddlewareWithAction:action];
    for(FLXStore *store in self.stores) {
        if([store respondsToAction:action]) {
            [store dispatchAction:action];
            [self notifyMiddlewareAboutStateChangeOfStore:store];
        }
    }
}

- (void)notifyMiddlewareWithAction:(id)action {
    for (id <FLXMiddleware> middleware in self.middlewares) {
        [middleware didDispatchAction:action];
    }
}

- (void)notifyMiddlewareAboutStoreRegistration:(FLXStore *)store {
    for (id <FLXMiddleware> middleware in self.middlewares) {
        [middleware didRegisterStore:store];
    }
}

- (void)notifyMiddlewareAboutStateChangeOfStore:(FLXStore *)store {
    for (id <FLXMiddleware> middleware in self.middlewares) {
        [middleware store:store didChangeState:store.state];
    }
}

@end
