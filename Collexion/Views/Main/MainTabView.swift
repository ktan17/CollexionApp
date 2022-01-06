//
//  MainTabView.swift
//  Collexion
//
//  Created by Kevin Tan on 12/25/21.
//

import SwiftUI

struct MainTabView: View {
  private let router = MainRouter()
  
  var body: some View {
    TabView {
      router.destination(for: .home)
        .tabItem {
          Image(systemName: "house.fill")
        }
    }
  }
}
