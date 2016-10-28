//
//  TESerialExecutorSpec.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/7/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TESerialExecutor.h"

@interface TESerialExecutor (Testing)
@property (nonatomic, strong) dispatch_queue_t executionQueue;
@end

SPEC_BEGIN(TESerialExecutorSpec)

let(sut, ^TESerialExecutor *{
    return [[TESerialExecutor alloc] init];
});

describe(@"initialization", ^{
    it(@"should create executionQueue", ^{
        [[sut should] beKindOfClass:[TESerialExecutor class]];
        [[sut.executionQueue shouldNot] beNil];
    });
});

describe(@"execute", ^{
    static void *kTestSpecificKey = (void*)"kTestSpecificKey";
    beforeEach(^{
        dispatch_queue_set_specific(sut.executionQueue, kTestSpecificKey, (void *)kTestSpecificKey, NULL);
    });
    
    it(@"Calls block in execution queue", ^{
        __block NSNumber *didLaunchBlock;
        TEExecutorEmptyBlock block = ^{
            if(dispatch_get_specific(kTestSpecificKey)) {
                didLaunchBlock = @YES;
            }
        };
        [[didLaunchBlock shouldNotEventually] beNil];
        [sut execute:block];
    });
    
    it(@"Synchronously calls block in execution queue", ^{
        __block BOOL didLaunchBlock;
        TEExecutorEmptyBlock block = ^{
            if(dispatch_get_specific(kTestSpecificKey)) {
                didLaunchBlock = YES;
            }
        };
        [sut executeAndWait:block];
        [[theValue(didLaunchBlock) should] beTrue];
    });
    
    #ifndef DNS_BLOCK_ASSERTIONS
    it(@"Should throw if no block passed to sync execution", ^{
        [[theBlock(^{
            [sut executeAndWait:nil];
        }) should] raise];
    });
    
    it(@"Should throw if no block passed to async execution", ^{
        [[theBlock(^{
            [sut execute:nil];
        }) should] raise];;
    });
    #endif
});

SPEC_END
