//
//  BFTextCellController.m
//  Briefs
//
//  Created by Rob Rhyne on 9/22/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFTextCellController.h"


@implementation BFTextCellController
@synthesize savedValue, labelText;

- (id)initWithLabel:(NSString *)label
{
  self = [super init];
  if (self != nil) {
    self.labelText = label;
    self.savedValue = [NSString string];
  }
  return self;
}

//- (NSString *)savedValue
//{
//  return self.savedValue;
//}

- (void)dealloc 
{
  [self.labelText release];
  [self.savedValue release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Cell Controller methods

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"TextCell"];
  if (cell == nil) {
    CGRect cellFrame = CGRectMake(0, 0, 300, 45);
    CGRect textFrame = CGRectMake(20, 10, 280, 25);
    
    cell = [[[UITableViewCell alloc] initWithFrame:cellFrame reuseIdentifier:@"TextCell"] autorelease];
    UITextField *textField = [[UITextField alloc] initWithFrame:textFrame];
    textField.placeholder = self.labelText;
    textField.text = self.savedValue;
    cell.accessoryView = textField;
    [textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
  }
  
  return cell;
}

- (void)textChanged:(UITextField *)source 
{
  if (![self.savedValue isEqual:source.text]) {
    self.savedValue = source.text;
  }
}

///////////////////////////////////////////////////////////////////////////////

@end
