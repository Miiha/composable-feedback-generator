//
//  ContentView.swift
//  FeedbackGenerator
//
//  Created by Michael Kao on 02.11.20.
//

import ComposableArchitecture
import SwiftUI

struct ContentView: View {
  let store: Store<AppState, AppAction>

  var body: some View {
    WithViewStore(self.store) { viewStore in
      Form {
        Section(header: Text("Input Feedback Generator")) {
          WithViewStore(self.store.scope(state: { $0.inputStyle }, action: AppAction.inputStylePicked)) { inputViewStore in
            VStack {
              Picker(
                "Input", selection: inputViewStore.binding(send: { $0 })
              ) {
                ForEach(InputStyle.allCases, id: \.self) { style in
                  Text(style.rawValue).tag(style)
                }
              }
              .pickerStyle(SegmentedPickerStyle())
              Button("Run") {
                viewStore.send(.tappedImpactButton)
              }
              .padding()
            }
          }
        }
        Section(header: Text("Notification Feedback Generator")) {
          WithViewStore(self.store.scope(state: { $0.notificationType }, action: AppAction.notificationTypePicked)) { inputViewStore in
            VStack {
              Picker(
                "Input", selection: inputViewStore.binding(send: { $0 })
              ) {
                ForEach(NotificationType.allCases, id: \.self) { type in
                  Text(type.rawValue).tag(type)
                }
              }
              .pickerStyle(SegmentedPickerStyle())
              Button("Run") {
                viewStore.send(.tappedNotificationButton)
              }
              .padding()
            }
          }
        }
        Section(header: Text("Selection Feedback Generator")) {
          WithViewStore(self.store) { viewStore in
            HStack {
              Spacer()
              Button("Run") {
                viewStore.send(.tappedSelectionButton)
              }
              .padding()
              Spacer()
            }
          }
        }
      }
    }
  }
}
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(
      store:
        Store(
          initialState: AppState(),
          reducer: .empty,
          environment: AppEnvironment(
            feedbackGenerator: .unimplemented()
          )
        )
    )
  }
}
