#import "GlobalHeader.h"
#import "Formats.h"
#import "ConnectionErrors.h"

@interface ORConnection : NSObject
{
	NSURL* site;
	NSString* user;
	NSString* password;
	id<ORFormat> format;
}
@property (retain) id site;
@property (retain) NSString* user;
@property (retain) NSString* password;

- (id)initToSite:(NSString*)reqSite format:(NSString*)reqFormat;
- (id)get:(NSString*)path headers:(NSDictionary*)headers;
@end
