//
//  RecipeDetailsView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 02/07/2024.
//

import SwiftUI

struct RecipeDetailsView: View {
  @EnvironmentObject var recipeStoreManager: RecipesStore
  @State private var instructionDisclousureExpand = false
  @State private var ingredientdisclousureExpand = false
  @State private var descriptionShowingModal = false
  @State var isNewRecipeSheetPresented = false
  @State var recipe: Recipe
  var addFavoriteButton: Bool

  var body: some View {
    ZStack {
      GeometryReader { proxy in
        VStack {
          // image
          VStack {
            VStack {
              if let url = recipe.tastyRecipe.imageDataURL {
                RecipeAsyncImage(thumbnailURL: url)
              } else {
                RecipeImage(thumbnailURL: recipe.tastyRecipe.getRecipeImageURL())
              }
            }
            .frame(width: 280, height: 280)
            .clipShape(RoundedRectangle(cornerRadius: ViewConstants.roundCorner))
            .shadow(radius: 3.0)
          }
          .padding(.top, 20)
          .frame(height: proxy.size.height * 0.5)
          // Recipe Name + Recipe Description
          VStack(spacing: 15) {
            Text(recipe.tastyRecipe.name)
              .font(.title)
              .padding(.top, 6)
            RecipeTime(recipe: recipe)
            Text(recipe.tastyRecipe.description ?? " - ")
              .font(.subheadline)
              .lineLimit(4)
              .allowsTightening(true)
              .onTapGesture {
                descriptionShowingModal = true
              }
          }
          .padding(.horizontal, 20)
          .frame(height: proxy.size.height * 0.3)

          VStack(spacing: 12.0) {
            VStack {
              NavigationLink {
                InstructionListView(
                  instructions: recipe.tastyRecipe.instructions,
                  videoURL: recipe.tastyRecipe.videoURL)
              } label: {
                RecipeDetailsButton(
                  imageName: ImagesConstants.Instructions,
                  text: "Instructions",
                  background: Color.accentColor)
              }
            }
            VStack {
              NavigationLink {
                IngredientListView(ingredientSection: recipe.tastyRecipe.ingredientSections)
              } label: {
                RecipeDetailsButton(
                  imageName: ImagesConstants.Ingredient,
                  text: "Check Ingredient",
                  background: Color.tint
                )
              }
            }
          }
          .frame(height: proxy.size.height * 0.2)
          .padding(.top, 8)
        }
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            if recipe.recipeType == .tastyRecipe {
              AddRecipeButton(
                isAddedToMyRecipes: $recipe.isRecipeAddedToMyCookbook,
                recipeID: recipe.id)
            } else {
              NavigationLink {
                AddRecipeView(recipe: $recipe, addOrEdit: .editRecipe)
              } label: {
                Text("Edit")
              }
            }
          }
        }
      }
      .padding(.bottom, 30)
      if $descriptionShowingModal.wrappedValue {
        if let description = recipe.tastyRecipe.description {
          CustomPopup(
            isPopPresented: $descriptionShowingModal,
            popText: description)
        }
      }
    }
  }
}
struct RecipeTime: View {
  @State var recipe: Recipe
  var body: some View {
    HStack(alignment: .firstTextBaseline) {
      Spacer()
      Spacer()
      HStack(alignment: .center) {
        if let prepareTime = recipe.tastyRecipe.prepTimeMinutes {
          Image("\(ImagesConstants.PrepareTime)")
            .resizable()
            .frame(width: 25, height: 25)
          Text(HandleMeasurement().calculateTotalTime(prepTime: prepareTime, cookTime: 0))
        }
      }
      Spacer()
      if let cookTime = recipe.tastyRecipe.cookTimeMinutes {
        HStack {
          Image(systemName: "frying.pan")
            .frame(width: 25, height: 25)
          Text(HandleMeasurement().calculateTotalTime(prepTime: 0, cookTime: cookTime))
        }
      }
      Spacer()
      Spacer()
      Spacer()
    }
  }
}

struct RecipeDetailsButton: View {
  let imageName: String
  let text: String
  let background: Color
  var body: some View {
    HStack {
      Image(imageName)
        .resizable()
        .frame(width: 30, height: 30)
      Text(text)
        .font(.title2)
        .foregroundStyle(.white)
    }
    .padding()
    .background(background)
    .clipShape(RoundedRectangle(cornerRadius: ViewConstants.roundCorner))
    .overlay {
      RoundedRectangle(cornerRadius: ViewConstants.roundCorner)
        .stroke(.white, lineWidth: 2.0)
    }
  }
}
// #Preview {
//  NavigationStack {
//    RecipeDetailsView(
//      recipe: .constant(TastyRecipeModel().getExample()), addFavoriteButton: true)
//  }
//  .environmentObject(RecipesStore())
// }

#Preview {
  struct Preview: View {
    private static let tastyRecipe = TastyJSONSample().getRecipeFromJSONFile()?.recipes[0]
    @State var recipe = Recipe(tastyRecipe: tastyRecipe, recipeType: .myRecipe)
    var body: some View {
      NavigationStack {
        RecipeDetailsView(recipe: recipe, addFavoriteButton: true)
          .environmentObject(RecipesStore())
      }
    }
  }
  return Preview()
}


struct InstructionsView: View {
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
  InstructionsView(
    disclousureExpand: .constant(true),
    instructions: TastyRecipeModel().getExample().tastyRecipe.instructions)
}

struct IngredientView: View {
  @Binding var disclousureExpand: Bool
  let ingredientSections: [IngredientSections]
  var body: some View {
    VStack { }
    //      DisclosureGroup(
    //        isExpanded: $disclousureExpand,
    //        content: {
    //          VStack {
    //            ForEach(ingredientSections) { section in
    //              if ingredientSections.count > 1 {
    //                DisclosureGroup(
    //                  content: {
    //                    ScrollView {
    //                      VStack(alignment: .leading, spacing: 5) {
    //                        ForEach(section.components) { component in
    //                          Text("• \(component.getIngredientDescription(measurement: component.measurements[0]))")
    //                            .frame(maxWidth: .infinity, alignment: .leading)
    //                        }
    //                      }
    //                    }
    //                  },
    //                  label: {
    //                    Text("\(section.name ?? "")")
    //                      .font(.title2)
    //                  }
    //                )
    //                .padding(.horizontal, 20)
    //              } else {
    //                ForEach(section.components) { component in
    //                  VStack(alignment: .leading, spacing: 5) {
    //                    Text("• \(component.getIngredientDescription())")
    //                      .frame(maxWidth: .infinity, alignment: .leading)
    //                  }
    //                }
    //              }
    //            }
    //          }
    //        },
    //        label: {
    //          Text("Ingredient")
    //            .font(.title)
    //        }
    //      )
    //    }
    //    //    .frame(width: .infinity, height: 200)
    //    .padding(.horizontal, 20)
  }
}

#Preview("Ingredient") {
  IngredientView(
    disclousureExpand: .constant(false),
    ingredientSections: TastyRecipeModel().getExample().tastyRecipe.ingredientSections)
}

struct NutritionView: View {
  @ObservedObject var tastyStore: RecipesStore
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
    //    tastyStore.scaleRecipe(for: recipeID, numberOfPeople: numberOfPeople)
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
