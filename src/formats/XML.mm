#import "XML.h"
#import "TouchXML.h"

NSDate* date_from_iso_8601 (NSString* str)
{
	static NSDateFormatter* sISO8601 = nil;
	if(!sISO8601)
	{
		sISO8601 = [[NSDateFormatter alloc] init];
		[sISO8601 setTimeStyle:NSDateFormatterFullStyle];
		[sISO8601 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
	}
	if([str hasSuffix:@"Z"])
		str = [[str substringToIndex:(str.length-1)] stringByAppendingString:@"GMT"];
	return [sISO8601 dateFromString:str];
}

@interface ARSXMLFormat (Private)
- (id)decodeElement:(id)element;
- (NSArray*)decodeArray:(id)element;
- (NSDictionary*)decodeDictionary:(id)inElement;
@end

@implementation ARSXMLFormat
- (NSString*)extension
{ return @"xml"; }

- (NSString*)mimeType
{ return @"application/xml"; }

- (NSString*)encode:(id)data
{
	NSAssert(NO, @"XML encode: Not implemented");
	return nil;
}

- (id)decodeElement:(id)element;
{
	NSString* type = [[element attributeForName:@"type"] stringValue];
	if([type isEqualToString:@"integer"])
		return [NSNumber numberWithInt:[[element stringValue] intValue]];
	else if([type isEqualToString:@"boolean"])
		return [NSNumber numberWithBool:([[element stringValue] isEqualToString:@"true"])];
	else if([type isEqualToString:@"datetime"])
		return date_from_iso_8601([element stringValue]);
	else if([type isEqualToString:@"array"])
		return [self decodeArray:element];
	else if([[element nodesForXPath:@"*" error:NULL] count] > 0)
		return [self decodeDictionary:element];
	else if([[[element attributeForName:@"nil"] stringValue] isEqualToString:@"true"])
		return [NSNull null];
	else if([element stringValue] == nil)
		return [NSNull null];
	return [element stringValue];
}

- (NSArray*)decodeArray:(id)inElement;
{
	NSMutableArray* result = [NSMutableArray arrayWithCapacity:[inElement childCount]];

	for(CXMLNode* element in [inElement children])
	{
		if([element kind] == CXMLElementKind)
			[result addObject:[self decodeElement:element]];
	}

	return result;
}

- (NSDictionary*)decodeDictionary:(id)inElement;
{
	NSMutableDictionary* result = [NSMutableDictionary dictionaryWithCapacity:[inElement childCount]];

	for(CXMLNode* element in [inElement children])
	{
		if([element kind] == CXMLElementKind)
		{
			id value = [self decodeElement:element];
			[result setObject:value forKey:[[element name] stringByReplacingOccurrencesOfString:@"-" withString:@"_"]];
		}
	}

	return result;
}

- (id)decode:(NSString*)xml
{
	NSError* error    = nil;
	CXMLDocument* doc = [[[CXMLDocument alloc] initWithXMLString:xml options:0 error:&error] autorelease];
	if([[[[doc rootElement] attributeForName:@"type"] stringValue] isEqualToString:@"array"])
		return [self decodeArray:[doc rootElement]];
	else
		return [self decodeDictionary:[doc rootElement]];
}
@end
