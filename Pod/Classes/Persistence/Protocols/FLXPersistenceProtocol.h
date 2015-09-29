//
// Created by Dmitry on 08.09.15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLXBaseStore.h"
#import "FLXPersistentStoreProtocol.h"

@protocol FLXPersistenceProtocol <NSObject>

- (void)saveState:(id <NSCoding>)state forStore:(FLXBaseStore <FLXPersistentStoreProtocol> *)store;
- (id)stateForStore:(FLXBaseStore <FLXPersistentStoreProtocol> *)store;

@end