//
//  FLXSerialExecutorSpec.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/7/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FLXSerialExecutor.h"

@interface FLXSerialExecutor (Testing)
@property (nonatomic, strong) dispatch_queue_t executionQueue;
@end

SPEC_BEGIN(FLXSerialExecutorSpec)

let(sut, ^FLXSerialExecutor *{
    return [[FLXSerialExecutor alloc] init];
});

describe(@"initialization", ^{
    it(@"should create executionQueue", ^{
        [[sut should] beKindOfClass:[FLXSerialExecutor class]];
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
        dispatch_block_t block = ^{
            if(dispatch_get_specific(kTestSpecificKey)) {
                didLaunchBlock = @YES;
            }
        };
        [[didLaunchBlock shouldNotEventually] beNil];
        [sut execute:block];
    });
    
    it(@"Synchronously calls block in execution queue", ^{
        __block BOOL didLaunchBlock;
        dispatch_block_t block = ^{
            if(dispatch_get_specific(kTestSpecificKey)) {
                didLaunchBlock = YES;
            }
        };
        [sut executeAndWait:block];
        [[theValue(didLaunchBlock) should] beTrue];
    });
});

SPEC_END
