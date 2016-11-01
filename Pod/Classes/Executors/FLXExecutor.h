//
//  FLXExecutor.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/4/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Provides an interface for wrapping GCD or NSOperation queue that will be used for processing actions.
 */
@protocol FLXExecutor <NSObject>

/**
 Asynchronously executes a block and returns control to caller

 @param block task to be executed
 */
- (void)execute:(dispatch_block_t)block;


/**
 Synchronously executes a block

 @param block task to be executed
 */
- (void)executeAndWait:(dispatch_block_t)block;

@end
