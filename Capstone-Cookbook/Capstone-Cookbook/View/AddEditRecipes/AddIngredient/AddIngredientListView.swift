//
//  IngredientListView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 15/07/2024.
//

import SwiftUI

struct AddIngredientListView: View {
  @Binding var sectionName: String?
  var sectionID: String
  @Binding var components: [Component]
  // Don't update the section name immediately while the user still writing, only update it when user clicks `OK`, since the user can change their mind, and decide that they don't want to update the section name now
  @State var sectionNameInAlert: String
  @State private var isEditSectionNameAlertPresented = false // Add sections name
  @State private var isRemoveSectionAlertPresented = false
  var delegate: UpdateIngredientSections?

  var body: some View {
    Form {
      Section {
        VStack {
          HStack {
            Button(action: {
              // Edit Section name
              isEditSectionNameAlertPresented = true
            }, label: {
              HStack {
                Image(systemName: "pencil.line")
                Text("\(sectionName ?? "Section")")
                  .font(.title)
              }
            })
          }
          .alert("Edit Section Name", isPresented: $isEditSectionNameAlertPresented, actions: {
            TextField("Section Name", text: $sectionNameInAlert)
              .autocorrectionDisabled()
            Button("OK", role: .none) {
              isEditSectionNameAlertPresented = false
              sectionName = sectionNameInAlert
            }
            Button("Cancel", role: .cancel) {}
          }, message: {
            Text("Add Section to add Ingredient to it")
          })
          .alert(TextsConstants().removeSectionConfirmationAlertTitle, isPresented: $isRemoveSectionAlertPresented) {
            Button("Yes", role: .destructive) {
              removeSection(sectionID: sectionID)
            }
            Button("No", role: .cancel) { }
          } message: {
            Text(TextsConstants().removeSectionConfirmationAlertMessage)
          }
        }
      }.listRowBackground(Color.clear)
      Section {
        List {
          ForEach($components) { component in
            NavigationLink {
              AddIngredientView(
                componentID: component.id.uuidString,
                ingredient: component.ingredient.wrappedValue,
                measurement: component.measurements.wrappedValue,
                addOrEdit: AddOrEditEnum.editRecipe,
                delegate: self)
            } label: {
              // Can't split the next line, which causes `Line Length Violation`
              // swiftlint:disable:next line_length
              Text("\(HandleMeasurement().getIngredientDescription(ingredient: component.wrappedValue.ingredient, measurements: component.wrappedValue.measurements))")
            }
          }
          .onMove { indices, newOffset in
            components.move(fromOffsets: indices, toOffset: newOffset)
          }
          .onDelete { indexSet in
            components.remove(atOffsets: indexSet)
          }
        }
      } footer: {
        HStack {
          Spacer()
          Button {
            isRemoveSectionAlertPresented = true
          } label: {
            Text("Remove Section")
              .foregroundStyle(.red)
              .padding(.top, 40)
          }
          Spacer()
        }
      }
    }
    .onAppear {
      print(components)
    }
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        NavigationLink {
          let ingredientComponent = EmptyObjects().createEmptyIngredientComponent()
          AddIngredientView(
            componentID: "",
            ingredient: ingredientComponent.ingredient,
            measurement: ingredientComponent.measurements,
            addOrEdit: AddOrEditEnum.addRecipe,
            delegate: self)
        } label: {
          HStack {
            Image(systemName: "plus")
            Text("Ingredient")
          }
        }
      }
    }
  }

  func removeSection(sectionID: String) {
    if let delegate = delegate {
      delegate.removeSection(sectionID: sectionID)
    }
  }
}

extension AddIngredientListView: UpdateIngredientComponent {
  func saveComponent(componentID: String, ingredient: Ingredient, measurement: [Measurement], shouldAddComponent: AddOrEditEnum) {
    if shouldAddComponent == .addRecipe {
      let component = Component(
        extraComment: "",
        rawText: "",
        ingredient: ingredient,
        measurements: measurement)
      components.append(component)
    } else {
      // Edit
      if let componentIndex = components.firstIndex(where: { $0.id.uuidString == componentID }) {
        components[componentIndex].ingredient = ingredient
        components[componentIndex].measurements = measurement
      }
    }
  }
}

#Preview("IngredientListView") {
  struct Preview: View {
    private static let section = TastyJSONSample().getRecipeFromJSONFile()?.recipes[0].ingredientSections.first
    @State var components = Preview.section?.components ?? []
    @State var sectionName = Preview.section?.name
    var sectionID: String = Preview.section?.id.uuidString ?? ""
    var body: some View {
      return NavigationStack {
        VStack {
          AddIngredientListView(
            sectionName: $sectionName,
            sectionID: sectionID,
            components: $components,
            sectionNameInAlert: sectionName ?? "Section")
        }
      }
    }
  }
  return Preview()
}
