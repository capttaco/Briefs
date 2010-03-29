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


#define kRightAccessoryNormalRect           CGRectMake(271.0f, 0.0f, 49.0f,  80.0f)
#define kRightAccessoryExpandedRect         CGRectMake(240.0f, 0.0f, 80.0f,  80.0f)


@interface BFBriefCellController (PrivateMethods)

- (void)setInstallButtonExpanded:(BOOL)expand;

@end



@implementation BFBriefCellController
@synthesize brief;

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
        
    }
}

- (void)setInstallButtonExpanded:(BOOL)expand
{
    [UIView beginAnimations:@"Toggle Download Mode" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];

    if (expand) {
        // expand the button
        rightAccessoryView.frame = kRightAccessoryExpandedRect;
        [installButton setTitle:@"INSTALL" forState:UIControlStateNormal];

    }
    
    else {
        // unexpand the button
        rightAccessoryView.frame = kRightAccessoryNormalRect;
        [installButton setTitle:@"GET" forState:UIControlStateNormal];
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

         
//    NSString *pathToDictionary = [[[BFDataManager sharedBFDataManager] documentDirectory] stringByAppendingPathComponent:[self.brief filePath]];
//    
//    // setup scene view controller
//    BFSceneManager *manager = [[BFSceneManager alloc] initWithPathToDictionary:pathToDictionary];
//    BFSceneViewController *controller = [[BFSceneViewController alloc] initWithSceneManager:manager];
//    
//    // wire dispatch
//    if ([[BFPresentationDispatch sharedBFPresentationDispatch] viewController] != nil)
//        [BFPresentationDispatch sharedBFPresentationDispatch].viewController = nil;
//    
//    [[BFPresentationDispatch sharedBFPresentationDispatch] setViewController:controller]; 
//    
//    if ([[tv delegate] isKindOfClass:[UIViewController class]]) {
//        UIViewController *tvc = (UIViewController *) [tv delegate];
//        [tvc.navigationController pushViewController:[[BFPresentationDispatch sharedBFPresentationDispatch] viewController] animated:YES];
//    }
//    
//    [controller release];
//    [manager release];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{	
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//        [[BFDataManager sharedBFDataManager] removeBrief:self.brief];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

///////////////////////////////////////////////////////////////////////////////

@end
