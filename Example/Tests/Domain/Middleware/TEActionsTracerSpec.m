//
//  TEActionsTracerSpec.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/14/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TEActionsTracer.h"
#import "TEMiddlewareModels.h"

@interface TEActionsTracer (Testing)

- (TEActionStackNode *)nodeFromAction:(TEBaseAction *)action;

@end

SPEC_BEGIN(TEActionsTracerSpec)

TEActionsTracer __block *sut;

beforeEach(^{
    sut = [[TEActionsTracer alloc] init];
});

afterEach(^{
    sut = nil;
});

describe(@"initialization", ^{
    
    it(@"should return tracer", ^{
        [[sut shouldNot] beNil];
        [[sut should] beKindOfClass:[TEActionsTracer class]];
    });
    
    it(@"should create emtpy trace array", ^{
        [[sut.trace shouldNot] beNil];
        [[sut.trace should] beEmpty];
    });
    
    it(@"should be able to track actions", ^{
        [[sut should] conformToProtocol:@protocol(TEDomainMiddleware)];
        [[sut should] respondToSelector:@selector(onActionDispatching:)];
    });
});

describe(@"actions tracking", ^{
    
    it(@"should create and save action node", ^{
        
        id nodeMock = [KWMock mockForClass:[TEActionStackNode class]];
        id actionMock = [KWMock mockForClass:[TEBaseAction class]];
        [[sut should] receive:@selector(nodeFromAction:) andReturn:nodeMock withArguments:actionMock];
        [sut onActionDispatching:actionMock];
        [[sut.trace should] contain:nodeMock];
    });
    
    it(@"should create node from action", ^{
    
        id actionMock = [KWMock mockForClass:[TEBaseAction class]];
        id nodeMock = [KWMock mockForClass:[TEActionStackNode class]];
        id builderMock = [KWMock mockForClass:[TEActionStackNodeBuilder class]];
        
        [[builderMock should] receive:@selector(setCreatedAt:)];
        [[builderMock should] receive:@selector(setAction:) withArguments:actionMock];
        
        [TEActionStackNode stub:@selector(create:) withBlock:^id(NSArray *params) {
            
            void(^block)(TEActionStackNodeBuilder *builder) = params[0];
            block(builderMock);
            return nodeMock;
        }];
        
        id node = [sut nodeFromAction:actionMock];
        [[node should] equal:nodeMock];
    });
    
});



SPEC_END