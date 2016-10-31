//
//  FLXExecutor.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/4/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FLXExecutor <NSObject>

- (void)execute:(dispatch_block_t)block;
- (void)executeAndWait:(dispatch_block_t)block;

@end
