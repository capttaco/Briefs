//
//  FPItem.h
//  FeedParser
//
//  Created by Kevin Ballard on 4/4/09.
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
#import "FPXMLParser.h"

@class FPLink;
@class FPEnclosure;

@interface FPItem : FPXMLParser {
@private
	NSString *title;
	FPLink *link;
	NSMutableArray *links;
	NSString *guid;
	NSString *content;
	NSDate *pubDate;
	NSString *creator; // <dc:creator>
	FPEnclosure *enclosure;
	NSString *category;
}
@property (nonatomic, copy, readonly) NSString *title;
// RSS <link> or Atom <link rel="alternate">
// If multiple qualifying links exist, returns the first
@property (nonatomic, copy, readonly) FPLink *link;
// An array of FPLink objects corresponding to Atom <link> elements
// RSS <link> elements are treated as Atom <link rel="alternate"> elements
@property (nonatomic, copy, readonly) NSArray *links;
@property (nonatomic, copy, readonly) NSString *guid;
@property (nonatomic, copy, readonly) NSString *content;
@property (nonatomic, copy, readonly) NSString *creator; // <dc:creator>
@property (nonatomic, copy, readonly) NSDate *pubDate;
@property (nonatomic, copy, readonly) FPEnclosure *enclosure;
@property (nonatomic, copy, readonly) NSString *category;
// parent class defines property NSArray *extensionElements
// parent class defines method - (NSArray *)extensionElementsWithXMLNamespace:(NSString *)namespaceURI
// parent class defines method - (NSArray *)extensionElementsWithXMLNamespace:(NSString *)namespaceURI elementName:(NSString *)elementName
@end
