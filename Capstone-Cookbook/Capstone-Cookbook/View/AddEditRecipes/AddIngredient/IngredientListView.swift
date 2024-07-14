//
//  IngredientListView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 15/07/2024.
//

import SwiftUI

struct IngredientListView: View {
  @Binding var sectionName: String?
  @Binding var components: [Component]
  // Don't update the section name immediately while the user still writing, only update it when user clicks `OK`, since the user can change their mind, and decide that they don't want to update the section name now
  @State var sectionNameInAlert: String
  @State private var isAlertShown = false // Add sections name
  var body: some View {
    Form {
      Section {
        VStack {
          HStack {
            Button(action: {
              // Edit Section name
              isAlertShown = true
            }, label: {
              HStack {
                Image(systemName: "pencil.line")
                Text("\(sectionName ?? "Section")")
              }
            })
          }
          .alert("Edit Section Name", isPresented: $isAlertShown, actions: {
            TextField("Section Name", text: $sectionNameInAlert)
            Button("OK", role: .none) {
              isAlertShown = false
              sectionName = sectionNameInAlert
            }
            Button("Cancel", role: .cancel) {}
          }, message: {
            Text("Add Section to add Ingredient to it")
          })
        }
      }.listRowBackground(Color.clear)
      Section {
        List {
          ForEach($components) { comp in
            NavigationLink {
              AddIngredientView(
                ingredient: comp.ingredient,
                measurement: comp.measurements)
            } label: {
              // Can't split the next line, which causes `Line Length Violation`
              // swiftlint:disable:next line_length
              Text("\(HandleMeasurement().getIngredientDescription(ingredient: comp.wrappedValue.ingredient, measurement: comp.wrappedValue.measurements[0]))")
            }
          }
          .onMove { indices, newOffset in
            components.move(fromOffsets: indices, toOffset: newOffset)
          }
          .onDelete { indexSet in
            components.remove(atOffsets: indexSet)
          }
        }
      }
    }
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        NavigationLink {
          //          AddIngredientView(ingredien/*t: <#Binding<Ingredient>#>, measurement: <#Binding<Measurement>#>)*/
        } label: {
          Image(systemName: "plus")
        }
      }
    }
  }
}

#Preview("IngredientListView") {
  struct Preview: View {
    private static let section = TastyJSONSample().getRecipeFromJSONFile()?.recipes[0].ingredientSections.first
    @State var components = Preview.section?.components ?? []
    @State var sectionName = Preview.section?.name
    var body: some View {
      return NavigationStack {
        VStack {
          IngredientListView(
            sectionName: $sectionName,
            components: $components,
            sectionNameInAlert: sectionName ?? "Section")
        }
      }
    }
  }
  return Preview()
}
