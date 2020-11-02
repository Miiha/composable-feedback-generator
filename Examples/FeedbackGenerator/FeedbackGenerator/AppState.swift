//
//  AppState.swift
//  FeedbackGenerator
//
//  Created by Michael Kao on 02.11.20.
//

import ComposableArchitecture
import ComposableFeedbackGenerator
import Foundation
import UIKit

struct AppState: Equatable {
  var inputStyle: InputStyle = .medium
  var notificationType: NotificationType = .success
}

enum AppAction: Equatable {
  case onAppear
  case onDisappear
  case tappedImpactButton
  case tappedNotificationButton
  case tappedSelectionButton
  case inputStylePicked(InputStyle)
  case notificationTypePicked(NotificationType)
}

struct AppEnvironment {
  var feedbackGenerator: FeedbackGenerator
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
  struct ImpactId: Hashable {}
  struct NotificationId: Hashable {}
  struct SelectionId: Hashable {}

  switch action {
  case .onAppear:
    return .merge(
      environment.feedbackGenerator.impact.create(ImpactId(), .init(style: state.inputStyle)).map(absurd),
      environment.feedbackGenerator.selection.create(SelectionId()).map(absurd),
      environment.feedbackGenerator.notification.create(NotificationId()).map(absurd)
    )

  case .onDisappear:
    return .merge(
      environment.feedbackGenerator.impact.destroy(ImpactId()).map(absurd),
      environment.feedbackGenerator.notification.destroy(NotificationId()).map(absurd),
      environment.feedbackGenerator.selection.destroy(SelectionId()).map(absurd)
    )

  case .tappedImpactButton:
    let impact = environment.feedbackGenerator.impact
    return impact.impactOccurred(ImpactId()).map(absurd)

  case .tappedNotificationButton:
    let notification = environment.feedbackGenerator.notification
    return notification.notificationOccurred(NotificationId(), .init(type: state.notificationType)).map(absurd)

  case .tappedSelectionButton:
    let selection = environment.feedbackGenerator.selection
    return selection.selectionChanged(SelectionId()).map(absurd)

  case let .inputStylePicked(style):
    state.inputStyle = style
    return environment.feedbackGenerator.impact.create(ImpactId(), .init(style: state.inputStyle))
      .map(absurd)
      .cancellable(id: ImpactId(), cancelInFlight: true)

  case let .notificationTypePicked(type):
    state.notificationType = type
    return .none
  }
}

private func absurd<A>(_ never: Never) -> A {
}

enum InputStyle: String, CaseIterable, Hashable {
  case light = "Light"
  case medium = "Medium"
  case heavy = "Heavy"
  case soft = "Soft"
  case rigid = "Rigit"
}

extension UIImpactFeedbackGenerator.FeedbackStyle {
  init(style: InputStyle) {
    switch style {
    case .light:
      self = .light
    case .medium:
      self = .medium
    case .heavy:
      self = .heavy
    case .soft:
      self = .soft
    case .rigid:
      self = .rigid
    }
  }
}

enum NotificationType: String, CaseIterable, Hashable {
  case success = "Success"
  case warning = "Warning"
  case error = "Error"
}

extension UINotificationFeedbackGenerator.FeedbackType {
  init(type: NotificationType) {
    switch type {
    case .success:
      self = .success
    case .warning:
      self = .warning
    case .error:
      self = .error
    }
  }
}
