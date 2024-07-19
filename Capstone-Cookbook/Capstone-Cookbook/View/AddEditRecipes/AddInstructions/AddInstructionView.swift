//
//  SwiftUIView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 18/07/2024.
//

import SwiftUI

struct AddInstructionView: View {
  @State var instruction: Instructions
  @State var instructionText: String = ""
  @FocusState private var isAddInstructionFocued: Bool
  @State private var isConfirmationAlertPresented = false
  var addOrEdit: AddOrEditEnum
  var delegate: InstructionProtocol?
  @Environment(\.dismiss)
  var dismiss
  var body: some View {
    VStack {
      Form {
        Section {
          TextField("Add Instruction...", text: $instructionText, axis: .vertical)
            .lineLimit(8...20)
            .autocorrectionDisabled()
            .padding()
            .focused($isAddInstructionFocued)
        }
      }
      .navigationBarBackButtonHidden()
      .navigationTitle(addOrEdit == .addRecipe ? "Add Instruction" : "Edit Instruction")
      .alert(
        TextsConstants.leavingInstructionConfirmation,
        isPresented: $isConfirmationAlertPresented) {
          Button("Yes", role: .destructive) { dismiss() }
          Button("No", role: .cancel) {}
      }
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
              saveInstruction()
              dismiss()
            }, label: {
              Text("Save")
            })
          }
          ToolbarItem(placement: .topBarLeading) {
            Button(action: {
              isConfirmationAlertPresented = true
            }, label: {
              BackNavigationButton()
            })
          }
          ToolbarItemGroup(placement: .keyboard) {
            Button(action: {
              isAddInstructionFocued = false
            }, label: {
              Text("Done")
            })
          }
        }
    }
    .interactiveDismissDisabled()
    .onAppear {
      instructionText = instruction.displayText
      ViewConstants.enableSwipBackGesture = false
    }
    .onDisappear {
      ViewConstants.enableSwipBackGesture = true
    }
  }
  func saveInstruction() {
    instruction.displayText = instructionText
    if let delegate = delegate {
      delegate.saveInstruction(instruction: instruction, addOrEdit: addOrEdit)
    }
  }
}

#Preview("AddInstructionView") {
  struct Preview: View {
    let tastyRecipe = TastyJSONSample().getRecipeFromJSONFile()?.recipes[0]
    var body: some View {
      VStack {
        AddInstructionView(
          instruction: tastyRecipe?.instructions[2] ?? EmptyObjects().createEmptyInstruction(),
          addOrEdit: .addRecipe,
          delegate: nil)
      }
    }
  }
  return Preview()
}
