//
//  ExpandingTextView.swift
//  Collexion
//
//  Created by Kevin Tan on 1/1/22.
//

import Combine
import SwiftUI

struct ExpandingTextView: View {
  
  // MARK: - Constant
  
  private enum Constant {
    static let editorInset: CGFloat = 8
    static let placeholderVerticalInset: CGFloat = 8
    static let placeholderHorizontalInset: CGFloat = 5
  }
  
  var placeholder: String
  @Binding var text: String
  var validator: ((String) -> String?)?
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      if text.isEmpty {
        Text(placeholder)
          .foregroundColor(.gray)
          .padding([.top, .bottom], Constant.placeholderVerticalInset)
          .padding([.leading, .trailing], Constant.placeholderHorizontalInset)
      }
      TextEditor(text: $text)
      Text(text)
        .opacity(0)
        .padding(.all, Constant.editorInset)
    }
    .onReceive(Just(text)) { _ in
      if let replacement = validator?(text) {
        text = replacement
      }
    }
  }
  
}

struct ExpandingTextView_Previews: PreviewProvider {
  @State static var text = ""
  static var previews: some View {
    ExpandingTextView(
      placeholder: "Placeholder",
      text: $text
    )
    .previewDevice("iPhone 13")
  }
}
