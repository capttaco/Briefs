//
//  FPItem.m
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

#import "FPItem.h"
#import "FPLink.h"
#import "NSDate_FeedParserExtensions.h"
#import "FPEnclosure.h"

@interface FPItem ()
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSString *guid;
@property (nonatomic, copy, readwrite) NSString *content;
@property (nonatomic, copy, readwrite) NSString *creator;
@property (nonatomic, copy, readwrite) NSDate *pubDate;
@property (nonatomic, copy, readwrite) NSString *category;
- (void)rss_pubDate:(NSString *)textValue attributes:(NSDictionary *)attributes parser:(NSXMLParser *)parser;
- (void)rss_link:(NSString *)textValue attributes:(NSDictionary *)attributes parser:(NSXMLParser *)parser;
- (void)atom_link:(NSDictionary *)attributes parser:(NSXMLParser *)parser;
- (void)rss_enclosure:(NSString *)textValue attributes:(NSDictionary *)attributes parser:(NSXMLParser *)parser;
@end

@implementation FPItem
@synthesize title, link, links, guid, content, pubDate, enclosure, category;
@synthesize creator;

+ (void)initialize {
	if (self == [FPItem class]) {
		[self registerHandler:@selector(setTitle:) forElement:@"title" namespaceURI:@"" type:FPXMLParserTextElementType];
		[self registerHandler:@selector(rss_link:attributes:parser:) forElement:@"link" namespaceURI:@"" type:FPXMLParserTextElementType];
		[self registerHandler:@selector(setGuid:) forElement:@"guid" namespaceURI:@"" type:FPXMLParserTextElementType];
		[self registerHandler:@selector(setContent:) forElement:@"description" namespaceURI:@"" type:FPXMLParserTextElementType];
		[self registerHandler:@selector(rss_pubDate:attributes:parser:) forElement:@"pubDate" namespaceURI:@"" type:FPXMLParserTextElementType];
		[self registerHandler:@selector(rss_enclosure:attributes:parser:) forElement:@"enclosure" namespaceURI:@"" type:FPXMLParserTextElementType];
		[self registerHandler:@selector(setCategory:) forElement:@"category" namespaceURI:@"" type:FPXMLParserTextElementType];
		for (NSString *key in [NSArray arrayWithObjects:@"author", @"comments", @"source", nil]) {
			[self registerHandler:NULL forElement:key namespaceURI:@"" type:FPXMLParserSkipElementType];
		}
		// Atom
		[self registerHandler:@selector(atom_link:parser:) forElement:@"link" namespaceURI:kFPXMLParserAtomNamespaceURI
						 type:FPXMLParserSkipElementType];
		// DublinCore
		[self registerHandler:@selector(setCreator:) forElement:@"creator"
				 namespaceURI:kFPXMLParserDublinCoreNamespaceURI type:FPXMLParserTextElementType];
	}
}

- (id)initWithBaseNamespaceURI:(NSString *)namespaceURI {
	if (self = [super initWithBaseNamespaceURI:namespaceURI]) {
		links = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)rss_pubDate:(NSString *)textValue attributes:(NSDictionary *)attributes parser:(NSXMLParser *)parser {
	NSDate *date = [NSDate dateWithRFC822:textValue];
	self.pubDate = date;
	if (date == nil) [self abortParsing:parser];
}

- (void)rss_link:(NSString *)textValue attributes:(NSDictionary *)attributes parser:(NSXMLParser *)parser {
	FPLink *aLink = [[FPLink alloc] initWithHref:textValue rel:@"alternate" type:nil title:nil];
	if (link == nil) {
		link = [aLink retain];
	}
	[links addObject:aLink];
	[aLink release];
}

- (void)rss_enclosure:(NSString *)textValue attributes:(NSDictionary *)attributes parser:(NSXMLParser *)parser {	
	FPEnclosure *anEnclosure = [[FPEnclosure alloc] initWithURL:[attributes objectForKey:@"url"] type:[attributes objectForKey:@"type"] length:[attributes objectForKey:@"length"]];
	enclosure = [anEnclosure retain];
	[anEnclosure release];
}

- (void)atom_link:(NSDictionary *)attributes parser:(NSXMLParser *)parser {
	NSString *href = [attributes objectForKey:@"href"];
	if (href == nil) return; // sanity check
	FPLink *aLink = [[FPLink alloc] initWithHref:href rel:[attributes objectForKey:@"rel"] type:[attributes objectForKey:@"type"]
										   title:[attributes objectForKey:@"title"]];
	if (link == nil && [aLink.rel isEqualToString:@"alternate"]) {
		link = [aLink retain];
	}
	[links addObject:aLink];
	[aLink release];
}

- (void)dealloc {
	[title release];
	[link release];
	[enclosure release];
	[links release];
	[guid release];
	[content release];
	[pubDate release];
	[creator release];
	[category release];
	[super dealloc];
}
@end
