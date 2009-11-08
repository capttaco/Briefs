//
//  BFRemoteBriefCellController.m
//  Briefs
//
//  Created by Rob Rhyne on 11/7/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFRemoteBriefCellController.h"


@implementation BFRemoteBriefCellController

@synthesize delegate;

- (id)initWithLocationOfBrief:(NSString *)url andDelegate:(id<BFRemoteBriefEventDelegate>)remote 
{
    self = [super initWithButtonLabel:@"Download this Brief"];
    if (self != nil) {
        locationOfRemoteBrief = url;
        self.delegate = remote;
    }
    
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
    if ([self.delegate respondsToSelector:@selector(shouldDownloadBrief:atURL:)]) {
        [self.delegate shouldDownloadBrief:self atURL:locationOfRemoteBrief];
    }
}

@end
