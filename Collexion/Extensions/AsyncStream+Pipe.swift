//
//  AsyncStream+Pipe.swift
//  Collexion
//
//  Created by Kevin Tan on 1/4/22.
//

import Foundation

extension AsyncStream {
  static func pipe() -> ((Element) -> Void, Self) {
    var input: (Element) -> Void = { _ in }
    let output = Self { continuation in
      input = { element in
        continuation.yield(element)
      }
    }
    return (input, output)
  }
}
