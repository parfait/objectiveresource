#import "ConnectionTests.h"
#define HC_SHORTHAND
#import <hamcrest/hamcrest.h>

@implementation ConnectionTests
- (void)setUp
{
	connection = [[ORConnection alloc] initToSite:TEST_SITE_URL format:@"xml"];
}

- (void)tearDown
{
	[connection release];
}

- (void)testConnection
{
	id result = [connection get:@"products/1.xml" headers:nil];
	assertThat(result, instanceOf([NSDictionary class]));
	STAssertTrue([result count] > 0, @"Result should have elements");
}

- (void)testConnectionWithArrayResult
{
	id result = [connection get:@"products.xml" headers:nil];
	assertThat(result, instanceOf([NSArray class]));
	STAssertTrue([result count] > 0, @"Result should have elements");
}

- (void)testConnectionWith404Result
{
	STAssertThrows([connection get:@"foobarbaz.xml" headers:nil], @"ORConnection should throw on 404");
}
@end
