//
//  Router.swift
//  Collexion
//
//  Created by Kevin Tan on 12/31/21.
//

import SwiftUI

protocol Router {
  associatedtype Route
  associatedtype DestinationView: View

  @ViewBuilder
  func destination(for route: Route) -> DestinationView
}

extension Router {
  var dependencies: Dependencies {
    Dependencies.shared
  }
}
