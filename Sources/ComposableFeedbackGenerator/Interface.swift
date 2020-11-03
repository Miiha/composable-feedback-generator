import ComposableArchitecture
import UIKit
import Combine

public struct FeedbackGenerator {
  public var impact: Impact
  public var notification: Notification
  public var selection: Selection
}

extension FeedbackGenerator {
  public struct Impact {
    public var create: (AnyHashable, UIImpactFeedbackGenerator.FeedbackStyle) -> Effect<Never, Never>
    public var destroy: (AnyHashable) -> Effect<Never, Never>
    public var impactOccurred: (AnyHashable) -> Effect<Never, Never>
    public var impactOccurredWithIntensity: (AnyHashable, CGFloat) -> Effect<Never, Never>
    public var prepare: (AnyHashable) -> Effect<Never, Never>
  }
}

extension FeedbackGenerator {
  public struct Notification {
    public var create: (AnyHashable) -> Effect<Never, Never>
    public var destroy: (AnyHashable) -> Effect<Never, Never>
    public var notificationOccurred: (AnyHashable, UINotificationFeedbackGenerator.FeedbackType) -> Effect<Never, Never>
    public var prepare: (AnyHashable) -> Effect<Never, Never>
  }
}

extension FeedbackGenerator {
  public struct Selection {
    public var create: (AnyHashable) -> Effect<Never, Never>
    public var destroy: (AnyHashable) -> Effect<Never, Never>
    public var selectionChanged: (AnyHashable) -> Effect<Never, Never>
    public var prepare: (AnyHashable) -> Effect<Never, Never>
  }
}
