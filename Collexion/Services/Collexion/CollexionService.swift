//
//  CollexionService.swift
//  Collexion
//
//  Created by Kevin Tan on 12/31/21.
//

import Foundation

actor CollexionService: CollexionServiceProtocol {

  // MARK: - Constant

  private enum Constant {
    static let defaultsKey = "com.ktan17.words"
  }

  var words: AsyncStream<[Word]> {
    get async { wordsSubject.stream }
  }
  private let wordsSubject = AsyncCurrentValueSubject<[Word]>(value: [])

  init() {
    Task { [wordsSubject] in
      // Load words from User Defaults
      if let object = UserDefaults.standard.object(forKey: Constant.defaultsKey),
         let data = object as? Data,
         let words = try? PropertyListDecoder().decode([Word].self, from: data) {
        await wordsSubject.send(words)
      }
    }
  }

  func add(word: Word) async throws {
    let newValue = await wordsSubject.currentValue + [word]
    let object = try PropertyListEncoder().encode(newValue)
    UserDefaults.standard.set(object, forKey: Constant.defaultsKey)
    await wordsSubject.send(newValue)
  }

}
