#import "ConnectionTests.h"
#import <ObjectiveResource/Connection.h>
#define HC_SHORTHAND
#import <hamcrest/hamcrest.h>

@implementation ConnectionTests
- (void)testConnection
{
	ARSConnection* connection = [[[ARSConnection alloc] initToSite:TEST_SITE_URL format:@"xml"] autorelease];
	id result                 = [connection get:@"products/1.xml" headers:nil];
	assertThat(result, instanceOf([NSDictionary class]));
	STAssertTrue([result count] > 0, @"Result should have elements");
}

- (void)testConnectionWithArrayResult
{
	ARSConnection* connection = [[[ARSConnection alloc] initToSite:TEST_SITE_URL format:@"xml"] autorelease];
	id result                 = [connection get:@"products.xml" headers:nil];
	assertThat(result, instanceOf([NSArray class]));
	STAssertTrue([result count] > 0, @"Result should have elements");
}
@end
