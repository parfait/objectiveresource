#import "GlobalHeader.h"

@protocol ARSFormat
- (NSString*)extension;
- (NSString*)mimeType;
- (NSString*)encode:(id)data;
- (id)decode:(NSString*)xml;
@end

#import "Formats/XML.h"
