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
+ (NSString*)elementName;
+ (NSString*)collectionName;

+ (id)find:(int)recordId;
+ (id)findAll:(id)options;

- (NSString*)title;
- (ORAttributeType)typeForAttribute:(NSString*)attributeName;

- (void)reload;
@end
