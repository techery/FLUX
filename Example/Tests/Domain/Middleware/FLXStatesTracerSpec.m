//
//  FLXStatesTracerSpec.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/14/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FLXStatesTracer.h"
#import "FLXBaseStore.h"
#import "FLXFakeStore.h"

@interface FLXStatesTracer (Testing)

@property (nonatomic, strong) NSMutableDictionary *traces;

- (FLXStoreStateNode *)nodeWithStore:(FLXBaseStore *)store
                              state:(FLXBaseState *)state;
- (NSMutableArray *)obtainOrCreateTracesStackForStore:(FLXBaseStore *)store;

@end

SPEC_BEGIN(FLXStatesTracerSpec)

FLXStatesTracer __block *sut;

beforeEach(^{
    sut = [[FLXStatesTracer alloc] init];
});

afterEach(^{
    sut = nil;
});

describe(@"initialization", ^{
    
    it(@"should return tracer", ^{
        [[sut shouldNot] beNil];
        [[sut should] beKindOfClass:[FLXStatesTracer class]];
    });
    
    it(@"should create emtpy traces array", ^{
        [[sut.traces shouldNot] beNil];
        [[sut.traces.allKeys should] beEmpty];
    });
    
    it(@"should be able to track store registration", ^{
        [[sut should] conformToProtocol:@protocol(FLXDomainMiddleware)];
        [[sut should] respondToSelector:@selector(onStoreRegistration:)];
    });
});

describe(@"state observing", ^{
    
    id __block nodeMock;
    FLXFakeStore __block *storeMock;
    id __block stateMock;
    
    beforeEach(^{
        nodeMock = [KWMock mockForClass:[FLXStoreStateNode class]];
        storeMock = [FLXFakeStore new];
        stateMock = storeMock.state;
    });
    
    afterEach(^{
        nodeMock = nil;
        storeMock = nil;
        stateMock = nil;
    });
    
    it(@"should observe all stores", ^{
        BOOL shouldObserveStore = [sut shouldObserveStore:storeMock];
        [[theValue(shouldObserveStore) should] beTrue];
    });
    
    it(@"should save node in traces on state change", ^{
        NSMutableArray *stack = [@[] mutableCopy];
        [[sut should] receive:@selector(nodeWithStore:state:) andReturn:nodeMock withArguments:storeMock, stateMock];
        [[sut should] receive:@selector(obtainOrCreateTracesStackForStore:) andReturn:stack withArguments:storeMock];
        [sut store:storeMock didChangeState:stateMock];
        
        [[stack should] contain:nodeMock];
    });
    
    it(@"should get trace for current store if exists", ^{
        
        NSMutableArray *stackMock = [@[] mutableCopy];
        sut.traces = [@{@"FLXFakeStore" : stackMock} mutableCopy];
        
        id stack = [sut obtainOrCreateTracesStackForStore:storeMock];
        [[stack should] equal:stackMock];
    });
    
    it(@"should create trace for current store if not exists", ^{
        
        sut.traces = [@{} mutableCopy];
        id stack = [sut obtainOrCreateTracesStackForStore:storeMock];
        
        [[stack shouldNot] beNil];
        [[stack should] beKindOfClass:[NSMutableArray class]];
        [[sut.traces.allValues should] contain:stack];
    });
    
    it(@"should create node for state", ^{
        
        id builderMock = [KWMock mockForClass:[FLXStoreStateNodeBuilder class]];
        
        [[builderMock should] receive:@selector(setCreatedAt:)];
        [[builderMock should] receive:@selector(setStoreClassString:) withArguments:@"FLXFakeStore"];
        [[builderMock should] receive:@selector(setState:) withArguments:stateMock];
        
        [FLXStoreStateNode stub:@selector(create:) withBlock:^id(NSArray *params) {
            
            void(^block)(FLXStoreStateNodeBuilder *builder) = params[0];
            
            block(builderMock);
            return nodeMock;
        }];
        
        id node = [sut nodeWithStore:storeMock state:stateMock];
        [[node should] equal:nodeMock];
    });
});

describe(@"traces interface", ^{
    
    it(@"should return trace for store class", ^{
        NSMutableArray *stackMock = [@[] mutableCopy];
        sut.traces = [@{@"FLXFakeStore" : stackMock} mutableCopy];
        
        id trace = [sut statesTraceForStoreClass:[FLXFakeStore class]];
        [[trace should] equal:stackMock];
    });
    
    it(@"should return trace for store object", ^{
        
        FLXFakeStore *storeMock = [FLXFakeStore new];
        
        NSMutableArray *stackMock = [@[] mutableCopy];
        sut.traces = [@{@"FLXFakeStore" : stackMock} mutableCopy];
        
        id trace = [sut statesTraceForStore:storeMock];
        [[trace should] equal:stackMock];
    });
    
});




SPEC_END