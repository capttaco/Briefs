//
//  BFTextCellController.m
//  Briefs
//
//  Created by Rob Rhyne on 9/22/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import "BFTextCellController.h"


@implementation BFTextCellController

- (id)initWithLabel:(NSString *)label
{
  self = [super init];
  if (self != nil) {
    labelText = label;
  }
  return self;
}

- (NSString *)savedValue
{
  return savedValue;
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
    UITextField *textField = [[[UITextField alloc] initWithFrame:textFrame] autorelease];
    textField.placeholder = labelText;
    textField.text = savedValue;
    cell.accessoryView = textField;
    [textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventValueChanged];
  }
  
  return cell;
}

- (void) textChanged:(UITextField *)source 
{
  savedValue = source.text;
}


- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


///////////////////////////////////////////////////////////////////////////////

@end
