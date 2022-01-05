//
//  EditWordViewModel.swift
//  Collexion
//
//  Created by Kevin Tan on 1/1/22.
//

import Combine
import SwiftUI

class EditWordViewModel: ObservableObject {
  
  // MARK: - Constant
  
  private enum Constant {
    static let titleCharacterLimit = 45
    static let definitionCharacterLimit = 250
    static let focusDelay: TimeInterval = 0.5
  }
  
  // MARK: - Deps
  
  struct Deps {
    let title: String = ""
    let definition: String = ""
    let partOfSpeech: PartOfSpeech = .noun
    let isPresented: Binding<Bool>
    let collexionService: CollexionServiceProtocol
  }
  
  // MARK: - Outputs
  
  @Published var title: String
  @Published var definition: String
  @Published var partOfSpeech: PartOfSpeech
  @Published var isFocused = false
  let onAppear: () -> Void
  let cancelAction: () -> Void
  let addAction: () -> Void
  let titleValidator: (String) -> String?
  let definitionValidator: (String) -> String?
  
  // MARK: - Private properties
  
  private let deps: Deps
  private var cancellables = Set<AnyCancellable>()
  
  // MARK: - Initializers
  
  init(deps: Deps) {
    self.deps = deps
    self.title = deps.title
    self.definition = deps.definition
    self.partOfSpeech = deps.partOfSpeech
    
    // Need to use a relay because of a circular dependency between
    // onAppear and self
    let appearRelay = PassthroughSubject<Void, Never>()
    onAppear = {
      appearRelay.send()
    }
    defer {
      appearRelay
        .first()
        .sink { [weak self] in
          DispatchQueue.main.asyncAfter(deadline: .now() + Constant.focusDelay) { [weak self] in
            self?.isFocused = true
          }
        }
        .store(in: &cancellables)
    }
    
    cancelAction = {
      deps.isPresented.wrappedValue = false
    }
    
    let addRelay = PassthroughSubject<Void, Never>()
    addAction = {
      addRelay.send()
    }
    defer {
      addRelay
        .first()
        .sink { [weak self] in
          guard let self = self else { return }
          let newWord = Word(
            id: UUID().uuidString,
            title: self.title,
            definition: self.definition,
            partOfSpeech: self.partOfSpeech,
            timestamp: .now
          )
          Task { [weak self, deps] in
            await deps.collexionService.add(word: newWord)
            await self?.dismiss()
          }
        }
        .store(in: &cancellables)
    }
    
    titleValidator = { candidate in
      let trimmed = candidate.trimmingCharacters(in: .whitespacesAndNewlines)
      if trimmed.count > Constant.titleCharacterLimit {
        return String(trimmed.prefix(Constant.titleCharacterLimit))
      } else if trimmed != candidate {
        return trimmed
      } else {
        return nil
      }
    }
    
    definitionValidator = { candidate in
      if candidate.count > Constant.definitionCharacterLimit {
        return String(candidate.prefix(Constant.definitionCharacterLimit))
      }
      return nil
    }
  }
  
  // MARK: - Helper functions
  
  @MainActor
  private func dismiss() {
    deps.isPresented.wrappedValue = false
  }
  
}
