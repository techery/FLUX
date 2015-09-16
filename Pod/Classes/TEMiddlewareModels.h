#import <Foundation/Foundation.h>

#import "TEBaseAction.h"
#import "TEBaseState.h"

@class TEActionStackNodeBuilder;

@interface TEActionStackNode : NSObject

@property(nonatomic, strong, readonly) NSDate *createdAt;
@property(nonatomic, strong, readonly) TEBaseAction *action;

+ (TEActionStackNode*)create:(void(^)(TEActionStackNodeBuilder *builder))builder;
- (TEActionStackNode*)mutate:(void(^)(TEActionStackNodeBuilder *builder))builder;


@end
        
@interface TEActionStackNodeBuilder : NSObject

@property(nonatomic, strong, readwrite) NSDate *createdAt;
@property(nonatomic, strong, readwrite) TEBaseAction *action;
@end


@class TEStoreStateNodeBuilder;

@interface TEStoreStateNode : NSObject

@property(nonatomic, strong, readonly) NSDate *createdAt;
@property(nonatomic, strong, readonly) NSString *storeClassString;
@property(nonatomic, strong, readonly) TEBaseState *state;

+ (TEStoreStateNode*)create:(void(^)(TEStoreStateNodeBuilder *builder))builder;
- (TEStoreStateNode*)mutate:(void(^)(TEStoreStateNodeBuilder *builder))builder;


@end
        
@interface TEStoreStateNodeBuilder : NSObject

@property(nonatomic, strong, readwrite) NSDate *createdAt;
@property(nonatomic, strong, readwrite) NSString *storeClassString;
@property(nonatomic, strong, readwrite) TEBaseState *state;
@end

