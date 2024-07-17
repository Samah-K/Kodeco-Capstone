//
//  RecipeItemView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 06/07/2024.
//

import SwiftUI

struct RecipeItemView: View {
  @EnvironmentObject var recipeStoreManager: RecipesStore
  @Binding var recipe: Recipe

  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      RoundedRectangle(cornerRadius: ViewConstants.roundCorner)
        .fill(.white)
        .shadow(radius: 10)
        .padding(5)
      GeometryReader { proxy in
      HStack(alignment: .center) {
        VStack {
          Spacer()
          VStack {
            if let photoURL = recipe.tastyRecipe.imageDataURL {
              AsyncImage(url: photoURL) { imagePhase in
                switch imagePhase {
                case .empty:
                  RoundedRectangle(cornerRadius: ViewConstants.roundCorner)
                    .fill(.gray)
                case .success(let image):
                  image.resizable()
                case .failure(let error):
                  Text(error.localizedDescription)
                  RoundedRectangle(cornerRadius: ViewConstants.roundCorner)
                    .fill(.gray)
                @unknown default:
                  RoundedRectangle(cornerRadius: ViewConstants.roundCorner)
                    .fill(.gray)
                }
              }
            } else {
              ZStack {
                RoundedRectangle(cornerRadius: ViewConstants.roundCorner)
                  .fill(.gray)
                ProgressView()
                  .tint(.accent)
              }
            }
          }
          .aspectRatio(contentMode: .fill)
          .padding(.leading, 10)
          Spacer()
        }
        .frame(width: proxy.size.width * 0.4)

//        .frame(maxWidth: .infinity)
        VStack(alignment: .leading) {
          Spacer()
            Text(recipe.getRecipeName())
              .font(.title3)
              .foregroundStyle(.text)
              .multilineTextAlignment(.leading)
              .shadow(color: .tint.opacity(0.3), radius: 1)
              .lineLimit(2)
            HStack (spacing: 5) {
              Image(systemName: "timer")
              Text(recipe.getTotalCookTime())
            }
            .font(.caption)
            .foregroundStyle(.accentSecondary)
          Spacer()
          Spacer()
          }
        .frame(maxWidth: proxy.size.width * (1 - 0.4), maxHeight: .infinity)
//          .background(.yellow)


        }
      }
//      .frame(
//        maxWidth: .infinity,
//        minHeight: ViewConstants.listHeight,
//        maxHeight: ViewConstants.listHeight)
//      .overlay {
//        RoundedRectangle(cornerRadius: ViewConstants.roundCorner)
//          .fill(.clear)
//      }


      ZStack {
        Circle()
          .fill(.white)
          .shadow(radius: 5)
          .frame(maxWidth: 25, maxHeight: 25)
        AddRecipeButton(
          isAddedToMyRecipes: $recipe.isRecipeAddedToMyCookbook,
          recipeID: recipe.id
        )
      }
      .padding()
    }
    .frame(
      maxWidth: .infinity,
      minHeight: ViewConstants.listHeight,
      maxHeight: ViewConstants.listHeight)
//    .padding(5)
//    .overlay {
//      RoundedRectangle(cornerRadius: ViewConstants.roundCorner)
////        .fill(.clear)
////        .shadow(radius: 10)
//        .padding(5)
//    }




//      ZStack(alignment: .bottom) {
//        HStack {
//
//        }
//        HStack(alignment: .firstTextBaseline) {
//          Spacer()
//
//          Spacer()
//          Spacer()
//          Spacer()
//        }
//        .frame(maxWidth: .infinity)
//        .padding(.vertical, 15)
//      }
//      HStack {
//        ZStack {
//
//        }
//      }
//      .padding(10)
//    }
//    .clipShape(RoundedRectangle(cornerRadius: 25))
//    .aspectRatio(1, contentMode: .fit)
//    .overlay {
//      RoundedRectangle(cornerRadius: 25)
//        .strokeBorder(.white, lineWidth: 4.0)
//    }
//    .shadow(radius: 1)
  }
}

#Preview {
  RecipeItemView(
    recipe: .constant(TastyRecipeModel().getExample()))
  .environmentObject(RecipesStore())
}
