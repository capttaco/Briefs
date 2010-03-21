//
//  BFPagedBrowseViewController.h
//  Briefs
//
//  Created by Rob Rhyne on 3/19/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFPreviewBriefViewController.h"
#import "BFBriefDataSource.h"

//  Adapted from code seen on http://cocoawithlove.com/2009/01/multiple-virtual-pages-in-uiscrollview.html
//  
//  The following copyright, accompanied his code:
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.


@interface BFPagedBrowseViewController : UIViewController 
{
    IBOutlet UIScrollView           *pagedHorizontalView;
    IBOutlet UIPageControl          *pageControl;

    NSInteger                       currentIndex;
    NSMutableArray                  *pages;
    id<BFBriefDataSource>           dataSource;
}

@property (nonatomic, retain) id<BFBriefDataSource> dataSource;
@property (nonatomic, retain) NSMutableArray        *pages;

- (IBAction)changePage:(id)sender;
- (id)initWithDataSource:(id<BFBriefDataSource>)ref;

@end
