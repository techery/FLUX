//
// Created by Dmitry on 08.09.15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "TEFileSystemPersistentProvider.h"
#import "TEBaseState.h"

@interface TEFileSystemPersistentProvider ()

@property (nonatomic, strong) dispatch_queue_t storeQueue;
@property (nonatomic, strong) NSFileManager *fileManager;

@end

@implementation TEFileSystemPersistentProvider

- (instancetype)initWithFileManager:(NSFileManager *)fileManager; {
    NSParameterAssert(fileManager);
    self = [super init];
    if (self) {
        self.storeQueue = dispatch_queue_create([self serviceId].UTF8String, DISPATCH_QUEUE_SERIAL);
        self.fileManager = fileManager;
        [self createWorkingDirectoryIfNeeded];
    }
    return self;
}

- (void)saveState:(id <NSCoding>)state forStore:(TEBaseStore <TEPersistentStoreProtocol> *)store {
    dispatch_async(self.storeQueue, ^{
        [NSKeyedArchiver archiveRootObject:state toFile:[self pathForStore:store]];
    });
}

- (NSString *)pathForStore:(TEBaseStore <TEPersistentStoreProtocol> *)store {
    NSString *storeName = NSStringFromClass([store class]);
    return [NSString stringWithFormat:@"%@/%@.savedstate", [self pathToWorkingDirectory], storeName];
}

- (void)createWorkingDirectoryIfNeeded {
    NSError *error = nil;
    NSString *pathToWorkingDirectory = [self pathToWorkingDirectory];
    if (![self.fileManager fileExistsAtPath:pathToWorkingDirectory]) {
        [self.fileManager createDirectoryAtPath:pathToWorkingDirectory withIntermediateDirectories:NO attributes:nil error:&error];
    }
}

- (NSString *)pathToWorkingDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/FLUX"];
    return dataPath;
}

- (id)stateForStore:(TEBaseStore <TEPersistentStoreProtocol> *)store {
    id object;
    NSString *statePath = [self pathForStore:store];
    @try {
         object = [NSKeyedUnarchiver unarchiveObjectWithFile:statePath];
    }
    @catch (NSException *exception) {
        object = nil;
        [self.fileManager removeItemAtPath:statePath error:nil];
    }
    return object;
}

- (NSString *)serviceId {
    return [NSString stringWithFormat:@"%@.%@.%p", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"], NSStringFromClass([self class]), self];
}

@end