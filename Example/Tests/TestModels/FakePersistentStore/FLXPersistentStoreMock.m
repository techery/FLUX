//
//  FLXPersistentStoreMock.m
//  MasterApp
//
//  Created by Dmitry on 16.09.15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "FLXPersistentStoreMock.h"

@implementation FLXPersistentStoreMock

- (BOOL)shouldSaveState:(id)state {
    return YES;
}

- (BOOL)shouldRestoreState:(id)state {
    return YES;
}

@end
