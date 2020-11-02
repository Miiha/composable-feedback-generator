import ComposableArchitecture
import Combine
import UIKit

extension FeedbackGenerator.Impact {
  static var live: Self {
    Self(
      create: { id, style in
        Effect.run { subscriber in
          let generator = UIImpactFeedbackGenerator(style: style)
          dependencies[id] = Dependency(
            generator: generator,
            subscriber: subscriber
          )
          return AnyCancellable {
            dependencies[id] = nil
          }
        }
      }, destroy: { id in
        .fireAndForget {
          dependencies[id]?.subscriber.send(completion: .finished)
          dependencies[id] = nil
        }
      }, impactOccurred: { id in
        .fireAndForget {
          guard let generator = dependencies[id]?.generator as? UIImpactFeedbackGenerator else {
            return
          }
          generator.impactOccurred()
        }
      },
      impactOccurredWithIntensity: { id, intensity in
        .fireAndForget {
          guard let generator = dependencies[id]?.generator as? UIImpactFeedbackGenerator else {
            return
          }
          generator.impactOccurred(intensity: intensity)
        }
      },
      prepare: { id in
        .fireAndForget {
          guard let generator = dependencies[id]?.generator as? UIImpactFeedbackGenerator else {
            return
          }
          generator.prepare()
        }
      }
    )
  }
}

extension FeedbackGenerator.Notification {
  static var live: Self {
    Self(
      create: { id in
        Effect.run { subscriber in
          let generator = UINotificationFeedbackGenerator()
          dependencies[id] = Dependency(
            generator: generator,
            subscriber: subscriber
          )
          return AnyCancellable {
            dependencies[id] = nil
          }
        }
      }, destroy: { id in
        .fireAndForget {
          dependencies[id]?.subscriber.send(completion: .finished)
          dependencies[id] = nil
        }
      },
      notificationOccurred: { id, type in
        .fireAndForget {
          guard let generator = dependencies[id]?.generator as? UINotificationFeedbackGenerator else {
            return
          }
          generator.notificationOccurred(type)
        }
      },
      prepare: { id in
        .fireAndForget {
          guard let generator = dependencies[id]?.generator as? UINotificationFeedbackGenerator else {
            return
          }
          generator.prepare()
        }
      }
    )
  }
}

extension FeedbackGenerator.Selection {
  public static var live: Self {
    Self(
      create: { id in
        Effect.run { subscriber in
          let generator = UISelectionFeedbackGenerator()
          dependencies[id] = Dependency(
            generator: generator,
            subscriber: subscriber
          )
          return AnyCancellable {
            dependencies[id] = nil
          }
        }
      }, destroy: { id in
        .fireAndForget {
          dependencies[id]?.subscriber.send(completion: .finished)
          dependencies[id] = nil
        }
      },
      selectionChanged: { id in
        .fireAndForget {
          guard let generator = dependencies[id]?.generator as? UISelectionFeedbackGenerator else {
            return
          }
          generator.selectionChanged()
        }
      },
      prepare: { id in
        .fireAndForget {
          guard let generator = dependencies[id]?.generator as? UISelectionFeedbackGenerator else {
            return
          }
          generator.prepare()
        }
      }
    )
  }
}

extension FeedbackGenerator {
  public static var live: Self {
    Self(
      impact: .live,
      notification: .live,
      selection: .live
    )
  }
}

struct Dependency {
  let generator: UIFeedbackGenerator
  let subscriber: Effect<Never, Never>.Subscriber
}

private var dependencies: [AnyHashable: Dependency] = [:]

public func _unimplemented(
  _ function: StaticString, file: StaticString = #file, line: UInt = #line
) -> Never {
  fatalError(
    """
    `\(function)` was called but is not implemented. Be sure to provide an implementation for
    this endpoint when creating the mock.
    """,
    file: file,
    line: line
  )
}
