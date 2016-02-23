//
//  TEDomain.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/4/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TEBaseStore;
@class TEBaseAction;

@protocol TEDomainProtocol <NSObject>
- (TEBaseStore *)getStoreByClass:(Class)store;
- (void)registerStore:(TEBaseStore *)store;
- (void)dispatchAction:(TEBaseAction *)action;
- (void)dispatchActionAndWait:(TEBaseAction *)action;
@end

@interface TEDomain : NSObject <TEDomainProtocol>

@end
