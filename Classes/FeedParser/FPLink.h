//
//  FPLink.h
//  FeedParser
//
//  Created by Kevin Ballard on 4/10/09.
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


@interface FPLink : NSObject {
@private
	NSString *href;
	NSString *rel;
	NSString *type;
	NSString *title;
}
@property (nonatomic, readonly) NSString *href;
@property (nonatomic, readonly) NSString *rel; // the value of the rel attribute or @"alternate"
@property (nonatomic, readonly) NSString *type; // the value of the type attribute or nil
@property (nonatomic, readonly) NSString *title; // the value of the title attribute or nil
+ (id)linkWithHref:(NSString *)href rel:(NSString *)rel type:(NSString *)type title:(NSString *)title;
- (id)initWithHref:(NSString *)href rel:(NSString *)rel type:(NSString *)type title:(NSString *)title;
@end
