# Composable Feedback Generator

Composable Feedback Generator is a library that bridges [the Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture) and  UIKit's [UIFeedbackGenerator](https://developer.apple.com/documentation/uikit/uifeedbackgenerator) and it's subclasses.

* [Example](#example)
* [Basic usage](#basic-usage)
* [Installation](#installation)

## Example

Check out the [FeedbackGenerator](./Examples/FeedbackGenerator) demo to see FeedbackGenerator in practice.

## Basic Usage
The FeedbackGenerator wraps the three subclasses of UIFeedbackGenerator:

* [UIImpactFeedbackGenerator](https://developer.apple.com/documentation/uikit/uiimpactfeedbackgenerator) -> `FeedbackGenerator.impact`
* [UINotificationFeedbackGenerator](https://developer.apple.com/documentation/uikit/uinotificationfeedbackgenerator) -> `FeedbackGenerator.notification`
* [UISelectionFeedbackGenerator](https://developer.apple.com/documentation/uikit/uiselectionfeedbackgenerator) -> `FeedbackGenerator.selection`

To use FeedbackGenerator in your application, add the FeedbackGenerator to your Environment. 

```swift
struct AppEnvironment {
  var feedbackGenerator: FeedbackGenerator

  // Your domain's other dependencies:
  ...
}
```

If you only need one FeedbackGenerator, you can add the specific generator to your Environment.

```swift
struct AppEnvironment {
  var impactFeedbackGenerator: FeedbackGenerator.Impact
  ...
}
```

To create a FeedbackGenerator use the `create`-methode which returns a long running Effect.
```swift
let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
  struct ImpactId: Hashable {}

  switch action {
  case .onAppear:
    return environment.feedbackGenerator.impact.create(ImpactId(), .medium)).map(absurd)
    ...
```
It's recommended to run `UIFeedbackGenerator.prepare` before calling to the actual feedback call. The generator will be placed into a prepared state for a short period of time. This will ensure that while the generator is prepared, you can trigger feedback with lower latency.   

```swift
switch action {
case .someAction:
  return environment.feedbackGenerator.impact.prepare(ImpactId()).map(absurd)
...
```
To run the feedback use the feedback generators run method.

```swift
switch action {
case .buttonTapped:
return environment.feedbackGenerator.impact.impactOccured(ImpactId()).map(absurd)
...
```

To supply the "live" implementation to your Environment you can use the provided `FeedbackGenerator.live` property.
```swift
let store = Store(
  initialState: AppState(),
  reducer: appReducer,
  environment: AppEnvironment(
    feedbackGenerator: .live,
    // And your other dependencies...
  )
)
```

For testing you can use the provided `unimplemented` methods on FeedbackGenerator and replace the required implementations.
The power of this approach is that your are able to fully test you feedback related logic.
```swift
var impactStyle: UIImpactFeedbackGenerator.FeedbackStyle?
var createdImpactGenerator = false
var impactOccurred = false

environment.feedbackGenerator.impact.create = { _, style in
  impactStyle = style
  createdImpactGenerator = true
  return self.impactSubject.eraseToEffect()
}
environment.feedbackGenerator.impact.impactOccurred = { _ in
  impactOccurred = true
  return .fireAndForget {}
}

TestStore(
  initialState: AppState(),
  reducer: appReducer,
  environment: environment
).assert(
  .send(.tappedImpactButton),
  .do { XCTAssertEqual(impactStyle, .medium) },
  .do { XCTAssertTrue(createdImpactGenerator) },
  .do { XCTAssertTrue(impactOccurred) },
  ...
```

For more information around testability have a look at [AppStateTests.swift](./Examples/FeedbackGenerator/FeedbackGeneratorTests/AppStateTests.swift).

## Installation

You can add ComposableFeedbackGenerator to an Xcode project by adding it as a package dependency.

1. From the **File** menu, select **Swift Packages › Add Package Dependency…**
2. Enter "https://github.com/Miiha/composable-feedback-generator" into the package repository URL text field

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
