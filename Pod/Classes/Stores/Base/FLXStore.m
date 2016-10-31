//
//  FLXStore.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/9/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "FLXStore.h"
#import <libkern/OSAtomic.h>

@interface FLXStore () {
    volatile uint32_t _isLoaded;
}

@property (nonatomic, strong, readwrite) id state;
@property (nonatomic, strong) NSMutableDictionary *actionRegistry;

@end

@implementation FLXStore

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if(self) {
        self.state = [self.class defaultState];
        self.actionRegistry = [NSMutableDictionary new];
    }
    return self;
}

#pragma mark - Abstract methods

- (id)defaultState {
    return [self.class defaultState];
}

+ (id)defaultState {
    [NSException raise:@"Not allowed" format:@"-defaultState method of base class shouldn't be used. Please override it in sublass"];
    return nil;
}

#pragma mark - Action handling

- (void)dispatchAction:(id)action {
    FLXActionCallback callback = [self callbackForAction:action];
    if(callback) {
        id newState = callback(action);
        self.state = newState;
    }
}

- (void)onAction:(Class)actionClass callback:(FLXActionCallback)callback {
    NSParameterAssert(callback);
    NSParameterAssert(actionClass);
    [self.actionRegistry setObject:callback forKey:NSStringFromClass(actionClass)];
}

- (FLXActionCallback)callbackForAction:(id)action {
    return [self.actionRegistry objectForKey:NSStringFromClass([action class])];
}

- (BOOL)respondsToAction:(id)action {
    FLXActionCallback callback = [self callbackForAction:action];
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
