//
//  FLXDispatcher.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/4/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLXDispatcherProtocol.h"

@class FLXStore;
@protocol FLXExecutor;
@protocol FLXMiddleware;

/**
 Dispatcher is a core class of FLUX that is responsible for delivering actions to stores. It's also responsible
 for notifying middlewares about events such as changing of store's state or dispatching an action.
 
 In most cases dispatcher is created inside domain and used internally, so you there is no need to create it manually or subclass.
 */
NS_ASSUME_NONNULL_BEGIN
@interface FLXDispatcher : NSObject <FLXDispatcherProtocol>


/**
 Designated constructor of dispatcher object

 @param middlewares array of middlewares that will be notified about domain-specific events

 @return instance of FLXDispatcher
 */
- (instancetype)initWithMiddlewares:(nullable NSArray <id<FLXMiddleware>> *)middlewares NS_DESIGNATED_INITIALIZER;


/**
 Designated factory method for dispatcher object paired to -initWithMiddlewares:

 @param middlewares array of middlewares that will be notified about domain-specific events

 @return instance of FLXDispatcher
 */
+ (instancetype)dispatcherWithMiddlewares:(nullable NSArray <id<FLXMiddleware>> *)middlewares;


/**
 Registers a FLUX store in a dispatcher. 
 Store that is registered in a dispatcher starts to receive actions and this store's events will be forwarded to middlewares.
 
 @warning Stores are not retained by dispatcher, so caller is responsible for managing lifecycle of the store object.
 
 @param store FLUX store to be registered in a dispatcher
 */
- (void)registerStore:(FLXStore *)store;

@end
NS_ASSUME_NONNULL_END
