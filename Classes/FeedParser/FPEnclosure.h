//
//  FPEncslosure.h
//
//  Created by Patrick O'Shaughnessey on 8/24/09.
//  Copyright 2009 Patched Reality. All rights reserved.
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


@interface FPEnclosure : NSObject {
@private
	NSString *url;
	NSString *type;
	NSNumber *length;
}
@property (nonatomic, readonly) NSString *url;
@property (nonatomic, readonly) NSString *type; // the value of the type attribute or nil
@property (nonatomic, readonly) NSNumber *length; // the value of the length or nil
+ (id)enclosureWithURL:(NSString *)url type:(NSString *)type length:(NSNumber *)length;
- (id)initWithURL:(NSString *)url type:(NSString *)type length:(NSNumber *)length;
@end
