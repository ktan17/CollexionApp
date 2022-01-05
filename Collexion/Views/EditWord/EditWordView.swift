//
//  EditWordView.swift
//  Collexion
//
//  Created by Kevin Tan on 1/1/22.
//

import SwiftUI

struct EditWordView: View {
  
  // MARK: - Constant
  
  private enum Constant {
    enum Title {
      static let placeholder = "word"
    }
    enum Definition {
      static let placeholder = "Definition"
    }
    static let navigationTitle = "New Word"
    static let partOfSpeechTitle = "Part of Speech"
  }
  
  // MARK: - Properties
  
  @ObservedObject private var viewModel: EditWordViewModel
  @FocusState private var isFocused: Bool
  
  var body: some View {
    NavigationView {
      List {
        Section {
          ExpandingTextView(
            placeholder: Constant.Title.placeholder,
            text: $viewModel.title,
            validator: viewModel.titleValidator
          )
          .themedFont(.title)
          .textInputAutocapitalization(.never)
          .disableAutocorrection(true)
          .padding(.top, theme.smallPadding)
          .focused($isFocused)
          .onAppear(perform: viewModel.onAppear)
          .onReceive(viewModel.$isFocused) { focused in
            isFocused = focused
          }
          ExpandingTextView(
            placeholder: Constant.Definition.placeholder,
            text: $viewModel.definition,
            validator: viewModel.definitionValidator
          )
          .themedFont(.body)
          .padding(.bottom, theme.smallPadding)
        }
        Section {
          Picker(Constant.partOfSpeechTitle, selection: $viewModel.partOfSpeech) {
            ForEach(PartOfSpeech.allCases) { partOfSpeech in
              Text(partOfSpeech.rawValue)
                .tag(partOfSpeech)
                .themedFont(.body)
            }
          }
          .themedFont(.title3)
        }
      }
      .navigationTitle(Constant.navigationTitle)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button(action: viewModel.cancelAction, label: { Text("Cancel") })
        }
        ToolbarItem(placement: .confirmationAction) {
          Button(action: viewModel.addAction, label: { Text("Add") })
        }
      }
    }
  }
  
  // MARK: - Initializers
  
  init(viewModel: ObservedObject<EditWordViewModel>) {
    _viewModel = viewModel
  }
  
}
