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
  let addWordAction: () -> Void
  
  // MARK: - Private properties
  
  private let deps: Deps
  private var cancellables = Set<AnyCancellable>()
  
  // MARK: - Initializers
  
  init(deps: Deps) {
    self.deps = deps
    
    let relay = PassthroughSubject<Void, Never>()
    addWordAction = {
      relay.send()
    }
    
    // Need to use a relay because of a circular dependency between
    // addWordAction and self
    relay.sink { [weak self] in
      self?.shouldShowEditor = true
    }
    .store(in: &cancellables)
    
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
