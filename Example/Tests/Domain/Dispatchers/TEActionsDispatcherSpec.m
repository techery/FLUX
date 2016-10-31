//
//  TEActionsDispatcher.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/6/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <FLUX/TEActionsDispatcher.h>
#import <FLUX/TEDomainMiddleware.h>
#import <FLUX/TEBaseStore.h>

SPEC_BEGIN(TEActionsDispatcherSpec)

__block TEActionsDispatcher  *sut;
__block NSObject <TEDomainMiddleware> *firstMiddleware;
__block NSObject <TEDomainMiddleware> *secondMiddleware;

beforeEach(^{
    firstMiddleware = [KWMock mockForProtocol:@protocol(TEDomainMiddleware)];
    secondMiddleware = [KWMock mockForProtocol:@protocol(TEDomainMiddleware)];
    sut = [[TEActionsDispatcher alloc] initWithMiddlewares:@[
                                                             firstMiddleware,
                                                             secondMiddleware
                                                             ]];
});

describe(@"initialization", ^{
    it(@"should initialize correctly", ^{
        [[sut shouldNot] beNil];
    });
});

describe(@"Store registration", ^{
    it(@"Should notify middlewares", ^{
        id storeMock = [TEBaseStore mock];
        
        /* registering in middleware */
        [[firstMiddleware should] receive:@selector(onStoreRegistration:) withArguments:storeMock];
        [[secondMiddleware should] receive:@selector(onStoreRegistration:) withArguments:storeMock];
        [sut registerStore:storeMock];
    });
    
    it(@"Doesn't retain store", ^{
        [firstMiddleware stub:@selector(onStoreRegistration:)];
        [secondMiddleware stub:@selector(onStoreRegistration:)];
        
        __weak id weakStore;
        @autoreleasepool {
            id store = [TEBaseStore mock];
            [sut registerStore:store];
            weakStore = store;
        }
        
        [[weakStore should] beNil];
    });
});

describe(@"Action dispatch", ^{
    beforeEach(^{
        [firstMiddleware stub:@selector(onStoreRegistration:)];
        [secondMiddleware stub:@selector(onStoreRegistration:)];
    });
    
    it(@"Sent to all stores that respond", ^{
        id actionMock = [KWMock mock];
        
        id firstStore = [TEBaseStore mock];
        id firstState = [NSObject new];
        [firstStore stub:@selector(respondsToAction:)
               andReturn:theValue(YES)
           withArguments:actionMock];
        [firstStore stub:@selector(state) andReturn:firstState];
        
        id secondStore = [TEBaseStore mock];
        id secondState = [NSObject new];
        [secondStore stub:@selector(respondsToAction:)
                andReturn:theValue(YES)
            withArguments:actionMock];
        [secondStore stub:@selector(state) andReturn:secondState];
        
        
        [[firstStore should] receive:@selector(dispatchAction:)
                       withArguments:actionMock];
        [[secondStore should] receive:@selector(dispatchAction:)
                        withArguments:actionMock];
        
        [[firstMiddleware should] receive:@selector(onActionDispatching:) withArguments:actionMock];
        [[firstMiddleware should] receive:@selector(store:didChangeState:) withArguments:firstStore, firstState];
        [[firstMiddleware should] receive:@selector(store:didChangeState:) withArguments:secondStore, secondState];
        
        [[secondMiddleware should] receive:@selector(onActionDispatching:) withArguments:actionMock];
        [[secondMiddleware should] receive:@selector(store:didChangeState:) withArguments:firstStore, firstState];
        [[secondMiddleware should] receive:@selector(store:didChangeState:) withArguments:secondStore, secondState];
        
        [sut registerStore:firstStore];
        [sut registerStore:secondStore];
        [sut dispatchAction:actionMock];
    });
    
    it(@"Skips to all stores that don't respond", ^{
        id actionMock = [KWMock mock];
        
        id firstStore = [TEBaseStore mock];
        [firstStore stub:@selector(respondsToAction:)
               andReturn:theValue(NO)
           withArguments:actionMock];

        id secondStore = [TEBaseStore mock];
        [secondStore stub:@selector(respondsToAction:)
                andReturn:theValue(NO)
            withArguments:actionMock];
        
        [[firstStore shouldNot] receive:@selector(dispatchAction:)
                          withArguments:actionMock];
        [[secondStore shouldNot] receive:@selector(dispatchAction:)
                        withArguments:actionMock];
        
        [[firstMiddleware should] receive:@selector(onActionDispatching:) withArguments:actionMock];
        [[firstMiddleware shouldNot] receive:@selector(store:didChangeState:)];
        
        [[secondMiddleware should] receive:@selector(onActionDispatching:) withArguments:actionMock];
        [[secondMiddleware shouldNot] receive:@selector(store:didChangeState:)];
        
        [sut registerStore:firstStore];
        [sut registerStore:secondStore];
        [sut dispatchAction:actionMock];
    });
});

SPEC_END
