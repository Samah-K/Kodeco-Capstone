//
//  RecipeItemView.swift
//  Capstone-Cookbook
//
//  Created by Samah Ktaifan on 06/07/2024.
//

import SwiftUI

struct RecipeItemView: View {
  var recipe: TastyRecipe
  var body: some View {
    ZStack(alignment: .topTrailing) {
      ZStack(alignment: .bottom) {
        HStack {
          if let photoURL = recipe.imageDataURL {
            AsyncImage(url: photoURL) { imagePhase in
              switch imagePhase {
              case .empty:
                RoundedRectangle(cornerRadius: 25.0)
                  .fill(.gray)
              case .success(let image):
                image.resizable()
              case .failure(let error):
                Text(error.localizedDescription)
                RoundedRectangle(cornerRadius: 25.0)
                  .fill(.gray)
              @unknown default:
                RoundedRectangle(cornerRadius: 25.0)
                  .fill(.gray)
              }
            }
            //          AsyncImage(url: recipe.imageDataURL) { image  in
            //            image.resizable()
            //          } placeholder: {
            //            ZStack {
            //              ProgressView()
            //            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            //          }
          } else {
            ZStack {
              RoundedRectangle(cornerRadius: 25.0)
                .fill(.gray)
              ProgressView()
                .tint(.accent)
            }
          }
        }
        HStack(alignment: .firstTextBaseline) {
          Spacer()
          Text(recipe.name)
            .font(.title)
            .fontDesign(.rounded)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .shadow(radius: 4)
            .shadow(color: .black, radius: 1)
          //          .shadow(color: .black.opacity(0.9), radius: 1)
            .shadow(color: .accent, radius: 1)
            .lineLimit(2)
            .padding(.horizontal, 9)
          //          .background(.red)
          Spacer()
          Spacer()
          Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
      }
      HStack {
        Button(action: {
          // ADD
        }, label: {
          ZStack {
            Circle()
              .fill(.white)
              .shadow(radius: 10)
              .frame(maxWidth: 30, maxHeight: 30)
            Image(systemName: "bookmark")
              .foregroundStyle(.accent)
          }
        })
      }
      .padding(10)
      //      .background(.accent.opacity(0.8))
      //      .padding(.trailing, 20)
    }
    .clipShape(RoundedRectangle(cornerRadius: 25))
    .aspectRatio(1, contentMode: .fit)
//    .frame(height: 250)
    .overlay {
      RoundedRectangle(cornerRadius: 25)
        .strokeBorder(.white, lineWidth: 4.0)
    }
    .shadow(radius: 1)
  }
}

#Preview {
  RecipeItemView(recipe: TastyRecipeModel().getExample())
}
