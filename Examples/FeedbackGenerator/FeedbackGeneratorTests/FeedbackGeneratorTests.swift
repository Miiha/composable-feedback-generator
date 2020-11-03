//
//  FeedbackGeneratorTests.swift
//  FeedbackGeneratorTests
//
//  Created by Michael Kao on 02.11.20.
//

import XCTest
import Combine
import ComposableArchitecture
import ComposableFeedbackGenerator
@testable import FeedbackGenerator

class FeedbackGeneratorTests: XCTestCase {
  var environment = AppEnvironment(feedbackGenerator: .unimplemented())
  var impactSubject = PassthroughSubject<Never, Never>()
  var notificationSubject = PassthroughSubject<Never, Never>()
  var selectedSubject = PassthroughSubject<Never, Never>()

  func testGeneratorCreation() throws {
    var initialImpactStyle: UIImpactFeedbackGenerator.FeedbackStyle?
    var createdImpactGenerator = false
    var createdNotificationGenerator = false
    var createdSelectionGenerator = false

    environment.feedbackGenerator.impact.create = { _, style in
      initialImpactStyle = style
      createdImpactGenerator = true
      return self.impactSubject.eraseToEffect()
    }
    environment.feedbackGenerator.notification.create = { _ in
      createdNotificationGenerator = true
      return self.notificationSubject.eraseToEffect()
    }
    environment.feedbackGenerator.selection.create = { _ in
      createdSelectionGenerator = true
      return self.selectedSubject.eraseToEffect()
    }

    TestStore(
      initialState: AppState(),
      reducer: appReducer,
      environment: environment
    ).assert(
      .send(.onAppear),
      .do { XCTAssertEqual(initialImpactStyle, .medium) },
      .do { XCTAssertTrue(createdImpactGenerator) },
      .do { XCTAssertTrue(createdNotificationGenerator) },
      .do { XCTAssertTrue(createdSelectionGenerator) },
      .do { self.impactSubject.send(completion: .finished) },
      .do { self.notificationSubject.send(completion: .finished) },
      .do { self.selectedSubject.send(completion: .finished) }
    )
  }

  func testImpactGenerator() throws {
    var impactOccurred = false
    environment.feedbackGenerator.impact.create = { _, _ in
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
      .send(.impactStylePicked(.rigid)) {
        $0.impactStyle = .rigid
      },
      .send(.tappedImpactButton),
      .do { XCTAssertTrue(impactOccurred) },
      .do { self.impactSubject.send(completion: .finished) }
    )
  }

  func testNotificationGenerator() throws {
    var notificationOccurredType: UINotificationFeedbackGenerator.FeedbackType?
    environment.feedbackGenerator.notification.notificationOccurred = { _, type in
      notificationOccurredType = type
      return .fireAndForget {}
    }

    TestStore(
      initialState: AppState(),
      reducer: appReducer,
      environment: environment
    ).assert(
      .send(.notificationTypePicked(.warning)) {
        $0.notificationType = .warning
      },
      .send(.tappedNotificationButton),
      .do { XCTAssertEqual(notificationOccurredType, .warning) }
    )
  }

  func testSelectionGenerator() throws {
    var selectionChanged = false
    environment.feedbackGenerator.selection.create = { _ in
      return self.selectedSubject.eraseToEffect()
    }
    environment.feedbackGenerator.selection.selectionChanged = { _ in
      selectionChanged = true
      return .fireAndForget {}
    }

    TestStore(
      initialState: AppState(),
      reducer: appReducer,
      environment: environment
    ).assert(
      .send(.tappedSelectionButton),
      .do { XCTAssertTrue(selectionChanged) }
    )
  }
}
