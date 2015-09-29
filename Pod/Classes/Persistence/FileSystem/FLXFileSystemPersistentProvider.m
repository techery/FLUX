//
// Created by Dmitry on 08.09.15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "FLXFileSystemPersistentProvider.h"

@interface FLXFileSystemPersistentProvider ()

@property (nonatomic, strong) dispatch_queue_t storeQueue;

@end

@implementation FLXFileSystemPersistentProvider

- (instancetype)init {
    self = [super init];
    if (self) {
        self.storeQueue = dispatch_queue_create([self serviceId].UTF8String, DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)saveState:(id <NSCoding>)state forStore:(FLXBaseStore <FLXPersistentStoreProtocol> *)store {
    dispatch_async(self.storeQueue, ^{
        BOOL result = [NSKeyedArchiver archiveRootObject:state toFile:[self pathForStore:store]];
        NSLog(@"Saved to persistence: %@ \n with result:%d", [(NSObject *)state performSelector:@selector(description)], result);
    });
}

- (NSString *)pathForStore:(FLXBaseStore <FLXPersistentStoreProtocol> *)store {
    NSString *storeName = NSStringFromClass([store class]);
    return [NSString stringWithFormat:@"%@%@.savedstate", NSTemporaryDirectory(), storeName];
}

- (id)stateForStore:(FLXBaseStore <FLXPersistentStoreProtocol> *)store {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self pathForStore:store]];
}

- (NSString *)serviceId
{
    return [NSString stringWithFormat:@"%@.%@.%p", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"], NSStringFromClass([self class]), self];
}

@end