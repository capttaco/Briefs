//
//  FPXMLParser.m
//  FeedParser
//
//  Created by Kevin Ballard on 4/6/09.
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

#import "FPXMLParser.h"
#import "FPXMLPair.h"
#import "FPExtensionNode.h"
#import "FPExtensionElementNode.h"
#import "FPExtensionElementNode_Private.h"
#import <objc/message.h>
#import <stdarg.h>

NSString * const kFPXMLParserAtomNamespaceURI = @"http://www.w3.org/2005/Atom";
NSString * const kFPXMLParserDublinCoreNamespaceURI = @"http://purl.org/dc/elements/1.1/";
NSString * const kFPXMLParserContentNamespaceURI = @"http://web.resource.org/rss/1.0/modules/content/";

static NSMutableDictionary *kHandlerMap;

void (*handleTextValue)(id, SEL, NSString*, NSDictionary*, NSXMLParser*) = (void(*)(id, SEL, NSString*, NSDictionary*, NSXMLParser*))objc_msgSend;
void (*handleStreamElement)(id, SEL, NSDictionary*, NSXMLParser*) = (void(*)(id, SEL, NSDictionary*, NSXMLParser*))objc_msgSend;
void (*handleSkipElement)(id, SEL, NSDictionary*, NSXMLParser*) = (void(*)(id, SEL, NSDictionary*, NSXMLParser*))objc_msgSend;

@implementation FPXMLParser
@synthesize extensionElements;
+ (void)initialize {
	if (self == [FPXMLParser class]) {
		kHandlerMap = (NSMutableDictionary *)CFDictionaryCreateMutable(NULL, 0, NULL, &kCFTypeDictionaryValueCallBacks);
	}
}

// if selector is NULL then just ignore this element rather than raising an error
+ (void)registerHandler:(SEL)selector forElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI type:(FPXMLParserElementType)type {
	NSMutableDictionary *handlers = [kHandlerMap objectForKey:self];
	if (handlers == nil) {
		handlers = [NSMutableDictionary dictionary];
		CFDictionarySetValue((CFMutableDictionaryRef)kHandlerMap, self, handlers);
	}
	FPXMLPair *keyPair = [FPXMLPair pairWithFirst:elementName second:namespaceURI];
	FPXMLPair *valuePair = [FPXMLPair pairWithFirst:NSStringFromSelector(selector) second:[NSNumber numberWithInt:type]];
	[handlers setObject:valuePair forKey:keyPair];
}

- (id)initWithBaseNamespaceURI:(NSString *)namespaceURI {
	if (self = [self init]) {
		baseNamespaceURI = [namespaceURI copy];
	}
	return self;
}

- (id)init {
	if (self = [super init]) {
		extensionElements = [[NSMutableArray alloc] init];
		handlers = [[kHandlerMap objectForKey:[self class]] retain];
		currentElementType = FPXMLParserStreamElementType;
		parseDepth = 1;
	}
	return self;
}

- (void)acceptParsing:(NSXMLParser *)parser {
	parentParser = (id<FPXMLParserProtocol>)[parser delegate];
	[parser setDelegate:self];
}

- (void)abortParsing:(NSXMLParser *)parser {
	[self abortParsing:parser withString:nil];
}

- (void)abortParsing:(NSXMLParser *)parser withFormat:(NSString *)description, ... {
	va_list valist;
	va_start(valist, description);
	NSString *desc = [[[NSString alloc] initWithFormat:description arguments:valist] autorelease];
	va_end(valist);
	return [self abortParsing:parser withString:desc];
}

- (void)abortParsing:(NSXMLParser *)parser withString:(NSString *)description {
	if (parentParser != nil) {
		FPXMLParser *parent = parentParser;
		parentParser = nil;
		[parent abortParsing:parser withString:description];
	} else {
		[parser setDelegate:nil];
		[parser abortParsing];
	}
}

- (void)abdicateParsing:(NSXMLParser *)parser {
	[parser setDelegate:parentParser];
	parentParser = nil;
}

- (NSArray *)extensionElementsWithXMLNamespace:(NSString *)namespaceURI {
	if (namespaceURI == nil) {
		return self.extensionElements;
	} else {
		return [self extensionElementsWithXMLNamespace:namespaceURI elementName:nil];
	}
}

- (NSArray *)extensionElementsWithXMLNamespace:(NSString *)namespaceURI elementName:(NSString *)elementName {
	NSMutableArray *ary = [NSMutableArray arrayWithCapacity:[extensionElements count]];
	for (FPExtensionNode *node in extensionElements) {
		if ([node.namespaceURI isEqualToString:namespaceURI] &&
			(elementName == nil || [node.name isEqualToString:elementName])) {
			[ary addObject:node];
		}
	}
	return ary;
}

- (void)dealloc {
	[extensionElements release];
	[handlers release];
	[currentTextValue release];
	[currentAttributeDict release];
	[super dealloc];
}

