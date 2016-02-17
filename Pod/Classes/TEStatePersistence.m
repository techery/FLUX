//
// Created by Dmitry on 09.09.15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "TEStatePersistence.h"
#import "TEPersistentStoreProtocol.h"
#import "TEFileSystemPersistentProvider.h"
#import "TEBaseStore.h"
#import "TEBaseState.h"

@interface TEStatePersistence ()

@property (nonatomic, strong) TEFileSystemPersistentProvider *persistence;

- (void)restoreState:(id)state ofStore:(TEBaseStore <TEPersistentStoreProtocol> *)store;

@end

@implementation TEStatePersistence

- (instancetype)init {
    self = [super init];
    if (self) {
        self.persistence = [TEFileSystemPersistentProvider new];
    }
    return self;
}

- (void)restoreState:(id)state ofStore:(TEBaseStore <TEPersistentStoreProtocol> *)store {
    if(state) {
        if(![store.state isEqual:state]) {
            [store setValue:state forKey:@keypath(store.state)];
        }
    }
}

- (void)setupStore:(TEBaseStore *)store {
    TEBaseStore <TEPersistentStoreProtocol>*castedStore = (TEBaseStore <TEPersistentStoreProtocol>*)store;
    id state = [self.persistence stateForStore:castedStore];
    if ([castedStore shouldRestoreState:state]) {
        [self restoreState:state ofStore:castedStore];
    }
    store.isLoaded = YES;
}

- (BOOL)shouldObserveStore:(TEBaseStore *)store {
    return [store conformsToProtocol:@protocol(TEPersistentStoreProtocol)];
}

- (void)store:(TEBaseStore *)store didChangeState:(TEBaseState *)state {
    TEBaseStore <TEPersistentStoreProtocol> *castedStore = (TEBaseStore <TEPersistentStoreProtocol>*)store;
    if ([castedStore shouldSaveState:state]) {
        [self.persistence saveState:state forStore:castedStore];
    }
}

@end