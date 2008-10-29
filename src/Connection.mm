#import "Connection.h"

@interface ARSConnection ()
@property (retain) id<ARSFormat> format;
@end

@implementation ARSConnection
// ==================
// = Setup/Teardown =
// ==================

- (id)initToSite:(NSString*)reqSite format:(NSString*)reqFormat;
{
	NSAssert(reqSite != nil, @"Site must not be nil");
	if(self = [self init])
	{
		self.user     = nil;
		self.password = nil;
		self.site     = reqSite;
		if([reqFormat isEqualToString:@"xml"])
			format = [ARSXMLFormat new];
		else
		{
			NSLog(@"Unknown format: %@", reqFormat);
			[self release];
			return nil;
		}
	}
	return self;
}

- (void)dealloc
{
	self.user     = nil;
	self.password = nil;
	self.site     = nil;
	self.format   = nil;
	[super dealloc];
}


// =============
// = Accessors =
// =============

@synthesize site, user, password, format;

- (void)setSite:(id)newSite;
{
	if(site != newSite)
	{
		if([newSite isKindOfClass:[NSString class]])
			newSite = [NSURL URLWithString:newSite];
		if([newSite user])
			self.user = [newSite user];
		if([newSite password])
			self.password = [newSite password];
		[site release];
		site = [newSite retain];
	}
}

// ============
// = Internal =
// ============

- (NSDictionary*)defaultHeaders
{
	return [NSDictionary dictionaryWithObjectsAndKeys:[self.format mimeType], @"Content-Type", nil];
}

- (id)requestWithMethod:(NSString*)method path:(NSString*)path payload:(id)payload headers:(NSDictionary*)headers;
{
	NSURL* URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", self.site, path]];
	if([self user])
		URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@:%@@%@:%@%@", [URL scheme], [self user], [self password], [URL host], [URL port] ?: @"80", [URL path]]];
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
	[request setHTTPMethod:[method uppercaseString]];
	if(payload)
	{
		if([[method uppercaseString] isEqualToString:@"GET"] || [[method uppercaseString] isEqualToString:@"DELETE"])
			[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", [[[[request URL] absoluteString] componentsSeparatedByString:@"?"] objectAtIndex:0], payload]]];
		else
		{
			[request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
			[request setValue:[NSString stringWithFormat:@"%d", [payload length]] forHTTPHeaderField:@"Content-Length"];
			[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
		}
	}
	NSMutableDictionary* requestHeaders = [[[self defaultHeaders] mutableCopy] autorelease];
	if(headers)
		[requestHeaders addEntriesFromDictionary:headers];
	[request setAllHTTPHeaderFields:requestHeaders];

	NSError* error;
	NSHTTPURLResponse* response;
	NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}

// ===========
// = Methods =
// ===========

- (id)get:(NSString*)path headers:(NSDictionary*)headers;
{
	return [self.format decode:[self requestWithMethod:@"GET" path:path payload:nil headers:headers]];
}

@end
