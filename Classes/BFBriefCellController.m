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


#define kInstallButtonNormalRect            CGRectMake(270.0f, 0.0f, 42.0f,  70.0f)
#define kInstallButtonExpandedRect          CGRectMake(240.0f, 0.0f, 72.0f,  70.0f)
#define kInstallButtonBgNormalRect          CGRectMake(270.0f, 23.0f, 42.0f,  24.0f)
#define kInstallButtonBgExpandedRect        CGRectMake(240.0f, 23.0f, 72.0f,  24.0f)



@interface BFBriefCellController (PrivateMethods)

- (void)setInstallButtonExpanded:(BOOL)expand;

@end


@implementation BFBriefCellController
@synthesize brief, delegate;

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSObject overrides

- (id)initWithEnclosure:(FPItem *)item
{
    self = [self init];
    if (self != nil) {
        self.brief = item;
        isSelected = NO;
        isInstallButtonExpanded = NO;
        
        // determine install type
        NSDate *dateBriefLastInstalled = [[BFDataManager sharedBFDataManager] briefFromURLWasInstalledOnDate:self.brief.enclosure.url];
        if (dateBriefLastInstalled == nil)
            installType = BFBriefCellInstallTypeNewInstall;
        else if ([dateBriefLastInstalled compare:self.brief.pubDate] == NSOrderedAscending)
            installType = BFBriefCellInstallTypeUpdate;
        else
            installType = BFBriefCellInstallTypeAlreadyInstalled;
        
        // style install/update button
        UIImage *buttonBG;
        switch (installType) {
            case BFBriefCellInstallTypeUpdate:
                buttonBG = [[UIImage imageNamed:@"update-button.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:0];
                break;
            case BFBriefCellInstallTypeAlreadyInstalled:
                buttonBG = [[UIImage imageNamed:@"already-button.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:0];
                break;
            default:
                buttonBG = [[UIImage imageNamed:@"install-button.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:0];                
        }
        
        installButtonBg = [[UIImageView alloc] initWithImage:buttonBG];

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
        installButtonBg.frame = kInstallButtonBgExpandedRect;
    }
    
    else {
        // unexpand the button
//        rightAccessoryView.frame = kRightAccessoryNormalRect;
        installButton.frame = kInstallButtonNormalRect;
        installButtonBg.frame = kInstallButtonBgNormalRect;
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
    
    if (installButtonBg != nil) {

        CGRect theFrame, theFrameBg;
        switch (installType) {
            case BFBriefCellInstallTypeUpdate:
                [installButton setTitle:@"UPDATE" forState:UIControlStateNormal];
                theFrame = kInstallButtonExpandedRect;
                theFrameBg = kInstallButtonBgExpandedRect;
                break;
                
            case BFBriefCellInstallTypeAlreadyInstalled:
                [installButton setTitle:@"INSTALLED" forState:UIControlStateNormal];
                installButton.enabled = NO;
                theFrame = kInstallButtonExpandedRect;
                theFrameBg = kInstallButtonBgExpandedRect;
                [installButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
                [installButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateDisabled];

                break;

            default:
                [installButton setTitle:@"NEW" forState:UIControlStateNormal];
                theFrame = kInstallButtonNormalRect;
                theFrameBg = kInstallButtonBgNormalRect;

        }
        
        installButtonBg.frame = theFrameBg;
        installButton.frame = theFrame;
        
        [cell addSubview:installButtonBg]; 
        [cell addSubview:installButton];
    }
    
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
