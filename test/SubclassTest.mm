#import "SubclassTest.h"
#import "ConnectionTests.h"
#import <ObjectiveResource/ObjectiveResource.h>
#define HC_SHORTHAND
#import <hamcrest/hamcrest.h>

@interface Product : ObjectiveResource
@end

@implementation Product
+ (NSString*)baseURL  { return TEST_SITE_URL; }
@end


@implementation SubclassTest
- (void)testBaseURL
{
	STAssertNoThrow([Product baseURL], @"Subclass should not throw when attempting to access baseURL");
	assertThat([Product baseURL], equalTo(TEST_SITE_URL));
}

- (void)testFind
{
	Product* product = [Product find:1];
	assertThat(product, notNilValue());
	assertThat(product, instanceOf([Product class]));
	assertThat([product valueForKey:@"title"], equalTo(@"Test"));
}

- (void)testList
{
	NSArray* products = [Product findAll:nil];
	STAssertTrue([products count] > 0, @"There should be some products returned");
	Product* product = [products objectAtIndex:0];
	assertThat(product, instanceOf([Product class]));
	assertThat([product valueForKey:@"title"], equalTo(@"Test"));
}

- (void)testReload
{
	Product* product = [Product find:1];
	assertThat([product valueForKey:@"title"], equalTo(@"Test"));
	[product setValue:@"Renamed Product" forKey:@"title"];
	assertThat([product valueForKey:@"title"], equalTo(@"Renamed Product"));
	[product reload];
	assertThat([product valueForKey:@"title"], equalTo(@"Test"));
}

- (void)testInvalidFind
{
	STAssertThrows([Product find:255], @"Exception should be thrown for missing resource");
}
@end
