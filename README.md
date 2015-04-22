# [![PureLayout](https://github.com/smileyborg/PureLayout/blob/master/Images/PureLayout.png?raw=true)](#)
[![Build Status](http://img.shields.io/travis/smileyborg/PureLayout.svg?style=flat)](https://travis-ci.org/smileyborg/PureLayout) [![Test Coverage](http://img.shields.io/coveralls/smileyborg/PureLayout.svg?style=flat)](https://coveralls.io/r/smileyborg/PureLayout) [![Version](http://img.shields.io/cocoapods/v/PureLayout.svg?style=flat)](http://cocoapods.org/?q=PureLayout) [![Platform](http://img.shields.io/cocoapods/p/PureLayout.svg?style=flat)](http://cocoapods.org/?q=PureLayout) [![License](http://img.shields.io/cocoapods/l/PureLayout.svg?style=flat)](LICENSE)

The ultimate API for iOS & OS X Auto Layout — impressively simple, immensely powerful. PureLayout extends `UIView`/`NSView`, `NSArray`, and `NSLayoutConstraint` with a comprehensive Auto Layout API that is modeled after Apple's own frameworks. PureLayout is an Objective-C library that also works (and looks!) great with Swift using a bridging header.

Writing Auto Layout code from scratch isn't easy. PureLayout provides a fully capable and developer-friendly interface for Auto Layout. It is designed for clarity and simplicity, and takes inspiration from the AutoLayout UI options available in Interface Builder while delivering far more flexibility. The API is also highly efficient, as it adds only a thin layer of third party code and is engineered for maximum performance.

## API Cheat Sheet
This is just a handy overview of the core API methods. Explore the [header files](PureLayout/PureLayout) for the full API, and find the complete documentation above the implementation of each method in the corresponding .m file. A couple of notes:

*	All of the public API methods are namespaced with the prefix `auto...`, which also makes it easy for Xcode to autocomplete as you type.
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

### [`UIView`/`NSView`](PureLayout/PureLayout/ALView%2BPureLayout.h)

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

### [`NSArray`](PureLayout/PureLayout/NSArray%2BPureLayout.h)

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

### [`NSLayoutConstraint`](PureLayout/PureLayout/NSLayoutConstraint%2BPureLayout.h)

	- autoInstall
    - autoRemove
    - autoIdentify: // iOS 7.0+, OS X 10.9+ only

## Setup
*Note: PureLayout requires a minimum deployment target of iOS 6.0 or OS X 10.7*

### Using [CocoaPods](http://cocoapods.org)
1.	Add the pod `PureLayout` to your [Podfile](http://guides.cocoapods.org/using/the-podfile.html).

    	pod 'PureLayout'

2.	Run `pod install` from Terminal, then open your app's `.xcworkspace` file to launch Xcode.
3.	Import the `PureLayout.h` header. Typically, this should be written as `#import <PureLayout/PureLayout.h>`

That's it - now go write some beautiful Auto Layout code!

### Using [Carthage](https://github.com/Carthage/Carthage)
1.  Add the `smileyborg/PureLayout` project to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile).

        github "smileyborg/PureLayout"

2.  Run `carthage update`, then follow the [additional steps required](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application) to add the iOS and/or Mac frameworks into your project.
3.  Import the PureLayout framework/module (with the appropriate name for the platform you're using it on).
    *  Using Modules: `@import PureLayout_iOS` or `@import PureLayout_Mac`
    *  Without Modules: `#import <PureLayout_iOS/PureLayout_iOS.h>` or `#import <PureLayout_Mac/PureLayout_Mac.h>`

That's it - now go write some beautiful Auto Layout code!

### Manually from GitHub
1.	Download the source files in the [PureLayout subdirectory](PureLayout/PureLayout).
2.	Add the source files to your Xcode project.
3.	Import the `PureLayout.h` header.

That's it - now go write some beautiful Auto Layout code!

### App Extensions
To use PureLayout in an App Extension, you need to do a bit of extra configuration to prevent usage of unavailable APIs. [Click here](https://github.com/smileyborg/PureLayout/wiki/App-Extensions) for more info.

### Releases
Releases are tagged in the git commit history using [semantic versioning](http://semver.org). Check out the [releases and release notes](https://github.com/smileyborg/PureLayout/releases) for each version.

## Usage
### Example Project
Open the project included in the repository (requires Xcode 6 or higher). It contains [iOS](PureLayout/Example-iOS) (`Example-iOS` scheme) and [OS X](PureLayout/Example-Mac) (`Example-Mac` scheme) demos of the library being used in various scenarios.

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
*	High-level Auto Layout Libraries/DSLs ([Cartography](https://github.com/robb/Cartography), [SnapKit](https://github.com/SnapKit/SnapKit), [KeepLayout](https://github.com/iMartinKiss/KeepLayout))
	*	Pros: Very clean, concise, and convenient 
	*	Cons: Unique API style is foreign to Cocoa APIs, mixed compatibility with Objective-C & Swift, greater dependency on third party code
	
PureLayout takes a balanced approach to Auto Layout that makes it well suited for any project.

## Problems, Suggestions, Pull Requests?
Please open a [new Issue here](https://github.com/smileyborg/PureLayout/issues/new) if you run into an issue, have a feature request, or want to share a comment. Note that general Auto Layout questions should be asked on [Stack Overflow](http://stackoverflow.com).

If you're considering taking on significant changes or additions to the project, please communicate in advance by opening a new Issue. This allows everyone to get onboard with upcoming changes, ensures that changes align with the project's design philosophy, and avoids duplicated work.

## Meta
Designed & maintained by Tyler Fox ([@smileyborg](https://twitter.com/smileyborg)). Distributed with the MIT license.
