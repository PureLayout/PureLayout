//
//  ALiOSDemoListController.m
//  PureLayout Example-iOS
//
//  Copyright (c) 2014-2015 Tyler Fox
//  https://github.com/PureLayout/PureLayout
//

#import "ALiOSDemoListController.h"

NSString *const kLastUsedDemoTypeUserDefaultsKey = @"PureLayout-iOS-Demos-LastUsedDemoType";

@interface ALiOSDemoListController ()

@property (nonatomic, readonly) NSArray *demoTitles;

// Whether to load the Swift (YES) or Objective-C (NO) versions of the demos.
@property (nonatomic, assign) BOOL useSwiftDemos;

@end

@implementation ALiOSDemoListController

@synthesize useSwiftDemos = _useSwiftDemos;

// Recalls and returns the last value of the `useSwiftDemos` flag.
+ (BOOL)recallPreviousUseSwiftDemosValue
{
#if !USING_XCODE7_SCHEME
    return NO;
#endif
    
    id storedDemoType = [[NSUserDefaults standardUserDefaults] objectForKey:kLastUsedDemoTypeUserDefaultsKey];
    if (storedDemoType) {
        NSAssert([storedDemoType isKindOfClass:[NSNumber class]], @"The stored demo type object should be of type NSNumber!");
        return [storedDemoType boolValue];
    }
    
    // Use the Swift demos by default, if there is no persisted value.
    return YES;
}

- (BOOL)useSwiftDemos
{
#if !USING_XCODE7_SCHEME
    return NO;
#endif
    
    return _useSwiftDemos;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"PureLayout iOS Demos";
    
    self.useSwiftDemos = [[self class] recallPreviousUseSwiftDemosValue];
}

- (void)setUseSwiftDemos:(BOOL)useSwiftDemos
{
    _useSwiftDemos = useSwiftDemos;
    
    // When changing between the Swift and Objective-C demos, persist the last used language type so that the demo app always opens back up to it.
    [[NSUserDefaults standardUserDefaults] setObject:@(self.useSwiftDemos) forKey:kLastUsedDemoTypeUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
             @"Constraints Without Installing", // Demo 10
             @"Basic UIScrollView" // Demo 11
             ];
}

- (NSString *)textForDemoAtIndex:(NSUInteger)index
{
    NSString *text = self.demoTitles[index];
    text = [NSString stringWithFormat:@"%@. %@", @(index + 1), text];
    return text;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return self.demoTitles.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    } else {
        NSString *language = self.useSwiftDemos ? @"Swift" : @"Objective-C";
        return [NSString stringWithFormat:@"%@ Demos", language];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil]; // not bothering to reuse cells here
    NSString *text;
    if (indexPath.section == 0) {
        // The very first section is the option to switch between Objective-C and Swift demo files.
#if USING_XCODE7_SCHEME
        cell.textLabel.textColor = [UIColor blueColor];
        cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        NSString *language = self.useSwiftDemos ? @"Objective-C" : @"Swift";
        text = [NSString stringWithFormat:@"Switch to %@ demo files", language];
#else
        cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        text = @"Use Example-iOS-Xcode7 scheme to run Swift demos.";
#endif
    } else {
        // All other rows take you to the actual demos.
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        text = [self textForDemoAtIndex:indexPath.row];
    }
    cell.textLabel.text = text;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // The very first section is the option to switch between Objective-C and Swift demo files.
#if USING_XCODE7_SCHEME
        self.useSwiftDemos = !self.useSwiftDemos;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationRight];
#else
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
#endif
    } else {
        // All other rows take you to the actual demos.
        [self displayDemoAtIndex:indexPath.row];
    }
}

- (void)displayDemoAtIndex:(NSUInteger)index
{
    NSString *viewControllerClassName;
    if (self.useSwiftDemos) {
        viewControllerClassName = [NSString stringWithFormat:@"iOSDemo%@ViewController", @(index + 1)];
    } else {
        viewControllerClassName = [NSString stringWithFormat:@"ALiOSDemo%@ViewController", @(index + 1)];
    }
    Class viewControllerKlass = NSClassFromString(viewControllerClassName);
    NSAssert(viewControllerKlass, @"Class should not be nil!");
    NSAssert([viewControllerKlass isSubclassOfClass:[UIViewController class]], @"Class should be a view controller!");
    UIViewController *demoViewController = [[viewControllerKlass alloc] initWithNibName:nil bundle:nil];
    if (demoViewController) {
        demoViewController.title = [self textForDemoAtIndex:index];
        [self.navigationController pushViewController:demoViewController animated:YES];
    }
}

@end
