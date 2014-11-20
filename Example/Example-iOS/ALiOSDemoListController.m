//
//  ALiOSDemoListController.m
//  PureLayout Example-iOS
//
//  Copyright (c) 2014 Tyler Fox
//  https://github.com/smileyborg/PureLayout
//

#import "ALiOSDemoListController.h"

@interface ALiOSDemoListController ()

@property (nonatomic, readonly) NSArray *demoTitles;

@end

@implementation ALiOSDemoListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"PureLayout iOS Demos";
}

- (NSArray *)demoTitles
{
    return @[
             @"Basic Auto Layout", // Demo 1
             @"Working with Arrays of Views", // Demo 2
             @"Distributing Views", // Demo 3
             @"Leading & Trailing Attributes", // Demo 4
             @"Cross-Attribute Constraints", // Demo 5
             @"Priorities & Inequalities", // Demo 6
             @"Animating Constraints", // Demo 7
             @"Constraint Identifiers (iOS 7.0+)", // Demo 8
             @"Layout Margins (iOS 8.0+)", // Demo 9
             @"Constraints Without Installing" // Demo 10
             ];
}

- (NSString *)textForDemoAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = self.demoTitles[indexPath.row];
    text = [NSString stringWithFormat:@"%@. %@", @(indexPath.row + 1), text];
    return text;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.demoTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil]; // not bothering to reuse cells here
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [self textForDemoAtIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *viewControllerClassName = [NSString stringWithFormat:@"ALiOSDemo%@ViewController", @(indexPath.row + 1)];
    Class viewControllerKlass = NSClassFromString(viewControllerClassName);
    NSAssert(viewControllerKlass, @"Class should not be nil!");
    NSAssert([viewControllerKlass isSubclassOfClass:[UIViewController class]], @"Class should be a view controller!");
    UIViewController *demoViewController = [[viewControllerKlass alloc] initWithNibName:nil bundle:nil];
    if (demoViewController) {
        demoViewController.title = [self textForDemoAtIndexPath:indexPath];
        [self.navigationController pushViewController:demoViewController animated:YES];
    }
}

@end
