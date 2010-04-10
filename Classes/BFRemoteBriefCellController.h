//
//  BFRemoteBriefCellController.h
//  Briefs
//
//  Created by Rob Rhyne on 11/7/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <Foundation/Foundation.h>
#import "BFButtonCellController.h"
#import "BFBriefcastEventDelegate.h"

@interface BFRemoteBriefCellController : BFButtonCellController 
{
    id delegate;
    NSString *locationOfRemoteBrief;
}

@property (nonatomic, assign) id delegate;

- (id)initWithLocationOfBrief:(NSString *)url andDelegate:(id<BFBriefcastEventDelegate>)remote;

@end
