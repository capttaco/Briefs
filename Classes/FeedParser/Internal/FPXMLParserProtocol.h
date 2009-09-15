//
//  FPXMLParserProtocol.h
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

/*!
    @protocol
    @abstract    FPXMLParserProtocol declares a protocol for a tree of XML parser delegates
    @discussion  Every class that can be a delegate of the NSXMLParser must conform to this protocol.
				 This ensures that each class can pass parser delegation to its parent appropriately.
*/

@protocol FPXMLParserProtocol <NSObject>
@required
/*!
    @method     
    @abstract   Take over the delegate role for the NSXMLParser
	@param parser The NSXMLParser that is currently parsing the document.
    @discussion The implementation of this method must call [parser setDelegate:self]
				after recording the previous delegate of the parser. The previous
				delegate should be assumed to conform to FPXMLParserProtocol.
*/
- (void)acceptParsing:(NSXMLParser *)parser;
/*!
    @method     
    @abstract   Abort parsing
	@param parser The NSXMLParser that is currently parsing the document.
	@param description A description of the error that occurred. If no description is known, it will be nil.
    @discussion When an error occurs, whether it's an XML error or a validation error,
				the parser must call this method. It should do any cleanup necessary, and
				it must call this same method on its parent parser. If the parent parser
				does not exist, then it must call [parser abortParsing].
				Normally FPXMLParser is the root parser and will abort the parser.
				Be aware that the call to super may cause self to be deallocated.
*/
- (void)abortParsing:(NSXMLParser *)parser withString:(NSString *)description;
@end
