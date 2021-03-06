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

  @Published var shouldShowEditor = false
  @Published private(set) var words = [Word]()
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
      self.words = words.sorted {
        guard $0.title != $1.title else { return $0.timestamp < $1.timestamp }
        return $0.title < $1.title
      }
    }
  }

}
