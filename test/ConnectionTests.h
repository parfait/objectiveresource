#import <SenTestingKit/SenTestingKit.h>
#import <ObjectiveResource/Connection.h>

#define TEST_SITE_URL       @"http://caboose:monkeyballs@localhost:3000"

@interface ConnectionTests : SenTestCase
{
	ORConnection* connection;
}
@end
