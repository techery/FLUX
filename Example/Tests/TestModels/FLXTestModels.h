//
//  TETestModels.h
//  FLUX
//
//  Created by Alex Faizullov on 10/28/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FLUX/FLXStore.h>

#define flx_defineStoreTestDouble(name) \
\
@interface name : FLXStore <NSObject *> \
\
@end \
\
@implementation name \
\
+ (id)defaultState { return [NSObject new]; } \
\
@end \
\

flx_defineStoreTestDouble(FLXFakeStore)
flx_defineStoreTestDouble(FLXTestStore)
