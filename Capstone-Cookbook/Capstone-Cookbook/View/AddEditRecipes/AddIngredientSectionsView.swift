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
                    components: $section.components,
                    sectionNameInAlert: section.name ?? defaultSectionName)
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
            Image(systemName: "plus.square.on.square")
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
          ForEach(components) { component in
            NavigationLink {
              AddIngredientView()
            } label: {
              Text(component.rawText)
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
          AddIngredientView()
        } label: {
          Image(systemName: "plus")
        }
      }
    }
  }
}

struct AddIngredientView: View {
  @State var ingredientName = ""
  @State var ingredientPlural = ""
  @State var ingredientSignal = ""
  @State var quantity = 0
  @State var unitString = UnitsName.none
  @State var unit: Unit?

  @State var system = UnitsSystem.metric.rawValue
  var body: some View {
    Form {
      Section {
        TextField("Ingredient Name", text: $ingredientName)
        TextField("Ingredient Name (Singular)", text: $ingredientName)
        TextField("Ingredient Name (Plural)", text: $ingredientName)
      } header: {
        Text("Ingredient Name")
      } footer: {
        Text("Plural and Singular are optional.")
          .font(.caption)
      }
      Section {
        TextField("Quantity", value: $quantity, format: .number)
          .keyboardType(.decimalPad)
        Picker("System", selection: $system) {
          ForEach(UnitsSystem.allCases, id: \.self) { unitSystem in
            Text(unitSystem.rawValue.uppercased())
              .tag(unitSystem.rawValue.uppercased())
          }
        }.disabled(true)
        .pickerStyle(.segmented)
        Picker("Unit", selection: $unitString) {
          ForEach(UnitsSystem.allCases, id: \.self) { system in
            Section {
              if let unitsInSystem = UnitsConstant().unitsInUnitSystems[system] {
                ForEach(unitsInSystem, id: \.self) { unit in
                  Text(unit.rawValue)
                    .tag(unit.rawValue)
                }
              }
            } header: {
              Text("\(system.rawValue.uppercased())")
            }
          }
        }
        .onChange(of: unitString) { _, newValue in
          if let unitSystem = newValue.getUnitSystem() {
            system = unitSystem.rawValue.uppercased()
          }
        }
      } header: {
        Text("Ingredient Quantity")
      } footer: {
        Group {
          Text("You only need to provide one value in the metric or the imperial systems. ")
          + Text("The other value will be automatically calculated when you save the recipe.")
        }
      }
    }
    .navigationTitle("Add New Ingredient")
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button(action: {
        }, label: {
          Text("Save")
        })
      }
    }
  }
}

#Preview {
  struct Preview: View {
    @State var section = TastyJSONSample().getRecipeFromJSONFile()?.recipes[0].ingredientSections ?? []
    var body: some View {
      AddIngredientSectionsView(ingredientSections: $section)
    }
  }
  return Preview()
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

#Preview("AddIngredientView") {
  NavigationStack {
    AddIngredientView()
  }
}
