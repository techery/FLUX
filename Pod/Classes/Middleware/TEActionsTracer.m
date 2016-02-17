//
//  TEActionsStackMiddleware.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/10/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "TEActionsTracer.h"
#import "TEMiddlewareModels.h"

@interface TEActionsTracer ()

@property (nonatomic, strong, readwrite) NSMutableArray *trace;

@end

@implementation TEActionsTracer

- (instancetype)init {
    self = [super init];
    if(self) {
        self.trace = [@[] mutableCopy];
    }
    return self;
}

- (void)onActionDispatching:(TEBaseAction *)action {
    
    TEActionStackNode *node = [self nodeFromAction:action];
    [self.trace addObject:node];
}

- (TEActionStackNode *)nodeFromAction:(TEBaseAction *)action
{
    return [TEActionStackNode create:^(TEActionStackNodeBuilder *builder) {
        builder.createdAt = [NSDate date];
        builder.action = action;
    }];
}

@end
