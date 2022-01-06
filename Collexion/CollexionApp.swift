//
//  CollexionApp.swift
//  Collexion
//
//  Created by Kevin Tan on 12/27/21.
//

import SwiftUI

@main
struct CollexionApp: App {
  var body: some Scene {
    WindowGroup {
      MainTabView()
    }
  }
  
  init() {
    UINavigationBar.appearance().largeTitleTextAttributes = [
      .font: Theme.FontStyle.largeTitle.uiFont
    ]
    UINavigationBar.appearance().titleTextAttributes = [
      .font: Theme.FontStyle.title2.uiFont
    ]
  }
}
