import ComposableArchitecture
import UIKit

extension FeedbackGenerator {
  public static func unimplemented(
    impact: Impact = .unimplemented(),
    notification: Notification = .unimplemented(),
    selection: Selection = .unimplemented()
  ) -> Self {
    Self(
      impact: impact,
      notification: notification,
      selection: selection
    )
  }
}

extension FeedbackGenerator.Impact {
  public static func unimplemented(
    create: @escaping (AnyHashable, UIImpactFeedbackGenerator.FeedbackStyle) -> Effect<Never, Never> = { _, _ in
      _unimplemented("create")
    },
    destroy: @escaping (AnyHashable) -> Effect<Never, Never> = { _ in
      _unimplemented("destroy")
    },
    impactOccurred: @escaping (AnyHashable) -> Effect<Never, Never> = { _ in
      _unimplemented("impactOccurred")
    },
    impactOccurredWithIntensity: @escaping (AnyHashable, CGFloat) -> Effect<Never, Never> = { _, _ in
      _unimplemented("impactOccurredWithIntensity")
    },
    prepare: @escaping (AnyHashable) -> Effect<Never, Never> = { _ in
      _unimplemented("prepare")
    }
  ) -> Self {
    Self(
      create: create,
      destroy: destroy,
      impactOccurred: impactOccurred,
      impactOccurredWithIntensity: impactOccurredWithIntensity,
      prepare: prepare
    )
  }
}

extension FeedbackGenerator.Notification {
  public static func unimplemented(
    create: @escaping (AnyHashable) -> Effect<Never, Never> = { _ in
      _unimplemented("create")
    },
    destroy: @escaping (AnyHashable) -> Effect<Never, Never> = { _ in
      _unimplemented("destroy")
    },
    notificationOccurred: @escaping (AnyHashable, UINotificationFeedbackGenerator.FeedbackType) -> Effect<Never, Never> = { _, _ in
    _unimplemented("notificationOccurred")
    },
    prepare: @escaping (AnyHashable) -> Effect<Never, Never> = { _ in
      _unimplemented("prepare")
    }
  ) -> Self {
    Self(
      create: create,
      destroy: destroy,
      notificationOccurred: notificationOccurred,
      prepare: prepare
    )
  }
}

extension FeedbackGenerator.Selection {
  public static func unimplemented(
    create: @escaping (AnyHashable) -> Effect<Never, Never> = { _ in
      _unimplemented("create")
    },
    destroy: @escaping (AnyHashable) -> Effect<Never, Never> = { _ in
      _unimplemented("destroy")
    },
    selectionChanged: @escaping (AnyHashable) -> Effect<Never, Never> = { _ in
      _unimplemented("selectionChanged")
    },
    prepare: @escaping (AnyHashable) -> Effect<Never, Never> = { _ in
      _unimplemented("prepare")
    }
  ) -> Self {
    Self(
      create: create,
      destroy: destroy,
      selectionChanged: selectionChanged,
      prepare: prepare
    )
  }
}
