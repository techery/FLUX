//
//  FLXTestExecutor.m
//  FLUX
//
//  Created by Alex Faizullov on 10/28/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "FLXTestExecutor.h"

@implementation FLXTestExecutor

- (void)execute:(dispatch_block_t)block {
    if(block) {
        block();
    }
}

- (void)executeAndWait:(dispatch_block_t)block {
    if(block) {
        block();
    }
}

@end
