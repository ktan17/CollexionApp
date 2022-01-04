//
//  View+Theme.swift
//  Collexion
//
//  Created by Kevin Tan on 12/31/21.
//

import SwiftUI

struct Theme {
  enum FontStyle {
    case largeTitle
    case title
    case title2
    case title3
    case caption
    case body
    
    var font: Font {
      .init(uiFont as CTFont)
    }
    
    var uiFont: UIFont {
      switch self {
      case .largeTitle:
        return UIFont(name: "LibreBaskerville-Bold", size: 32)!
      case .title:
        return UIFont(name: "LibreBaskerville-Bold", size: 20)!
      case .title2:
        return UIFont(name: "LibreBaskerville-Bold", size: 16)!
      case .title3:
        return UIFont(name: "LibreBaskerville-Bold", size: 14)!
      case .caption:
        return UIFont(name: "LibreBaskerville-Italic", size: 12)!
      case .body:
        return UIFont(name: "LibreBaskerville-Regular", size: 12)!
      }
    }
    
    var lineSpacing: CGFloat? {
      switch self {
      case .body:
        return 4
      default:
        return nil
      }
    }
  }
  var smallPadding: CGFloat = 8
  var mediumPadding: CGFloat = 16
  var largePadding: CGFloat = 24
}

extension View {
  var theme: Theme {
    .init()
  }
}
