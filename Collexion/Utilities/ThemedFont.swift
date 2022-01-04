//
//  ThemedFont.swift
//  Collexion
//
//  Created by Kevin Tan on 12/31/21.
//

import SwiftUI

struct ThemedFont: ViewModifier {
  var style: Theme.FontStyle
  func body(content: Content) -> some View {
    content.font(style.font)
  }
}

extension View {
  @ViewBuilder
  func themedFont(_ style: Theme.FontStyle) -> some View {
    let view = modifier(ThemedFont(style: style))
    switch style.lineSpacing {
    case let .some(lineSpacing):
      view.lineSpacing(lineSpacing)
    default:
      view
    }
  }
}
