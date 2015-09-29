//
// Created by Dmitry on 14.09.15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <KVOController/FBKVOController.h>
#import "FLXStoreStateObserver.h"
#import "FLXBaseStore.h"
#import "FLXFakeStore.h"
#import "FLXFakeState.h"

@interface FLXStoreStateObserver (Testing)

@property (nonatomic, strong) FBKVOController *observer;
- (void)onStoreRegistration:(FLXBaseStore *)store;
- (void)setupStore:(FLXBaseStore *)store;
- (void)setupStateObservingOfStore:(FLXBaseStore *)store;
@end

SPEC_BEGIN(FLXStoreStateObserverSpec)

FLXStoreStateObserver __block *sut;

beforeEach(^{
    sut = [[FLXStoreStateObserver alloc] init];
});

afterEach(^{
    sut = nil;
});

describe(@"init", ^{
    it(@"should init", ^{
        [[sut shouldNot] beNil];
        [[sut should] conformToProtocol:@protocol(FLXDomainMiddleware)];
    });
});
describe(@"register store", ^{
    it(@"should register store correct if shouldObserveStore: returns YES", ^{
        id storeMock = [KWMock mockForClass:[FLXFakeStore class]];
        
        [[sut should] receive:@selector(shouldObserveStore:)
                    andReturn:theValue(YES)
                withArguments:storeMock];
        [[sut should] receive:@selector(setupStore:)
                withArguments:storeMock];
        [[sut should] receive:@selector(setupStateObservingOfStore:)
                withArguments:storeMock];
        [sut onStoreRegistration:storeMock];
    });
    
    it(@"shouldn't register store if shouldObserveStore: returns NO", ^{
        id storeMock = [KWMock mockForClass:[FLXFakeStore class]];
        [[sut should] receive:@selector(shouldObserveStore:)
                    andReturn:theValue(NO)
                withArguments:storeMock];
        [[sut shouldNot] receive:@selector(setupStore:)
                   withArguments:storeMock];
        [[sut shouldNot] receive:@selector(setupStateObservingOfStore:)
                   withArguments:storeMock];
        [sut onStoreRegistration:storeMock];
    });
});

describe(@"observing of state changes", ^{
    it(@"should observe state change if shouldObserveStore: returns YES", ^{
        sut.observer = (FBKVOController *)[KWMock mockForClass:[FBKVOController class]];
        id storeMock = [KWMock mockForClass:[FLXFakeStore class]];
        id stateMock = [KWMock mockForClass:[FLXFakeState class]];
        NSDictionary *changes = @{NSKeyValueChangeNewKey:stateMock};
        
        [sut stub:@selector(shouldObserveStore:) andReturn:theValue(YES)];
        [sut.observer stub:@selector(observe:keyPath:options:block:)
                 withBlock:^id(NSArray *params) {
                     void (^block)(FLXStoreStateObserver *, FLXBaseStore *, NSDictionary *) = params[3];
                     block(sut, storeMock, changes);
                     return nil;
                 }];
        
        [[sut should] receive:@selector(store:didChangeState:) withArguments:storeMock, stateMock, nil];
        
        [sut onStoreRegistration:storeMock];
    });
    
    it(@"shouldn't observe state change if shouldObserveStore: returns NO", ^{
        sut.observer = (FBKVOController *)[KWMock mockForClass:[FBKVOController class]];
        id storeMock = [KWMock mockForClass:[FLXFakeStore class]];
        id stateMock = [KWMock mockForClass:[FLXFakeState class]];
        NSDictionary *changes = @{NSKeyValueChangeNewKey:stateMock};
        
        [sut stub:@selector(shouldObserveStore:) andReturn:theValue(NO)];
        [sut.observer stub:@selector(observe:keyPath:options:block:)
                 withBlock:^id(NSArray *params) {
                     void (^block)(FLXStoreStateObserver *, FLXBaseStore *, NSDictionary *) = params[3];
                     block(sut, storeMock, changes);
                     return nil;
                 }];
        
        [[sut shouldNot] receive:@selector(store:didChangeState:) withArguments:storeMock, stateMock, nil];
        
        [sut onStoreRegistration:storeMock];
    });
});

SPEC_END