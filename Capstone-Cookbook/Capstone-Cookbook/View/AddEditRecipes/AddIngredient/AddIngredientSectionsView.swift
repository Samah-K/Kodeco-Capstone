//
//  AddIngredientView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 12/07/2024.
//

import SwiftUI

struct AddIngredientSectionsView: View {
  private let defaultSectionName = "Section"
  @Binding var ingredientSections: [IngredientSections]
  @State private var isAddSectionAlertPresented = false // Add sections name
  @State private var isDeleteSectionAlertPresented = false // Add sections name
  @State private var removeSectionIndex: IndexSet?
  @State private var sectionName = ""

  var body: some View {
    NavigationStack {
      VStack {
        Form {
          Group {
            Text("Divide your ingredients into sections.")
            + Text("\nFor example, a section for the `Pie Dough`")
            + Text("and another for the `Filling`")
          }
          .listRowBackground(Color.clear)
          ForEach($ingredientSections) { $section in
            Section {
              VStack {
                NavigationLink {
                  AddIngredientListView(
                    sectionName: $section.name,
                    sectionID: section.id.uuidString,
                    components: $section.components,
                    sectionNameInAlert: section.name ?? defaultSectionName
                  )
                } label: {
                  Text(section.name ?? defaultSectionName)
                }
              }
            }
          }
          .onDelete { indexSet in
            isDeleteSectionAlertPresented = true
            removeSectionIndex = indexSet
          }
        }
      }
      .navigationTitle("Ingredient List")
      .alert("Add Section", isPresented: $isAddSectionAlertPresented, actions: {
        TextField("Section Name", text: $sectionName)
          .autocorrectionDisabled()
        Button("OK", role: .none) {
          addSection()
        }
      }, message: {
        Text("Add Section to add Ingredient to it")
      })
      .alert(TextsConstants.removeSectionConfirmationAlertTitle, isPresented: $isDeleteSectionAlertPresented, actions: {
        Button("No", role: .cancel) {
          removeSectionIndex = nil
          isDeleteSectionAlertPresented = false
        }
        Button("Yes", role: .destructive) {
          // remove
          removeSection(sectionID: removeSectionIndex)
          isDeleteSectionAlertPresented = false
          removeSectionIndex = nil
        }
      }, message: {
        Text(TextsConstants.removeSectionConfirmationAlertMessage)
      })

      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button(action: {
            // Add
            isAddSectionAlertPresented = true
          }, label: {
            HStack {
              Image(systemName: "plus.square.on.square")
              Text("Section")
            }
          })
        }
      }
    }
  }
}
extension AddIngredientSectionsView {
  private func addSection() {
    guard !sectionName.isEmpty else { return }
    let newSection = IngredientSections(components: [], name: sectionName, position: ingredientSections.count + 1)
    ingredientSections.append(newSection)
  }

  private func removeSection(sectionID: IndexSet?) {
    if let indexSet = sectionID {
      ingredientSections.remove(atOffsets: indexSet)
    }
  }
}

#Preview {
  struct Preview: View {
    @State var section = TastyJSONSample().getRecipeFromJSONFile()?.recipes[0].ingredientSections ?? []
    var body: some View {
      AddIngredientSectionsView(
        ingredientSections: $section)
    }
  }
  return Preview()
}
