#import "BasicTest.h"
#import <ObjectiveResource/ObjectiveResource.h>

@implementation BasicTest
- (void)testBaseURL
{
	STAssertThrows([ObjectiveResource baseURL], @"ObjectiveResource base class should throw when attempting to access baseURL");
}
@end
