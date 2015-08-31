//
//  ALMacAppDelegate.m
//  PureLayout Example-Mac
//
//  Copyright (c) 2014-2015 Tyler Fox
//  https://github.com/PureLayout/PureLayout
//

#import "ALMacAppDelegate.h"
#import "ALMacViewController.h"

@interface ALMacAppDelegate ()
            
@property (weak, nonatomic) IBOutlet NSWindow *window;
@property (strong, nonatomic) ALMacViewController *viewController;

@end

@implementation ALMacAppDelegate
            
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.viewController = [[ALMacViewController alloc] initWithNibName:nil bundle:nil];
    self.viewController.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.window.frame), CGRectGetHeight(self.window.frame));
    [self.window.contentView addSubview:self.viewController.view];
    [self.window makeFirstResponder:self];
    self.window.delegate = self;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}

- (NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize
{
    self.viewController.view.frame = CGRectMake(0, 0, frameSize.width, frameSize.height);
    return frameSize;
}

- (void)keyDown:(NSEvent *)theEvent
{
    // Press any key to advance to the next demo
    [self.viewController nextDemo];
}

@end
