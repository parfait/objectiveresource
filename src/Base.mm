#import "Base.h"
#import "Connection.h"
#import "CWInflector.h"

static NSMutableDictionary const* connections = [[NSMutableDictionary alloc] init];

@interface ObjectiveResource (Private)
+ (id)connection;
@end

@implementation ObjectiveResource
+ (NSString*)baseURL;
{
	@throw [NSException exceptionWithName:@"ARNoBaseURL" reason:@"You must specify a base URL before using an ObjectiveResource." userInfo:nil];
}

+ (NSString*)user
{ return nil; }

+ (NSString*)password
{ return nil; }

+ (NSString*)elementName
{
	return [[self description] lowercaseString];
}

+ (NSString*)collectionName
{
	return [[self elementName] pluralForm];
}

+ (NSString*)elementPathForId:(id)recordId prefixOptions:(NSDictionary*)prefixOptions queryOptions:(NSDictionary*)queryOptions;
{
	return [NSString stringWithFormat:@"%@/%@.%@", [self collectionName], recordId, @"xml"];
}

+ (NSString*)collectionPathWithPrefixOptions:(NSDictionary*)prefixOptions queryOptions:(NSDictionary*)queryOptions;
{
	return [NSString stringWithFormat:@"%@.%@", [self collectionName], @"xml"];
}

- (ORAttributeType)typeForAttribute:(NSString*)attributeName;
{
	id value = [self valueForKey:attributeName];
	if([value isKindOfClass:[NSNumber class]])
	{
		if(!strcmp([value objCType], @encode(BOOL)))
			return kORAttributeTypeBoolean;
		else
			return kORAttributeTypeNumber;
	}
	else if([value isKindOfClass:[NSDate class]])
		return kORAttributeTypeDate;
	return kORAttributeTypeString;
}

+ (id)connection
{
	if(![connections objectForKey:self])
	{
		ORConnection* connection = [[ORConnection alloc] initToSite:[[self class] baseURL] format:@"xml"];
		if([self user])
			connection.user = [self user];
		if([self password])
			connection.password = [self password];
		[connections setObject:connection forKey:self];
		[connection release];
	}
	return [connections objectForKey:self];
}

+ (id)instantiateRecord:(NSDictionary*)attributes prefixOptions:(id)prefixOptions;
{
	ObjectiveResource* record = [[self new] autorelease];
	[record setAttributes:attributes];
	return record;
}

+ (id)instantiateCollection:(id)collection prefixOptions:(id)prefixOptions;
{
	NSMutableArray* records = [NSMutableArray arrayWithCapacity:[collection count]];

	for(id attributes in collection)
	{
		ObjectiveResource* record = [self new];
		[record setAttributes:attributes];
		[records addObject:record];
		[record release];
	}

	return records;
}

// =============
// = Accessors =
// =============

@synthesize attributes;

- (void)setAttributes:(NSDictionary*)newAttrs
{
	if(newAttrs != attributes)
	{
		[attributes release];
		attributes = [newAttrs mutableCopy];
	}
}

- (id)valueForKey:(NSString*)key
{
	return [attributes objectForKey:key];
}

- (void)setValue:(id)value forKey:(NSString*)key
{
	[attributes setObject:value forKey:key];
}

- (NSString*)title;
{
	NSString* title = [attributes objectForKey:@"title"];
	if(!title)
		title = [attributes objectForKey:@"name"];
	return title;
}

- (NSArray*)interestingAttributeNames;
{
	return [attributes allKeys];
}

- (id)toParam;
{
	return [self valueForKey:@"id"];
}

// ===========
// = Finders =
// ===========

+ (id)find:(int)recordId;
{
	id attributes = [[self connection] get:[self elementPathForId:[NSNumber numberWithInt:recordId] prefixOptions:nil queryOptions:nil] headers:nil];
	return [self instantiateRecord:attributes prefixOptions:nil];
}

+ (id)findAll:(id)options;
{
	id collection = [[self connection] get:[self collectionPathWithPrefixOptions:nil queryOptions:nil] headers:nil];
	return [self instantiateCollection:collection prefixOptions:nil];
}

// ===========
// = Actions =
// ===========

- (void)reload;
{
	id newAttributes = [[[self class] connection] get:[[self class] elementPathForId:[self toParam] prefixOptions:nil queryOptions:nil] headers:nil];
	self.attributes  = newAttributes;
}
@end
