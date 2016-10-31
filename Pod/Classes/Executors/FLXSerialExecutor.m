//
//  TEConcurrentExecutor.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/6/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "FLXSerialExecutor.h"

@interface FLXSerialExecutor ()

@property (nonatomic, strong) dispatch_queue_t executionQueue;

@end

@implementation FLXSerialExecutor

- (instancetype)init {
    self = [super init];
    if(self) {
        [self setupExecutionQueue];
    }
    return self;
}

- (void)setupExecutionQueue {
    self.executionQueue = dispatch_queue_create([self serviceId].UTF8String, DISPATCH_QUEUE_SERIAL);
}

- (void)execute:(dispatch_block_t)block {
    NSParameterAssert(block);
    dispatch_async(self.executionQueue, block);
}

- (void)executeAndWait:(dispatch_block_t)block {
    NSParameterAssert(block);
    dispatch_sync(self.executionQueue, block);
}

- (NSString *)serviceId {
    return [NSString stringWithFormat:@"%@.%@.%p", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"], NSStringFromClass([self class]), self];
}

@end
