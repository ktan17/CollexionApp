//
//  CollexionTests.swift
//  CollexionTests
//
//  Created by Kevin Tan on 12/27/21.
//

import XCTest
import SwiftUI
@testable import Collexion

class CollexionTests: XCTestCase {
  
  func testExample() throws {
    var isPresented = false
    let isPresentedBinding = Binding<Bool>(
      get: { isPresented },
      set: { newValue in isPresented = newValue }
    )
    let sut = EditWordViewModel(
      deps: .init(
        isPresented: isPresentedBinding,
        collexionService: CollexionService()
      )
    )
  }
  
}
