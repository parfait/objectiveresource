#import "GlobalHeader.h"

enum ORAttributeType
{
	kORAttributeTypeString,
	kORAttributeTypeNumber,
	kORAttributeTypeBoolean,
	kORAttributeTypeDate,
};

@interface ObjectiveResource : NSObject
{
	NSMutableDictionary* attributes;
}
@property (retain) NSDictionary* attributes;
@property (readonly) NSArray* interestingAttributeNames;

+ (NSString*)baseURL; // NO trailing slash!
+ (NSString*)user;
+ (NSString*)password;

// The singular name for the resource in lowercase. Defaults to the class name.
+ (NSString*)elementName;

// The plural name for the resource. Defaults to the plural form of +elementName
+ (NSString*)collectionName;

+ (id)find:(int)recordId;
+ (id)findAll:(id)options;

- (void)reload;

// The title for the record.
// Checks for a 'title' attribute first, and then tries a 'name' attribute.
- (NSString*)title;

// Subclass to override the type for attributes.
- (ORAttributeType)typeForAttribute:(NSString*)attributeName;
@end
