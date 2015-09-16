//
// Created by Dmitry on 08.09.15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TEBaseStore.h"
#import "TEPersistentStoreProtocol.h"

@protocol TEPersistenceProtocol <NSObject>

- (void)saveState:(id <NSCoding>)state forStore:(TEBaseStore <TEPersistentStoreProtocol> *)store;
- (id)stateForStore:(TEBaseStore <TEPersistentStoreProtocol> *)store;

@end