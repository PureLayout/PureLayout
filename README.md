# [![PureLayout](https://github.com/PureLayout/PureLayout/blob/master/Images/PureLayout.png?raw=true)](#)
[![Build Status](http://img.shields.io/travis/PureLayout/PureLayout.svg?style=flat)](https://travis-ci.org/PureLayout/PureLayout) [![Test Coverage](http://img.shields.io/coveralls/PureLayout/PureLayout.svg?style=flat)](https://coveralls.io/r/PureLayout/PureLayout) [![Version](http://img.shields.io/cocoapods/v/PureLayout.svg?style=flat)](http://cocoapods.org/?q=PureLayout) [![Platform](http://img.shields.io/cocoapods/p/PureLayout.svg?style=flat)](http://cocoapods.org/?q=PureLayout) [![License](http://img.shields.io/cocoapods/l/PureLayout.svg?style=flat)](LICENSE)

The ultimate API for iOS & OS X Auto Layout — impressively simple, immensely powerful. PureLayout extends `UIView`/`NSView`, `NSArray`, and `NSLayoutConstraint` with a comprehensive Auto Layout API that is modeled after Apple's own frameworks. PureLayout is a cross-platform Objective-C library that works (and looks!) great in Swift. It is fully backwards-compatible with all versions of iOS and OS X that support Auto Layout.

Writing Auto Layout code from scratch isn't easy. PureLayout provides a fully capable and developer-friendly interface for Auto Layout. It is designed for clarity and simplicity, and takes inspiration from the AutoLayout UI options available in Interface Builder while delivering far more flexibility. The API is also highly efficient, as it adds only a thin layer of third party code and is engineered for maximum performance.

### Table of Contents
 1. [Setup](#setup)
 1. [API Cheat Sheet](#api-cheat-sheet)
 1. [Usage](#usage)
   * [Sample Code](#sample-code-swift)
   * [Example Apps](#example-apps)
 1. [PureLayout vs. the rest](#purelayout-vs-the-rest)
 1. [Problems, Suggestions, Pull Requests?](#problems-suggestions-pull-requests)

## Setup
### Compatibility
The current release of PureLayout supports all versions of iOS and OS X since the introduction of Auto Layout on each platform, in both Swift and Objective-C, with a single codebase!

* Xcode
  * Language Support: **Swift** *(any version)*, **Objective-C**
  * Fully Compatible With: **Xcode 7.0**
  * Minimum Supported Version: **Xcode 5.0**
* iOS
  * Fully Compatible With: **iOS 9.0**
  * Minimum Deployment Target: **iOS 6.0**
* OS X
  * Fully Compatible With: **OS X 10.11**
  * Minimum Deployment Target: **OS X 10.7**

### Using [CocoaPods](http://cocoapods.org)
1. Add the pod `PureLayout` to your [Podfile](http://guides.cocoapods.org/using/the-podfile.html).

  ```ruby
  pod 'PureLayout'
  ```

1. Run `pod install` from Terminal, then open your app's `.xcworkspace` file to launch Xcode.
1. Import the `PureLayout.h` umbrella header.
  * With `use_frameworks!` in your Podfile
    * Swift: `import PureLayout`
    * Objective-C: `#import <PureLayout/PureLayout.h>` (or with Modules enabled: `@import PureLayout;`)
  * Without `use_frameworks!` in your Podfile
    * Swift: Add `#import "PureLayout.h"` to your bridging header.
    * Objective-C: `#import "PureLayout.h"`

That's it - now go write some beautiful Auto Layout code!

### Using [Carthage](https://github.com/Carthage/Carthage)
1. Add the `PureLayout/PureLayout` project to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile).

  ```ogdl
  github "PureLayout/PureLayout"
  ```

1. Run `carthage update`, then follow the [additional steps required](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application) to add the framework into your project.
1. Import the PureLayout framework/module.
  * Swift: `import PureLayout`
  * Objective-C: `#import <PureLayout/PureLayout.h>` (or with Modules enabled: `@import PureLayout;`)

That's it - now go write some beautiful Auto Layout code!

### Manually from GitHub
1. Download the source files in the [PureLayout subdirectory](PureLayout/PureLayout).
1. Add the source files to your Xcode project.
1. Import the `PureLayout.h` header.
  * Swift: Add `#import "PureLayout.h"` to your bridging header.
  * Objective-C: `#import "PureLayout.h"`

That's it - now go write some beautiful Auto Layout code!

### App Extensions
To use PureLayout in an App Extension, you need to do a bit of extra configuration to prevent usage of unavailable APIs. [Click here](https://github.com/PureLayout/PureLayout/wiki/App-Extensions) for more info.

### Releases
Releases are tagged in the git commit history using [semantic versioning](http://semver.org). Check out the [releases and release notes](https://github.com/PureLayout/PureLayout/releases) for each version.

## API Cheat Sheet
This is just a handy overview of the core API methods. Explore the [header files](PureLayout/PureLayout) for the full API, and find the complete documentation above the implementation of each method in the corresponding .m file. A couple of notes:

* All of the public API methods are namespaced with the prefix `auto...`, which also makes it easy for Xcode to autocomplete as you type.
* Methods that create constraints also automatically install (activate) the constraint(s), then return the new constraint(s) for you to optionally store for later adjustment or removal.
* Many methods below also have a variant which includes a `relation:` parameter to make the constraint an inequality.

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
```
- autoSetContent(CompressionResistance|Hugging)PriorityForAxis:
- autoCenterInSuperview(Margins): // Margins variant iOS 8.0+ only
- autoAlignAxisToSuperview(Margin)Axis: // Margin variant iOS 8.0+ only
- autoPinEdgeToSuperview(Edge:|Margin:)(withInset:) // Margin variant iOS 8.0+ only
- autoPinEdgesToSuperview(Edges|Margins)(WithInsets:)(excludingEdge:) // Margins variant iOS 8.0+ only
- autoPinEdge:toEdge:ofView:(withOffset:)
- autoAlignAxis:toSameAxisOfView:(withOffset:|withMultiplier:)
- autoMatchDimension:toDimension:ofView:(withOffset:|withMultiplier:)
- autoSetDimension(s)ToSize:
- autoConstrainAttribute:toAttribute:ofView:(withOffset:|withMultiplier:)
- autoPinTo(Top|Bottom)LayoutGuideOfViewController:withInset: // iOS only
```

### [`NSArray`](PureLayout/PureLayout/NSArray%2BPureLayout.h)
```
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
```

### [`NSLayoutConstraint`](PureLayout/PureLayout/NSLayoutConstraint%2BPureLayout.h)
```
+ autoCreateAndInstallConstraints:
+ autoCreateConstraintsWithoutInstalling:
+ autoSetPriority:forConstraints:
+ autoSetIdentifier:forConstraints: // iOS 7.0+, OS X 10.9+ only
- autoIdentify: // iOS 7.0+, OS X 10.9+ only
- autoInstall
- autoRemove
```

## Usage
### Sample Code (Swift)
PureLayout dramatically simplifies writing Auto Layout code. Let's take a quick look at some examples, using PureLayout from Swift.

Here's a constraint between two views created (and automatically activated) using PureLayout:

```swift
view1.autoPinEdge(.Top, toEdge: .Bottom, ofView: view2)
```

Without PureLayout, here's the equivalent code you'd have to write using Apple's Foundation API directly:

```swift
NSLayoutConstraint(item: view1, attribute: .Top, relatedBy: .Equal, toItem: view2, attribute: .Bottom, multiplier: 1.0, constant: 0.0).active = true
```

Many APIs of PureLayout create multiple constraints for you under the hood, letting you write highly readable layout code:

```swift
// 2 constraints created & activated in one line!
logoImageView.autoCenterInSuperview()

// 4 constraints created & activated in one line!
textContentView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 20.0, left: 5.0, bottom: 10.0, right: 5.0))
```

PureLayout always returns the constraints it creates so you have full control:

```swift
let constraint = skinnyView.autoMatchDimension(.Height, toDimension: .Width, ofView: tallView)
```

PureLayout supports all Auto Layout features including inequalities, priorities, layout margins, identifiers, and much more. It's a comprehensive, developer-friendly way to use Auto Layout.

Check out the example apps below for many more demos of PureLayout in use.

### Example Apps
Open the project included in the repository (requires Xcode 6 or higher). It contains [iOS](PureLayout/Example-iOS) (`Example-iOS` scheme) and [OS X](PureLayout/Example-Mac) (`Example-Mac` scheme) demos of the library being used in various scenarios. The demos in the iOS example app make a great introductory tutorial to PureLayout -- run each demo, review the code used to implement it, then practice by making some changes of your own to the demo code.

Each demo in the iOS example app has a Swift and Objective-C version. **To compile & run the Swift demos, you must use Xcode 7.0 or higher (Swift 2.0) and choose the `Example-iOS-Xcode7` scheme.** When you run the example app, you can easily switch between using the Swift and Objective-C versions of the demos. To see the constraints in action while running the iOS demos, try using different device simulators, rotating the device to different orientations, as well as toggling the taller in-call status bar in the iOS Simulator.

On OS X, while running the app, press any key to cycle through the demos. You can resize the window to see the constraints in action.

### Tips and Tricks
Check out some [Tips and Tricks](https://github.com/PureLayout/PureLayout/wiki/Tips-and-Tricks) to keep in mind when using the API.

## PureLayout vs. the rest
There are quite a few different ways to implement Auto Layout. Here is a quick overview of the available options:

* Apple [NSLayoutConstraint SDK API](https://developer.apple.com/library/ios/documentation/AppKit/Reference/NSLayoutConstraint_Class/index.html#//apple_ref/occ/clm/NSLayoutConstraint/constraintWithItem:attribute:relatedBy:toItem:attribute:multiplier:constant:)
  * Pros: Raw power
  * Cons: Extremely verbose; tedious to write; difficult to read
* Apple [Visual Format Language](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG/VisualFormatLanguage/VisualFormatLanguage.html)
  * Pros: Concise; convenient
  * Cons: Doesn't support some use cases; lacks compile-time checking and safety; must learn syntax; hard to debug
* Apple Interface Builder
  * Pros: Visual; interactive; provides compile-time layout checking
  * Cons: Difficult for complex layouts; cannot dynamically set constraints at runtime; encourages hardcoded magic numbers; not always WYSIWYG
* Apple [NSLayoutAnchor SDK API](https://developer.apple.com/library/prerelease/ios/documentation/AppKit/Reference/NSLayoutAnchor_ClassReference/index.html)
  * Pros: Clean, readable, and type-safe API for creating individual constraints
  * Cons: Only available in iOS 9.0 and OS X 10.11 and higher; requires manually activating each constraint; no API for creating multiple constraints at once
* **PureLayout**
  * Pros: Compatible with Objective-C and Swift codebases; consistent with Cocoa API style; cross-platform API and implementation shared across iOS and OS X; fully backwards-compatible to iOS 6 & OS X 10.7; easy to use; type-safe; efficient
  * Cons: Not the most concise expression of layout code
* High-level Auto Layout Libraries/DSLs ([Cartography](https://github.com/robb/Cartography), [SnapKit](https://github.com/SnapKit/SnapKit), [KeepLayout](https://github.com/iMartinKiss/KeepLayout))
  * Pros: Very clean, concise, and convenient 
  * Cons: Unique API style is foreign to Apple's APIs; mixed compatibility with Objective-C & Swift; greater dependency on third party code
	
PureLayout takes a balanced approach to Auto Layout that makes it well suited for any project.

## Problems, Suggestions, Pull Requests?
Please open a [new Issue here](https://github.com/PureLayout/PureLayout/issues/new) if you run into a problem specific to PureLayout, have a feature request, or want to share a comment. Note that general Auto Layout questions should be asked on [Stack Overflow](http://stackoverflow.com).

Pull requests are encouraged and greatly appreciated! Please try to maintain consistency with the existing code style. If you're considering taking on significant changes or additions to the project, please communicate in advance by opening a new Issue. This allows everyone to get onboard with upcoming changes, ensures that changes align with the project's design philosophy, and avoids duplicated work.

## Meta
Originally designed & built by Tyler Fox ([@smileyborg](https://github.com/smileyborg)). Currently maintained by Mickey Reiss ([@mickeyreiss](https://github.com/mickeyreiss)). Distributed with the MIT license.
