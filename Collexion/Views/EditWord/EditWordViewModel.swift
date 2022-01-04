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
  }
  
  // MARK: - Outputs
  
  @Published var title: String
  @Published var definition: String
  @Published var partOfSpeech: PartOfSpeech
  @Published var isFocused = false
  let onAppear: () -> Void
  let cancelAction: () -> Void
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
    let relay = PassthroughSubject<Void, Never>()
    onAppear = {
      relay.send()
    }
    defer {
      relay
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
  
}
