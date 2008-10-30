#import "GlobalHeader.h"

@interface ORConnectionError : NSException
+ (ORConnectionError*)exceptionWithResponse:(NSHTTPURLResponse*)response message:(NSString*)message;
+ (ORConnectionError*)exceptionWithResponse:(NSHTTPURLResponse*)response;
@end

@interface ORResourceNotFound : ORConnectionError
@end
