# PureLayout [![Build Status](https://travis-ci.org/smileyborg/PureLayout.svg?branch=master)](https://travis-ci.org/smileyborg/PureLayout)
The ultimate API for iOS & OS X Auto Layout — impressively simple, immensely powerful. PureLayout extends `UIView`/`NSView`, `NSArray`, and `NSLayoutConstraint` with a comprehensive Auto Layout API that is modeled after Apple's own frameworks. PureLayout is an Objective-C library that also works (and looks!) great with Swift using a bridging header.

Writing Auto Layout code from scratch isn't easy. PureLayout provides a fully capable and developer-friendly interface for Auto Layout. It is designed for clarity and simplicity, and takes inspiration from the AutoLayout UI options available in Interface Builder while delivering far more flexibility. The API is also highly efficient, as it adds only a thin layer of third party code and is engineered for maximum performance.

## API Cheat Sheet
This is just a handy overview of the core API methods. Explore the [header files](Source) for the full API and documentation. A couple of notes:

*	*All of the API methods begin with `auto...` for easy autocompletion in Xcode!*
*	*All methods that generate constraints also automatically add the constraint(s) to the correct view, then return the newly created constraint(s) for you to optionally store for later adjustment or removal.*
*	*Many methods below also have a variant which includes a `relation:` parameter to make the constraint an inequality.*

**`ALAttribute`**

Here is an [illustration of the ALAttribute constants](Images/PureLayout-ALAttributes.png) used throughout the API.

**[`UIView`/`NSView`](Source/ALView%2BPureLayout.h)**

    + autoRemoveConstraint(s):
    - autoRemoveConstraintsAffectingView(AndSubviews)
    + autoSetPriority:forConstraints:
    - autoSetContent(CompressionResistance|Hugging)PriorityForAxis:
    - autoCenterInSuperview:
    - autoAlignAxisToSuperviewAxis:
    - autoPinEdgeToSuperviewEdge:withInset:
    - autoPinEdgesToSuperviewEdges:withInsets:(excludingEdge:)
    - autoPinEdge:toEdge:ofView:(withOffset:)
    - autoAlignAxis:toSameAxisOfView:(withOffset:)
    - autoMatchDimension:toDimension:ofView:(withOffset:|withMultiplier:)
    - autoSetDimension(s)ToSize:
    - autoConstrainAttribute:toAttribute:ofView:(withOffset:|withMultiplier:)
    - autoPinTo(Top|Bottom)LayoutGuideOfViewController:withInset: // iOS only

**[`NSArray`](Source/NSArray%2BPureLayout.h)**

    - autoAlignViewsToEdge:
    - autoAlignViewsToAxis:
    - autoMatchViewsDimension:
    - autoSetViewsDimension:toSize:
    - autoDistributeViewsAlongAxis:withFixedSpacing:(insetSpacing:)(matchedSizes:)alignment:
    - autoDistributeViewsAlongAxis:withFixedSize:(insetSpacing:)alignment:

**[`NSLayoutConstraint`](Source/NSLayoutConstraint%2BPureLayout.h)**

    - autoInstall
    - autoRemove

## Setup
*Note: PureLayout requires a minimum deployment target of iOS 6.0 or OS X 10.7*

### Using [CocoaPods](http://cocoapods.org)
1.	Add the pod `PureLayout` to your [Podfile](http://guides.cocoapods.org/using/the-podfile.html).

    	pod 'PureLayout'

2.	Run `pod install` from Terminal, then open your app's `.xcworkspace` file to launch Xcode.
3.	`#import "PureLayout.h"` wherever you want to use the API. *(Hint: add this import to your prefix header (.pch) file so that the API is automatically available everywhere!)*

That's it - now go write some beautifully simple Auto Layout code!

### Manually from GitHub
1.	Download the source files in the [Source directory](Source).
2.	Add the source files to your Xcode project.
3.	`#import "PureLayout.h"` wherever you want to use the API. *(Hint: add this import to your prefix header (.pch) file so that the API is automatically available everywhere!)*

That's it - now go write some beautifully simple Auto Layout code!

### Migrating from [UIView+AutoLayout](https://github.com/smileyborg/UIView-AutoLayout)?
If you are using the latest version of UIView+AutoLayout (v2.0.0), migrating to PureLayout is simple. The API is 100% compatible, so you only need to swap out the pod or library and update `#import "UIView+AutoLayout.h"` to `#import "PureLayout.h"` where necessary.

### Releases
Releases are tagged in the git commit history using [semantic versioning](http://semver.org). Check out the [releases and release notes](https://github.com/smileyborg/PureLayout/releases) for each version.

## Usage
### Example Project
Check out the [example project](Example) included in the repository. It contains iOS and OS X demos of the API being used in various scenarios.

On iOS, while running the app, tap on the screen to cycle through the demos. You can rotate the device to see the constraints in action (as well as toggle the taller in-call status bar in the iOS Simulator).

On OS X, while running the app, press any key to cycle through the demos. You can resize the window to see the constraints in action.

### Tips and Tricks
Check out some [Tips and Tricks](https://github.com/smileyborg/PureLayout/wiki/Tips-and-Tricks) to keep in mind when using the API.

## PureLayout vs. the rest
An overview of the Auto Layout options available, ordered from the lowest- to highest-level of abstraction.

*	Apple [NSLayoutConstraint SDK API](https://developer.apple.com/library/ios/documentation/AppKit/Reference/NSLayoutConstraint_Class/NSLayoutConstraint/NSLayoutConstraint.html#//apple_ref/doc/uid/TP40010628-CH1-SW18)
 	*	Pros: Raw power
	*	Cons: Extremely verbose, tedious to write, difficult to read
*	Apple [Visual Format Language](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG/VisualFormatLanguage/VisualFormatLanguage.html)
	*	Pros: Concise, convenient
	*	Cons: Doesn't support some use cases, incomplete compile-time checks, must learn syntax, hard to debug
*	Apple Interface Builder
	*	Pros: Visual, simple
	* 	Cons: Difficult for complex layouts, cannot dynamically set constraints at runtime, encourages hardcoded magic numbers, not always WYSIWYG
*	**PureLayout**
	*	Pros: Simple, efficient, minimal third party code, consistent with Apple API style, compatible with Objective-C and Swift codebases
	*	Cons: Not the most concise expression of layout code
*	High-level Auto Layout Libraries/DSLs ([Masonry](https://github.com/Masonry/Masonry), [KeepLayout](https://github.com/iMartinKiss/KeepLayout))
	*	Pros: Very clean, concise, and convenient 
	*	Cons: Overloaded Objective-C syntax (Swift incompatible), heavier dependency on third party code, difficult to mix with SDK APIs

## Problems, Suggestions, Pull Requests?
Bring 'em on! :)

If you're considering taking on significant changes or additions to the project, it's always a good idea to communicate in advance (open a [new Issue here](https://github.com/smileyborg/PureLayout/issues/new)). This allows everyone to get onboard with upcoming changes, ensures that changes align with the project's design philosophy, and avoids duplicated work.

I'm especially interested in hearing about any common use cases that this API does not currently address. Feel free to add feature requests (and view current work in progress) on the [Feature Requests](https://github.com/smileyborg/PureLayout/wiki/Feature-Requests) page of the wiki for this project.

## Meta
Designed & maintained by Tyler Fox ([@smileyborg](https://twitter.com/smileyborg)). Distributed with the MIT license.
