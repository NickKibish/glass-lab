# Glass Lab

A SwiftUI gallery of interactive Liquid Glass buttons for iOS and macOS. Open `Button-Test.xcodeproj` and run the `Button-Test` scheme.

## Getting started

The current project targets **iOS 27.0+ and macOS 27.0+** and was built with **Xcode 27.1**. It has no external dependencies.

1. Clone this repository and open `Button-Test.xcodeproj` in Xcode.
2. Select the `Button-Test` scheme.
3. Choose an iPhone or iPad simulator, or My Mac, and run with **⌘R**.
4. For a physical device, select your own development team under **Signing & Capabilities** and use a unique bundle identifier.

Swipe the category strip horizontally on smaller screens to reach every section. Tap sample buttons to try their behavior and use the sliders icon in the toolbar to customize the viewing environment.

## Explore

- **Styles:** native glass, prominent glass, clear and tinted glass; standard button styles for comparison; text, symbol, and multiline labels.
- **Materials:** regular, clear, tinted, interactive, and identity glass; five standard blur materials as frost references.
- **Colors:** 12 colors, each in tinted and prominent glass, plus four tint strengths.
- **Shapes:** native border shapes, all five control sizes, custom shapes, and a full-width action.
- **Roles:** default, destructive, cancel, confirm, and close in both glass styles; disabled, selected, playback, loading, and confirmation states.
- **Navigation:** real navigation links, a toolbar screen with a system back button and iOS bottom bar, a sheet, a menu, and a floating tool palette.
- **Motion:** expanding glass controls, proximity blending, and interactive versus static press effects.

Use the sliders icon to change light/dark appearance, accent color, backdrop, background position, and disabled state. The footer reports sample actions. Demo actions do not modify external data.

Liquid Glass uses the system's real SwiftUI APIs. Standard blur materials are labeled separately: tint opacity controls color strength, and no simulated blur-radius control is presented as native Liquid Glass. System accessibility settings can change rendering and animation.

## Source

- `ContentView.swift`: gallery navigation and action feedback.
- `GalleryComponents.swift`: shared sample layout, backgrounds, and viewing options.
- `ButtonSamples.swift`: styles, materials, colors, shapes, and roles.
- `ContextSamples.swift`: navigation, toolbars, presentations, and motion.

Reference: [Apple's guide to applying Liquid Glass to custom views](https://developer.apple.com/documentation/swiftui/applying-liquid-glass-to-custom-views).

## Validation

iOS Simulator and macOS builds passed with Xcode 27.1. Representative layouts and interactions were checked in the iPhone simulator. The project also contains its original visionOS target configuration, which has not been validated.
