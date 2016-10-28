//
//  TETestExecutor.m
//  FLUX
//
//  Created by Alex Faizullov on 10/28/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TETestExecutor.h"
#import <FLUX/TEExecutor.h>

@implementation TETestExecutor

- (void)execute:(TEExecutorEmptyBlock)block {
    if(block) {
        block();
    }
}

- (void)executeAndWait:(TEExecutorEmptyBlock)block {
    if(block) {
        block();
    }
}

@end
