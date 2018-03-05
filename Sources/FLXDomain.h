 //
//  FLXDomain.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/4/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FLXStore;

@protocol FLXExecutor;
@protocol FLXMiddleware;

/**
 FLUX domain protocol that describes public interface of the domain
 */
@protocol FLXDomainProtocol <NSObject>

/**
 Returns existing store of given class which is registered in domain.
 
 @param storeClass class of store, FLXStore or one if its subclasses

 @return FLXStore instance if store is registered in a domain, nil otherwise
 */
- (nullable FLXStore *)storeOfClass:(nonnull Class)storeClass;


/**
 Instantiates and returns new temporary store of given class. 
 Domain doesn't retain temporary store, so caller is responsible for lifecycle of this store.
 
 @param storeClass class of temporary store, FLXStore or one if its subclasses

 @return FLXStore instance if store is successfully created, nil otherwise
 */
- (nullable FLXStore *)temporaryStoreOfClass:(nonnull Class)storeClass;

/**
 Asynchronously dispatches an action to domain.
 
 @param action object of any type that represents a specific action
 */
- (void)dispatchAction:(nonnull id)action;

/**
 Synchronously dispatches an action to domain.
 
 @param action object of any type that represents a specific action
 */
- (void)dispatchActionAndWait:(nonnull id)action;


/**
 Registers additional stores in domain. Allows to attach additional stores after domain was initialized

 @param stores array of stores to be registered in a domain
 */
- (void)attachStores:(nonnull NSArray <FLXStore *>*)stores;

/**
 Registers temporary store in domain.
 Domain doesn't retain temporary store, so caller is responsible for lifecycle of this store.
 
 @param temporaryStore instance of temporary store to be registered
 */
- (void)attachTemporaryStore:(nonnull FLXStore *)temporaryStore;

@end

/**
 Main FLUX class that is designed to be subclassed by your application domain.

 @warning This class is designed for subclassing by your application domain, but be careful with overriding 
 base implementation of FLXDomainProtocol methods. Recommended way to subclass a domain is to extend it's implementation 
 with more convinient methods e.g. specific store accessors, constructors etc.
 */
@interface FLXDomain : NSObject <FLXDomainProtocol>

/**
 Designated initializer of domain object

 @param executor    object that executes domain actions, potentially on separate queue/thread
 @param middlewares array of middlewares that provide side effects for action dispatching or store state changes
 @param stores      array of stores that will be registered and stored by domain

 @return initialized domain instance
 */
- (nonnull instancetype)initWithExecutor:(nonnull id <FLXExecutor>)executor
                     middlewares:(nonnull NSArray <id <FLXMiddleware>> *)middlewares
                          stores:(nonnull NSArray <FLXStore *>*)stores;

- (nonnull instancetype)init NS_UNAVAILABLE;

@end
