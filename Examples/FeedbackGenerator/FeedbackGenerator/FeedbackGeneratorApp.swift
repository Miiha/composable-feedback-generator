//
//  FeedbackGeneratorApp.swift
//  FeedbackGenerator
//
//  Created by Michael Kao on 02.11.20.
//

import ComposableArchitecture
import SwiftUI

@main
struct FeedbackGeneratorApp: App {
  let store = Store(
    initialState: AppState(),
    reducer: appReducer,
    environment: AppEnvironment(feedbackGenerator: .live)
  )

  var body: some Scene {
    WindowGroup {
      NavigationView {
        WithViewStore(self.store) { viewStore in
          ContentView(store: self.store)
            .onAppear { viewStore.send(.onAppear) }
            .onDisappear { viewStore.send(.onDisappear) }
            .navigationTitle("Feedback Example")
        }
      }
      .navigationViewStyle(StackNavigationViewStyle())
    }
  }
}
