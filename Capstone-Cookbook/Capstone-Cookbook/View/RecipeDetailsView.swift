//
//  RecipeDetailsView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 02/07/2024.
//

import SwiftUI

struct RecipeDetailsView: View {
  @EnvironmentObject var tastyStore: TastyStore
  @State private var instructionDisclousureExpand = false
  @State private var ingredientdisclousureExpand = false

  var recipe: TastyRecipe
  var body: some View {
    GeometryReader { proxy in
      VStack {
        // image
        VStack {
          AsyncImage(url: URL(string: recipe.getRecipeImageURL()), content: { image in
            image.resizable()
          }, placeholder: {
            ZStack {
              ProgressView()
            }
            .frame(width: 300, height: 300)
          })
          .clipShape(Circle())
          .overlay {
            Circle()
              .stroke(Color.white, lineWidth: 5.0)
          }
          .shadow(radius: 3.0)
          .frame(width: 300, height: 300)
        }
        .frame(height: proxy.size.height * 0.4)


        // Recipe Name + Recipe Description
        VStack(spacing: 15) {
          Text(recipe.name)
            .font(.title)
          // TODO: Fix this
          Text(recipe.description)
            .font(.subheadline)
            .lineLimit(4)
            .allowsTightening(true)
        }
        .padding(20)
        .frame(height: proxy.size.height * 0.2)
        //         Nutrition
        if !ingredientdisclousureExpand && !instructionDisclousureExpand {
          if let recipeNutrition = recipe.nutrition {
            NutritionView(
              numberOfPeople: recipe.numServing,
              recipeID: recipe.id,
              nutrition: recipeNutrition)
          }
        }
        ScrollView {
          if !ingredientdisclousureExpand {
            InstructionsViews(disclousureExpand: $instructionDisclousureExpand, instructions: recipe.instructions)
          }
          if !instructionDisclousureExpand {
            IngredientView(
              disclousureExpand: $ingredientdisclousureExpand,
              ingredientSections: recipe.ingredientSections
            )
          }
        }
        .frame(height: proxy.size.height * 0.4)
      }
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button("Add") {
            tastyStore.myRecipesStore.addNewRecipe(recipe: recipe)
          }
        }
      }
    }
    .padding(.bottom, 30)
  }
}

#Preview {
  NavigationStack {
    RecipeDetailsView(recipe: (TastyRecipeModel().getExample()))
      .environmentObject(TastyStore())
  }
}

struct InstructionsViews: View {
  @Binding var disclousureExpand: Bool
  let instructions: [Instructions]
  var body: some View {
    VStack {
      DisclosureGroup(
        isExpanded: $disclousureExpand,
        content: {
          ScrollView {
            VStack(alignment: .leading, spacing: 5) {
              ForEach(instructions) { instruction in
                Group {
                  Text("\(instruction.getBulletOrNumber()) ").fontWeight(.bold).foregroundStyle(.accent)
                  + Text("\(instruction.displayText)").fontWeight(.light)
                }
              }
            }
          }
        },
        label: {
          Text("Instructions")
            .font(.title)
        }
      )
      .padding(.horizontal, 20)
    }
  }
}

#Preview("Instructions") {
  InstructionsViews(disclousureExpand: .constant(true), instructions: TastyRecipeModel().getExample().instructions)
//    .environmentObject(TastyStore())
}

struct IngredientView: View {
  @Binding var disclousureExpand: Bool
  let ingredientSections: [IngredientSections]
  var body: some View {
    VStack {
      DisclosureGroup(
        isExpanded: $disclousureExpand,
        content: {
          VStack {
            ForEach(ingredientSections) { section in
              if ingredientSections.count > 1 {
                DisclosureGroup(
                  content: {
                    ScrollView {
                      VStack(alignment: .leading, spacing: 5) {
                        ForEach(section.components) { component in
                          Text("• \(component.getIngredientDescription())")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                      }
                    }
                  },
                  label: {
                    Text("\(section.name ?? "")")
                      .font(.title2)
                  }
                )
                .padding(.horizontal, 20)
              } else {
                ForEach(section.components) { component in
                  VStack(alignment: .leading, spacing: 5) {
                    Text("• \(component.getIngredientDescription())")
                      .frame(maxWidth: .infinity, alignment: .leading)

                  }
                }
              }
            }
          }
        },
        label: {
          Text("Ingredient")
            .font(.title)
        }
      )
    }
    //    .frame(width: .infinity, height: 200)
    .padding(.horizontal, 20)
  }
}

#Preview("Ingredient") {
  IngredientView(
    disclousureExpand: .constant(false),
    ingredientSections: TastyRecipeModel().getExample().ingredientSections)
//  .environmentObject(TastyStore())
}

struct NutritionView: View {
  @EnvironmentObject var tastyStore: TastyStore
  @State var numberOfPeople: Int
  let recipeID: Int
  let nutrition: Nutrition
  var body: some View {
    HStack(alignment: .firstTextBaseline, spacing: 20) {
      Spacer(minLength: 10)
      VStack {
        HStack {
          VStack(spacing: 5) {
            Button(action: {
              scaleARecipe(scaleRecipe: .increment)
            }, label: {
              Image(systemName: "plus.rectangle.fill")
            })
            Button(action: {
              scaleARecipe(scaleRecipe: .decrement)
            }, label: {
              Image(systemName: "minus.rectangle.fill")
            })
          }
          NutritionSubView(title: "Serving", value: numberOfPeople)
        }
      }
      if let calories = nutrition.calories {
        NutritionSubView(title: "Calories", value: calories)
      }
      if let fat = nutrition.fat {
        NutritionSubView(title: "Fat", value: fat)
      }
      if let sugar = nutrition.sugar {
        NutritionSubView(title: "Suger", value: sugar)
      }
      Spacer(minLength: 10)
    }
  }
  enum ScaleRecipe {
    case increment, decrement
  }

  func scaleARecipe(scaleRecipe: ScaleRecipe) {
    switch scaleRecipe {
    case .increment:
      numberOfPeople += 1
    case .decrement:
      if numberOfPeople > 1 {
        numberOfPeople -= 1
      }
    }
    tastyStore.scaleRecipe(for: recipeID, numberOfPeople: numberOfPeople)
  }
}

struct NutritionSubView: View {
  let title: String
  let value: Int
  var body: some View {
    VStack {
      Text("\(title)")
      Text("\(value)")
    }
  }
}

struct DetailsSectionView: View {
  @State private var isSectionOpened = false
  var sectionTitle: String
  var body: some View {
    VStack {
      HStack {
        Text(sectionTitle)
          .font(.title2)
        Spacer()
        Button(action: {
          isSectionOpened.toggle()
        }, label: {
          Image(systemName: isSectionOpened ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
        })
      }
      if isSectionOpened {
        VStack {
          HStack {
            Image(systemName: "circle.fill")
              .padding(.trailing, 20)
            Text("Example 1")
          }
          HStack {
            Image(systemName: "circle.fill")
              .padding(.trailing, 20)
            Text("Example 2")
          }
          HStack {
            Image(systemName: "circle.fill")
              .padding(.trailing, 20)
            Text("Example 3")
          }
          HStack {
            Image(systemName: "circle.fill")
              .padding(.trailing, 20)
            Text("Example 4")
          }
          HStack {
            Image(systemName: "circle.fill")
              .padding(.trailing, 20)
            Text("Example 5")
          }
        } .padding(20)
      }
    }.padding(20)
  }
}
