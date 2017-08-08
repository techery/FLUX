//
//  FLXStore.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/9/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLXDispatcher.h"

@protocol FLXMiddleware;

typedef NSString * FLXStoreIdentifier;

/**
 Base class for FLUX store. It's designed to be subclassed.
 FLXStateType is a generic that defines a store's state type
 */
@interface FLXStore <FLXStateType> : NSObject <FLXDispatcherProtocol>

/**
 Action callback block that defines how store's state is changed in response to a specific action.

 @param action specific action object that store could process

 @return state modified in result of action
 */
typedef FLXStateType (^FLXActionCallback)(id action);

/**
 FLUX store unique identifier, subclasses can override this method. By default, it's equal to class name
 */
@property (nonatomic, readonly) FLXStoreIdentifier identifier;

/**
 State of FLUX store that stores all domain-specific data.
 */
@property (nonatomic, readonly) FLXStateType state;

/**
 Each store subclass should override this method in order to subscribe to specific domain actions.
 */
- (void)subscribeToActions NS_REQUIRES_SUPER;

/**
 Subscribes store on specific action class with a callback.
 Each store subclass is responsible for subscribing to all actions it is interested in on initialization.
 
 @param actionClass class of the action which will be processed by current store
 @param callback    action block that defines how state will be changed
 */
- (void)onAction:(Class)actionClass callback:(FLXActionCallback)callback NS_REQUIRES_SUPER;


/**
 Tells whether current store can respond to a specific action instance or not

 @param action instance of a specific action

 @return YES if store is subscribed to action, NO otherwise
 */
- (BOOL)respondsToAction:(id)action NS_REQUIRES_SUPER;

/**
 Tells whether current store can respond to a action of some class or not
 
 @param actionClass class of an action
 
 @return YES if store is subscribed to action, NO otherwise
 */
- (BOOL)respondsToActionClass:(Class)actionClass NS_REQUIRES_SUPER;

/**
 Class method that returns default state for all instances of current store class.
 
 @warning this method throws is abstract and should be overrided in store subclass. 
 Default implementation throws an exception.
 
 @return instance of state populated with default values. It's not recommended to return nil.
 */
+ (FLXStateType)defaultState;


/**
 Instance method that returns default state for all instances of current store class.
 It calls class method with the same name and created for more convinience when overriding instance methods.
 
 @return instance state populated with default values. It's not recommended to return nil.
 */
- (FLXStateType)defaultState;

@end
