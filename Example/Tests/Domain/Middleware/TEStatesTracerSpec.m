//
//  TEStatesTracerSpec.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/14/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TEStatesTracer.h"
#import "TEBaseStore.h"
#import "TEFakeStore.h"

@interface TEStatesTracer (Testing)

@property (nonatomic, strong) NSMutableDictionary *traces;

- (TEStoreStateNode *)nodeWithStore:(TEBaseStore *)store
                              state:(TEBaseState *)state;
- (NSMutableArray *)obtainOrCreateTracesStackForStore:(TEBaseStore *)store;

@end

SPEC_BEGIN(TEStatesTracerSpec)

TEStatesTracer __block *sut;

beforeEach(^{
    sut = [[TEStatesTracer alloc] init];
});

afterEach(^{
    sut = nil;
});

describe(@"initialization", ^{
    
    it(@"should return tracer", ^{
        [[sut shouldNot] beNil];
        [[sut should] beKindOfClass:[TEStatesTracer class]];
    });
    
    it(@"should create emtpy traces array", ^{
        [[sut.traces shouldNot] beNil];
        [[sut.traces.allKeys should] beEmpty];
    });
    
    it(@"should be able to track store registration", ^{
        [[sut should] conformToProtocol:@protocol(TEDomainMiddleware)];
        [[sut should] respondToSelector:@selector(onStoreRegistration:)];
    });
});

describe(@"state observing", ^{
    
    id __block nodeMock;
    TEFakeStore __block *storeMock;
    id __block stateMock;
    
    beforeEach(^{
        nodeMock = [KWMock mockForClass:[TEStoreStateNode class]];
        storeMock = [TEFakeStore new];
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
        sut.traces = [@{@"TEFakeStore" : stackMock} mutableCopy];
        
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
        
        id builderMock = [KWMock mockForClass:[TEStoreStateNodeBuilder class]];
        
        [[builderMock should] receive:@selector(setCreatedAt:)];
        [[builderMock should] receive:@selector(setStoreClassString:) withArguments:@"TEFakeStore"];
        [[builderMock should] receive:@selector(setState:) withArguments:stateMock];
        
        [TEStoreStateNode stub:@selector(create:) withBlock:^id(NSArray *params) {
            
            void(^block)(TEStoreStateNodeBuilder *builder) = params[0];
            
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
        sut.traces = [@{@"TEFakeStore" : stackMock} mutableCopy];
        
        id trace = [sut statesTraceForStoreClass:[TEFakeStore class]];
        [[trace should] equal:stackMock];
    });
    
    it(@"should return trace for store object", ^{
        
        TEFakeStore *storeMock = [TEFakeStore new];
        
        NSMutableArray *stackMock = [@[] mutableCopy];
        sut.traces = [@{@"TEFakeStore" : stackMock} mutableCopy];
        
        id trace = [sut statesTraceForStore:storeMock];
        [[trace should] equal:stackMock];
    });
    
});




SPEC_END