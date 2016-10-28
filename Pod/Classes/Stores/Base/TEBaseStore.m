//
//  TEBaseStore.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/9/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "TEBaseStore.h"
#import "TEBaseState.h"
#import "TEBaseAction.h"
#import <libkern/OSAtomic.h>

@interface TEBaseStore () <TEActionRegistry> {
    volatile uint32_t _isLoaded;
}

@property (nonatomic, strong, readwrite) TEBaseState *state;
@property (nonatomic, strong) NSMutableDictionary *actionRegistry;

@end

@implementation TEBaseStore

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if(self) {
        self.state = [self.class defaultState];
        self.actionRegistry = [NSMutableDictionary new];
        [self registerWithLocalDispatcher:self];
    }
    return self;
}

#pragma mark - Abstract methods

- (TEBaseState *)defaultState {
    return [self.class defaultState];
}

+ (TEBaseState *)defaultState {
    [NSException raise:@"Not allowed" format:@"-defaultState method of base class shouldn't be used. Please override it in sublass"];
    return nil;
}

- (void)registerWithLocalDispatcher:(TEStoreDispatcher *)storeDispatcher {

}

#pragma mark - Action handling

- (void)dispatchAction:(TEBaseAction *)action {
    TEActionCallback callback = [self callbackForAction:action];
    if(callback) {
        id newState = callback(action);
        self.state = newState;
    }
}

- (void)onAction:(Class)actionClass callback:(TEActionCallback)callback {
    NSParameterAssert(callback);
    NSParameterAssert(actionClass);
    [self.actionRegistry setObject:callback forKey:NSStringFromClass(actionClass)];
}

- (TEActionCallback)callbackForAction:(TEBaseAction *)action {
    return [self.actionRegistry objectForKey:NSStringFromClass([action class])];
}

- (BOOL)respondsToAction:(TEBaseAction *)action {
    TEActionCallback callback = [self callbackForAction:action];
    return callback != nil;
}

#pragma mark - Thread-safe loaded state

- (BOOL)isLoaded {
    return _isLoaded != 0;
}

- (void)setIsLoaded:(BOOL)isLoaded {
    [self willChangeValueForKey:@"isLoaded"];
    if (isLoaded) {
        OSAtomicOr32Barrier(1, & _isLoaded);
    } else {
        OSAtomicAnd32Barrier(0, & _isLoaded);
    }
    [self didChangeValueForKey:@"isLoaded"];
}

+ (BOOL)automaticallyNotifiesObserversOfIsLoaded {
    return NO;
}

@end
