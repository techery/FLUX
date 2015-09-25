#import <Foundation/Foundation.h>

#import "FLXBaseState.h"

@class FLXActionStackNodeBuilder;

@interface FLXActionStackNode : NSObject

@property(nonatomic, strong, readonly) NSDate *createdAt;
@property(nonatomic, strong, readonly) NSObject *action;

+ (FLXActionStackNode*)create:(void(^)(FLXActionStackNodeBuilder *builder))builder;
- (FLXActionStackNode*)mutate:(void(^)(FLXActionStackNodeBuilder *builder))builder;


@end
        
@interface FLXActionStackNodeBuilder : NSObject

@property(nonatomic, strong, readwrite) NSDate *createdAt;
@property(nonatomic, strong, readwrite) NSObject *action;
@end


@class FLXStoreStateNodeBuilder;

@interface FLXStoreStateNode : NSObject

@property(nonatomic, strong, readonly) NSDate *createdAt;
@property(nonatomic, strong, readonly) NSString *storeClassString;
@property(nonatomic, strong, readonly) FLXBaseState *state;

+ (FLXStoreStateNode*)create:(void(^)(FLXStoreStateNodeBuilder *builder))builder;
- (FLXStoreStateNode*)mutate:(void(^)(FLXStoreStateNodeBuilder *builder))builder;


@end
        
@interface FLXStoreStateNodeBuilder : NSObject

@property(nonatomic, strong, readwrite) NSDate *createdAt;
@property(nonatomic, strong, readwrite) NSString *storeClassString;
@property(nonatomic, strong, readwrite) FLXBaseState *state;
@end

