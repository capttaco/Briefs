//
//  FPParser.m
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

#import "FPParser.h"
#import "FPFeed.h"
#import "FPErrors.h"

NSString * const FPParserErrorDomain = @"FPParserErrorDomain";

@interface FPParser ()
- (FPFeed *)parseData:(NSData *)data error:(NSError **)error;
@end

@implementation FPParser
+ (void)initialize {
	if (self == [FPParser class]) {
		[self registerHandler:@selector(rss_rss:parser:) forElement:@"rss" namespaceURI:@"" type:FPXMLParserStreamElementType];
		[self registerHandler:@selector(rss_channel:parser:) forElement:@"channel" namespaceURI:@"" type:FPXMLParserStreamElementType];
		[self registerHandler:@selector(atom_feed:parser:) forElement:@"feed" namespaceURI:kFPXMLParserAtomNamespaceURI type:FPXMLParserStreamElementType];
	}
}

+ (FPFeed *)parsedFeedWithData:(NSData *)data error:(NSError **)error {
	FPParser *parser = [[[FPParser alloc] init] autorelease];
	return [parser parseData:data error:error];
}

- (void)dealloc {
	[feed release];
	[errorString release];
	[super dealloc];
}

#pragma mark -

- (FPFeed *)parseData:(NSData *)data error:(NSError **)error {
	NSXMLParser *xmlParser = [[[NSXMLParser alloc] initWithData:data] autorelease];
	if (xmlParser == nil) {
		if (error) *error = [NSError errorWithDomain:FPParserErrorDomain code:FPParserInternalError userInfo:nil];
		return nil;
	}
	parseDepth = 1;
	[xmlParser setDelegate:self];
	[xmlParser setShouldProcessNamespaces:YES];
	if ([xmlParser parse]) {
		if (feed != nil) {
			FPFeed *retFeed = [feed autorelease];
			feed = nil;
			[errorString release]; errorString = nil;
			return retFeed;
		} else {
			// nil means we aborted, but NSXMLParser didn't record the error
			// there's a bug in NSXMLParser which means aborting in some cases produces no error value
			if (errorString == nil) {
				// no errorString means the parse actually succeeded, but didn't contain a feed
				errorString = @"The XML document did not contain a feed";
			}
			NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errorString forKey:NSLocalizedDescriptionKey];
			[errorString release]; errorString = nil;
			if (error) *error = [NSError errorWithDomain:FPParserErrorDomain code:FPParserInvalidFeedError userInfo:userInfo];
			return nil;
		}
	} else {
		[feed release]; feed = nil;
		if (error) {
			*error = [xmlParser parserError];
			if ([[*error domain] isEqualToString:NSXMLParserErrorDomain]) {
				if ([*error code] == NSXMLParserInternalError) {
					NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errorString forKey:NSLocalizedDescriptionKey];
					*error = [NSError errorWithDomain:FPParserErrorDomain code:FPParserInternalError userInfo:userInfo];
				} else {
					// adjust the error localizedDescription to include the line number
					NSString *desc = [NSString stringWithFormat:@"line %ld: %@", [xmlParser lineNumber], [*error localizedDescription]];
					NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[*error userInfo]];
					[userInfo setObject:desc forKey:NSLocalizedDescriptionKey];
					*error = [NSError errorWithDomain:[*error domain] code:[*error code] userInfo:userInfo];
				}
			}
		}
		[errorString release]; errorString = nil;
		return nil;
	}
}

- (void)abortParsing:(NSXMLParser *)parser withString:(NSString *)description {
	[feed release];
	feed = nil;
	//[errorString release];
	if (description == nil) {
		//errorString = [[NSString stringWithFormat:@"Invalid feed data at line %ld", [parser lineNumber]] copy];
		errorString = [[NSString alloc] initWithFormat:@"Invalid feed data at line %ld", [parser lineNumber]];
	} else {
		errorString = [description copy];
	}
	[super abortParsing:parser withString:description];
}

#pragma mark XML Parser methods

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	[feed release];
	feed = nil;
	lookingForChannel = NO;
}

#pragma mark Element handlers

- (void)rss_rss:(NSDictionary *)attributes parser:(NSXMLParser *)parser {
	if (feed != nil || lookingForChannel) {
		[self abortParsing:parser];
	} else {
		NSString *version = [attributes objectForKey:@"version"];
		if ([version isEqualToString:@"2.0"] || [version isEqualToString:@"0.92"] || [version isEqualToString:@"0.91"]) {
			lookingForChannel = YES;
		} else {
			[self abortParsing:parser];
		}
	}
}

- (void)rss_channel:(NSDictionary *)attributes parser:(NSXMLParser *)parser {
	if (feed != nil || !lookingForChannel) {
		[self abortParsing:parser];
	} else {
		feed = [[FPFeed alloc] initWithBaseNamespaceURI:baseNamespaceURI];
		[feed acceptParsing:parser];
		lookingForChannel = NO;
	}
}

- (void)atom_feed:(NSDictionary *)attributes parser:(NSXMLParser *)parser {
	if (feed != nil || lookingForChannel) {
		[self abortParsing:parser];
	} else {
		feed = [[FPFeed alloc] initWithBaseNamespaceURI:baseNamespaceURI];
		[feed acceptParsing:parser];
	}
}
@end
