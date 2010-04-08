//
//  BFMainViewController.h
//  Briefs
//
//  Created by Rob Rhyne on 1/1/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//


// Display states for various start-up conditions
typedef enum {
    /** Start-up triggered by a brief:// or briefcast:// url */
    BFMainViewOpenedByURL = -2100,
    
    /** restarting the app, after it was interuppted while showing a brief */
    BFMainViewClosedWhilePlayingBrief = -2101,
    
    /** user has not entered any new briefs or briefcasts, encourage them */
    BFMainViewNoDataToDisplay = -2102,
    
    /** the default state, which presents recently opened briefs/briefcasts */
    BFMainViewDefaultState = -2103,
    
    /** first time the user opens the app, show welcome launch */
    BFMainViewFirstTimeOpened = -2104,
    
} BFMainViewState;


@interface BFMainViewController : UIViewController
{
    IBOutlet UIView     *openingView;
    IBOutlet UIView     *menuView;
    
    BFMainViewState     stateUponLaunch;
    
    // optional context ivars
    NSURL                   *urlLaunchWith;
}

// Initialization
- (id)initWithState:(BFMainViewState)state;
- (id)initWithExternalURL:(NSURL *)url;

// Menu Actions
- (IBAction)browseYourBriefs;
- (IBAction)browseYourBriefcasts;

@end
