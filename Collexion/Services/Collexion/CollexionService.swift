//
//  CollexionService.swift
//  Collexion
//
//  Created by Kevin Tan on 12/31/21.
//

import Foundation

actor CollexionService: CollexionServiceProtocol {
  let words: AsyncStream<[Word]> = AsyncStream { continuation in
    continuation.yield([
      .init(id: "1", title: "feces", definition: "poo", partOfSpeech: .noun, timestamp: .now),
      .init(id: "2", title: "apple", definition: "A fruit that is delicious and nutritious", partOfSpeech: .noun, timestamp: .now),
      .init(id: "3", title: "intrepid", definition: "Characterized by resolute fearlessness, fortitude, and endurance", partOfSpeech: .adjective, timestamp: .now)
    ])
    continuation.finish()
  }
}
