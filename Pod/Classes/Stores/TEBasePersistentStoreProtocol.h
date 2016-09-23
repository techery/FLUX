#import <Foundation/Foundation.h>

@protocol TEBasePersistentStoreProtocol <NSObject>

- (BOOL)shouldSaveState:(id)state;
- (BOOL)shouldRestoreState:(id)state;

@end
