// Firebase Analytics: Getting Started
// https://www.raywenderlich.com/18579842-firebase-analytics-getting-started#toc-anchor-011

import SwiftUI
import Firebase

@main
struct Cocoabucks: App {
  var order = Order()

  // Initialize Firebase
  init() {
    // Start firebase when app launch
    FirebaseApp.configure()
    
  }
  var body: some Scene {
    WindowGroup {
      ProductListView()
        .environmentObject(order)
    }
  }
}
