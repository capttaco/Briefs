//
//  BFRemoteBriefSaver.h
//  Briefs
//
//  Created by Rob Rhyne on 4/10/10.
//  Copyright Digital Arch Design, 2009-2010. See LICENSE file for details.
//

@protocol BFRemoteBriefSaverDelegate;
@interface BFRemoteBriefSaver : UIViewController 
{
    IBOutlet UILabel                *promptLabel;
    id<BFRemoteBriefSaverDelegate>  __unsafe_unretained delegate;
}

@property (unsafe_unretained) id<BFRemoteBriefSaverDelegate> delegate;

- (IBAction)didFinishWithSave;
- (IBAction)didFinishWithCancel;

- (void)setPromptLabelText:(NSString *)prompt;

@end



@protocol BFRemoteBriefSaverDelegate

- (void)view:(id)sender shouldDismissAndSave:(BOOL)animated;
- (void)view:(id)sender shouldDismissAndCancel:(BOOL)animated;

@end