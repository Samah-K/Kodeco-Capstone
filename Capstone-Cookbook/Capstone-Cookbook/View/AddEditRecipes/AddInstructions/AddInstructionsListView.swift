//
//  AddInstructionsView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 18/07/2024.
//

import SwiftUI

struct AddInstructionsListView: View {
  @Binding var instructions: [Instructions]
  var body: some View {
    NavigationStack {
      Form {
        Section {
          ForEach(instructions) { instruction in
            NavigationLink {
              AddInstructionView(
                instruction: instruction,
                addOrEdit: .editRecipe,
                delegate: self)
            } label: {
              HStack {
                Text(instruction.getBulletOrNumber())
                  .font(.title3)
                  .fontWeight(.light)
                  .foregroundStyle(Color.accentSecondary)
                Text(instruction.displayText)
              }
            }
          }
          .onDelete { offsets in
            instructions.remove(atOffsets: offsets)
            updateInstructionPosition()
          }
          .onMove { source, destination in
            instructions.move(fromOffsets: source, toOffset: destination)
            updateInstructionPosition()
          }
        }
      }
      .navigationTitle("Instructions")
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          NavigationLink {
            let instruction = EmptyObjects().createEmptyInstruction()
            AddInstructionView(
              instruction: instruction,
              addOrEdit: .addRecipe,
              delegate: self)
          } label: {
            HStack {
              Image(systemName: "plus")
              Text("Instruction")
            }
          }
        }
      }
    }
  }
}

extension AddInstructionsListView {
  func updateInstructionPosition() {
    for index in 0..<instructions.count {
      instructions[index].position = index + 1
    }
  }
}

extension AddInstructionsListView: InstructionProtocol {
  func saveInstruction(instruction: Instructions, addOrEdit: AddOrEditEnum) {
    switch addOrEdit {
    case .addRecipe:
      instructions.append(instruction)
    case .editRecipe:
      if let index = instructions.firstIndex(where: { $0.id == instruction.id }) {
        instructions[index] = instruction
      }
    }
    updateInstructionPosition()
  }
}


#Preview {
  struct Preview: View {
    private static let tastyRecipe = TastyJSONSample().getRecipeFromJSONFile()?.recipes[0]
    @State var recipe = Recipe(tastyRecipe: tastyRecipe, recipeType: .myRecipe)
    var body: some View {
      NavigationStack {
        AddInstructionsListView(instructions: $recipe.tastyRecipe.instructions)
      }
    }
  }
  return Preview()
}
