//
//  HomeRouter.swift
//  Collexion
//
//  Created by Kevin Tan on 12/31/21.
//

import SwiftUI

class HomeRouter: Router {
  enum Route {
    case addWord
  }
  
  @ViewBuilder
  func destination(for route: Route) -> some View {
    switch route {
    case .addWord:
      let viewModel = EditWordViewModel(deps: .init())
      EditWordView(viewModel: viewModel)
    }
  }
}
