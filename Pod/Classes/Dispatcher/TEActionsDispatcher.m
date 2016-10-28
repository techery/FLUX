//
//  TEActionsDispatcher.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/4/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "TEActionsDispatcher.h"
#import "TEBaseAction.h"
#import "TEBaseStore.h"
#import "TEDomainMiddleware.h"

@interface TEActionsDispatcher ()

@property (nonatomic, strong) NSPointerArray *stores;
@property (nonatomic, strong) NSArray <id<TEDomainMiddleware>> *middlewares;

@end

@implementation TEActionsDispatcher

+ (instancetype)dispatcherWithMiddlewares:(NSArray <id<TEDomainMiddleware>> *)middlewares {
    return [[self alloc] initWithMiddlewares:middlewares];
}

- (instancetype)initWithMiddlewares:(NSArray <id<TEDomainMiddleware>> *)middlewares {
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

- (void)registerStore:(TEBaseStore *)store {
    NSParameterAssert([store isKindOfClass:[TEBaseStore class]]);
    [self.stores addPointer:(__bridge void *)store];
    [self notifyMiddlewareAboutStoreRegistration:store];
}

- (void)dispatchAction:(TEBaseAction *)action {
    [self notifyMiddlewareWithAction:action];
    for(TEBaseStore *store in self.stores) {
        if([store respondsToAction:action]) {
            [store dispatchAction:action];
            [self notifyMiddlewareWithState:store.state ofStore:store];
        }
    }
}

- (void)notifyMiddlewareWithAction:(TEBaseAction *)action {
    for (id <TEDomainMiddleware> middleware in self.middlewares) {
        [middleware onActionDispatching:action];
    }
}

- (void)notifyMiddlewareAboutStoreRegistration:(TEBaseStore *)store {
    for (id <TEDomainMiddleware> middleware in self.middlewares) {
        [middleware onStoreRegistration:store];
    }
}

- (void)notifyMiddlewareWithState:(TEBaseState *)state ofStore:(TEBaseStore *)store {
    for (id <TEDomainMiddleware> middleware in self.middlewares) {
        [middleware store:store didChangeState:store.state];
    }
}

@end
