//
//  AsyncCurrentValueSubject.swift
//  Collexion
//
//  Created by Kevin Tan on 1/4/22.
//

import Combine

actor AsyncCurrentValueSubject<Element> {
  let stream: AsyncStream<Element>
  private(set) var currentValue: Element
  private let input: (Element) -> Void
  
  init(value: Element) {
    (input, stream) = AsyncStream<Element>.pipe()
    currentValue = value
    input(value)
  }
  
  func send(_ element: Element) {
    currentValue = element
    input(element)
  }
}
