//
//  FPExtensionElementNode.h
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

#import <Foundation/Foundation.h>
#import "FPExtensionNode.h"

@protocol FPXMLParserProtocol;

// FPExtensionElementNode is used for unknown elements outside of the RSS and Atom namespaces
@interface FPExtensionElementNode : FPExtensionNode {
@private
	NSString *name;
	NSString *qualifiedName;
	NSString *namespaceURI;
	NSDictionary *attributes;
	NSMutableArray *children;
	// parsing ivars
	id<FPXMLParserProtocol> parentParser;
	NSMutableString *currentText;
}
- (id)initWithElementName:(NSString *)name namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
			   attributes:(NSDictionary *)attributeDict;

- (NSArray *)childElementsWithElementName:(NSString *)elementName;

@end
