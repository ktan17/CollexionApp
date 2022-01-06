//
//  HomeViewModel.swift
//  Collexion
//
//  Created by Kevin Tan on 12/30/21.
//

import Combine

class HomeViewModel: ObservableObject {
  
  // MARK: - Deps
  
  struct Deps {
    let collexionService: CollexionServiceProtocol
  }
  
  // MARK: - Outputs
  
  @Published var words = [Word]()
  @Published var shouldShowEditor = false
  private(set) var addWordAction: () -> Void = {}
  
  // MARK: - Private properties
  
  private let deps: Deps
  
  // MARK: - Initializers
  
  init(deps: Deps) {
    self.deps = deps
    
    addWordAction = { [weak self] in
      self?.shouldShowEditor = true
    }
    
    Task { [weak self] in
      await self?.bindWords(to: await deps.collexionService.words)
    }
  }
  
  // MARK: - Helper functions
  
  @MainActor
  private func bindWords(to stream: AsyncStream<[Word]>) async {
    for await words in stream {
      self.words = words
    }
  }
  
}
