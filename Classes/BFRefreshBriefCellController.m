//
//  BFRefreshBriefCellController.m
//  Briefs
//
//  Created by Rob Rhyne on 5/1/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

#import "BFRefreshBriefCellController.h"
#import "BFLoadingViewController.h"
#import "BFDataManager.h"
#import "BFConfig.h"

@implementation BFRefreshBriefCellController
@synthesize brief;

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
    [self.brief release];
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark BFLoadingViewDelegate Methods

- (IBAction)updateBriefData
{
    NSLog(@"Is the accessory view registering the taps?");

    // setup the loading controller
    NSString *location = self.brief.fromURL;
    BFLoadingViewController *loadingController = [[BFLoadingViewController alloc] initWithNibName:nil bundle:nil];
    loadingController.view.frame = CGRectMake(10.0f, 0, 300.0f, 50.0f);
    
    loadingController.view.alpha = 0.0;
    [cell addSubview:[loadingController view]];
    [UIView beginAnimations:@"fade-in refresh view" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.5f];
    loadingController.view.alpha = 1.0f;
    [UIView commitAnimations];
    
    [loadingController setDelegate:self];
    [loadingController load:location withStatus:@"Changing underwear..."];
}

- (void)loadingFadeDidStop:(NSString *)animationId finished:(NSNumber *)finished context:(void *)context
{
    BFLoadingViewController *controller = context;
    [[controller view] removeFromSuperview];
}

- (void)beginLoadingFadeOutAnimation:(id)loading
{
    BFLoadingViewController *controller = loading;
    [UIView beginAnimations:@"fade-out refresh view" context:controller];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(loadingFadeDidStop:finished:context:)];
    controller.view.alpha = 0.0f;
    [UIView commitAnimations];
}

- (void)loadingView:(BFLoadingViewController *)controller didCompleteWithData:(NSData *)data
{    
    [self performSelector:@selector(beginLoadingFadeOutAnimation:) withObject:controller afterDelay:1.0f];
    
    // refresh data, reload brief-info
    self.brief = [[BFDataManager sharedBFDataManager] updateBrief:self.brief usingData:data];
    //[self prepareInfoView:briefBeingPreviewed];
    
}

- (void)loadingView:(BFLoadingViewController *)controller didNotCompleteWithError:(NSError *)error
{
    // TODO: handle error
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
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"BFRefreshBriefCell" owner:self options:nil];
        cell = (UITableViewCell *) [nibArray objectAtIndex:0];
    }
    
    name.text = [self.brief title];
    desc.text = [NSString stringWithFormat:@"%@ scenes, last opened %@", 
                                 self.brief.totalNumberOfScenes, [BFConfig shortDateStringFromDate:self.brief.dateLastOpened]];
    
    
    // Miserable hack to get custom accessory view
    UIImage *refreshImage = [UIImage imageNamed:@"refresh-accessory.png"];
    UIButton *refresh = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [refresh addTarget:self action:@selector(updateBriefData) forControlEvents:UIControlEventTouchUpInside];
    [refresh setImage:refreshImage forState:UIControlStateNormal];
    [refresh setImage:refreshImage forState:UIControlStateSelected];
    [refresh setImage:refreshImage forState:UIControlStateHighlighted];    
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
    // TODO: launch brief
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

///////////////////////////////////////////////////////////////////////////////

@end
