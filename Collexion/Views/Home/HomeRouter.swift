//
//  HomeRouter.swift
//  Collexion
//
//  Created by Kevin Tan on 12/31/21.
//

import SwiftUI

class HomeRouter: Router {
  
  // MARK: - Route
  
  enum Route {
    case addWord
  }
  
  // MARK: - Private properties
  
  @ObservedObject private var viewModel: HomeViewModel
  
  // MARK: - Initializers
  
  init(viewModel: ObservedObject<HomeViewModel>) {
    self._viewModel = viewModel
  }
  
  // MARK: - Router
  
  @ViewBuilder
  func destination(for route: Route) -> some View {
    switch route {
    case .addWord:
      let viewModel = ObservedObject(
        wrappedValue: EditWordViewModel(
          deps: .init(
            isPresented: $viewModel.shouldShowEditor,
            collexionService: dependencies.collexionService
          )
        )
      )
      EditWordView(viewModel: viewModel)
    }
  }
  
}
