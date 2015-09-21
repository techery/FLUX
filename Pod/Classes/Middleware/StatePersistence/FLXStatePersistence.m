//
// Created by Dmitry on 09.09.15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "FLXStatePersistence.h"
#import "FLXPersistentStoreProtocol.h"
#import "FLXFileSystemPersistentProvider.h"
#import "FLXBaseStore.h"
#import "FLXBaseState.h"

@interface FLXStatePersistence ()

@property (nonatomic, strong) FLXFileSystemPersistentProvider *persistence;

- (void)restoreState:(id)state ofStore:(FLXBaseStore <FLXPersistentStoreProtocol> *)store;

@end

@implementation FLXStatePersistence

- (instancetype)init {
    self = [super init];
    if (self) {
        self.persistence = [FLXFileSystemPersistentProvider new];
    }
    return self;
}

- (void)restoreState:(id)state ofStore:(FLXBaseStore <FLXPersistentStoreProtocol> *)store {
    if(state) {
        if(![store.state isEqual:state]) {
            NSLog(@"Restored from persistence: %@", [state performSelector:@selector(description)]);
            [store setValue:state forKey:@keypath(store.state)];
        }
    }
}

- (void)setupStore:(FLXBaseStore *)store {
    FLXBaseStore <FLXPersistentStoreProtocol>*castedStore = (FLXBaseStore <FLXPersistentStoreProtocol>*)store;
    id state = [self.persistence stateForStore:castedStore];
    if ([castedStore shouldRestoreState:state]) {
        [self restoreState:state ofStore:castedStore];
    }
}

- (BOOL)shouldObserveStore:(FLXBaseStore *)store {
    return [store conformsToProtocol:@protocol(FLXPersistentStoreProtocol)];
}

- (void)store:(FLXBaseStore *)store didChangeState:(FLXBaseState *)state {
    FLXBaseStore <FLXPersistentStoreProtocol> *castedStore = (FLXBaseStore <FLXPersistentStoreProtocol>*)store;
    if ([castedStore shouldSaveState:state]) {
        [self.persistence saveState:state forStore:castedStore];
    }
}

@end