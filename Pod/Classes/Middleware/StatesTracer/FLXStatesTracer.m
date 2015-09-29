//
//  FLXStoreStateStack.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/10/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "FLXMiddlewareModels.h"
#import "FLXStatesTracer.h"
#import "FLXBaseStore.h"

@interface FLXStatesTracer ()

@property (nonatomic, strong) NSMutableDictionary *traces;

@end

@implementation FLXStatesTracer

- (instancetype)init {
    
    self = [super init];
    if(self) {
        self.traces = [@{} mutableCopy];
    }
    return self;
}

- (void)store:(FLXBaseStore *)store didChangeState:(id)state {
    FLXStoreStateNode *stateNode = [self nodeWithStore:store state:state];
    NSMutableArray *storeStack = [self obtainOrCreateTracesStackForStore:store];
    [storeStack addObject:stateNode];
    NSLog(@">State change of %@: \n     %@", [store description], [state description]);
}

- (NSMutableArray *)obtainOrCreateTracesStackForStore:(FLXBaseStore *)store
{
    NSString *storeKey = NSStringFromClass([store class]);
    NSMutableArray *storeStack = [self.traces objectForKey:storeKey];
    if(!storeStack) {
        storeStack = [@[] mutableCopy];
        [self.traces setObject:storeStack forKey:storeKey];
    }
    return storeStack;
}

- (FLXStoreStateNode *)nodeWithStore:(FLXBaseStore *)store state:(id)state
{
    return [FLXStoreStateNode create:^(FLXStoreStateNodeBuilder *builder) {
        builder.createdAt = [NSDate date];
        builder.storeClassString = NSStringFromClass([store class]);
        builder.state = state;
    }];
}

- (NSArray *)statesTraceForStoreClass:(Class)storeClass
{
    return [self.traces objectForKey:NSStringFromClass(storeClass)];
}

- (NSArray *)statesTraceForStore:(FLXBaseStore *)store
{
    return [self statesTraceForStoreClass:[store class]];
}

- (BOOL)shouldObserveStore:(FLXBaseStore *)store
{
    return YES;
}

@end
