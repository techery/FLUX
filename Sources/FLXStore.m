//
//  FLXStore.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/9/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "FLXStore.h"
#import <libkern/OSAtomic.h>

@interface FLXStore ()

@property (nonatomic, readwrite) FLXStoreIdentifier identifier;
@property (nonatomic, strong, readwrite) id state;
@property (nonatomic, strong) NSMutableDictionary *actionRegistry;

@end

@implementation FLXStore

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if(self) {
        self.identifier = NSStringFromClass(self.class);
        self.state = [self.class defaultState];
        self.actionRegistry = [NSMutableDictionary new];
        [self subscribeToActions];
    }
    return self;
}

#pragma mark - Abstract methods

- (void)subscribeToActions {
    // Does nothing in default implementation
}

- (id)defaultState {
    return [self.class defaultState];
}

+ (id)defaultState {
    [NSException raise:@"Not allowed" format:@"-defaultState method of base class shouldn't be used. Please override it in sublass"];
    return nil;
}

#pragma mark - Action handling

- (void)dispatchAction:(id)action {
    FLXActionCallback callback = [self callbackForActionClass:[action class]];
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

- (BOOL)respondsToAction:(id)action {
    return [self respondsToActionClass:[action class]];
}

- (BOOL)respondsToActionClass:(Class)actionClass {
    FLXActionCallback callback = [self callbackForActionClass:actionClass];
    return callback != nil;
}

- (FLXActionCallback)callbackForActionClass:(Class)actionClass {
    return [self.actionRegistry objectForKey:NSStringFromClass(actionClass)];
}

@end
