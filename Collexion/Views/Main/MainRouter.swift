//
//  MainRouter.swift
//  Collexion
//
//  Created by Kevin Tan on 12/31/21.
//

import SwiftUI

class MainRouter: Router {
  enum Route {
    case home
  }

  @ViewBuilder
  func destination(for route: Route) -> some View {
    switch route {
    case .home:
      let viewModel = ObservedObject(
        wrappedValue: HomeViewModel(
          deps: .init(collexionService: dependencies.collexionService)
        )
      )
      let router = HomeRouter(viewModel: viewModel)
      HomeView(viewModel: viewModel, router: router)
    }
  }
}
