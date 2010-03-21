//
//  BFPreviewBriefViewController.h
//  Briefs
//
//  Created by Rob Rhyne on 3/19/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFPreviewBriefView.h"
#import "BFBriefInfoView.h"
#import "BFBriefDataSource.h"
#import "BriefRef.h"

//  Adapted from code seen on http://cocoawithlove.com/2009/01/multiple-virtual-pages-in-uiscrollview.html
//  
//  The following copyright, accompanied the code:
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.

@interface BFPreviewBriefViewController : UIViewController
{
    IBOutlet BFPreviewBriefView     *previewView;
    IBOutlet BFBriefInfoView        *infoView;
    
    NSInteger                       pageIndex;
    id<BFBriefDataSource>           dataSource;
    BriefRef                        *briefBeingPreviewed;

}

@property (retain)  id<BFBriefDataSource>   dataSource;
@property           NSInteger               pageIndex;

@end
