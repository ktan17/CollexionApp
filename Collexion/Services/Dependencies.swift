//
//  Dependencies.swift
//  Collexion
//
//  Created by Kevin Tan on 12/31/21.
//

import Foundation

class Dependencies {
  
  // MARK: - Singleton pattern
  
  static let shared = Dependencies()
  
  private init() {
    collexionService = CollexionService()
  }
  
  // MARK: - Services
  
  let collexionService: CollexionServiceProtocol
  
}
