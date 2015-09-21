//
//  FLXActionsStackMiddleware.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/10/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "FLXActionsTracer.h"
#import "FLXMiddlewareModels.h"

@interface FLXActionsTracer ()

@property (nonatomic, strong, readwrite) NSMutableArray *trace;

@end

@implementation FLXActionsTracer

- (instancetype)init {
    self = [super init];
    if(self) {
        self.trace = [@[] mutableCopy];
    }
    return self;
}

- (void)onActionDispatching:(FLXBaseAction *)action {
    
    FLXActionStackNode *node = [self nodeFromAction:action];
    [self.trace addObject:node];
    NSLog(@">Action: %@", [action description]);
}

- (FLXActionStackNode *)nodeFromAction:(FLXBaseAction *)action
{
    return [FLXActionStackNode create:^(FLXActionStackNodeBuilder *builder) {
        builder.createdAt = [NSDate date];
        builder.action = action;
    }];
}

@end
