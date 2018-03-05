//
//  FLXMiddleware.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/9/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FLXStore;

/**
 Provides an interface for generating of side-effects to some FLUX events.
 Each middleware instance is notified about all events and each middleware is 
 responsible for filtering only events it is interested in.
 
 All middleware methods are called in a context provided by domain's executor.
 That's why it is considered as a good practice to apply side-effect asynchronously 
 in order to prevent blocking action processing by stores.
 */
NS_ASSUME_NONNULL_BEGIN
@protocol FLXMiddleware <NSObject>

/**
 Method is called each time an action is dispatched to the domain.

 @param action instance of a specific action
 */
- (void)didDispatchAction:(id)action;


/**
 Method is called each time a store is registered in a dispatcher.

 @param store instance of a specific store that is registered
 */
- (void)didRegisterStore:(FLXStore *)store;


/**
 Method is called each time when any store changed it's state in response to some action.
 
 @warning This method is not called if store's state was changed using any method except dispatching an action.

 @param store instance of a specific store which state was changed
 @param state new value of store's state
 */
- (void)store:(FLXStore *)store didChangeState:(id)state;
@end
NS_ASSUME_NONNULL_END
