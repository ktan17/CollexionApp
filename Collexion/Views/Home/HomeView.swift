//
//  HomeView.swift
//  Collexion
//
//  Created by Kevin Tan on 12/27/21.
//

import SwiftUI

struct HomeView: View {
  
  // MARK: - Constant
  
  private enum Constant {
    static let title = "Your Collexion"
    static let addWordImageName = "square.and.pencil"
  }
  
  // MARK: - Properties
  
  @ObservedObject private var viewModel: HomeViewModel
  private let router: HomeRouter
  
  var body: some View {
    NavigationView {
      List(viewModel.words) { word in
        VStack(alignment: .leading, spacing: theme.smallPadding) {
          HStack(alignment: .firstTextBaseline, spacing: theme.smallPadding) {
            Text(word.title)
              .themedFont(.title)
            Text(word.partOfSpeech.abbreviation)
              .themedFont(.caption)
          }
          Text(word.definition)
            .themedFont(.body)
        }
        .listRowInsets(
          EdgeInsets(
            top: theme.mediumPadding,
            leading: theme.mediumPadding,
            bottom: theme.smallPadding,
            trailing: theme.mediumPadding
          )
        )
      }
      .listStyle(.plain)
      .navigationTitle(Constant.title)
      .toolbar {
        Button(
          action: viewModel.addWordAction,
          label: {
            Image(systemName: Constant.addWordImageName)
          }
        )
      }
      .sheet(isPresented: $viewModel.shouldShowEditor) {
        router.destination(for: .addWord)
      }
    }
  }
  
  // MARK: - Initializers
  
  init(viewModel: ObservedObject<HomeViewModel>, router: HomeRouter) {
    _viewModel = viewModel
    self.router = router
    
    UINavigationBar.appearance().largeTitleTextAttributes = [
      .font: Theme.FontStyle.largeTitle.uiFont
    ]
    UINavigationBar.appearance().titleTextAttributes = [
      .font: Theme.FontStyle.title2.uiFont
    ]
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    let viewModel = ObservedObject(
      wrappedValue: HomeViewModel(
        deps: .init(collexionService: CollexionService())
      )
    )
    HomeView(
      viewModel: viewModel,
      router: .init(viewModel: viewModel)
    )
      .previewDevice("iPhone 13")
  }
}
