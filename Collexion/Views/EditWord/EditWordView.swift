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
    static let titlePlaceholder = "word"
    static let definitionPlaceholder = "Definition"
    static let navigationTitle = "New Word"
    static let partOfSpeechTitle = "Part of Speech"
    static let alertTitle = "Failed to Upload"
    static let cancelTitle = "Cancel"
    static let addTitle = "Add"
    static let dismissTitle = "Dismiss"
  }
  
  // MARK: - Properties
  
  @ObservedObject private var viewModel: EditWordViewModel
  @FocusState private var isFocused: Bool
  
  var body: some View {
    NavigationView {
      List {
        Section {
          ExpandingTextView(
            placeholder: Constant.titlePlaceholder,
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
            placeholder: Constant.definitionPlaceholder,
            text: $viewModel.definition,
            validator: viewModel.definitionValidator
          )
          .themedFont(.body)
          .textInputAutocapitalization(.never)
          .padding(.bottom, theme.smallPadding)
        }
        Section {
          Picker(Constant.partOfSpeechTitle, selection: $viewModel.partOfSpeech) {
            ForEach(PartOfSpeech.allCases) { partOfSpeech in
              Text(partOfSpeech.rawValue)
                .tag(partOfSpeech as PartOfSpeech?)
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
          Button(
            action: viewModel.cancelAction,
            label: { Text(Constant.cancelTitle) }
          )
        }
        ToolbarItem(placement: .confirmationAction) {
          Button(
            action: viewModel.addAction,
            label: { Text(Constant.addTitle) }
          )
          .disabled(viewModel.isAddButtonDisabled)
        }
      }
      .alert(
        Constant.alertTitle,
        isPresented: $viewModel.isPresentingAlert,
        presenting: viewModel.uploadError,
        actions: { _ in
          Button(
            action: viewModel.dismissAlertAction,
            label: { Text(Constant.dismissTitle) }
          )
        },
        message: { error in
          error.map { Text($0.localizedDescription) }
        }
      )
    }
  }
  
  // MARK: - Initializers
  
  init(viewModel: ObservedObject<EditWordViewModel>) {
    _viewModel = viewModel
  }
  
}
