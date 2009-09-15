//
//  FPXMLParser.h
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

#import <Foundation/Foundation.h>
#import "FPXMLParserProtocol.h"

typedef enum {
	FPXMLParserTextElementType = 1,
	FPXMLParserStreamElementType = 2,
	FPXMLParserSkipElementType = 3 // for keys we're skipping, and don't care about the contents
} FPXMLParserElementType;

// RSS has no namespace, just test against @""
extern NSString * const kFPXMLParserAtomNamespaceURI;
extern NSString * const kFPXMLParserDublinCoreNamespaceURI;
extern NSString * const kFPXMLParserContentNamespaceURI;

@interface FPXMLParser : NSObject <FPXMLParserProtocol> {
@protected
	NSMutableArray *extensionElements;
	id<FPXMLParserProtocol> parentParser; // non-retained
	NSString *baseNamespaceURI;
	NSDictionary *handlers;
	NSMutableString *currentTextValue;
	NSDictionary *currentAttributeDict;
	FPXMLParserElementType currentElementType;
	NSUInteger skipDepth;
	NSUInteger parseDepth;
	SEL currentHandlerSelector;
}
@property (nonatomic, readonly) NSMutableArray *extensionElements;
+ (void)registerHandler:(SEL)selector forElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI type:(FPXMLParserElementType)type;
- (id)initWithBaseNamespaceURI:(NSString *)namespaceURI;
- (void)abortParsing:(NSXMLParser *)parser;
- (void)abortParsing:(NSXMLParser *)parser withFormat:(NSString *)description, ...;
- (void)abortParsing:(NSXMLParser *)parser withString:(NSString *)description;
- (void)abdicateParsing:(NSXMLParser *)parser;

- (NSArray *)extensionElementsWithXMLNamespace:(NSString *)namespaceURI;
- (NSArray *)extensionElementsWithXMLNamespace:(NSString *)namespaceURI elementName:(NSString *)elementName;
@end
