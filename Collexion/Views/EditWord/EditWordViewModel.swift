//
//  EditWordViewModel.swift
//  Collexion
//
//  Created by Kevin Tan on 1/1/22.
//

import Foundation
import SwiftUI

class EditWordViewModel: ObservableObject {
  
  // MARK: - Constant
  
  private enum Constant {
    static let titleCharacterLimit = 45
    static let definitionCharacterLimit = 250
  }
  
  // MARK: - Deps
  
  struct Deps {
    let title: String = ""
    let definition: String = ""
    let partOfSpeech: PartOfSpeech = .noun
  }
  
  @Published var title: String
  @Published var definition: String
  @Published var partOfSpeech: PartOfSpeech
  let titleValidator: (String) -> String?
  let definitionValidator: (String) -> String?
  
  init(deps: Deps) {
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
  }
}
