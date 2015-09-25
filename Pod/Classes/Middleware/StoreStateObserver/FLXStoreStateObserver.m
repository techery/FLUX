//
//  FLXStoreStateObserver.m
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/10/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "FLXStoreStateObserver.h"
#import <KVOController/FBKVOController.h>
#import "FLXBaseStore.h"

@interface FLXStoreStateObserver ()

@property (nonatomic, strong) FBKVOController *observer;

@end

@implementation FLXStoreStateObserver

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.observer = [FBKVOController controllerWithObserver:self];
    }
    return self;
}

- (void)onStoreRegistration:(FLXBaseStore *)store
{
    if([self shouldObserveStore:store])
    {
        [self setupStore:store];
        [self setupStateObservingOfStore:store];
    }
}

- (void)setupStore:(FLXBaseStore *)store {

}

- (void)setupStateObservingOfStore:(FLXBaseStore *)store {
    
    @weakify(self);
    [self.observer observe:store
                   keyPath:@keypath(store.state)
                   options:NSKeyValueObservingOptionNew
                     block:^(FLXStoreStateObserver *observer, FLXBaseStore *object, NSDictionary *change)
     {
         @strongify(self);
         [self store:object didChangeState:change[NSKeyValueChangeNewKey]];
     }];
}

- (BOOL)shouldObserveStore:(FLXBaseStore *)store {
    [NSException raise:@"Not allowed" format:@"Subclass of FLXStoreStateObserver should override -(BOOL)shouldObserveStore:"];
    return NO;
}

-(void)store:(FLXBaseStore *)store didChangeState :(id)state {
    [NSException raise:@"Not allowed" format:@"Subclass of FLXStoreStateObserver should override -(void)store:didChangeState:"];}

@end
