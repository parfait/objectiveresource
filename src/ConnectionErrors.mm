#import "ConnectionErrors.h"

@implementation ORConnectionError
+ (ORConnectionError*)exceptionWithResponse:(NSHTTPURLResponse*)response message:(NSString*)message;
{
	return [[[[self class] alloc] initWithName:[[self class] description] reason:message userInfo:[NSDictionary dictionaryWithObject:response forKey:@"response"]] autorelease];
}

+ (ORConnectionError*)exceptionWithResponse:(NSHTTPURLResponse*)response;
{
	return [self exceptionWithResponse:response message:nil];
}
@end

@implementation ORResourceNotFound
@end
