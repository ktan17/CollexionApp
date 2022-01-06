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
    let partOfSpeech: PartOfSpeech? = nil
    let isPresented: Binding<Bool>
    let collexionService: CollexionServiceProtocol
  }
  
  // MARK: - Outputs
  
  @Published var title: String
  @Published var definition: String
  @Published var partOfSpeech: PartOfSpeech?
  @Published var isFocused = false
  @Published var isAddButtonDisabled = true
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
    
    // Text validation logic
    
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
    
    // Actions
    
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
    
    let uploadStateSubject = PassthroughSubject<UploadState, Never>()
    addAction = { [weak self] in
      guard let self = self,
            let partOfSpeech = self.partOfSpeech else {
        return
      }
      uploadStateSubject.send(.uploading)
      
      let newWord = Word(
        id: UUID().uuidString,
        title: self.title,
        definition: self.definition,
        partOfSpeech: partOfSpeech,
        timestamp: .now
      )
      Task { [deps] in
        do {
          try await deps.collexionService.add(word: newWord)
          uploadStateSubject.send(.idle)
          await MainActor.run {
            deps.isPresented.wrappedValue = false
          }
        } catch {
          uploadStateSubject.send(.failed(error: error))
        }
      }
    }
    
    dismissAlertAction = { [weak self] in
      self?.isPresentingAlert = false
    }
    
    // State drivers
    
    uploadStateSubject
      .merge(with: Just(.idle))  // startWith
      .receive(on: DispatchQueue.main)
      .sink { [weak self] uploadState in
        switch uploadState {
        case .idle:
          self?.isUploading = false
          self?.uploadError = nil
        case .uploading:
          self?.isUploading = true
        case let .failed(error):
          self?.isUploading = false
          self?.uploadError = error
          self?.isPresentingAlert = true
        }
      }
      .store(in: &cancellables)
    
    $title
      .combineLatest($definition, $partOfSpeech)
      .sink { [weak self] title, definition, partOfSpeech in
        self?.isAddButtonDisabled = (
          title.isEmpty || definition.isEmpty || partOfSpeech == nil
        )
      }
      .store(in: &cancellables)
  }
  
}
