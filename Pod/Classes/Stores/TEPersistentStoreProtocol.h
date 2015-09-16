//
// Created by Dmitry on 08.09.15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TEPersistentStoreProtocol

- (BOOL)shouldSaveState:(id)state;
- (BOOL)shouldRestoreState:(id)state;

@end