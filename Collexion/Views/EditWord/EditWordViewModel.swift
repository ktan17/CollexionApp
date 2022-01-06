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
    static let focusDelayNanoseconds: UInt64 = 500_000_000
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
  @Published var isUploading = false
  @Published var isPresentingAlert = false
  @Published var uploadError: Error?
  private(set) var onAppear: () -> Void = {}
  private(set) var cancelAction: () -> Void = {}
  private(set) var addAction: () -> Void = {}
  private(set) var dismissAlertAction: () -> Void = {}
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
    
    onAppear = { [weak self] in
      Task { [weak self] in
        try? await Task.sleep(nanoseconds: Constant.focusDelayNanoseconds)
        await MainActor.run { [weak self] in
          self?.isFocused = true
        }
      }
    }
    
    cancelAction = {
      deps.isPresented.wrappedValue = false
    }
    
    addAction = { [weak self] in
      guard let self = self else { return }
      self.isUploading = true
      
      let newWord = Word(
        id: UUID().uuidString,
        title: self.title,
        definition: self.definition,
        partOfSpeech: self.partOfSpeech,
        timestamp: .now
      )
      Task { [weak self, deps] in
        guard let self = self else { return }
        do {
          try await deps.collexionService.add(word: newWord)
          await MainActor.run {
            self.isUploading = false
            deps.isPresented.wrappedValue = false
          }
        } catch {
          await MainActor.run {
            self.isUploading = false
            self.isPresentingAlert = true
            self.uploadError = error
          }
        }
      }
    }
    
    dismissAlertAction = { [weak self] in
      self?.isPresentingAlert = false
    }
  }
  
}