#pragma mark XML Parser methods

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	switch (currentElementType) {
		case FPXMLParserTextElementType:
			[currentTextValue appendString:string];
			break;
		case FPXMLParserStreamElementType:
			if ([string rangeOfCharacterFromSet:[[NSCharacterSet whitespaceAndNewlineCharacterSet] invertedSet]].location != NSNotFound) {
				[self abortParsing:parser withFormat:@"Unexpected text \"%@\" at line %d", string, [parser lineNumber]];
			}
			break;
		case FPXMLParserSkipElementType:
			break;
	}
}

// this method never seems to be called
- (void)parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString {
	if (currentElementType == FPXMLParserTextElementType) {
		[currentTextValue appendString:whitespaceString];
	}
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
	switch (currentElementType) {
		case FPXMLParserTextElementType: {
			NSString *str = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
			if (str == nil) {
				// the data isn't valid UTF-8
				// try as ISO-Latin-1. Probably not correct, but at least it will never fail
				str = [[NSString alloc] initWithData:CDATABlock encoding:NSISOLatin1StringEncoding];
			}
			[currentTextValue appendString:str];
			[str release];
			break;
		}
		case FPXMLParserStreamElementType:
			[self abortParsing:parser withFormat:@"Unexpected CDATA at line %d", [parser lineNumber]];
			break;
		case FPXMLParserSkipElementType:
			break;
	}
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
	if (baseNamespaceURI == nil) {
		baseNamespaceURI = [namespaceURI copy];
	}
	switch (currentElementType) {
		case FPXMLParserTextElementType:
			[self abortParsing:parser];
			break;
		case FPXMLParserStreamElementType: {
			FPXMLPair *keyPair = [FPXMLPair pairWithFirst:elementName second:namespaceURI];
			FPXMLPair *handler = [handlers objectForKey:keyPair];
			if (handler != nil) {
				SEL selector = NSSelectorFromString((NSString *)handler.first);
				currentElementType = (FPXMLParserElementType)[(NSNumber *)handler.second intValue];
				switch (currentElementType) {
					case FPXMLParserStreamElementType:
						if (selector != NULL) {
							handleStreamElement(self, selector, attributeDict, parser);
						}
						if ([parser delegate] == self) parseDepth++;
						break;
					case FPXMLParserTextElementType:
						[currentTextValue release];
						currentTextValue = [[NSMutableString alloc] init];
						[currentAttributeDict release];
						currentAttributeDict = [attributeDict copy];
						currentHandlerSelector = selector;
						break;
					case FPXMLParserSkipElementType:
						if (selector != NULL) {
							handleSkipElement(self, selector, attributeDict, parser);
						}
						if ([parser delegate] == self) {
							skipDepth++;
						} else {
							// if the skip handler changed the delegate, then when we gain control
							// again we should be in the stream mode.
							// note that this is an exceptional condition, as skip handlers are not expected
							// to change the delegate. If the handler wants to do that it should use a stream handler.
							currentElementType = FPXMLParserStreamElementType;
						}
						break;
				}
//			} else if ([namespaceURI isEqualToString:baseNamespaceURI]) {
//				[self abortParsing:parser];
			} else if (![namespaceURI isEqualToString:kFPXMLParserAtomNamespaceURI] //&& ![namespaceURI isEqualToString:@""]non
					   ) {				// element is unknown and belongs to neither the Atom nor RSS namespaces
				FPExtensionElementNode *node = [[FPExtensionElementNode alloc] initWithElementName:elementName namespaceURI:namespaceURI
																					 qualifiedName:qualifiedName attributes:attributeDict];
				[node acceptParsing:parser];
				[extensionElements addObject:node];
				[node release];
			} else {
				// this is an unknown element outside of the base namespace, but still belonging to either RSS or Atom
				// As this is not in our base namespace, we are not required to handle it.
				// Do not use the extension mechanism for this because of forward-compatibility issues. If we use the
				// extension mechanism, then later add support for the element, code relying on the extension mechanism
				// would stop working.
				currentElementType = FPXMLParserSkipElementType;
				skipDepth = 1;
			}
			break;
		}
		case FPXMLParserSkipElementType:
			skipDepth++;
			break;
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	switch (currentElementType) {
		case FPXMLParserTextElementType: {
			if (currentHandlerSelector != NULL) {
				handleTextValue(self, currentHandlerSelector, currentTextValue, currentAttributeDict, parser);
			}
			[currentTextValue release];
			currentTextValue = nil;
			[currentAttributeDict release];
			currentAttributeDict = nil;
			currentElementType = FPXMLParserStreamElementType;
			break;
		}
		case FPXMLParserStreamElementType:
			parseDepth--;
			if (parseDepth == 0) {
				[self abdicateParsing:parser];
			}
			break;
		case FPXMLParserSkipElementType:
			skipDepth--;
			if (skipDepth == 0) {
				currentElementType = FPXMLParserStreamElementType;
			}
			break;
	}
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	[self abortParsing:parser];
}
@end
