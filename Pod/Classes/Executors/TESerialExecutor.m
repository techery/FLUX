//
//  TEConcurrentExecutor.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/6/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "TESerialExecutor.h"

@interface TESerialExecutor ()

@property (nonatomic, strong) dispatch_queue_t executionQueue;

@end

@implementation TESerialExecutor

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self setupExecutionQueue];
    }
    return self;
}

- (void)setupExecutionQueue
{
    self.executionQueue = dispatch_queue_create([self serviceId].UTF8String, DISPATCH_QUEUE_SERIAL);
}

- (void)execute:(TEExecutorEmptyBlock)block
{
    NSParameterAssert(block);
    dispatch_async(self.executionQueue, block);
}

- (NSString *)serviceId
{
    return [NSString stringWithFormat:@"%@.%@.%p", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"], NSStringFromClass([self class]), self];
}

@end
