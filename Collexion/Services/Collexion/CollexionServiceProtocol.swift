//
//  CollexionServiceProtocol.swift
//  Collexion
//
//  Created by Kevin Tan on 12/31/21.
//

import Combine

protocol CollexionServiceProtocol {
  var words: AsyncStream<[Word]> { get }
}
