//
//  TETestModels.h
//  FLUX
//
//  Created by Alex Faizullov on 10/28/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FLUX/TEBaseStore.h>
#import <FLUX/TEBaseState.h>

#define te_createFakeStore(name) \
\
@interface name : TEBaseStore \
\
@end \
\
@implementation name \
\
+ (TEBaseState *)defaultState { return [TEBaseState new]; } \
- (void)registerWithLocalDispatcher:(TEStoreDispatcher *)storeDispatcher {} \
\
@end \
\

te_createFakeStore(TEFakeStore)
te_createFakeStore(TETestStore)
