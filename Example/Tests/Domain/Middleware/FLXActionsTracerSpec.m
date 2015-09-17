//
//  FLXActionsTracerSpec.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/14/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FLXActionsTracer.h"
#import "FLXMiddlewareModels.h"

@interface FLXActionsTracer (Testing)

- (FLXActionStackNode *)nodeFromAction:(FLXBaseAction *)action;

@end

SPEC_BEGIN(FLXActionsTracerSpec)

FLXActionsTracer __block *sut;

beforeEach(^{
    sut = [[FLXActionsTracer alloc] init];
});

afterEach(^{
    sut = nil;
});

describe(@"initialization", ^{
    
    it(@"should return tracer", ^{
        [[sut shouldNot] beNil];
        [[sut should] beKindOfClass:[FLXActionsTracer class]];
    });
    
    it(@"should create emtpy trace array", ^{
        [[sut.trace shouldNot] beNil];
        [[sut.trace should] beEmpty];
    });
    
    it(@"should be able to track actions", ^{
        [[sut should] conformToProtocol:@protocol(FLXDomainMiddleware)];
        [[sut should] respondToSelector:@selector(onActionDispatching:)];
    });
});

describe(@"actions tracking", ^{
    
    it(@"should create and save action node", ^{
        
        id nodeMock = [KWMock mockForClass:[FLXActionStackNode class]];
        id actionMock = [KWMock mockForClass:[FLXBaseAction class]];
        [[sut should] receive:@selector(nodeFromAction:) andReturn:nodeMock withArguments:actionMock];
        [sut onActionDispatching:actionMock];
        [[sut.trace should] contain:nodeMock];
    });
    
    it(@"should create node from action", ^{
    
        id actionMock = [KWMock mockForClass:[FLXBaseAction class]];
        id nodeMock = [KWMock mockForClass:[FLXActionStackNode class]];
        id builderMock = [KWMock mockForClass:[FLXActionStackNodeBuilder class]];
        
        [[builderMock should] receive:@selector(setCreatedAt:)];
        [[builderMock should] receive:@selector(setAction:) withArguments:actionMock];
        
        [FLXActionStackNode stub:@selector(create:) withBlock:^id(NSArray *params) {
            
            void(^block)(FLXActionStackNodeBuilder *builder) = params[0];
            block(builderMock);
            return nodeMock;
        }];
        
        id node = [sut nodeFromAction:actionMock];
        [[node should] equal:nodeMock];
    });
    
});



SPEC_END