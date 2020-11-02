import ComposableArchitecture
import UIKit
import Combine

struct FeedbackGenerator {
  let impact: Impact
  let notification: Notification
  let selection: Selection
}

extension FeedbackGenerator {
  struct Impact {
    var create: (AnyHashable, UIImpactFeedbackGenerator.FeedbackStyle) -> Effect<Never, Never> = { _, _ in
      _unimplemented("create")
    }

    var impactOccurred: (AnyHashable) -> Effect<Never, Never> = { _ in
      _unimplemented("impactOccurred")
    }

    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    var impactOccurredWithIntensity: (AnyHashable, CGFloat) -> Effect<Never, Never> = { _,_  in
      _unimplemented("impactOccurredWithIntensity")
    }

    var prepare: (AnyHashable) -> Effect<Never, Never> = { _ in
      _unimplemented("prepare")
    }
  }
}

extension FeedbackGenerator {
  struct Notification {
    var create: (AnyHashable) -> Effect<Never, Never> = { _ in
      _unimplemented("create")
    }

    var notificationOccurred: (AnyHashable, UINotificationFeedbackGenerator.FeedbackType) -> Effect<Never, Never> = { _, _ in
      _unimplemented("notificationOccurred")
    }

    var prepare: (AnyHashable) -> Effect<Never, Never> = { _ in
      _unimplemented("prepare")
    }
  }
}

extension FeedbackGenerator {
  struct Selection {
    var create: (AnyHashable) -> Effect<Never, Never> = { _ in
      _unimplemented("create")
    }

    var selectionChanged: (AnyHashable) -> Effect<Never, Never> = { _ in
      _unimplemented("selectionChanged")
    }

    var prepare: (AnyHashable) -> Effect<Never, Never> = { _ in
      _unimplemented("prepare")
    }
  }
}
