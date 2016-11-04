# Migration to 1.0

## Store subclassing

* Store subclass should inherit FLXStore class instead of TEBaseStore and provide a generic for it's state
* Store subclass should parametrize inherited FLXStore with state generic class
* Store subclass shouldn't override it's `state` property
* `-registerWithLocalDispatcher:` should be replaced with `-subscribeToActions` method.
* Subscription on actions should be done by calling `-onAction:Callback:` on store subclass instance instead of `storeDispatcher`
* Store subclass should override `+defaultState` instead of `-defaultState` for providing default state value
* Store subclass shouldn't mark it's state as `@dynamic` anymore

#### Interface:

```objective-c
// FLUX 0.3
#import <FLUX/TEBaseStore.h>
@interface MyStore : TEBaseStore
@property (nonatomic, strong, readonly) MyState *state;
@end
```

```objective-c
// FLUX 1.0
#import <FLUX/FLXStore.h>
@interface MyStore : FLXStore <MyState *>
@end
```

#### Implementation:

```objective-c
// FLUX 0.3
#import <FLUX/TEStoreDispatcher.h>

@implementation MyStore
@dynamic state;

- (void)registerWithLocalDispatcher:(TEStoreDispatcher *)storeDispatcher {
    [storeDispatcher onAction:[MyActionClass]] callback:^TEBaseState *(MyActionClass *action) {
        return [MyState stateWithAction:action];
    }];
}

- (MyState *)defaultState {
    return [MyState new];
}
@end
```

```objective-c
// FLUX 1.0
@implementation MyStore

- (void)subscribeToActions {
    [self onAction:[MyActionClass]] callback:^MyState *(MyActionClass *action) {
        return [MyState stateWithAction:action];
    }];
}

+ (MyState *)defaultState {
    return [MyState new];
}
@end

```

## Domain subclassing

* Domain subclass should inherit FLXDomain class instead of TEDomain class
* Domain protocol should inherit FLXDomainProtocol instead of TEDomainProtocol
* Domain should use `-initWithExecutor:middlewares:stores` instead of overriding `-setup` and `-createMiddlewares` methods
