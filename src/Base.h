#import "GlobalHeader.h"

enum ARSAttributeType
{
	kARSAttributeTypeString,
	kARSAttributeTypeNumber,
	kARSAttributeTypeBoolean,
	kARSAttributeTypeDate,
	kARSAttributeTypeHTMLText, // This should be moved to the app really…
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
- (ARSAttributeType)typeForAttribute:(NSString*)attributeName;

- (void)reload;
@end
