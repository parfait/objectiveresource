#import <SenTestingKit/SenTestingKit.h>
#import <ObjectiveResource/Connection.h>
#import "ObjectiveResourceTest.h"

#define TEST_SITE_URL       @"http://caboose:monkeyballs@localhost:3000"

@interface ConnectionTests : ObjectiveResourceTest
{
	ORConnection* connection;
}
@end
