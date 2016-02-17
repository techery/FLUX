//
// Created by Dmitry on 08.09.15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TEPersistenceProtocol.h"

@interface TEFileSystemPersistentProvider : NSObject <TEPersistenceProtocol>

- (instancetype)initWithFileManager:(NSFileManager *)fileManager;

- (instancetype)init __attribute__((unavailable("Use initWithFileManager: instead")));

@end