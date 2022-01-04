//
//  Word.swift
//  Collexion
//
//  Created by Kevin Tan on 12/30/21.
//

import Foundation

enum PartOfSpeech: String, CaseIterable, Identifiable {
  case noun
  case verb
  case adjective
  case adverb
  
  var id: Int {
    hashValue
  }
  
  var abbreviation: String {
    switch self {
    case .noun:
      return "n."
    case .verb:
      return "v."
    case .adjective:
      return "adj."
    case .adverb:
      return "adv."
    }
  }
}

struct Word: Identifiable {
  var id: String
  var title: String
  var definition: String
  var partOfSpeech: PartOfSpeech
  var timestamp: Date
}
