# [![PureLayout](https://github.com/smileyborg/PureLayout/blob/master/Images/PureLayout.png?raw=true)](#)
[![Build Status](http://img.shields.io/travis/smileyborg/PureLayout.svg?style=flat)](https://travis-ci.org/smileyborg/PureLayout) [![Version](http://img.shields.io/cocoapods/v/PureLayout.svg?style=flat)](http://cocoapods.org/?q=PureLayout) [![Platform](http://img.shields.io/cocoapods/p/PureLayout.svg?style=flat)](http://cocoapods.org/?q=PureLayout) [![License](http://img.shields.io/cocoapods/l/PureLayout.svg?style=flat)](LICENSE)

The ultimate API for iOS & OS X Auto Layout — impressively simple, immensely powerful. PureLayout extends `UIView`/`NSView`, `NSArray`, and `NSLayoutConstraint` with a comprehensive Auto Layout API that is modeled after Apple's own frameworks. PureLayout is an Objective-C library that also works (and looks!) great with Swift using a bridging header.

Writing Auto Layout code from scratch isn't easy. PureLayout provides a fully capable and developer-friendly interface for Auto Layout. It is designed for clarity and simplicity, and takes inspiration from the AutoLayout UI options available in Interface Builder while delivering far more flexibility. The API is also highly efficient, as it adds only a thin layer of third party code and is engineered for maximum performance.

## API Cheat Sheet
This is just a handy overview of the core API methods. Explore the [header files](Source) for the full API, and find the complete documentation above the implementation of each method in the corresponding .m file. A couple of notes:

*	All of the API methods are namespaced with the prefix `auto...`, which also allows for easy autocompletion in Xcode!
*	Methods that create constraints also automatically install (activate) the constraint(s), then return the new constraint(s) for you to optionally store for later adjustment or removal.
*	Many methods below also have a variant which includes a `relation:` parameter to make the constraint an inequality.

### Attributes

PureLayout defines view attributes that are used to create auto layout constraints. Here is an [illustration of the most common attributes](Images/PureLayout-CommonAttributes.png).

There are 5 specific attribute types, which are used throughout most of the API:

* `ALEdge`
* `ALDimension`
* `ALAxis`
* `ALMargin` *available in iOS 8.0 and higher only*
* `ALMarginAxis` *available in iOS 8.0 and higher only*

Additionally, there is one generic attribute type, `ALAttribute`, which is effectively a union of all the specific types. You can think of this as the "supertype" of all of the specific attribute types, which means that it is always safe to cast a specific type to the generic `ALAttribute` type. (Note that the reverse is not true -- casting a generic ALAttribute to a specific attribute type is unsafe!)

### [`UIView`/`NSView`](Source/ALView%2BPureLayout.h)

	+ autoCreateConstraintsWithoutInstalling:
    + autoSetPriority:forConstraints:
	+ autoSetIdentifier:forConstraints: // iOS 7.0+, OS X 10.9+ only
    - autoSetContent(CompressionResistance|Hugging)PriorityForAxis:
    - autoCenterInSuperview:
    - autoAlignAxisToSuperviewAxis:
	- autoCenterInSuperviewMargins: // iOS 8.0+ only
	- autoAlignAxisToSuperviewMarginAxis: // iOS 8.0+ only
    - autoPinEdgeToSuperviewEdge:(withInset:)
    - autoPinEdgesToSuperviewEdgesWithInsets:(excludingEdge:)
	- autoPinEdgeToSuperviewMargin: // iOS 8.0+ only
	- autoPinEdgesToSuperviewMargins(ExcludingEdge:) // iOS 8.0+ only
    - autoPinEdge:toEdge:ofView:(withOffset:)
    - autoAlignAxis:toSameAxisOfView:(withOffset:)
    - autoMatchDimension:toDimension:ofView:(withOffset:|withMultiplier:)
    - autoSetDimension(s)ToSize:
    - autoConstrainAttribute:toAttribute:ofView:(withOffset:|withMultiplier:)
    - autoPinTo(Top|Bottom)LayoutGuideOfViewController:withInset: // iOS only

### [`NSArray`](Source/NSArray%2BPureLayout.h)

	// Arrays of Constraints
	- autoInstallConstraints
    - autoRemoveConstraints
    - autoIdentifyConstraints: // iOS 7.0+, OS X 10.9+ only
	
	// Arrays of Views
    - autoAlignViewsToEdge:
    - autoAlignViewsToAxis:
    - autoMatchViewsDimension:
    - autoSetViewsDimension:toSize:
	- autoSetViewsDimensionsToSize:
    - autoDistributeViewsAlongAxis:alignedTo:withFixedSpacing:(insetSpacing:)(matchedSizes:)
    - autoDistributeViewsAlongAxis:alignedTo:withFixedSize:(insetSpacing:)

### [`NSLayoutConstraint`](Source/NSLayoutConstraint%2BPureLayout.h)

	- autoInstall
    - autoRemove
    - autoIdentify: // iOS 7.0+, OS X 10.9+ only

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

### App Extensions
When using PureLayout in an App Extension, define the preprocessor macro `PURELAYOUT_APP_EXTENSIONS` in the Build Settings of your App Extension's target to prevent usage of unavailable APIs. [Click here](https://github.com/smileyborg/PureLayout/wiki/App-Extensions) for more info.

### Releases
Releases are tagged in the git commit history using [semantic versioning](http://semver.org). Check out the [releases and release notes](https://github.com/smileyborg/PureLayout/releases) for each version.

#### Upgrading from v1.x to v2.0?
Upgrading from v1.x of the library to v2.0 should be a very simple and easy process. Please review the [migration guide](https://github.com/smileyborg/PureLayout/wiki/Migrating-from-PureLayout-v1.x-to-v2.0) for more information.

## Usage
### Example Project
Check out the [example project](Example) included in the repository (requires Xcode 6 or higher). It contains iOS and OS X demos of the API being used in various scenarios.

On iOS, you can use different device simulators and rotate the device to see the constraints in action (as well as toggle the taller in-call status bar in the iOS Simulator).

On OS X, while running the app, press any key to cycle through the demos. You can resize the window to see the constraints in action.

### Tips and Tricks
Check out some [Tips and Tricks](https://github.com/smileyborg/PureLayout/wiki/Tips-and-Tricks) to keep in mind when using the API.

## PureLayout vs. the rest
An overview of the Auto Layout options available, ordered from the lowest- to highest-level of abstraction.

*	Apple [NSLayoutConstraint SDK API](https://developer.apple.com/library/ios/documentation/AppKit/Reference/NSLayoutConstraint_Class/index.html#//apple_ref/occ/clm/NSLayoutConstraint/constraintWithItem:attribute:relatedBy:toItem:attribute:multiplier:constant:)
 	*	Pros: Raw power
	*	Cons: Extremely verbose, tedious to write, difficult to read
*	Apple [Visual Format Language](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG/VisualFormatLanguage/VisualFormatLanguage.html)
	*	Pros: Concise, convenient
	*	Cons: Doesn't support some use cases, incomplete compile-time checks, must learn syntax, hard to debug
*	Apple Interface Builder
	*	Pros: Visual, simple
	* 	Cons: Difficult for complex layouts, cannot dynamically set constraints at runtime, encourages hardcoded magic numbers, not always WYSIWYG
*	**PureLayout**
	*	Pros: Simple, efficient, minimal third party code, consistent with Cocoa API style, compatible with Objective-C and Swift codebases
	*	Cons: Not the most concise expression of layout code
*	High-level Auto Layout Libraries/DSLs ([Cartography](https://github.com/robb/Cartography), [Masonry](https://github.com/Masonry/Masonry), [KeepLayout](https://github.com/iMartinKiss/KeepLayout))
	*	Pros: Very clean, concise, and convenient 
	*	Cons: Unique API style is foreign to Cocoa APIs, mixed compatibility with Objective-C & Swift, greater dependency on third party code
	
PureLayout takes a balanced approach to Auto Layout that makes it well suited for any project.

## Problems, Suggestions, Pull Requests?
Bring 'em on! :)

If you're considering taking on significant changes or additions to the project, it's always a good idea to communicate in advance (open a [new Issue here](https://github.com/smileyborg/PureLayout/issues/new)). This allows everyone to get onboard with upcoming changes, ensures that changes align with the project's design philosophy, and avoids duplicated work.

I'm especially interested in hearing about any common use cases that this API does not currently address. Feel free to add feature requests (and view current work in progress) on the [Feature Requests](https://github.com/smileyborg/PureLayout/wiki/Feature-Requests) page of the wiki for this project.

## Meta
Designed & maintained by Tyler Fox ([@smileyborg](https://twitter.com/smileyborg)). Distributed with the MIT license.
