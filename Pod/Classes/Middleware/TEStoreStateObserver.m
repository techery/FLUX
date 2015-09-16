//
//  TEStoreStateObserver.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/10/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "TEStoreStateObserver.h"
#import <KVOController/FBKVOController.h>
#import "TEBaseStore.h"

@interface TEStoreStateObserver ()

@property (nonatomic, strong) FBKVOController *observer;

@end

@implementation TEStoreStateObserver

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.observer = [FBKVOController controllerWithObserver:self];
    }
    return self;
}

- (void)onStoreRegistration:(TEBaseStore *)store
{
    if([self shouldObserveStore:store])
    {
        [self setupStore:store];
        [self setupStateObservingOfStore:store];
    }
}

- (void)setupStore:(TEBaseStore *)store {

}

- (void)setupStateObservingOfStore:(TEBaseStore *)store {
    
    @weakify(self);
    [self.observer observe:store
                   keyPath:@keypath(store.state)
                   options:NSKeyValueObservingOptionNew
                     block:^(TEStoreStateObserver *observer, TEBaseStore *object, NSDictionary *change)
     {
         @strongify(self);
         [self store:object didChangeState:change[NSKeyValueChangeNewKey]];
     }];
}

- (BOOL)shouldObserveStore:(TEBaseStore *)store {
    [NSException raise:@"Not allowed" format:@"Subclass of TEStoreStateObserver should override -(BOOL)shouldObserveStore:"];
    return NO;
}

-(void)store:(TEBaseStore *)store didChangeState :(TEBaseState *)state {
    [NSException raise:@"Not allowed" format:@"Subclass of TEStoreStateObserver should override -(void)store:didChangeState:"];}

@end
