Pod::Spec.new do |s|
  s.name         = "PureLayout"
  s.version      = "1.0.0"
  s.homepage     = "https://github.com/smileyborg/PureLayout"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Tyler Fox" => "tfox@smileyborg.com" }
  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.7'
  s.source       = { :git => "https://github.com/smileyborg/PureLayout.git", 
                     :tag => "v1.0.0" }
  s.source_files = 'Source'
  s.requires_arc = true
  s.summary      = "The ultimate API for iOS & OS X Auto Layout — impressively simple, immensely powerful."

  s.description  = <<-DESC
  PureLayout
  ==========

  The ultimate API for iOS & OS X Auto Layout — impressively simple, immensely powerful. PureLayout extends `UIView`/`NSView`, `NSArray`, and `NSLayoutConstraint` with a comprehensive Auto Layout API that is modeled after Apple's own frameworks.

  Writing Auto Layout code from scratch isn't easy. PureLayout provides a fully capable and developer-friendly interface for Auto Layout. It is designed for clarity and simplicity, and takes inspiration from the Auto Layout UI options available in Interface Builder while delivering far more flexibility. The API is also highly efficient, as it adds only a thin layer of third party code and is engineered for maximum performance.

  API Cheat Sheet
  ---------------

  This is just a handy overview of the core API methods. Explore the [header files](https://github.com/smileyborg/PureLayout/blob/master/Source) for the full API and documentation. A couple of notes:

  *	*All of the API methods begin with `auto...` for easy autocompletion in Xcode!*
  *	*All methods that generate constraints also automatically add the constraint(s) to the correct view, then return the newly created constraint(s) for you to optionally store for later adjustment or removal.*
  *	*Many methods below also have a variant which includes a `relation:` parameter to make the constraint an inequality.*

  **`UIView`/`NSView`**

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

  **`NSArray`**

      - autoAlignViewsToEdge:
      - autoAlignViewsToAxis:
      - autoMatchViewsDimension:
      - autoSetViewsDimension:toSize:
      - autoDistributeViewsAlongAxis:withFixedSpacing:(insetSpacing:)alignment:
      - autoDistributeViewsAlongAxis:withFixedSize:(insetSpacing:)alignment:

  **`NSLayoutConstraint`**

      - autoInstall
      - autoRemove
  DESC

end
