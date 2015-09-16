#import "TEMiddlewareModels.h"

@class TEActionStackNode;
@class TEStoreStateNode;


@implementation TEActionStackNode {
    int __modelVersion;
}





+ (TEActionStackNode*)create:(void(^)(TEActionStackNodeBuilder *builder))builderBlock
{
    TEActionStackNodeBuilder *builder = [TEActionStackNodeBuilder new];

    builderBlock(builder);

    return [[self alloc] initWithBuilder:builder modelVersion:1];
}

- (instancetype)init
{
    TEActionStackNodeBuilder *builder = [TEActionStackNodeBuilder new];
    return [[[self class] alloc] initWithBuilder:builder modelVersion:1];
}

- (instancetype)initWithBuilder:(TEActionStackNodeBuilder*)builder modelVersion:(int)modelVersion
{
    self = [super init];

    if (self) {
        __modelVersion = modelVersion;
		_createdAt = builder.createdAt;
		_action = builder.action;
    }

    return self;
}

- (TEActionStackNode*)mutate:(void(^)(TEActionStackNodeBuilder *builder))builderBlock
{
    TEActionStackNodeBuilder *builder = [TEActionStackNodeBuilder new];

	builder.createdAt = self.createdAt;
	builder.action = self.action;

    builderBlock(builder);

    return [[[self class] alloc] initWithBuilder:builder modelVersion:__modelVersion + 1];
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToOther:other];
}

- (BOOL)isEqualToOther:(TEActionStackNode *)object {
    if (self == object)
        return YES;
    if (object == nil)
        return NO;
    if (self.createdAt != object.createdAt)
        return NO;
    if (self.action != object.action)
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31u + [self.createdAt hash];
    hash = hash * 31u + [self.action hash];
    return hash;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"__modelVersion=%d", __modelVersion];
    [description appendFormat:@", createdAt=%@", self.createdAt];
    [description appendFormat:@", action=%@", self.action];
    [description appendString:@">"];
    return description;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _createdAt = [coder decodeObjectForKey:@"_createdAt"];
        _action = [coder decodeObjectForKey:@"_action"];
        __modelVersion = [coder decodeIntForKey:@"__modelVersion"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.createdAt forKey:@"_createdAt"];
    [coder encodeObject:self.action forKey:@"_action"];
    [coder encodeInt:__modelVersion forKey:@"__modelVersion"];
}

- (id)copyWithZone:(NSZone *)zone {
    TEActionStackNode *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy->__modelVersion = __modelVersion + 1;
        copy->_createdAt = _createdAt;
        copy->_action = _action;
    }

    return copy;
}


@end

@implementation TEActionStackNodeBuilder

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{};
}

@end


@implementation TEStoreStateNode {
    int __modelVersion;
}





+ (TEStoreStateNode*)create:(void(^)(TEStoreStateNodeBuilder *builder))builderBlock
{
    TEStoreStateNodeBuilder *builder = [TEStoreStateNodeBuilder new];

    builderBlock(builder);

    return [[self alloc] initWithBuilder:builder modelVersion:1];
}

- (instancetype)init
{
    TEStoreStateNodeBuilder *builder = [TEStoreStateNodeBuilder new];
    return [[[self class] alloc] initWithBuilder:builder modelVersion:1];
}

- (instancetype)initWithBuilder:(TEStoreStateNodeBuilder*)builder modelVersion:(int)modelVersion
{
    self = [super init];

    if (self) {
        __modelVersion = modelVersion;
		_createdAt = builder.createdAt;
		_storeClassString = builder.storeClassString;
		_state = builder.state;
    }

    return self;
}

- (TEStoreStateNode*)mutate:(void(^)(TEStoreStateNodeBuilder *builder))builderBlock
{
    TEStoreStateNodeBuilder *builder = [TEStoreStateNodeBuilder new];

	builder.createdAt = self.createdAt;
	builder.storeClassString = self.storeClassString;
	builder.state = self.state;

    builderBlock(builder);

    return [[[self class] alloc] initWithBuilder:builder modelVersion:__modelVersion + 1];
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToOther:other];
}

- (BOOL)isEqualToOther:(TEStoreStateNode *)object {
    if (self == object)
        return YES;
    if (object == nil)
        return NO;
    if (self.createdAt != object.createdAt)
        return NO;
    if (self.storeClassString != object.storeClassString)
        return NO;
    if (self.state != object.state)
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31u + [self.createdAt hash];
    hash = hash * 31u + [self.storeClassString hash];
    hash = hash * 31u + [self.state hash];
    return hash;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"__modelVersion=%d", __modelVersion];
    [description appendFormat:@", createdAt=%@", self.createdAt];
    [description appendFormat:@", storeClassString=%@", self.storeClassString];
    [description appendFormat:@", state=%@", self.state];
    [description appendString:@">"];
    return description;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _createdAt = [coder decodeObjectForKey:@"_createdAt"];
        _storeClassString = [coder decodeObjectForKey:@"_storeClassString"];
        _state = [coder decodeObjectForKey:@"_state"];
        __modelVersion = [coder decodeIntForKey:@"__modelVersion"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.createdAt forKey:@"_createdAt"];
    [coder encodeObject:self.storeClassString forKey:@"_storeClassString"];
    [coder encodeObject:self.state forKey:@"_state"];
    [coder encodeInt:__modelVersion forKey:@"__modelVersion"];
}

- (id)copyWithZone:(NSZone *)zone {
    TEStoreStateNode *copy = [[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy->__modelVersion = __modelVersion + 1;
        copy->_createdAt = _createdAt;
        copy->_storeClassString = _storeClassString;
        copy->_state = _state;
    }

    return copy;
}


@end

@implementation TEStoreStateNodeBuilder

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{};
}

@end

