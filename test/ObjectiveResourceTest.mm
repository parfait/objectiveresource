#import "ObjectiveResourceTest.h"


@implementation ObjectiveResourceTest
- (void)loadFixtures
{
	NSTask* task = [[NSTask new] autorelease];
	[task setLaunchPath:@"/opt/local/bin/rake"];
	NSString* appPath = [[[NSString stringWithUTF8String:__FILE__] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"app"];
	[task setCurrentDirectoryPath:appPath];
	[task setArguments:[NSArray arrayWithObjects:@"--trace", @"db:fixtures:load", nil]];
	[task setEnvironment:[NSDictionary dictionaryWithObject:@"/opt/local/bin" forKey:@"PATH"]];
	[task launch];
	[task waitUntilExit];
}

- (void)setUp
{
	[self loadFixtures];
}
@end
