//
//  FLXStoreSpec.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/10/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "FLXStore.h"

SPEC_BEGIN(FLXStoreSpec)

describe(@"Initialization", ^{
    it(@"Sets default state", ^{
        id stateMock = [NSObject new];
        [FLXStore stub:@selector(defaultState) andReturn:stateMock];
        FLXStore *localSut = [[FLXStore alloc] init];
        [[localSut.state should] equal:stateMock];
    });
});

describe(@"default state", ^{
    it(@"should raise an exception", ^{
        [[theBlock(^{
            [FLXStore defaultState];
        }) should] raise];
    });
    
    it(@"has backward compatibility", ^{
        [[FLXStore should] receive:@selector(defaultState)
                            andReturn:[NSObject new]];
        __unused FLXStore *localSut = [[FLXStore alloc] init];
    });
});

describe(@"Action handling", ^{
    __block FLXStore *sut;
    
    beforeEach(^{
        [FLXStore stub:@selector(defaultState) andReturn:[NSObject new]];
        sut = [[FLXStore alloc] init];
    });
    
    it(@"Doesn't respond to actions by default", ^{
        id actionMock = [NSObject new];
        BOOL result = [sut respondsToAction:actionMock];
        [[theValue(result) should] beFalse];
    });
    
    it(@"Responds to action if registered", ^{
        id actionMock = [NSObject new];
        [sut onAction:[NSObject class] callback:^id(__unused id action) {
            return [NSObject new];
        }];
        BOOL result = [sut respondsToAction:actionMock];
        [[theValue(result) should] beTrue];
    });
    
    it(@"Sets new state if registered", ^{
        id actionMock = [NSObject new];
        id stateMock = [NSObject new];
        [sut onAction:[NSObject class] callback:^id(__unused id action) {
            return stateMock;
        }];
        [sut dispatchAction:actionMock];
        [[sut.state should] beIdenticalTo:stateMock];
    });
    
    it(@"Doesn't change state if not registered", ^{
        id initialState = sut.state;
        id actionMock = [NSObject new];
        [sut dispatchAction:actionMock];
        [[sut.state should] beIdenticalTo:initialState];
    });
    
});

SPEC_END
