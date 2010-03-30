//
//  BFBriefCellController.m
//  Briefs
//
//  Created by Rob Rhyne on 9/19/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFBriefCellController.h"
#import "BFSceneManager.h"
#import "BFSceneViewController.h"
#import "BFPresentationDispatch.h"
#import "BFDataManager.h"
#import "BFColor.h"


#define kRightAccessoryNormalRect           CGRectMake(271.0f, 0.0f,  49.0f,  80.0f)
#define kRightAccessoryExpandedRect         CGRectMake(240.0f, 0.0f,  80.0f,  80.0f)
#define kInstallButtonNormalRect            CGRectMake(271.0f, 23.0f, 42.0f,  24.0f)
#define kInstallButtonExpandedRect          CGRectMake(240.0f, 23.0f, 72.0f,  24.0f)

@interface BFBriefCellController (PrivateMethods)

- (void)setInstallButtonExpanded:(BOOL)expand;

@end



@implementation BFBriefCellController
@synthesize brief, delegate;

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSObject overrides

- (id)initWithEnclosure:(FPItem *)item installType:(BFBriefCellInstallType)install;
{
    self = [self init];
    if (self != nil) {
        self.brief = item;
        isSelected = NO;
        isInstallButtonExpanded = NO;
    }
    return self;
}

- (void)dealloc
{
    [self.brief release];
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Button Actions

- (IBAction)shouldBeginRemotePlay
{
}

- (IBAction)shouldStartDownloadingBrief
{
    if (!isInstallButtonExpanded) {
        
        // if not in download mode, set the 
        // mode to download mode
        
        [self setInstallButtonExpanded:YES];
    }
    
    else {
        
        // if already in download mode, then
        // download the brief to local storage
        
        [self.delegate shouldDownloadBrief:self atURL:brief.enclosure.url];
        
    }
}

- (void)expandButtonDidStop:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context
{
    NSNumber *expand = context;
    NSString *label = ([expand boolValue]) ? @"INSTALL" : @"NEW";
    [installButton setTitle:label forState:UIControlStateNormal];
}

- (void)setInstallButtonExpanded:(BOOL)expand
{
    [UIView beginAnimations:@"Toggle Download Mode" context:[NSNumber numberWithBool:expand]];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(expandButtonDidStop:finished:context:)];
    [installButton setTitle:@"" forState:UIControlStateNormal];

    if (expand) {
        // expand the button
//        rightAccessoryView.frame = kRightAccessoryExpandedRect;
        installButton.frame = kInstallButtonExpandedRect;
    }
    
    else {
        // unexpand the button
//        rightAccessoryView.frame = kRightAccessoryNormalRect;
        installButton.frame = kInstallButtonNormalRect;
    }
    
    [UIView commitAnimations];
    isInstallButtonExpanded = expand;
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Cell Controller methods

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"BriefsCell"];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"BFBriefCellController" owner:self options:nil];
        cell = (UITableViewCell *) [nibArray objectAtIndex:0];
    }
    
    titleLabel.text = self.brief.title;
    indexLabel.text = [NSString stringWithFormat:@"%i", indexPath.row+1];
    descLabel.text = self.brief.content;
    
    [leftAccessoryView addSubview:indexView];
    
    // style install/update button
    UIImage *buttonBG = [[UIImage imageNamed:@"install-button.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:0];
    [installButton setBackgroundImage:buttonBG forState:UIControlStateNormal];
//    installButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    
    return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isInstallButtonExpanded) {
        
        // If not in download mode, display (or hide)
        // the remote play controls
        
        [UIView beginAnimations:@"flip-over play controls" context:nil];
        [UIView setAnimationDuration:0.5f];
        
        if (!isSelected) {
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:leftAccessoryView cache:YES];
            [leftAccessoryView addSubview:remotePlayView];
            [indexView removeFromSuperview];
        }
        
        else {
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:leftAccessoryView cache:YES];
            [leftAccessoryView addSubview:indexView];
            [remotePlayView removeFromSuperview];
        }
        
        isSelected = !isSelected;
        [UIView commitAnimations];
    }
    
    else {
        
        // Else, clear out the download mode
        
        [self setInstallButtonExpanded:NO];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

///////////////////////////////////////////////////////////////////////////////

@end
