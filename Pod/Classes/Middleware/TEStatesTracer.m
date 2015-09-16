//
//  TEStoreStateStack.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/10/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "TEMiddlewareModels.h"
#import "TEStatesTracer.h"
#import "TEBaseStore.h"

@interface TEStatesTracer ()

@property (nonatomic, strong) NSMutableDictionary *traces;

@end

@implementation TEStatesTracer

- (instancetype)init {
    
    self = [super init];
    if(self) {
        self.traces = [@{} mutableCopy];
    }
    return self;
}

- (void)store:(TEBaseStore *)store didChangeState:(TEBaseState *)state {
    TEStoreStateNode *stateNode = [self nodeWithStore:store state:state];
    NSMutableArray *storeStack = [self obtainOrCreateTracesStackForStore:store];
    [storeStack addObject:stateNode];
    NSLog(@">State change of %@: \n     %@", [store description], [state description]);
}

- (NSMutableArray *)obtainOrCreateTracesStackForStore:(TEBaseStore *)store
{
    NSString *storeKey = NSStringFromClass([store class]);
    NSMutableArray *storeStack = [self.traces objectForKey:storeKey];
    if(!storeStack) {
        storeStack = [@[] mutableCopy];
        [self.traces setObject:storeStack forKey:storeKey];
    }
    return storeStack;
}

- (TEStoreStateNode *)nodeWithStore:(TEBaseStore *)store state:(TEBaseState *)state
{
    return [TEStoreStateNode create:^(TEStoreStateNodeBuilder *builder) {
        builder.createdAt = [NSDate date];
        builder.storeClassString = NSStringFromClass([store class]);
        builder.state = state;
    }];
}

- (NSArray *)statesTraceForStoreClass:(Class)storeClass
{
    return [self.traces objectForKey:NSStringFromClass(storeClass)];
}

- (NSArray *)statesTraceForStore:(TEBaseStore *)store
{
    return [self statesTraceForStoreClass:[store class]];
}

- (BOOL)shouldObserveStore:(TEBaseStore *)store
{
    return YES;
}

@end
