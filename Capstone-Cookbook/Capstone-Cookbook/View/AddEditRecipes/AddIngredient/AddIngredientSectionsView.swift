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
  @State private var isAlertShown = false // Add sections name
  @State private var sectionName = ""
//  @Environment (\.dismiss)
//  var dismiss

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
                  IngredientListView(
                    sectionName: $section.name,
                    sectionID: section.id.uuidString,
                    components: $section.components,
                    sectionNameInAlert: section.name ?? defaultSectionName,
                    delegate: self
                  )
                } label: {
                  Text(section.name ?? defaultSectionName)
                }
              }
            }
          }
        }
      }
      .navigationTitle("Ingredient List")
      .alert("Add Section", isPresented: $isAlertShown, actions: {
        TextField("Section Name", text: $sectionName)
          .autocorrectionDisabled()
        Button("OK", role: .none) {
          addSection()
        }
      }, message: {
        Text("Add Section to add Ingredient to it")
      })
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button(action: {
            // Add
            isAlertShown = true
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
  private func addSection() {
    guard !sectionName.isEmpty else { return }
    let newSection = IngredientSections(components: [], name: sectionName, position: ingredientSections.count + 1)
    ingredientSections.append(newSection)
  }
}

extension AddIngredientSectionsView: UpdateIngredientSections {
  func removeSection(sectionID: String) {
    if let index = ingredientSections.firstIndex(where: { $0.id.uuidString == sectionID }) {
      ingredientSections.remove(at: index)
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
