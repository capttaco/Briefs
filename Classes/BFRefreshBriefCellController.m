//
//  BFRefreshBriefCellController.m
//  Briefs
//
//  Created by Rob Rhyne on 5/1/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFRefreshBriefCellController.h"
#import "BFSceneManager.h"
#import "BFPresentationDispatch.h"
#import "BFDataManager.h"
#import "BFConfig.h"

@implementation BFRefreshBriefCellController
@synthesize brief, navigation;

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSObject overrides

- (id)initWithBrief:(BriefRef *)item
{
    self = [self init];
    if (self != nil) {
        self.brief = item;
        cell = nil;
    }
    return self;
}

- (void)dealloc
{
    self.brief;
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark BFLoadingViewDelegate Methods

- (IBAction)updateBriefData
{
    NSLog(@"Is the accessory view registering the taps?");

    // setup the loading controller
    NSString *location = self.brief.fromURL;
    BFLoadingViewController *loadingController = [[BFLoadingViewController alloc] initWithNibName:@"CellRefreshLoad" bundle:nil];
    loadingController.view.frame = CGRectOffset(loadingController.view.frame, 60.0f, 5.0f);
    
    loadingController.view.alpha = 0.0;
    [cell addSubview:[loadingController view]];
    [UIView beginAnimations:@"fade-in refresh view" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.5f];
    
    name.alpha = 0.0f;
    desc.alpha = 0.0f;
    [(UIButton *)cell.accessoryView setEnabled:NO];
    
    loadingController.view.alpha = 1.0f;
    
    [UIView commitAnimations];
    
    [loadingController setDelegate:self];
    [loadingController load:location withStatus:@"Changing underwear..."];
}

- (void)loadingFadeDidStop:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context
{
    BFLoadingViewController *controller = (__bridge BFLoadingViewController*)context;
    [[controller view] removeFromSuperview];
}

- (void)beginLoadingFadeOutAnimation:(id)loading
{
    BFLoadingViewController *controller = loading;
    [UIView beginAnimations:@"fade-out refresh view" context:(__bridge void*)controller];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(loadingFadeDidStop:finished:context:)];
    
    name.alpha = 1.0f;
    desc.alpha = 1.0f;
    controller.view.alpha = 0.0f;
    [(UIButton *)cell.accessoryView setEnabled:YES];
    
    [UIView commitAnimations];
}

- (void)loadingView:(BFLoadingViewController *)controller didCompleteWithData:(NSData *)data
{    
    [self performSelector:@selector(beginLoadingFadeOutAnimation:) withObject:controller afterDelay:1.0f];
    
    // refresh data
    self.brief = [[BFDataManager sharedBFDataManager] updateBrief:self.brief usingData:data];
}

- (void)loadingView:(BFLoadingViewController *)controller didNotCompleteWithError:(NSError *)error
{
    // TODO: handle error
    [self performSelector:@selector(beginLoadingFadeOutAnimation:) withObject:controller afterDelay:1.0f];
}

- (void)loadingView:(BFLoadingViewController *)controller didCancelConnection:(NSString *)url
{
    // TODO: handle cancelation
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Cell Controller methods

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell = [tv dequeueReusableCellWithIdentifier:@"BriefsReloadCell"];
    //if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"BFRefreshBriefCell" owner:self options:nil];
        cell = (UITableViewCell *) [nibArray objectAtIndex:0];
    //}
    
    name.text = [self.brief title];
    
    // check for null date
    NSString *scenesText = ([self.brief.totalNumberOfScenes intValue] > 1) ? @"scenes" : @"scene";
    if (self.brief.dateLastOpened == nil)
        desc.text = [NSString stringWithFormat:@"%@ %@, never been opened", self.brief.totalNumberOfScenes, scenesText];
        
    else
        desc.text = [NSString stringWithFormat:@"%@ %@, last opened %@", self.brief.totalNumberOfScenes, scenesText,
                     [BFConfig shortDateStringFromDate:self.brief.dateLastOpened]];
    
    
    // Miserable hack to get custom accessory view
    UIImage *refreshImage = [UIImage imageNamed:@"refresh-accessory.png"];
    UIButton *refresh = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    // configure target
    [refresh addTarget:self action:@selector(updateBriefData) forControlEvents:UIControlEventTouchUpInside];
    
    // configure images
    [refresh setImage:refreshImage forState:UIControlStateNormal];
    [refresh setImage:refreshImage forState:UIControlStateSelected];
    [refresh setImage:refreshImage forState:UIControlStateHighlighted];   
    [refresh setImage:[UIImage imageNamed:@"refresh-accessory-disabled.png"] forState:UIControlStateDisabled];
    
    // disable if the brief is local
    if ([brief.fromURL isEqual:kBFLocallyStoredBriefURLString])
        [refresh setEnabled:NO];
    
    cell.accessoryView = refresh;
    
    // calculate background
    UIImage *bgImage, *selectedBgImage;
    if (indexPath.row == 0) {
        // top
        bgImage = [[UIImage imageNamed:@"cell-top.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
        selectedBgImage = [[UIImage imageNamed:@"cell-top-sel.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    } 
    
    else if (indexPath.row == [tv numberOfRowsInSection:indexPath.section]-1) {
        // bottom
        bgImage = [[UIImage imageNamed:@"cell-bottom.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
        selectedBgImage = [[UIImage imageNamed:@"cell-bottom-sel.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    }
    
    else {
        // middle
        bgImage = [[UIImage imageNamed:@"cell-middle.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
        selectedBgImage = [[UIImage imageNamed:@"cell-middle-sel.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    }
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:bgImage];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:selectedBgImage];
    
    return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.brief setDateLastOpened:[NSDate date]];
    [[BFDataManager sharedBFDataManager] save];
    
    NSString *pathToDictionary = [[[BFDataManager sharedBFDataManager] documentDirectory] stringByAppendingPathComponent:[self.brief filePath]];
    BFSceneManager *manager = [[BFSceneManager alloc] initWithPathToDictionary:pathToDictionary];
    BFSceneViewController *sceneController = [[BFSceneViewController alloc] initWithSceneManager:manager];
    
    // wire dispatch
    if ([[BFPresentationDispatch sharedBFPresentationDispatch] viewController] != nil)
        [BFPresentationDispatch sharedBFPresentationDispatch].viewController = nil;
    
    [[BFPresentationDispatch sharedBFPresentationDispatch] setViewController:sceneController];
    [BFPresentationDispatch sharedBFPresentationDispatch].viewController.delegate = self;
    
    // get parent View
    UIView *parentView = [self.navigation view];
    
    [UIView beginAnimations:@"display brief" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(briefShowDidStop:finished:context:)];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:parentView cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.8f];
    
    // swap loader for brief
    [parentView addSubview:[BFPresentationDispatch sharedBFPresentationDispatch].viewController.view];
    
    [UIView commitAnimations];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark BFSceneViewDelegate Methods

- (void)briefShowDidStop:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
}

- (void)sceneView:(BFSceneViewController *)controller shouldDismissView:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
    [cell setSelected:NO animated:YES];
    
    [UIView beginAnimations:@"remove brief" context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigation.view cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.8f];
    
    // swap brief for save view
    [controller.view removeFromSuperview];
    
    [UIView commitAnimations];
    
}



///////////////////////////////////////////////////////////////////////////////

@end
