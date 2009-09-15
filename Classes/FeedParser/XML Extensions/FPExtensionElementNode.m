//
//  FPExtensionElementNode.m
//  FeedParser
//
//  Created by Kevin Ballard on 4/9/09.
//  Copyright 2009 Kevin Ballard. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "FPExtensionElementNode.h"
#import "FPExtensionElementNode_Private.h"
#import "FPXMLParserProtocol.h"
#import "FPExtensionTextNode.h"

@interface FPExtensionElementNode ()
- (void)closeTextNode;
@end

@implementation FPExtensionElementNode
@synthesize name, qualifiedName, namespaceURI, attributes, children;

- (id)initWithElementName:(NSString *)aName namespaceURI:(NSString *)aNamespaceURI qualifiedName:(NSString *)qName
			   attributes:(NSDictionary *)attributeDict {
	if (self = [super init]) {
		name = [aName copy];
		qualifiedName = [qName copy];
		namespaceURI = [aNamespaceURI copy];
		attributes = [attributeDict copy];
		children = [[NSMutableArray alloc] init];
	}
	return self;
}

- (BOOL)isElement {
	return YES;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p <%@>>", NSStringFromClass([self class]), self, qualifiedName];
}

- (NSString *)stringValue {
	NSMutableString *stringValue = [NSMutableString string];
	for (FPExtensionNode *child in children) {
		NSString *str = child.stringValue;
		if (str != nil) {
			[stringValue appendString:str];
		}
	}
	return stringValue;
}

- (void)closeTextNode {
	FPExtensionTextNode *child = [[FPExtensionTextNode alloc] initWithStringValue:currentText];
	[children addObject:child];
	[child release];
	[currentText release];
	currentText = nil;
}

- (void)dealloc {
	[name release];
	[qualifiedName release];
	[namespaceURI release];
	[attributes release];
	[children release];
	[currentText release];
	[super dealloc];
}

#pragma mark XML parser methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)aNamespaceURI
 qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	if (currentText != nil) {
		[self closeTextNode];
	}
	FPExtensionElementNode *child = [[FPExtensionElementNode alloc] initWithElementName:elementName namespaceURI:aNamespaceURI
																		  qualifiedName:qName attributes:attributeDict];
	[child acceptParsing:parser];
	[children addObject:child];
	[child release];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if (currentText != nil) {
		[self closeTextNode];
	}
	[parser setDelegate:parentParser];
	parentParser = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (currentText == nil) currentText = [[NSMutableString alloc] init];
	[currentText appendString:string];
}

- (void)parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString {
	if (currentText == nil) currentText = [[NSMutableString alloc] init];
	[currentText appendString:whitespaceString];
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
	NSString *data = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
	if (data == nil) {
		[self abortParsing:parser withString:[NSString stringWithFormat:@"Non-UTF8 data found in CDATA block at line %d", [parser lineNumber]]];
	} else {
		if (currentText == nil) currentText = [[NSMutableString alloc] init];
		[currentText appendString:data];
		[data release];
	}
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	[self abortParsing:parser withString:nil];
}

#pragma mark FPXMLParserProtocol methods

- (void)acceptParsing:(NSXMLParser *)parser {
	parentParser = (id<FPXMLParserProtocol>)[parser delegate];
	[parser setDelegate:self];
}

- (void)abortParsing:(NSXMLParser *)parser withString:(NSString *)description {
	id<FPXMLParserProtocol> parent = parentParser;
	parentParser = nil;
	[currentText release];
	currentText = nil;
	[parent abortParsing:parser withString:description];
}

- (NSArray *)childElementsWithElementName:(NSString *)elementName {
	NSMutableArray *returnElements = [NSMutableArray arrayWithCapacity:[children count]];
	for (FPExtensionNode *node in children) {
		if ([node.name isEqualToString:elementName]) {
			[returnElements addObject:node];
		}
	}
	return returnElements;
}

@end
