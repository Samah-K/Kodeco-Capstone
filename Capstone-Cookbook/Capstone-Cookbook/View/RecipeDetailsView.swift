//
//  RecipeDetailsView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 02/07/2024.
//

import SwiftUI

struct RecipeDetailsView: View {
  @ObservedObject var recipeStoreManager: RecipeStoresManager
  @State private var instructionDisclousureExpand = false
  @State private var ingredientdisclousureExpand = false
  @State private var descriptionShowingModal = false
  @State private var descriptionAnimation = false
  @Binding var recipe: Recipe

  var body: some View {
    ZStack {
      GeometryReader { proxy in
        VStack {
          // image
          VStack {
            // TODO: Change image URL
            AsyncImage(url: URL(string: recipe.tastyRecipe.getRecipeImageURL()), content: { image in
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
            Text(recipe.tastyRecipe.name)
              .font(.title)
              .padding(.top, 6)
            // TODO: Fix this
            Text(recipe.tastyRecipe.description ?? " - ")
              .font(.subheadline)
              .lineLimit(2)
              .allowsTightening(true)
              .onTapGesture {
                descriptionShowingModal = true
              }
          }
          .padding(20)
          .frame(height: proxy.size.height * 0.25)
          //         Nutrition
          //          if !ingredientdisclousureExpand && !instructionDisclousureExpand {
          //            if let recipeNutrition = recipe.nutrition {
          //              NutritionView(
          //                numberOfPeople: recipe.numServing,
          //                recipeID: recipe.id,
          //                nutrition: recipeNutrition)
          //            }
          //          }
          ScrollView {
            if !ingredientdisclousureExpand {
              InstructionsView(
                disclousureExpand: $instructionDisclousureExpand,
                instructions: recipe.tastyRecipe.instructions)
            }
            if !instructionDisclousureExpand {
              IngredientView(
                disclousureExpand: $ingredientdisclousureExpand,
                ingredientSections: recipe.tastyRecipe.ingredientSections
              )
            }
          }
          .frame(height: proxy.size.height * 0.35)
        }
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            AddRecipeButton(
              recipeStoreManager: recipeStoreManager, isAddedToMyRecipes: $recipe.isRecipeAddedToMyCookbook, recipeID: recipe.id)
          }
        }
      }
      .padding(.bottom, 30)
      if $descriptionShowingModal.wrappedValue {
        if let description = recipe.tastyRecipe.description {
          DescriptionPopup(
            descriptionShowingModal: $descriptionShowingModal,
            descriptionAnimation: $descriptionAnimation,
            recipeDescription: description)
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    RecipeDetailsView(
      recipeStoreManager: RecipeStoresManager(),
      recipe: .constant(TastyRecipeModel().getExample()))
  }
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
    ingredientSections: TastyRecipeModel().getExample().tastyRecipe.ingredientSections)
}

struct NutritionView: View {
  @ObservedObject var tastyStore: RecipeStoresManager
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

struct DescriptionPopup: View {
  @Binding var descriptionShowingModal: Bool
  @Binding var descriptionAnimation: Bool
  var recipeDescription: String
  var body: some View {
    ZStack {
      Color.black
        .opacity(0.6)
        .ignoresSafeArea()
        .onTapGesture {
          descriptionAnimation.toggle()
          DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            descriptionShowingModal.toggle()
          }
        }
      VStack {
        ZStack {
          Circle()
            .fill(.accent)
            .frame(width: 40, height: 40)
            .shadow(radius: 10)
          Image(systemName: "fork.knife")
            .foregroundStyle(.white)
        }
        .padding(.top, 20)
        ScrollView {
          Text(recipeDescription)
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 20)
        }
      }
      .background(.white)
      .frame(width: 350, height: 400)
      .clipShape(RoundedRectangle(cornerRadius: 25.0))
      .shadow(radius: 20)
    }
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
        descriptionAnimation.toggle()
      }
    }
    .opacity(descriptionAnimation ? 1 : 0)
    .animation(.easeInOut(duration: 0.25), value: descriptionAnimation)
  }
}
