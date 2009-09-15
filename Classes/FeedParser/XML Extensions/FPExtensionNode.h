//
//  FPExtensionNode.h
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

// FPExtensionNode is used to represent extension elements outside of the RSS/Atom namespaces
// conceptually this is an extremely simplified NSXMLNode
// it can represent either textual data (FPExtensionTextNode) or an element (FPExtensionElementNode)
@interface FPExtensionNode : NSObject {
}
@property (nonatomic, readonly) BOOL isElement;
@property (nonatomic, readonly) BOOL isTextNode;

// stringValue returns a string representing the node
// for text nodes, it returns the text associated with the node
// for element nodes, it returns a concatenation of the stringValue of all its children
// this means that any child element nodes get effectively flattened out and disappear
@property (nonatomic, readonly) NSString *stringValue;

// The following properties are only valid for element nodes
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *qualifiedName; // returns the name as existed in the XML source
@property (nonatomic, readonly) NSString *namespaceURI;
@property (nonatomic, readonly) NSDictionary *attributes;
@property (nonatomic, readonly) NSArray *children; // an array of FPExtensionNodes
@end
